function test_all_so1(gNo, setNo)
% Run all test routines that do not require a solved model
% --------------------------------------------------

cS = const_so1(gNo, setNo);

fprintf('\nTesting everything\n');


%% Grouped

% Aggregates
aggr_so1.test_aggr(testSolution, gNo, setNo);

% Parameters
param_so1.test_all(gNo, setNo);


%% Helper

helper_so1.exper_wage_growth_test(gNo);


%% Other

var_save_test_so1(gNo, setNo);


end