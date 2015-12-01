function wGrowth_scM = aggr_wage_growth(logWage_syM, cS)
% Compute growth in aggregate wage over life-cycle of each cohort

% Ages over which to compute wage growth
ageV = cS.dataS.wageGrowthAgeV;
assert(isequal(length(ageV), 2));

wGrowth_scM = repmat(cS.missVal, [cS.nSchool, cS.nCohorts]);

for iSchool = 1 : cS.nSchool
   logWage_xcM = econ_lh.cohort_age_from_year(logWage_syM(iSchool,:)', ageV, cS.wageYearV, cS.demogS.bYearV, ...
      cS.demogS.ageInBirthYear, cS.missVal, cS.dbg)';

   % Find cohorts with data
   idxV = find(min(logWage_xcM) > cS.missVal);
   % Wage growth for these cohorts
   wGrowth_scM(iSchool, idxV) = logWage_xcM(2,idxV) - logWage_xcM(1,idxV);      
end

validateattributes(wGrowth_scM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   'size', [cS.nSchool, cS.nCohorts]})

end