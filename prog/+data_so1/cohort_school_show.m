function cohort_school_show(saveFigures, gNo)
% Show school fractions
% -------------------------------------------

cS = const_data_so1(gNo);
varS = param_so1.var_numbers;
figS = const_fig_so1;

tgS = output_so1.var_load(varS.vCalTargets, cS);

cumFrac_scM = cumsum(max(0, tgS.sFrac_scM));

cumFrac_scM(cumFrac_scM <= 0) = cS.missVal;

output_so1.plot_by_school(cS.demogS.bYearV,  cumFrac_scM', 'Birth year', 'Fraction', saveFigures, cS);


figures_lh.axis_range_lh([NaN, NaN, 0, NaN]);
% legend(cS.schoolLabelV, 'Location', 'Southoutside', 'orientation', 'horizontal');
% output_so1.fig_format(gca, 'line');

output_so1.fig_save('cohort_school_fractions', saveFigures, cS);


end