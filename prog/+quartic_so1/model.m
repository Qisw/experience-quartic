function model(gNo)
% Estimate model with fixed experience effects
%{
Regress log wage on
- age dummies or experience polynomial
- year dummies
- a measure of cohort schooling
%}


%% Settings

cS = const_data_so1(gNo);
varS = param_so1.var_numbers;
saveFigures = 1;

useCohortDummies = cS.quarticS.cohortEffects.equals('dummies');

ageMax = cS.quarticS.ageMax;
ny = length(cS.dataS.wageYearV);

fprintf('\nWage regressions\n');



%% Regression inputs: median wage by [t,s,y]

tgS = output_so1.var_load(varS.vCalTargets, cS);
logWage_tsyM = tgS.logWage_tsyM(1 : ageMax, :,cS.wageYearIdxV);

% Weights
nObs_tsyM = tgS.nObs_tsyM(1:ageMax,:,cS.wageYearIdxV);
wt_tsyM = sqrt(max(0,  nObs_tsyM));

saveS.logWage_tscM = tgS.logWage_tscM(1 : ageMax, :,cS.wageYearIdxV);


%% Make measure of cohort schooling
% Mean percentile position of person in that school group

% Percentile bounds of school classes
sCdf_scM = [zeros(1, cS.demogS.nCohorts); cumsum(tgS.sFrac_scM)];
% School percentile midpoint of school classes by cohort
saveS.schoolPct_scM = (sCdf_scM(1 : cS.nSchool, :) + sCdf_scM(2 : (cS.nSchool+1), :)) / 2;
validateattributes(saveS.schoolPct_scM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
   '<', 1, 'size', [cS.nSchool, cS.demogS.nCohorts]})

% The same by [age, school, year]
%  so it can be used as a regressor matrix
schoolPct_tsyM = nan(size(logWage_tsyM));
schoolYr_tsyM  = nan(size(logWage_tsyM));
for iy = 1 :ny
   % Birth year by age
   bYearV = cS.wageYearV(iy) - (1 : ageMax) + cS.demogS.ageInBirthYear;
   % Ages with valid birth years
   ageIdxV = find(bYearV >= cS.demogS.bYearV(1)  &  bYearV <= cS.demogS.bYearV(end));
   % Birth years and their indices for those ages
   byIdxV = bYearV(ageIdxV) - cS.demogS.bYearV(1) + 1;
   for iSchool = 1 : cS.nSchool
      schoolPct_tsyM(ageIdxV,iSchool,iy) = saveS.schoolPct_scM(iSchool, byIdxV);
      schoolYr_tsyM(ageIdxV,iSchool,iy) = tgS.schoolYrMean_cV(byIdxV);
   end
end


%% Wage regression

% Age range for each school group
ageRange_tsM = [cS.demogS.workStartAgeV(:)';  repmat(ageMax, [1, cS.nSchool])];


xM = logWage_tsyM;
xM(xM == cS.missVal) = NaN;

% Additional regressors
if cS.quarticS.cohortEffects.equals('schooling')
   x_tsyvM = schoolPct_tsyM;
elseif cS.quarticS.cohortEffects.equals('schoolYears')
   x_tsyvM = nan([size(logWage_tsyM), 2]);
   x_tsyvM(:,:,:,1) = schoolYr_tsyM;
   x_tsyvM(:,:,:,2) = schoolYr_tsyM .^ 2;
else
   x_tsyvM = [];
end

wrS = econLH.WageRegressionLH(xM, x_tsyvM, wt_tsyM, ageRange_tsM, cS.dataS.wageYearV, ...
   cS.quarticS.useWeights, useCohortDummies, cS.quarticS.ageEffects.value);
clear xM;

% Fitted values and confidence intervals
[saveS.pred_tsyM, saveS.predCi_tsy2M] = wrS.regress;
saveS.wrS = wrS;


%% Predicted profiles

% Predicted profiles by [age, school, year]
%  With cohort schooling as additional regressor, this is only filled in for [age,year] combinations
%  that belong to modeled cohorts!
% saveS.pred_tsyM = wrS.predict_ast;
saveS.pred_tsyM(isnan(saveS.pred_tsyM)) = cS.missVal;
validateattributes(saveS.pred_tsyM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(logWage_tsyM)})


% Predicted profiles by [age, school, cohort]
saveS.pred_tscM = repmat(cS.missVal, [ageMax, cS.nSchool, cS.nCohorts]);
% Confidence bands
saveS.predCi_tsc2M = repmat(cS.missVal, [ageMax, cS.nSchool, cS.nCohorts, 2]);
for iSchool = 1 : cS.nSchool
   % Ages to plot
   ageV = cS.demogS.workStartAgeV(iSchool) : ageMax;

   % Make cohort profiles
   pred_tcM = econ_lh.cohort_age_from_age_year(squeeze(saveS.pred_tsyM(ageV,iSchool,:)), ageV, cS.wageYearV, ...
      cS.demogS.bYearV, cS.demogS.ageInBirthYear, cS.missVal, cS.dbg)';
   assert(isequal(size(pred_tcM),  [length(ageV), length(cS.demogS.bYearV)]));
   saveS.pred_tscM(ageV,iSchool,:) = pred_tcM;
   
   for i2 = 1 : 2
      x_tcM = econ_lh.cohort_age_from_age_year(squeeze(saveS.predCi_tsy2M(ageV,iSchool,:,i2)), ageV, cS.wageYearV, ...
         cS.demogS.bYearV, cS.demogS.ageInBirthYear, cS.missVal, cS.dbg)';
      assert(isequal(size(x_tcM),  [length(ageV), length(cS.demogS.bYearV)]));
      saveS.predCi_tsc2M(ageV,iSchool,:,i2) = x_tcM;
   end
end

validateattributes(saveS.predCi_tsc2M, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   'size', [ageMax, cS.nSchool, cS.nCohorts, 2]})


%% Add cohort effects
% If they are of the "ex post" kind
if cS.quarticS.cohortEffects.equals('expost')
   % Estimate and plot cohort effects
   saveS.cohEffect_scM = quartic_so1.cohort_effects(tgS.logWage_tscM(1 : ageMax,:,:), ...
      saveS.pred_tscM(1 : ageMax,:,:), saveFigures, gNo);
   
   % Add cohort effects into predicted profiles
   for ic = 1 : cS.nCohorts
      for iSchool = 1 : cS.nSchool
         ageV = cS.demogS.workStartAgeV(iSchool) : ageMax;
         if saveS.cohEffect_scM(iSchool, ic) ~= cS.missVal
            saveS.pred_tscM(ageV, iSchool, ic) = ...
               saveS.pred_tscM(ageV, iSchool, ic) + saveS.cohEffect_scM(iSchool, ic);
         end
      end
   end
   
   % Remake the profiles by [t,s,y]
   for iSchool = 1 : cS.nSchool
      ageV = cS.demogS.workStartAgeV(iSchool) : ageMax;
      in_caM = squeeze(saveS.pred_tscM(ageV, iSchool, :))';
      saveS.pred_tsyM(ageV,iSchool,:) = econ_lh.age_year_from_cohort_age(in_caM, ageV, cS.wageYearV, ...
         cS.demogS.bYearV, cS.demogS.ageInBirthYear, cS.missVal, cS.dbg);
   end
end


%% Save

saveS.logWage_tsyM = logWage_tsyM;
saveS.wt_tsyM = wt_tsyM;

var_save_so1(saveS, cS.varNoS.vQuarticModel, cS);



end