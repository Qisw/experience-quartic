function cal_targets_show(saveFigures, gNo)
% Show calibration targets
%{
This repeats graphs from data routines, but it is useful to keep the
typesetting easy
%}
% -----------------------------------------------

cS = const_data_so1(gNo);
varS = param_so1.var_numbers;
figS = const_fig_so1;

tgS = output_so1.var_load(varS.vCalTargets, cS);


%% Wage profiles by [age, school, year]
if 01
   yearV = cS.wageYearV(1 : 2 : 10);
   legendV = arrayfun(@(x) {sprintf('%d', x)}, yearV);
  
   for iSchool = 1 : cS.nSchool
      ageV = cS.demogS.workStartAgeV(iSchool) : cS.demogS.ageRetire;
      output_so1.fig_new(saveFigures);
      hold on;
      
      for iLine = 1 : length(yearV)
         dataV = tgS.logWage_tsyM(ageV, iSchool, yearV(iLine)-cS.wageYearV(1)+1);
         idxV = find(dataV ~= cS.missVal);
         plot(ageV(idxV),  dataV(idxV),  figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine,:));         
      end
      
      hold off;
   
      xlabel('Age');
      ylabel('Log wage');
      legend(legendV)
      output_so1.fig_format(gca, 'line');
      output_so1.fig_save(['wage_log_tsy_', cS.schoolSuffixV{iSchool}], saveFigures, cS);
   end
end


%%  Cohort wage profiles
% Each sub-plot is a cohort
if 1
   figRows = 3;
   figCols = 2;
   byShowV = cS.demogS.byShowV;
   nc = length(byShowV);

   for iPlot = 1 : 1
      if iPlot == 1
         % Mean log wage
         yLabelStr = cS.wageStr;
         figFn = 'tg_wages';
         ageRangeV = [min(cS.demogS.workStartAgeV), cS.demogS.ageRetire];
         wageM = tgS.logWage_tscM;
         [yMin, yMax] = output_so1.y_range(wageM(:), cS.missVal);
%       elseif iPlot == 2
%          % no longer created
%          yLabelStr = 'Mean hours worked';
%          figFn = 'tg_hours';
%          ageRangeV = [min(cS.demogS.workStartAgeV), cS.demogS.ageRetire];
%          wageM = tgS.hours_tscM;
%          [yMin, yMax] = output_so1.y_range(wageM(:), cS.missVal);
         
      else
         error('Invalid ');
      end
      
      output_so1.fig_new(saveFigures, figS.figOpt6S);
   
      % Each suplot is a cohort; shows all school groups
      for i1 = 1 : min(figRows * figCols, nc)
         subplot(figRows,figCols,i1);
         ic = byShowV(i1);
         hold on;
         for iSchool = 1 : cS.nSchool
            wageV = wageM(:, iSchool, ic);
            wageV(1 : (cS.demogS.workStartAgeV(iSchool))) = cS.missVal;
            idxV = find(wageV ~= cS.missVal);
            plot(idxV, wageV(idxV), figS.lineStyleDenseV{iSchool}, 'Color', figS.colorM(iSchool, :));
         end

         hold off;
         axis([ageRangeV(1), ageRangeV(2), yMin, yMax]);
         xlabel(['Age  -  cohort ', cS.demogS.cohStrV{ic}]);
         ylabel(yLabelStr);
         if i1 == 1
            legend(cS.schoolLabelV, 'Location', 'South');
         end
         output_so1.fig_format(gca);
      end

      output_so1.fig_save(figFn, saveFigures, cS);
   end
end


%% Cohort schooling
% School fractions shown elsewhere
if 1
   fh = output_so1.fig_new(saveFigures, figS.figOpt2AcrossS);
   idxV = find(tgS.schoolYrMean_cV > 0);
   plot(cS.demogS.bYearV(idxV),  tgS.schoolYrMean_cV(idxV), figS.lineStyleDenseV{1}, 'color', figS.colorM(1,:));
   xlabel('Cohort');
   ylabel('Average schooling');
   output_so1.fig_format(fh, 'line');
   output_so1.fig_save('cohort_school', saveFigures, cS);
end


end