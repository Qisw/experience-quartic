function show_fit(saveFigures, gNo, setNo)
% Show how model fits wage profiles by cohort
% --------------------------------------------

cS = const_so1(gNo, setNo);
varS = param_so1.var_numbers;

cdS = const_data_so1(gNo);
tgS = var_load_so1(varS.vCalTargets, cdS);

% Individual level histories
simS = var_load_so1(varS.vSimResults, cS);

data_tscM = tgS.logWage_tscM;
model_tscM = simS.logWage_tscM;

valid_tscM = (tgS.wageWt_tscM > 0) .* (data_tscM ~= cS.missVal)  .*  (model_tscM ~= cS.missVal);
resid_tscM = model_tscM - data_tscM;
vIdxV      = find(valid_tscM == 1);
wt_tscM    = tgS.wageWt_tscM .* valid_tscM;


% Fit: log wage; one plot per school group
results_so1.fit_by_school(model_tscM, data_tscM, saveFigures, cS);
results_so1.fit_by_cohort(model_tscM, data_tscM, saveFigures, cS);



%% Histogram of residuals
if 1   
   output_so1.fig_new(saveFigures);
   results_so1.hist_resid(model_tscM, data_tscM, wt_tscM, cS);
   xlabel('Residual log wage');
   output_so1.fig_format(gca);
   output_so1.fig_save('fit_resid_hist', saveFigures, cS);
end

% ****  By schooling
if 1
   for iSchool = 1 : cS.nSchool
      output_so1.fig_new(saveFigures);
      results_so1.hist_resid(model_tscM(:,iSchool,:), data_tscM(:,iSchool,:), wt_tscM(:,iSchool,:), cS);
      
      xlabel('Residual log wage');
      output_so1.fig_format(gca);
      output_so1.fig_save(['fit_resid_hist_', cS.schoolSuffixV{iSchool}], saveFigures, cS);
   end
end




end


