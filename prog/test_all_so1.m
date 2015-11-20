function test_all_so1(gNo, setNo)
% Run all test routines that do not require a solved model
% --------------------------------------------------

cS = const_so1(gNo, setNo);
paramS = param_load_so1(gNo, setNo);
% Also test saved solution?
testSolution = false;

fprintf('\nTesting everything\n');


%% Grouped

% Aggregates
aggr_so1.test_aggr(testSolution, gNo, setNo);

% Parameters
param_so1.test_all(gNo, setNo);

% Results
% +++++  results_so1.test_results(gNo, setNo);


%% Household

hh_so1.ojt_solve_test(gNo, setNo);
hh_so1.sim_histories_test(gNo, setNo);


%% GE

% t_ge_technology_so1(gNo, setNo);
% t_ge_cal_weights_so1(gNo, setNo)
% t_ss_solve_givensp_so1(gNo, setNo);
% t_ss_solve_so1(gNo, setNo)
% t_ss_solve_given_wages_so1(gNo, setNo)
% t_aggr_ls_so1(gNo, setNo)
% t_cohort_to_year_so1(gNo, setNo)
% t_cs_data_so1(gNo, setNo);


%% Calibration

calibr_so1.skill_weights_test(gNo, setNo);
calibr_so1.skill_price_comp_test(gNo, setNo);
calibr_so1.aggr_ls_test(gNo, setNo);
calibr_so1.skill_price_dev_test(gNo, setNo)
calibr_so1.cal_dev_test(gNo, setNo);

calibrate_so1('test', gNo, setNo);


%% Other

var_save_test_so1(gNo, setNo);

% t_skill_price_comp_so1(gNo, setNo);
% t_guess_make_so1(gNo, setNo);
% t_aggr_stats_from_cells_so1(gNo, setNo)
% 

end