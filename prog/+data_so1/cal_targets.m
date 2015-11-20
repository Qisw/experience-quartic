function cal_targets(gNo)
% Save calibration targets
%{

Important:
Must rerun when data constants change!

Targets are
   sFrac_scM(school, cohort)
      fraction in each school group
   logWage_tscM(age, school, cohort)
      mean log wages  OR  log median wages
      scaled 
   nObs_tscM
      no of obs in each cell
   wt_tscM(age, school, cohort)
      mass in each cell (goes with wageM)
      sums to 100
      earlier cohorts have only about half the weight of later cohorts
      change that? +++

   logWage_stM(school, year)
      mean log wage, taken across cohorts in each year

   IQ targets
      betaIQ
         coefficient of regressing log wage at age cS.iqAge on IQ, school
         dummies
%}


cS = const_data_so1(gNo);
varS = param_so1.var_numbers;

size_ascV = [cS.demogS.ageRetire, cS.nSchool, cS.nCohorts];


%%  IQ targets
if cS.hasIQ == 1
   error('not updated');
   tgS.betaIQ = 0.104;
   tgS.iqAge = cS.iqAge;
   
   % From NLSY
   %  betaIQ by experience. 
   iqS = output_so1.var_load(cS.vTgIq, cS);
   % Max exper = 1.5 mean experience in sample
   tgS.iqExperV = 1 : 18;
   tgS.betaIqExperV = iqS.betaIQV(tgS.iqExperV);
   
   % Taubman wales: birth year and iq pct scores by [no college/college, cohort]
   % Last column is NLSY
%    tgS.twIqByV = [1925, 1929, 1934, 1946, 1950, 1957, 1960, 1961, 1960+18] - 18;
%    tgS.twIqPctM = [53, 47; 56, 45;  58, 43;  63, 43;  61, 42; 62, 40;  63, 35;  62, 36;  63, 35]' ./ 100;
      % update from JME +++++ currently eyeballed
   tgS.twIqByV  = [1920,   1930,    1940,    1950,    1960,    1970,    1980];
   tgS.twIqPctM = [61, 44; 63, 43;  64, 41;  64, 39;  63, 38;  61, 35;  59, 30]' ./ 100;

   % Interpolate for birth cohorts used in model
   tgS.iqPctM = zeros([2, cS.nCohorts]);
   for i1 = 1 : 2
      % Assume constant after last cohort
      tgS.iqPctM(i1, :) = interp1([tgS.twIqByV, 2000], [tgS.twIqPctM(i1,:), tgS.twIqPctM(i1,end)], ...
         cS.demogS.bYearV, 'linear');
   end
   if any(isnan(tgS.iqPctM(:)))
      error('Interpolation failed');
   end
end   


%% Schooling

tgS.sFrac_scM = output_so1.var_load(varS.vCohortSchool, cS);
check_lh.prob_check(tgS.sFrac_scM, 1e-5);

loadS = output_so1.var_load(varS.vCohortSchoolYears, cS);
tgS.schoolYrMean_cV = loadS.schoolYrMean_cV;
clear loadS;


%%  Data from profiles: wages, no of obs, weights
% There are missing values (not observed ages)

loadS = output_so1.var_load(varS.vDataProfiles, cS);


% Mean / median log wages, by [age, school, cohort]
if cS.useMedianWage == 1
   tgS.logWage_tscM = log_lh(loadS.wageMedian_ascM, cS.missVal);
else
   tgS.logWage_tscM = loadS.wageMeanLog_ascM;
end


% Scale factor (subtracted from log wages)
dataM = tgS.logWage_tscM(25 : 60, :, :);
tgS.logWageScaleFactor = median(dataM(dataM ~= cS.missVal));

tgS.logWage_tscM = matrix_lh.m_oper(tgS.logWage_tscM, tgS.logWageScaleFactor, '-', cS.missVal, cS.dbg);


% No of obs
tgS.nObs_tscM = loadS.nObs_ascM;
% should be integer, but is currently not +++
validateattributes(tgS.nObs_tscM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   'size', size(tgS.logWage_tscM)});


% Std log wage
% tgS.stdLogWageM = loadS.stdLogWageSmoothM;


% Used to compute weighted deviations
tgS.wageWt_tscM = sqrt(max(0, tgS.nObs_tscM));
wtMean = mean(tgS.wageWt_tscM(tgS.wageWt_tscM(:) > 0));
tgS.wageWt_tscM = tgS.wageWt_tscM ./ wtMean;



%% Time endowment by [age, school, year]
% Not a target - a model input
% Extended to all ages. No missing values, except when not working
% Scale is such that mean hours are roughly 1

hS = output_so1.var_load(varS.vCohortHours, cS);

hours_asM = hS.hoursFit_asM;
validateattributes(hours_asM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   'size', [cS.demogS.ageRetire, cS.nSchool]});
tgS.hoursScaleFactor = median(hours_asM(hours_asM > 0));
hours_asM = hours_asM ./ tgS.hoursScaleFactor;
hours_asM(hours_asM <= 0) = cS.missVal;

% Just give each cohort fitted hours
tgS.hours_tscM = zeros(size_ascV);
for ic = 1 : cS.nCohorts
   tgS.hours_tscM(:,:,ic) = hours_asM;
end

validateattributes(tgS.hours_tscM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   'size', size_ascV})



%% Log aggr wage by [age, school, year]
% Model input. Years are cS.wageYearV

loadS = output_so1.var_load(varS.vAgeSchoolYearStats, cS);

data_tsyM = log_lh(loadS.wageMedian_astuM(1:cS.demogS.ageRetire,:,:, cS.dataS.iuCpsEarn), cS.missVal);
% Scale
tgS.logWage_tsyM = matrix_lh.m_oper(data_tsyM, tgS.logWageScaleFactor, '-', cS.missVal, cS.dbg);

% Quick fix b/c the wage data for last year are missing +++++
ny = length(cS.wageYearV);
tgS.logWage_tsyM(:,:,ny) = tgS.logWage_tsyM(:,:,ny-1);


validateattributes(tgS.logWage_tsyM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   'size', [cS.demogS.ageRetire, cS.nSchool, length(cS.wageYearV)]})

% Check that consistent with log wage by [a,s,c]
for iSchool = 1 : cS.nSchool
   logWage_atM = squeeze(tgS.logWage_tsyM(:, iSchool, :));
   logWage_caM = econ_lh.cohort_age_from_age_year(logWage_atM, 1 : cS.demogS.ageRetire, cS.wageYearV, cS.demogS.bYearV, ...
      cS.ageInBirthYear, cS.missVal, cS.dbg);
   % This could fail with multi year birth cohorts
   % Missing values can be different
   diffM = matrix_lh.m_oper(squeeze(tgS.logWage_tscM(:, iSchool, :)), logWage_caM', '-', cS.missVal, cS.dbg);
   assert(max(abs(diffM(diffM ~= cS.missVal))) < 1e-2);
end

% Uses workers (b/c it is means to reflect the std error of wages)
tgS.nObs_tsyM = loadS.nObs_astuM(1:cS.demogS.ageRetire, :, :, cS.dataS.iuCpsEarn);

% Quick fix b/c the wage data for last year are missing +++++
ny = length(cS.wageYearV);
tgS.nObs_tsyM(:,:,ny) = tgS.nObs_tsyM(:,:,ny-1);




%%  Aggregate stats, using constant composition weights
% All indexed by cS.wageYearV

% Load cps weights, by [age, school]
%  Held constant for all years
tgS.aggrDataWt_tsM = output_so1.var_load(varS.vAggrCpsWeights, cS);
for iSchool = 1 : cS.nSchool
   validateattributes(tgS.aggrDataWt_tsM(cS.demogS.workStartAgeV(iSchool) : cS.demogS.ageRetire, iSchool), ...
      {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, '<=', 1});
end


if 1
   % *****  Compute directly from cps
   % Not constant composition +++++
   loadS = output_so1.var_load(varS.vAggrCpsStats, cS);

   % Mean / median log wage by [school, year]. 
   if cS.useMedianWage == 1
      tgS.logWage_stM = log_lh(loadS.wageMedian_stuM(:,:,cS.dataS.iuCpsEarn), cS.missVal);
   else
      tgS.logWage_stM = loadS.wageMeanLog_stuM(:,:,cS.dataS.iuCpsEarn);
   end
   
   % Scale
   tgS.logWage_stM = matrix_lh.m_oper(tgS.logWage_stM, tgS.logWageScaleFactor, '-', cS.missVal, cS.dbg);
   
   % Temporary fix +++++
   tgS.logWage_stM(:, end) = tgS.logWage_stM(:, end-1);
   
   validateattributes(tgS.logWage_stM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      '>', cS.missVal + 1,  'size', [cS.nSchool, length(cS.wageYearV)]})
   
   
   % College premium
   tgS.collPrem_tV = matrix_lh.m_oper(tgS.logWage_stM(cS.iCG, :)',  tgS.logWage_stM(cS.iHSG, :)',  '-',  ...
      cS.missVal, cS.dbg);
   

   % College premium by [young/middle/old, year]
   %  Log wage gap relative to HS
   if cS.useMedianWage
      logWage_ymo_stM = log_lh(loadS.wageMedian_ymo_stuM(:,:,:,cS.dataS.iuCpsEarn),  cS.missVal);
   else
      logWage_ymo_stM = loadS.wageMeanLog_ymo_stuM(:,:,:,cS.dataS.iuCpsEarn);
   end
   tgS.collPrem_YoungOldYearM = matrix_lh.m_oper(squeeze(logWage_ymo_stM(:, cS.iCG, :)),  squeeze(logWage_ymo_stM(:, cS.iHSG, :)), ...
      '-', cS.missVal, cS.dbg);

   
else
   error('Not updated');
   % ***** Use age wage profiles used in model calibration
   % This is not consistent when medians are used. They do not aggregate from cells
   wageS = aggr_stats_from_cells_so1(tgS.logWage_tscM, tgS.aggrDataWt_tsM, cS);

   tgS.logWage_stM = wageS.out_stM;
   tgS.collPrem_YoungOldYearM = wageS.collPrem_YoungOldYearM;
   tgS.collPrem_tV = wageS.collPrem_tV;

   clear wageS;   
end

if cS.dbg > 10
   validateattributes(tgS.logWage_stM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
   validateattributes(tgS.collPrem_YoungOldYearM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [3, length(cS.wageYearV)]})
end


%% Aggregate hours worked by [age, school, year]
% For aggregating labor supplies
% for years in cS.wageYearV

% stats by age/school/year
dataS = output_so1.var_load(varS.vAgeSchoolYearStats, cS);

iu = cS.dataS.iuCpsAll;
tgS.aggrHours_tsyM = dataS.mass_astuM(1:cS.demogS.ageRetire,:,:,iu) .* dataS.weeksMean_astuM(1:cS.demogS.ageRetire,:,:,iu);
% Scale to approximately 1
tgS.aggrHours_tsyM = tgS.aggrHours_tsyM ./ tgS.aggrHours_tsyM(30, 2, 20) .* 2;
tgS.aggrHours_tsyM(tgS.aggrHours_tsyM <= 0) = cS.missVal;

% Current bug: last year has no hours (why?) +++++
tgS.aggrHours_tsyM(:,:,end) = tgS.aggrHours_tsyM(:,:, end-1);

validateattributes(tgS.aggrHours_tsyM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   'size', [cS.demogS.ageRetire, cS.nSchool, length(cS.wageYearV)]});


% Aggregate over ages
tgS.aggrHours_stM = repmat(cS.missVal, [cS.nSchool, length(cS.wageYearV)]);
for iSchool = 1 : cS.nSchool
   ageV = cS.demogS.workStartAgeV(iSchool) : cS.demogS.ageRetire;
   tgS.aggrHours_stM(iSchool, :) = sum(max(0, tgS.aggrHours_tsyM(ageV, iSchool, :)), 1);
end
validateattributes(tgS.aggrHours_stM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
   'size', [cS.nSchool, length(cS.wageYearV)]});



var_save_so1(tgS, varS.vCalTargets, cS);

end