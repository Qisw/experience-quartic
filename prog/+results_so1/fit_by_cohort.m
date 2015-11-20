function fit_by_cohort(model_tscM, data_tscM, saveFigures, cS)
%  Age wage profiles: data vs model
% Each figure contains 8 cohorts. One subplot per cohort with all s.

dirS = cS.dirS;
figS = const_fig_so1;

[yMin, yMax] = output_so1.y_range(model_tscM, cS.missVal);

% Subplot counter
maxPlot = 6;
iPlot = 0;
% Plot counter
iFig = 0;
iCohortV = 2 : 3 : cS.nCohorts;


for iCohort = iCohortV
   if iPlot == 0
      output_so1.fig_new(saveFigures, figS.figOpt6S);
   end
   iPlot = iPlot + 1;
   subplot(3,2,iPlot);
   hold on;

   % Plot all school groups; data and model
   for iSchool = 1 : cS.nSchool
      ageRangeV = max(cS.demogS.workStartAgeV(iSchool), cS.calS.profileDevAgeRangeV(1)) : cS.calS.profileDevAgeRangeV(2);   

      modelWageV = model_tscM(ageRangeV, iSchool, iCohort);
      idxV = find(modelWageV > -10);
      plot(ageRangeV(idxV), modelWageV(idxV), figS.lineStyleDenseV{1}, 'Color', figS.colorM(iSchool,:));

      dataWageV  = data_tscM(ageRangeV, iSchool, iCohort);
      idxV = find(dataWageV > -10);
      plot(ageRangeV(idxV), dataWageV(idxV),  figS.lineStyleDenseV{2}, 'Color', figS.colorM(iSchool,:));
   end

   hold off;
   figures_lh.axis_range_lh([cS.calS.profileDevAgeRangeV(1), ageRangeV(end), yMin, yMax]);

   xlabel(['Age  --  Cohort ', cS.demogS.cohStrV{iCohort}]);
   ylabel('Log wage');

   %if iPlot == 1
   %   legend({'Data', 'Model'}, 'Location', 'Northwest');
   %end
   output_so1.fig_format(gca);

   % Close and save plot
   if iPlot == maxPlot  ||  iCohort == iCohortV(end)
      iFig = iFig + 1;
      figFn = fullfile(dirS.fitDir, ['wage_as_', sprintf('c%i', iFig)]);
      output_so1.fig_save(figFn, saveFigures, cS);
      iPlot = 0;
   end
end

end