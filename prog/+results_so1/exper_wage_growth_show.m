function exper_wage_growth_show(logWage_tscxM, legendV, outDir, saveFigures, cS)
% Plot experience wage growth by cohort
%{
IN:
   logWage_tscxM(age,school,year,case)
%}

figS = const_fig_so1;
[~, nSchool, nc, nx] = size(logWage_tscxM);


% Compute intercepts and growth rates over these ages
ageV = cS.dataS.wageGrowthAgeV;
assert(length(ageV) == 2);

% Show slope and intercept
for iPlot = 1 : 2
   fhV = zeros(cS.nSchool, 1);
   for iSchool = 1 : cS.nSchool
      % Compute log wages, both ages, all cohorts
      logWage_tcxM = squeeze(logWage_tscxM(ageV, iSchool, :, :));

      % Find cohorts with data at both ages
      valid_cV = ones(nc, 1);
      for ix = 1 : nx
         for iAge = 1 : 2
            for ic = 1 : nc
               if logWage_tcxM(iAge, ic, ix) == cS.missVal
                  valid_cV(ic) = 0;
               end
            end
         end
      end
      vIdxV = find(valid_cV);

      if iPlot == 1
         % Change in log median wage (slope of profile)
         y_cxM = squeeze(logWage_tcxM(2,:,:) - logWage_tcxM(1,:,:));
         figFn = 'cohort_wage_growth';
      elseif iPlot == 2
         % Level of log wage at age 25
         y_cxM = squeeze(logWage_tcxM(1,:,:));
         figFn = 'cohort_wage_intercept';
      end
      
      
      % *****  Plot

      fhV(iSchool) = output_so1.fig_new(saveFigures, figS.figOpt2AcrossS);
      hold on;

      for iLine = 1 : nx
         plot(cS.demogS.bYearV(vIdxV),  y_cxM(vIdxV,iLine), figS.lineStyleDenseV{iLine}, ...
            'Color', figS.colorM(iLine,:));
      end         

      hold off;
      xlabel('Birth year');
      if iPlot == 1
         ylabel(sprintf('Change in log wage, ages %i to %i', ageV));
      elseif iPlot == 2
         ylabel(sprintf('%s at age %i', cS.wageStr, ageV(1)));
      end

      if iSchool == 1
         legend(legendV, 'location', 'best');
      end
      output_so1.fig_format(gca);
   end % iSchool
   
   figures_lh.axes_same(fhV, []);
   
   for iSchool = 1 : cS.nSchool
      figure(fhV(iSchool));
      output_so1.fig_save(fullfile(outDir, [figFn, '_', cS.schoolSuffixV{iSchool}]), saveFigures, cS);
   end
end % for iPlot

   
end