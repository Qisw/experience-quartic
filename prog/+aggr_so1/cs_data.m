function logWage_tsyM = cs_data(logWage_tscM, logWageSS_tscM,  ...
   yearV, ageMin, ageMax, cS)
% Make a cross-sectional dataset from simulated histories
%{
This is used to compute cross-sectional stats, exactly as they are computed in the data
The stats use fixed [age, school] weights

Only ages in ageMin:ageMax have data filled in

Uses steady state cohorts to fill in non-modeled cohorts
   They don't have to be steady state cohorts. Just something constant for the cohorts before the
   first and after the last

IN:
   logWage_tscM(age, school, cohort)
      could be any other variable that is indexed the same way
   logWageSS_tscM
      the same for steady states (initial and terminal)
      for filling in non-modeled cohorts
   yearV
      years for which to return data
   ageMin, ageMax
      typically cS.dataS.aggrAgeRangeV

OUT:
   logWage_tsyM(age, school, year)
      cross-sectional profile
      simply picks the right cohort for each [age, year] combination

Checked: 2014-apr-8
%}


%% Input check

nYr = length(yearV);
nBy = length(cS.demogS.bYearV);
if cS.dbg > 10
   if ~v_check(logWage_tscM, 'f', [cS.demogS.ageRetire, cS.nSchool, nBy], [], [])
      error_so1('Invalid wageM', cS);
   end
   if ~v_check(logWageSS_tscM, 'f', [cS.demogS.ageRetire, cS.nSchool, 2], [], [])
      error_so1('Invalid wageM', cS);
   end
end


%% Loop over years

sizeV = [ageMax, cS.nSchool, nYr];
logWage_tsyM  = repmat(cS.missVal, sizeV);

for iy = 1 : nYr
   year1 = yearV(iy);
   
   % Age of each model cohort
   % cohAgeV = age_from_year_so(cS.demogS.bYearV, year1, cS.ageInBirthYear);
   
   for iSchool = 1 : cS.nSchool
      % Working age range
      ageRangeV = max(ageMin, cS.demogS.workStartAgeV(iSchool)) : ageMax;
      % Birth year for each age
      bYearV    = helper_so1.byear_from_age(ageRangeV, year1, cS);
      
      for iAge = 1 : length(ageRangeV)
         age = ageRangeV(iAge);
         if bYearV(iAge) < cS.demogS.bYearLbV(1)
            % Early cohorts: use initial SS
            iSS = 1;
         elseif bYearV(iAge) > cS.demogS.bYearUbV(cS.nCohorts)
            % Late cohorts: use terminal SS
            iSS = 2;
         else
            iSS = -1;
         end
         
         if iSS > 0
            % Use steady state iSS
            logWageV = logWageSS_tscM(age,iSchool,iSS);
         else
            % Find the cohort for this age
            %  If model has no matching cohort, use closest model cohort
            [~, iCohort] = min(abs(bYearV(iAge) - cS.demogS.bYearV));
            logWageV = logWage_tscM(age, iSchool, iCohort);
         end
         
         validateattributes(logWageV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>', -10, ...
            '<', 10})
         
         logWage_tsyM(age, iSchool,iy) = logWageV;
      end
   end
end


%% Self-test
if cS.dbg > 10
   if ~v_check(logWage_tsyM, 'f', sizeV, [], [])
      error_so1('Invalid log wage', cS);
   end
end
   
   
end