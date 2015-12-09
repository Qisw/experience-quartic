function [dev, ssd_scM] = dev_wage_profiles(model_tscM, data_tscM, wt_tscM, cS)
% Deviation from mean log or log median wage profiles
%{
IN:
   model_tscM
      model log wages
   data_tscM
      usually tgS.logWage_tscM
   wt_tscM
      usually tgS.wageWt_tscM

OUT:
   dev
      scalar deviation
   ssd_scM
      sum of squared residuals (weighted)
%}


%% Input check

[~, ~, nc] = size(model_tscM);

if cS.dbg > 10
   validateattributes(model_tscM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', size(data_tscM)});
   if ~v_check(wt_tscM, 'f', size(data_tscM), 0, [], [])
      error_so1('Invalid');
   end
end


%% Main

ssd_scM = zeros([cS.nSchool, nc]);

for ic = 1 : nc
   for iSchool = 1 : cS.nSchool
      % Ages for which wages are compared
      age1 = max(cS.demogS.workStartAgeV(iSchool) + cS.calS.profileDevDropYears, cS.calS.profileDevAgeRangeV(1));
      ageRangeV = age1 : cS.calS.profileDevAgeRangeV(2);

      modelWageV  = model_tscM(ageRangeV, iSchool, ic);
      dataWageV   = data_tscM(ageRangeV, iSchool, ic);
      wtV         = wt_tscM(ageRangeV, iSchool, ic);
      
      idxV = find(wtV > 0  &  dataWageV ~= cS.missVal  &  modelWageV ~= cS.missVal);
      ssd_scM(iSchool, ic) = sum(wtV(idxV) .* (dataWageV(idxV) - modelWageV(idxV)) .^ 2);
   end
end      

dev = sum(ssd_scM(:));


end