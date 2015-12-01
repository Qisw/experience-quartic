function wGrowth_scM = exper_wage_growth(logWage_tscM, cS)
% Compute wage growth over life-cycle of a cohort

% Ages over which to compute wage growth
ageV = cS.dataS.wageGrowthAgeV;
assert(isequal(length(ageV), 2));

wGrowth_scM = repmat(cS.missVal, [cS.nSchool, cS.nCohorts]);

for iSchool = 1 : cS.nSchool
   % Mean log wage by [exper, cohort]
   logWage_xcM = squeeze(logWage_tscM(ageV, iSchool, :));
   % Find cohorts with data
   idxV = find(min(logWage_xcM) > cS.missVal);
   % Wage growth for these cohorts
   wGrowth_scM(iSchool, idxV) = logWage_xcM(2,idxV) - logWage_xcM(1,idxV);      
end

validateattributes(wGrowth_scM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   'size', [cS.nSchool, cS.nCohorts]})


end