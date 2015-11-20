function run_data_so1(gNo)
% Run all data routines. Needs to be done only once
%{
CPS earnings profiles are constructed before this is run
Only this code should depend on cps data directly

Checked: 
%}
% -------------------------------------------------

cS = const_data_so1(gNo);
setNo = cS.dataSetNo;

saveFigures = 1;



%    % IQ targets
%    iq_targets_so1(gNo, setNo);



%% Compute stats from cps data files

% Constant composition weights for aggregates
data_so1.weights_age_school(gNo);

% Make fraction in each school group by by
data_so1.cohort_school(gNo);

% Make a file with cohort age wage profiles
data_so1.cohort_profiles(gNo);

% Cohort hours or weeks profiles
data_so1.cohort_hours(gNo)
data_so1.cohort_hours_show(saveFigures, gNo);

% Summary stats table for cps data
data_so1.cps_summary_tb(gNo);

% Flat spot wages
% flat_spot_cps_so1(saveFigures, gNo, setNo);

% Make calibration targets
%  Must be done last
data_so1.cal_targets(gNo);



%% Show cal targets 

data_so1.cal_targets_show(saveFigures, gNo);
data_so1.coll_prem_young_old_show(saveFigures, gNo);

data_so1.aggr_wages_show(saveFigures, gNo);
data_so1.cohort_school_show(saveFigures, gNo);
% data_so1.tg_hours_show(saveFigures, gNo);
data_so1.cohort_profiles_show(saveFigures, gNo);

% Data wages by year (stats not in cal_targets)
% data_wages_show_so1(saveFigures, gNo, setNo);

% Aggregate labor supply and college premium
%  Graph like AKK 2008
data_so1.aggr_ls_collprem(saveFigures, gNo);


% Show cross-sectional returns to experience
%  Better method used in quartic model
data_so1.cs_returns_show(saveFigures, gNo);



%  +++ preamble_group_so1(gNo, setNo);

   
end