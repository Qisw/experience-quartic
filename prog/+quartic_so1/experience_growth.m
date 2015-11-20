function experience_growth(saveFigures, gNo)

cS = const_data_so1(gNo);

tgS = var_load_so1(cS.varNoS.vCalTargets, cS);
loadS = var_load_so1(cS.varNoS.vQuarticModel, cS);
ageMax = cS.quarticS.ageMax;

nx = 2;
logWage_tscxM = repmat(cS.missVal, [ageMax, cS.nSchool, cS.nCohorts, nx]);

ix = 2;
logWage_tscxM(:,:,:,ix) = tgS.logWage_tscM(1 : ageMax, :,:);
legendV{ix} = 'Data';

ix = 1;
logWage_tscxM(:,:,:,ix) = loadS.pred_tscM(1 : ageMax, :,:);
legendV{ix} = 'Model';

results_so1.exper_wage_growth_show(logWage_tscxM, legendV, cS.dirS.quarticDir, saveFigures, cS);

end