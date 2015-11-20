function coll_prem_young_old_show(saveFigures, gNo)

cS = const_data_so1(gNo);
varS = param_so1.var_numbers;

tgS = output_so1.var_load(varS.vCalTargets, cS);


fh = output_so1.plot_by_year(tgS.collPrem_YoungOldYearM, cS.wageYearV, 'College premium', ...
   {'Young', 'Middle', 'Old'}, saveFigures, cS);
output_so1.fig_save('collprem_young_old', saveFigures, cS);


end