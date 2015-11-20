function fit_exper_wage_growth(saveFigures, gNo, setNo)
% Fit: wage growth and intercept; experience profiles by cohort

cS = const_so1(gNo, setNo);
varS = cS.varNoS;
figS = const_fig_so1;

% loadS = var_load_so1(varS.vCalResults, cS);
% outS = loadS.calDevS;

simS = var_load_so1(varS.vSimResults, cS);

cdS = const_so1(gNo, cS.dataSetNo);
tgS = var_load_so1(varS.vCalTargets, cdS);


%%   Wage growth and intercept
if 1
   % Compute intercepts and growth rates over these ages
   ageV = cS.dataS.wageGrowthAgeV;
   assert(length(ageV) == 2);
   
   % Show slope and intercept
   for iPlot = 1 : 2
      for iSchool = 1 : cS.nSchool
         % Compute data and model log wages, both ages, all cohorts
         
         dataLogWage_tcM   = squeeze(tgS.logWage_tscM(ageV,iSchool,:));
         % Find cohorts with data at both ages
         dataIdxV = find(dataLogWage_tcM(1, :) ~= cS.missVal  &   dataLogWage_tcM(2, :) ~= cS.missVal);

         modelLogWage_tcM  = squeeze(simS.logWage_tscM(ageV,iSchool,:));
         if 0
            % Show all model cohorts
            modelIdxV = find(modelLogWage_acM(1, :) ~= cS.missVal  &  modelLogWage_acM(2, :) ~= cS.missVal);
         else
            % Show only data cohorts
            modelIdxV = dataIdxV;
         end


         if iPlot == 1
            % Change in log median wage (slope of profile)
            yDataV  = dataLogWage_tcM(2, :) - dataLogWage_tcM(1, :);
            yModelV = modelLogWage_tcM(2, :) - modelLogWage_tcM(1, :);
            figFn = 'cohort_wage_growth';
         elseif iPlot == 2
            % Level of log wage at age 25
            yDataV  = dataLogWage_tcM(1, :);
            yModelV = modelLogWage_tcM(1, :);
            figFn = 'cohort_wage_intercept';
         end
         

         % *****  Plot
         
         output_so1.fig_new(saveFigures);
         hold on;

         iLine = cS.iModel;
         plot(cS.demogS.bYearV(modelIdxV),  yModelV(modelIdxV), figS.lineStyleV{iLine}, 'Color', figS.colorM(iLine,:));
         
         iLine = cS.iData;
         plot(cS.demogS.bYearV(dataIdxV),  yDataV(dataIdxV), figS.lineStyleV{iLine}, 'Color', figS.colorM(iLine,:));
         
         
         hold off;
         xlabel('Birth year');
         axisV = axis;
         if iPlot == 1
            ylabel(sprintf('Change in mean log wage, ages %i to %i', ageV));
            axis([axisV(1:2), -0.3, 0.65]);  % do not hard code +++
         elseif iPlot == 2
            ylabel(sprintf('%s at age %i', cS.wageStr, ageV(1)));
            % axis([axisV(1:2), 0, 950]);  % do not hard code +++
         end

         legend({'Model', 'Data'}, 'location', 'best');
         output_so1.fig_format(gca);
         output_so1.fig_save(fullfile(cS.dirS.profileDir, [figFn, '_', cS.schoolSuffixV{iSchool}]), saveFigures, cS);
      end % iSchool
   end % for iPlot
end   


end