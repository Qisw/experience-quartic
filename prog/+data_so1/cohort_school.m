function cohort_school(gNo)
% Make: fraction in each school group by cohort
%{
CPS data 
For a wide range of cohorts
Using all persons, not just workers

Test: inspect graphs of schooling
Checked: 2015-Dec-1
%}

fprintf('Computing cohort school fractions \n');
cS = const_data_so1(gNo);
nBy = length(cS.demogS.bYearV);
ageRangeV = cS.dataS.schoolAgeRangeV(1) : cS.dataS.schoolAgeRangeV(2);
nAge = length(ageRangeV);

% Stats by [age, school, cohort]
loadS = output_so1.var_load(cS.varNoS.vBYearSchoolAgeStats, cS);

% Output matrices
frac_scM = zeros([cS.nSchool, nBy]);
% Average years of schooling
saveS.schoolYrMean_scM = repmat(cS.missVal, [cS.nSchool, nBy]);
saveS.schoolYrMean_cV = repmat(cS.missVal, [nBy, 1]);


%% Compute schooling by cohort

for iBy = 1 : nBy
   % Mass by [school, age]
   %  Using all persons (even without wages)
   mass_stM = loadS.mass_csauM(iBy, :, ageRangeV, cS.dataS.iuCpsAll);
   mass_stM = max(0, squeeze(mass_stM));
   
   % Average years of schooling by [school, age]
   %  has missing values (not all cohorts observed at all ages)
   school_stM = squeeze(loadS.schoolYrMean_csauM(iBy, :, ageRangeV, cS.dataS.iuCpsAll));
   validateattributes(school_stM, {'double'}, ...
      {'finite', 'nonnan', 'nonempty', 'real', 'size', [cS.nSchool, nAge]})

   
   % Mass by school, across ages
   sMassV = sum(mass_stM, 2);
   assert(isequal(length(sMassV),  cS.nSchool));
   
   % Fraction in each school group
   frac_scM(:, iBy) = sMassV ./ sum(sMassV);
   
   % Average years of school by [s, c]
   for iSchool = 1 : cS.nSchool
      idxV = find(school_stM(iSchool, :) > 0);
      if ~isempty(idxV)
         saveS.schoolYrMean_scM(iSchool,iBy) = mean(school_stM(iSchool,idxV));
      end
   end
   
   % Average years of school by cohort
   wt_stM = mass_stM .* (school_stM > 0);
   wt_stM = wt_stM ./ sum(wt_stM(:));
   saveS.schoolYrMean_cV(iBy) = sum(school_stM(:) .* wt_stM(:));
end

validateattributes(frac_scM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>', 0.02, '<', 0.98, ...
   'size', [cS.nSchool, nBy]});
validateattributes(saveS.schoolYrMean_scM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>', 1, '<', 20, ...
   'size', [cS.nSchool, nBy]});
validateattributes(saveS.schoolYrMean_cV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>', 1, '<', 16})

output_so1.var_save(frac_scM, cS.varNoS.vCohortSchool, cS);
output_so1.var_save(saveS, cS.varNoS.vCohortSchoolYears, cS);

end