function cohort_effects_show(saveFigures, gNo)
%  Plot birth year dummies

cS = const_data_so1(gNo);
loadS = var_load_so1(cS.varNoS.vQuarticModel, cS);
tgS = var_load_so1(cS.varNoS.vCalTargets, cS);


%% Cases
if cS.quarticS.cohortEffects.equals('dummies')
   % Cohort dummies
   % Each entry contains age and year dummies
   profileV = loadS.wrS.age_year_effects(cS.dbg);

   % Index everything by a common set of birth years
   xyV = cell(cS.nSchool,1);
   for iSchool = 1 : cS.nSchool
      xyS.xV = profileV{iSchool}.bYearValueV;
      xyS.yV = profileV{iSchool}.bYearDummyV;
      xyV{iSchool} = xyS;
   end

   [bYearValueV,  bYearDummyM] = vectorLH.xy_to_common_base(xyV, cS.dbg);

elseif cS.quarticS.cohortEffects.equals('schooling')
   % Fraction in each school group
   bYearValueV = cS.demogS.bYearV;
   bYearDummyM = nan(cS.demogS.nCohorts, cS.nSchool);
   
   % Cohort effect = cohort schooling measure * beta(schooling)
   for iSchool = 1 : cS.nSchool
      % Linear model fitted for this group
      mdl = loadS.wrS.modelV{iSchool};
      % Not robust: assumes that first "other" regressor is cohort schooling
      betaIdx = find(strcmp(mdl.CoefficientNames,  loadS.wrS.xNameV{1}));
      assert(isequal(length(betaIdx), 1));
      rBeta = mdl.Coefficients.Estimate(betaIdx);
      bYearDummyM(:, iSchool) = rBeta .* loadS.schoolPct_scM(iSchool, :)';
      
      % Normalize first cohort's dummy to 0
      bYearDummyM(:, iSchool) = bYearDummyM(:, iSchool) - bYearDummyM(1, iSchool);
   end
   
elseif cS.quarticS.cohortEffects.equals('schoolYears')
   % Average years of school
   bYearValueV = cS.demogS.bYearV;
   bYearDummyM = zeros(cS.demogS.nCohorts, cS.nSchool);
   
   x_cV = tgS.schoolYrMean_cV;
   
   % This is really not robust +++++
   
   % Cohort effect = cohort schooling measure * beta(schooling)
   for iSchool = 1 : cS.nSchool
      % Linear model fitted for this group
      mdl = loadS.wrS.modelV{iSchool};
      % Not robust: assumes that first 2 "other" regressor is cohort schooling
      betaIdxV = [find(strcmp(mdl.CoefficientNames,  loadS.wrS.xNameV{1})); ...
         find(strcmp(mdl.CoefficientNames,  loadS.wrS.xNameV{2}))];
      assert(isequal(length(betaIdxV), 2));
      rBetaV = mdl.Coefficients.Estimate(betaIdxV);
      
      for ix = 1 : 2
         bYearDummyM(:, iSchool) = bYearDummyM(:, iSchool) +  rBetaV(ix) .* (x_cV .^ ix);
      end
      
      % Normalize first cohort's dummy to 0
      bYearDummyM(:, iSchool) = bYearDummyM(:, iSchool) - bYearDummyM(1, iSchool);
   end
else
   error('invalid');
end


%% Absolute

fh = output_so1.plot_by_school(bYearValueV, bYearDummyM, 'Birth year', 'Cohort effect', saveFigures, cS);
output_so1.fig_save(fullfile(cS.dirS.quarticDir, 'cohort_effects'),  saveFigures, cS);




%% Relative to hsg

relDummyM = bYearDummyM - repmat(bYearDummyM(:, cS.iHSG), [1, cS.nSchool]);
fh = output_so1.plot_by_school(bYearValueV, relDummyM, 'Birth year', 'Cohort effect rel to HSG', saveFigures, cS);
output_so1.fig_save(fullfile(cS.dirS.quarticDir, 'cohort_effects_relative'),  saveFigures, cS);

   
end
