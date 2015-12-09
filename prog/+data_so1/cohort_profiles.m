function cohort_profiles(gNo)
% Save cohort wage profiles
%{
Wages are in data units
This simply copies variables for the right universe of persons out of cpsearn files.
Universe: wage earners

Checked: 2015-Dec-1
%}

cS = const_data_so1(gNo);
varS = param_so1.var_numbers;

% Years with wage data
saveS.wageYearV = cS.dataS.wageYearV;
% Keep wage data for these ages
dataAgeV = cS.demogS.age1 : cS.demogS.ageRetire;
nBy = length(cS.demogS.bYearV);


% ***  Load data
% Wages NOT in model units
outS = output_so1.var_load(varS.vBYearSchoolAgeStats, cS);
assert(isequal(outS.ageV, dataAgeV))


%% Stats: not smoothed
% Simply copy from outS. But indexing order is different.

% Size of outputs
% Save by physical age
sizeV = [cS.demogS.ageRetire, cS.nSchool, length(cS.demogS.bYearV)];


srcFieldV = {'wageMedian', 'earnMedian', 'nObs', 'mass', 'weeksMean'};
tgFieldV  = srcFieldV;
% scaleFactorV = [1 / cS.wageScale, 1 / cS.wageScale, 1, 1, 1];
scaleFactorV = ones(size(srcFieldV));
minValueV = [-100, -100, 0, 0, 0];

for iField = 1 : length(srcFieldV)
   srcField = [srcFieldV{iField}, '_csauM'];
   % Only uses persons with wages
   srcData_csaM = outS.(srcField)(:,:,:, cS.dataS.iuCpsEarn);
   tgData_ascM = repmat(cS.missVal, sizeV);
   
   for iBy = 1 : nBy
      for iSchool = 1 : cS.nSchool
         tgData_ascM(dataAgeV, iSchool, iBy) = srcData_csaM(iBy, iSchool, dataAgeV);
      end
   end
   
   % Scale the field and copy into output structure
   missingM = tgData_ascM < minValueV(iField);
   tgData_ascM = tgData_ascM ./ scaleFactorV(iField);
   tgData_ascM(missingM) = cS.missVal;

   tgField = [tgFieldV{iField}, '_ascM'];
   saveS.(tgField) = tgData_ascM;
   
   validateattributes(tgData_ascM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', sizeV})
end



% Save
output_so1.var_save(saveS, varS.vDataProfiles, cS);




end