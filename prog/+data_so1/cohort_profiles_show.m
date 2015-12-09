function cohort_profiles_show(saveFigures, gNo)
% Show data wage profiles
%{
Checked: 2013-6-7
%}
% ------------------------------------------

cS = const_data_so1(gNo);
varS = param_so1.var_numbers;
figS = const_fig_so1;

byShowV = cS.demogS.byShowV(1 : 5);

% Load cohort profiles
tgS = output_so1.var_load(varS.vCalTargets, cS);
[nAge, nSchool, nBy] = size(tgS.logWage_tscM);

if nSchool ~= cS.nSchool  ||  nBy ~= length(cS.demogS.bYearV)
   error_so1('Invalid', cS);
end

% These are the wage profiles to be shown
%  In dollar units
wStr = 'Log wage';
validateattributes(tgS.logWage_tscM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   'size', [size(tgS.logWage_tscM, 1), nSchool, nBy]});



%%  Plot wage growth over life-cycle
if 1
   wGrowth_scM = helper_so1.exper_wage_growth(tgS.logWage_tscM, cS);
   
   output_so1.fig_new(saveFigures);
   hold on;
   for iSchool = 1 : cS.nSchool
      idxV = find(wGrowth_scM(iSchool,:) ~= cS.missVal);
      plot(cS.demogS.bYearV(idxV),  wGrowth_scM(iSchool,idxV),  ...
         figS.lineStyleV{iSchool}, 'color', figS.colorM(iSchool,:));
   end
   
   hold off;
   xlabel('Birth year');
   ylabel(sprintf('Wage growth, ages %i-%i',  cS.dataS.wageGrowthAgeV));
   legend(cS.schoolLabelV, 'location', 'southoutside', 'orientation', 'horizontal');
   output_so1.fig_format(gca, 'line');
   output_so1.fig_save('wage_growth_asc', saveFigures, cS);
end


%% Plot wage growth over life-cycle  and  growth in aggregate wages
if 1
   % Wage growth over life-cycle
   wGrowth_scM = helper_so1.exper_wage_growth(tgS.logWage_tscM, cS);
   % Growth in aggregate wage over life-cycle
   spGrowth_scM = helper_so1.aggr_wage_growth(tgS.logWage_syM, cS);
   
   for iSchool = 1 : cS.nSchool
      output_so1.fig_new(saveFigures, figS.figOpt2AcrossS);
      hold on;
      
      % Experience wage growth
      iLine = 1;
      idxV = find(wGrowth_scM(iSchool,:) ~= cS.missVal);
      plot(cS.demogS.bYearV(idxV),  wGrowth_scM(iSchool,idxV),  ...
         figS.lineStyleV{iLine}, 'color', figS.colorM(iLine,:));

      % Aggregate wage growth
      iLine = iLine + 1;
      idxV = find(spGrowth_scM(iSchool,:) ~= cS.missVal);
      plot(cS.demogS.bYearV(idxV),  spGrowth_scM(iSchool,idxV),  ...
         figS.lineStyleV{iLine}, 'color', figS.colorM(iLine,:));

      hold off;
      xlabel('Birth year');
      ylabel(sprintf('Wage growth, ages %i-%i',  cS.dataS.wageGrowthAgeV));
      if iSchool == 1
         legend({'Cohort', 'Aggregate'},  'location', 'southeast'); 
      end
      output_so1.fig_format(gca, 'line');
      output_so1.fig_save(['wage_growth_exper_aggr_', cS.schoolSuffixV{iSchool}], saveFigures, cS);
   end
end



%%   Plot profiles
% On same scale

% Figure out scale
ageMax = 60;
logWageV = tgS.logWage_tscM(1 : ageMax, : ,byShowV);
logWageV = logWageV(logWageV > cS.missVal);
[yMin, yMax] = output_so1.y_range(logWageV, cS.missVal);
yMin = max(yMin, yMax - 3);
xMin = 15;
xMax = ageMax;
clear logWageV;

for iSchool = 1 : cS.nSchool
   output_so1.fig_new(saveFigures);
   % Line counter
   iLine = 0;
   hold on;

   for iBy = byShowV(:)'
      smoothV = squeeze(tgS.logWage_tscM(:, iSchool, iBy));
      idxV = find(smoothV ~= cS.missVal);
      % Drop ages before assumed work start
      idxV(idxV < cS.demogS.workStartAgeV(iSchool)) = [];
      
      if length(idxV) < 2
         error_so1('no data to show', cS);
      end

      iLine = iLine + 1;
      plot(idxV, smoothV(idxV),  figS.lineStyleDenseV{iLine},  'Color', figS.colorM(iLine,:));

      %dataV   = squeeze(loadS.meanLogWageM(iBy, iSchool, :));
      %plot(idxV, dataV(idxV),    '.', 'Color', figS.colorM(iLine,:));
   end
   
   
   hold off;
   xlabel('Age');
   ylabel(wStr);
   figures_lh.axis_range_lh([xMin, xMax, yMin, yMax]);
   if iSchool == cS.iCG
      legend(cS.demogS.cohStrV(byShowV), 'Location', 'southeast');
   end
      
   % save
   output_so1.fig_format(gca, 'line');
   output_so1.fig_save(['data_profile_', cS.schoolSuffixV{iSchool}],  saveFigures, cS);
end


%%   Table: no of observations
if 1
   fprintf('\n\nNo of wage observations\n\n');
   fprintf('    by cohort / school.   mean / min / max across ages \n');
   
   for iBy = 1 : nBy
      fprintf('\nCohort %i\n',  cS.demogS.bYearV(iBy));
      
      for iSchool = 1 : cS.nSchool
         nObsV = squeeze(tgS.nObs_tscM(:, iSchool, iBy));
         idxV = find(nObsV >= cS.dataS.minWageObs);
         nObsV = nObsV(idxV);
         fprintf('%6.0f / %6.0f / %6.0f    ',  mean(nObsV), min(nObsV), max(nObsV));
      end
      
      fprintf('\n');
   end
end


end