function run_cpsearn(gNo)
% Run cpsearn routines to generate raw data files to import

fprintf('Running cpsearn routines \n');
cS = const_data_so1(gNo);
dirS = cS.dirS;
varS = param_so1.var_numbers;
% Keep wage data for these ages
dataAgeV = cS.demogS.age1 : cS.demogS.ageRetire;

% Get cps setNo
cpsS = const_cpsearn(1);
cpsSetNo = cpsS.(cS.cpsSetNoStr);
cpsS = const_cpsearn(cpsSetNo);


%% Filter settings

fltS = import_cpsearn.filter_settings(cpsS.fltExperDefault, cpsS);

fltS.cpiBaseYear = cS.dataS.cpiBaseYear;

% Years with data to use
fltS.yearV = 1964 : 2010;

% Wage years
fltS.wageYearV = fltS.yearV - 1;
fltS.wageYearV(fltS.wageYearV < 1964) = [];

fltS.bYearV = 1910 : 2000;

% Add some slack at the top (b/c one cpsearn routine wants it)
fltS.ageMax = cS.demogS.ageRetire + 4;

% Very little filtering
fltS.hoursMin = [];
fltS.weeksMin = [];

fltS.dropGq = false;
fltS.dropZeroEarn = false;
fltS.dropNonWageWorkers = false;

% Must count this to avoid artificial zeros
fltS.fracBusInc = cS.dataS.fracBusInc;

fltS.ymoAgeRangeM = cS.dataS.ageRangeYoungOldM;

if cS.groupS.cpsEarnFlt.equals('all')
   % nothing
elseif cS.groupS.cpsEarnFlt.equals('wageEarners')
   fltS.hoursMin = 20;
   fltS.weeksMin = 20;
   fltS.dropGq = true;
   fltS.dropZeroEarn = true;
   fltS.dropNonWageWorkers = true;
   fltS.fracBusInc = 0;
else
   error('Invalid');
end

fltS.validate;

output_cpsearn.var_save(fltS, cpsS.vFilterSettings, [], cpsSetNo);
% Also save locally so it can be retrieved more easily
var_save_so1(fltS, cS.varNoS.vCpsEarnFilter, cS);



%% Settings for earnings profiles
% Not directly used below. Just for checking results

profS = profiles_cpsearn.settings('exper');
profS.ageWorkStart_sV = cS.demogS.workStartAgeV;
output_cpsearn.var_save(profS, cpsS.vProfileSettings, [], cpsSetNo);


%% Run everything

run_all_cpsearn(cpsSetNo);


%% Copy files from cpsojt to make code independent for kure

% Get age profiles
%  only for requested ages, by [by, school, age]
outS = aggr_cpsearn.byear_school_age_stats(cS.demogS.bYearLbV, cS.demogS.bYearUbV, dataAgeV, cpsSetNo);
output_so1.var_save(outS, varS.vBYearSchoolAgeStats, cS);

% Stats by [age, school, year]
outS = output_cpsearn.var_load(cpsS.vAgeSchoolYearStats, [], cpsSetNo);
output_so1.var_save(outS, varS.vAgeSchoolYearStats, cS);

% Copy aggregate stats from cps
loadS = output_cpsearn.var_load(cpsS.vAggrStats, [], cpsSetNo);
output_so1.var_save(loadS, varS.vAggrCpsStats, cS);



cd(dirS.progDir);

end