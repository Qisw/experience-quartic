function aggr_stats_save(gNo, setNo)
% Compute and save aggregate wage stats
%{
Need to be consistent here. Use the correct solutions to fill in non-modeled cohorts

All aggregate stats use time invariant data hours(age, school) as weights!
These cannot be used to compute equilibrium objects!

Checked: 2014-apr-8
%}
% -----------------------------------------------

cS = const_so1(gNo, setNo);

% Compute resid std
% doStdResid = 1;
tgS = data_load_so1(cS.varNoS.vCalTargets, gNo);
yearV = cS.wageYearV(1) : cS.wageYearV(end); 
% Age range to use for aggregate stats
ageMin = cS.dataS.aggrAgeRangeV(1);
ageMax = cS.dataS.aggrAgeRangeV(end);


% Load
% calS = var_load_so1(cS.varNoS.vCalResults, cS);
simS = var_load_so1(cS.varNoS.vSimResults, cS);
% ssV  = var_load_so1(cS.varNoS.vSteadyStates, cS);
paramS = var_load_so1(cS.varNoS.vParams, cS);


% Add a year dimension to data weights (same in all years)
ny = length(yearV);
wt_tsyM = repmat(tgS.aggrDataWt_tsM, [1, 1, ny]);
assert(isequal(size(wt_tsyM),  [size(tgS.aggrDataWt_tsM), ny]));
checkLH.approx_equal(wt_tsyM(:,:,1),  tgS.aggrDataWt_tsM, 1e-8, []);



%% Collect "steady state" matrices
% They are currently simply the first and last modeled cohorts

nSS = 2;
ssCohortV = [1, cS.nCohorts];
logWageSS_tscM = repmat(cS.missVal, [cS.demogS.ageRetire, cS.nSchool, nSS]);
sTimeSS_tscM   = repmat(cS.missVal, [cS.demogS.ageRetire, cS.nSchool, nSS]);
tEndowSS_tscM  = repmat(cS.missVal, [cS.demogS.ageRetire, cS.nSchool, nSS]);

if 1  % +++ trying alternative comp of non modeled cohorts
   % Take 1st / last modeled cohort
   for iSS = 1 : nSS
      logWageSS_tscM(:,:,iSS) = log_lh(simS.wage_tscM(:,:,ssCohortV(iSS)), cS.missVal);
      sTimeSS_tscM(:,:,iSS)  = simS.sTime_tscM(:,:,ssCohortV(iSS));
      for iSchool = 1 : cS.nSchool
         tEndowSS_tscM(:,iSchool,iSS) = paramS.tEndow_tscM(:,iSchool,ssCohortV(iSS));
      end
   end
end



%%  Make sim histories into data by year, with weights matching aggrDataWtM


% Outputs are by [age, school, year]
logWage_tsyM = aggr_so1.cs_data(log_lh(simS.wage_tscM, cS.missVal), ...
   logWageSS_tscM, yearV, ageMin, ageMax, cS);

size_tsyV = [ageMax, cS.nSchool, length(yearV)];
validateattributes(logWage_tsyM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   'size', size_tsyV})

% Compute aggr stats from sim histories
%  Year range automatically matches targets
aggrS = aggr_so1.aggr_stats(logWage_tsyM, wt_tsyM, yearV, ageMin, ageMax, cS);

var_save_so1(aggrS, cS.varNoS.vAggrStats, cS);



%%  Average study time by year

% Study time by [age, school, year]
sTime_tsyM = aggr_so1.cs_data(simS.sTime_tscM, sTimeSS_tscM,  ...
   yearV, ageMin, ageMax, cS);
validateattributes(sTime_tsyM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   'size', size_tsyV})


% Outputs are by [ind, age, school, year]
tEndow_tsyM = aggr_so1.cs_data(paramS.tEndow_tscM, tEndowSS_tscM,  ...
   yearV, ageMin, ageMax, cS);


% Compute averages for years with wage data
nYr = length(yearV);
saveS.avgSTime_tV   = zeros([nYr, 1]);
saveS.avgTEndow_tV  = zeros([nYr, 1]);

% Loop over years
for iy = 1 : nYr
   % Make a matrix of wages and weights by [age, school]
   yrSTime_tsM  = sTime_tsyM(ageMin:ageMax, :, iy);
   yrTEndow_tsM = tEndow_tsyM(ageMin:ageMax, :, iy);
   yrWt_tsM     = wt_tsyM(ageMin:ageMax, :, iy) .* (yrSTime_tsM >= 0);
   
   idxV = find(yrWt_tsM > 0);
   tWt = sum(yrWt_tsM(idxV));
   saveS.avgSTime_tV(iy)  = sum(yrSTime_tsM(idxV)  .* yrWt_tsM(idxV)) ./ tWt;
   saveS.avgTEndow_tV(iy) = sum(yrTEndow_tsM(idxV) .* yrWt_tsM(idxV)) ./ tWt;
end

if cS.dbg > 10
   if ~v_check(saveS.avgSTime_tV, 'f', [nYr, 1], 0, max(tEndow_tsyM(:)), [])
      error_so1('Invalid');
   end
   if ~v_check(saveS.avgTEndow_tV, 'f', [nYr, 1], 0, max(tEndow_tsyM(:)), [])
      error_so1('Invalid');
   end
end

saveS.yearV = yearV;
var_save_so1(saveS, cS.varNoS.vAggrSTime, cS);


%% Output check

validateattributes(saveS.avgSTime_tV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
validateattributes(saveS.avgTEndow_tV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})


end