function cohort_profiles(saveFigures, gNo)
%  Show age profiles for selected cohorts

cS = const_data_so1(gNo);

figS = const_fig_so1;
tgS = var_load_so1(cS.varNoS.vCalTargets, cS);
loadS = var_load_so1(cS.varNoS.vQuarticModel, cS);


%% 6 cohorts in 1 plot

for iSchool = 1 : cS.nSchool
   % One subplot per cohort
   fh = output_so1.fig_new(saveFigures, figS.figOpt6S);
   for iSub = 1 : min(6, length(cS.demogS.byShowV))
      iBy = cS.demogS.byShowV(iSub);
      subplot(3,2, iSub);
      plot_one(iSchool, iBy);
   end
   output_so1.fig_save(fullfile(cS.dirS.quarticDir, ['wage_cohort_', cS.schoolSuffixV{iSchool}]),  ...
      saveFigures,  cS);
end



%% Plot all cohorts

for iSchool = 1 : cS.nSchool
   iPlot = 0;
   iSub = 0;
   for iBy = 1 : cS.nCohorts
      if iSub < 1
         % Start a new plot
         iPlot = iPlot + 1;
         fh = output_so1.fig_new(saveFigures, figS.figOpt6S);
      end
      
      % Next subplot
      iSub = iSub + 1;
      subplot(3,2, iSub);
      plot_one(iSchool, iBy);
      
      if iSub >= 6
         % Save the plot
         output_so1.fig_save(fullfile(cS.dirS.quarticDir, ...
            ['wage_cohort_', cS.schoolSuffixV{iSchool}, sprintf('_plot%i', iPlot)]),  ...
            saveFigures,  cS);         
         iSub = 0;
      end
   end
   
end



%% Nested: Plot 1 cohort
   function plot_one(iSchool, iBy)
      % Ages to plot
      ageV = cS.demogS.workStartAgeV(iSchool) : cS.quarticS.ageMax;

      model_tV = loadS.pred_tscM(ageV, iSchool, iBy);
      data_tV  = tgS.logWage_tscM(ageV, iSchool, iBy);         
      wtV = sqrt(tgS.nObs_tscM(ageV, iSchool, iBy));
      idxV = find(model_tV ~= cS.missVal  &  data_tV ~= cS.missVal  &  wtV > 0);

      hold on;

      iLine = 1;
      plot(ageV(idxV),  model_tV(idxV),  ...
         figS.lineStyleDenseV{iLine},  'color', figS.colorM(iLine,:));
      iLine = iLine + 1;
      plot(ageV(idxV),  data_tV(idxV),   ...
         figS.lineStyleDenseV{iLine},  'color', figS.colorM(iLine,:));
      
      % R^2
      r2 = statsLH.rsquared(data_tV(idxV), model_tV(idxV), wtV(idxV), cS.dbg);

      hold off;
      xlabel(sprintf('Age  --  cohort %i',  cS.demogS.bYearV(iBy)));
      ylabel('Log wage');
      axisV = axis;
      text(axisV(1) + 0.5 * (axisV(2) - axisV(1)),  axisV(3) + 0.1 * (axisV(4) - axisV(3)), ...
         ['R^2=',  sprintf('%.2f', r2)]);
      if iSub == 1
         legend({'Model', 'Data'});
      end
      output_so1.fig_format(fh, 'line');
   end

end
