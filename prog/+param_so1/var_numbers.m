function cS = var_numbers


%%  Data variables: 201-300

% Range of data variables
cS.dataVarRangeV = [201, 300];

% Stats by [age, school, year]. Simply copied from cpsojt
cS.vAgeSchoolYearStats = 201;

% Stats by [birth year, school, age]. Simply copied from cpsojt
cS.vBYearSchoolAgeStats = 208;

% Data wage profiles
cS.vDataProfiles = 202;

% Schooling by cohort
cS.vCohortSchool = 203;
cS.vCohortSchoolYears = 214;

% Age hours profiles
cS.vCohortHours = 204;

% Data constants, for preamble etc
cS.vDataConstants = 205;

% Data wages by year
% cS.vDataWageYear = 206;

% CPS population weights by [age, school]. For computing constant composition aggregates
% Mass in each cell. Averaged over years
cS.vAggrCpsWeights = 210;

% Aggregate CPS wage stats
cS.vAggrCpsStats = 211;

% % Flat spot wages
% cS.vFlatSpotWages = 207;

% Calibration targets
% Calibration targets
cS.vCalTargets = 209;

% % IQ targets (from NLSY)
% cS.vTgIq = 213; 

% CPS earnings profiles filter settings
cS.vCpsEarnFilter = 215;

% Preamble for data
cS.vDataPreamble = 216;


% Model with fixed experience profiles
cS.vQuarticModel = 250;
cS.vQuarticSkillWeights = 251;

cS.vTest = 299;


end