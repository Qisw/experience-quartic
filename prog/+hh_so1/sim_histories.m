function simS = sim_histories(tgSFrac_scM, skillPrice_stM, saveSim, paramS, cS)
% Simulate household histories
%{
Also solves OJT problems

IN:
   tgSFrac_scM
      fraction in each school group by [s, cohort]
   skillPrice_stM(school, year)
      year 1 is cS.spS.spYearV(1)
   saveSim 
      save sim histories

OUT:
   outS
      aggregates needed for calibration and smaller stuff
   simS (saved)
      contains all the fields of outS   AND
      individual histories (can be saved)


Checked: 
%}

nc = length(cS.demogS.bYearV);



%%  Input check
if cS.dbg > 10
   nsp = cS.spS.spYearV(end) - cS.spS.spYearV(1) + 1;
   validateattributes(skillPrice_stM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
      'size', [cS.nSchool, nsp]})
   check_lh.prob_check(tgSFrac_scM, 1e-5);
end



%%  Loop over cohorts


% Histories are saved for each person / school choice
sizeV = [cS.demogS.ageRetire, cS.nSchool, nc];
simS.h_tscM     = zeros(sizeV);
simS.sTime_tscM = zeros(sizeV);
simS.wage_tscM  = cS.missVal .* ones(sizeV);
% Skill prices for each cohort
simS.skillPrice_ascM = zeros([cS.demogS.ageRetire, cS.nSchool, nc]);
% Present value of lifetime earnings, discounted to age 1
simS.pvLtyAge1_scM = zeros([cS.nSchool, nc]);


for ic = 1 : nc
   % First year the cohort is cS.demogS.age1, cS.demogS.ageRetire
   yrIdxV = helper_so1.year_from_age([cS.demogS.age1, cS.demogS.ageRetire], cS.demogS.bYearV(ic), cS.ageInBirthYear) - cS.spS.spYearV(1) + 1;
   simS.skillPrice_tscM(cS.demogS.age1 : cS.demogS.ageRetire, :, ic) = skillPrice_stM(:, yrIdxV(1) : yrIdxV(2))';

   % Simulate cohort
   ojtS = hh_so1.ojt_solve(simS.skillPrice_tscM(:,:,ic), ic, paramS, cS);
%    [cohS, ojtS, schoolS] = hh_so1.sim_cohort(simS.skillPrice_tscM(:, :, ic),   ...
%       tgSFrac_scM(:,ic),  ic, paramS, cS);
         
   simS.h_tscM(:,:,ic) = ojtS.h_tsM;
   simS.sTime_tscM(:,:,ic) = ojtS.sTime_tsM;
   simS.wage_tscM(:,:,ic) = ojtS.wage_tsM;
   simS.pvLtyAge1_scM(:,ic)  = ojtS.pvLtyAge1_sV;
end


%% Implied

% Labor input in efficiency units per hour worked
tEndow_tscM = max(1e-4, paramS.tEndow_tscM);
simS.lPerHour_tscM = simS.h_tscM .* (tEndow_tscM - simS.sTime_tscM) ./ tEndow_tscM;

simS.logWage_tscM = log_lh(simS.wage_tscM, cS.missVal, cS.dbg);


% Save simulated histories (when calibration is done)
if saveSim == 1
   varS = param_so1.var_numbers;
   output_so1.var_save(simS, varS.vSimResults, cS);
end


%% Self test
if cS.dbg > 10
   for iSchool = 1 : cS.nSchool
      ageV = cS.demogS.workStartAgeV(iSchool) : cS.demogS.ageRetire;
      validateattributes(simS.h_tscM(ageV, iSchool,:), ...
         {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
      validateattributes(simS.sTime_tscM(ageV, iSchool,:), ...
         {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0})
      validateattributes(simS.wage_tscM(ageV, iSchool,:), ...
         {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
      validateattributes(simS.lPerHour_tscM(ageV, iSchool,:), ...
         {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
   end
end


end