function skill_weights_show(saveFigures, gNo)

cS = const_data_so1(gNo);
qS = var_load_so1(cS.varNoS.vQuarticSkillWeights, cS);

skillWeight_syM = results_so1.skill_weights_normalize(qS, cS);

figFn = fullfile(cS.dirS.quarticDir,  'skill_weights');
results_so1.plot_skill_weights(skillWeight_syM, cS.wageYearV, figFn, saveFigures, cS);

end