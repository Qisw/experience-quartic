function cohort_school_show(saveFigures, gNo)
% Show school fractions
% -------------------------------------------

cS = const_so1(gNo, 1);
cS = const_so1(gNo, cS.dataSetNo);
varS = param_so1.var_numbers;
figS = const_fig_so1;

tgS = output_so1.var_load(varS.vCalTargets, cS);

cumFrac_scM = cumsum(max(0, tgS.sFrac_scM));


output_so1.fig_new(saveFigures);
hold on;

for iSchool = 1 : cS.nSchool
   %sFracV = squeeze(tgS.sFrac_scM(iSchool,:));
   sFracV = cumFrac_scM(iSchool,:);
   idxV = find(sFracV > 0);
   plot(cS.demogS.bYearV(idxV), sFracV, figS.lineStyleDenseV{iSchool}, 'color', figS.colorM(iSchool,:));
end

hold off;
xlabel('Birth year');
ylabel('Fraction');
figures_lh.axis_range_lh([NaN, NaN, 0, NaN]);
legend(cS.schoolLabelV, 'Location', 'Southoutside', 'orientation', 'horizontal');
output_so1.fig_format(gca, 'line');

output_so1.fig_save('cohort_school_fractions', saveFigures, cS);


end