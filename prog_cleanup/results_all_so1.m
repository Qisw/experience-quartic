function results_all_so1(gNo, setNo)
% Generate all results and tex file to show them
% --------------------------------------------------

cS = const_so1(gNo, setNo);
% dirS = param_so1.directories(gNo, setNo);
saveFigures = 1;


% Make directories
output_so1.mkdir(gNo, setNo);


% Check that calibration is "correct"


% Compute additional stats
aggr_so1.aggr_stats_save(gNo, setNo);


% Delete existing output files
minAge = 2;
results_so1.delete_old_results(gNo, setNo, minAge, 'noConfirm');


% Set up preamble
results_so1.preamble_init(cS);
   

%% Fit

% Age wage profiles by cohort
results_so1.show_fit(saveFigures, gNo, setNo);
% Aggregate wage stats
% results_so1.fit_aggr_wages(saveFigures, gNo, setNo);
results_so1.fit_wage_st(saveFigures, gNo, setNo);
% Fit cohort profiles: slope and intercept by cohort
results_so1.fit_exper_wage_growth(saveFigures, gNo, setNo)


%% Parameters

results_so1.param_tb(cS.calBase, gNo, setNo);
results_so1.param_tb(cS.calNever, gNo, setNo);
results_so1.skill_prices_show(saveFigures, gNo, setNo);

 
% Show sim results
results_so1.sim_show(saveFigures, gNo, setNo);

%    flat_spot_model_so1(gNo, setNo);
%    flat_spot_show_so1(saveFigures, gNo, setNo);
% 
% 


%%  Aggregate wage stats

% Growth rate of wages versus skill prices
results_so1.wage_skillPrice_growth(saveFigures, gNo, setNo);

results.so1.aggr_wage_stats_show(saveFigures, gNo, setNo);

%    % Lifetime earnings stats
%    % +++++aggr_lty_show_so1(saveFigures, gNo, setNo);
%    % Aggregate study time
%    % +++++aggr_stime_show_so1(saveFigures, gNo, setNo);
%    % How does model get college premium young / old?
%       % redundant given aggr wage stats?
%    collprem_show_so1(saveFigures, gNo, setNo);
%    % How does model get changing returns to experience?
%    %     also has how changing returns to experience are achieved
%    % +++++wage_growth_so1(saveFigures, gNo, setNo);
% 
% 
% 
%    % ***  Counterfactual results
% 
%    % +++++cf_results_so1(gNo, setNo);
% 
%    % Explaining the rise in schooling
%    % +++++rising_school_so1(saveFigures, gNo, setNo);


%%  GE results
% Compare skill weights with what you would get with hours as labor supply
results_so1.skill_weights_show(saveFigures, gNo, setNo)
% 
% 
%    % ***  This must be run last. It crashes on kure
%    if cS.runLocal == 1
%       % Show age profiles by cohort: h, study time
%       age_profile_show_so1(saveFigures, gNo, setNo);
%    end


% Write preamble
results_so1.preamble_make(gNo, setNo);

% Copy results for paper
%  paper_figures_so1;

end