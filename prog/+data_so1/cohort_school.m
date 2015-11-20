function cohort_school(gNo)
% Make: fraction in each school group by cohort
%{
CPS data 
For a wide range of cohorts
Using all persons, not just workers

Checked: 2014-mar-21
%}

fprintf('Computing cohort school fractions \n');
cS = const_data_so1(gNo);
nBy = length(cS.demogS.bYearV);

loadS = output_so1.var_load(cS.varNoS.vBYearSchoolAgeStats, cS);

sFracM = zeros([cS.nSchool, nBy]);
% Average years of schooling
saveS.schoolYrMean_scM = repmat(cS.missVal, [cS.nSchool, nBy]);
saveS.schoolYrMean_cV = repmat(cS.missVal, [nBy, 1]);

for iBy = 1 : nBy
   % Mass by [school, age]
   %  Using all persons (even without wages)
   mass_stM = loadS.mass_csauM(iBy, :, cS.schoolAgeRangeV(1) : cS.schoolAgeRangeV(2), cS.dataS.iuCpsAll);
   mass_stM = max(0, squeeze(mass_stM));
   sMassV = sum(mass_stM, 2);
   if length(sMassV) ~= cS.nSchool
      error('Invalid');
   end
   sFracM(:, iBy) = sMassV ./ sum(sMassV);
   
   % Average years of school by [s, c]
   school_stM = ...
      squeeze(loadS.schoolYrMean_csauM(iBy, :, cS.schoolAgeRangeV(1) : cS.schoolAgeRangeV(2), cS.dataS.iuCpsAll));
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

validateattributes(sFracM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>', 0.02, '<', 0.98, ...
   'size', [cS.nSchool, nBy]});
validateattributes(saveS.schoolYrMean_scM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>', 1, '<', 20, ...
   'size', [cS.nSchool, nBy]});
validateattributes(saveS.schoolYrMean_cV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>', 1, '<', 16})

output_so1.var_save(sFracM, cS.varNoS.vCohortSchool, cS);
output_so1.var_save(saveS, cS.varNoS.vCohortSchoolYears, cS);

end