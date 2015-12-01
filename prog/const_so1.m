function cS = const_so1(gNo, setNo)
% Set constants
%{
If setNo invalid: set cS.validSet = 0


Index order
   [age t,  year y,  h,  s,  cohort c]
   matrices are indexed by physical age

Conventions
   in birth year, person is age +++
   matrices are indexed by physical age
   year = [birth year] + age - 1
   present values do not discount current period values


Checked: 2015-Oct-26
%}


% Start with constants that do not depend on group or set
cS = constants_so1;


cS.gNo   = gNo;
cS.setNo = setNo;
cS.validSet = 1;

% Descriptive string
cS.setStr = 'default';

% Version. To ensure that all results are consistent
cS.version = 3;

% Notation
cS.symS = param_so1.symbols;
% Variable numbers
cS.varNoS = param_so1.var_numbers;



%%  Data parameters

cS.dataS = data_so1.data_const;

% Quartic model settings
cS.quarticS = param_so1.QuarticModel;

% Years with wage data
cS.wageYearV = 1964 : 2010;


% Compute cohort schooling over this age range
%  make sure this is used in cps routines +++
cS.schoolAgeRangeV = [30, 50];

% Use median or mean log wage?
cS.useMedianWage = 1;

% Data wages are not expected to be > this value (to check scaling)
cS.maxWage = 10;

% for cps data routines (as string, b/c we don't know the number)
cS.cpsSetNoStr = 'setExperDefault';

% Min no of wage obs to keep a cell
cS.minWageObs = 50;

% Hourly or weekly wages
%  Make sure this matches what cps profiles use +++
cS.hourlyWages = 53;
cS.weeklyWages = 33;
cS.wagePeriod = cS.weeklyWages;



%% Default: Demographics
% Named choices go here. The actual parameter are derived later

cS.demogSettingS.cohDefStr = EnumLH('quartic', {'annual', 'default', 'quartic', 'bowlus', 'long'});


%% Default: What is calibrated

% Calibrate base parameters only
cS.doCalV = cS.calBase;

% Substitution elasticities
cS.calWhatS.substElast = true;




%% Grouped settings
% All of these can be overridden by groups or sets

% Settings for skill price paths
cS.spSpecS = skillPriceSpecs_so1('wageYears', 'sbtc', 'constGrowth', 'constGrowth');

% Calibration targets
cS.calS = CalSettingsSo1;

%  Groups override parameters
[cS, groupS] = param_so1.group_settings(cS);
cS.groupS = groupS;

%  Sets override settings again
cS = param_so1.set_settings(cS);
cS.dataSetNo = cS.setS.dataSetNo;


%%  Implied parameters
% Only here are actual parameter set. Before we just choose named settings

% Also defines what is calibrated / fixed
% cS.pvector = param_so1.pvector_default(cS);

% Demographics
workStartAge_sV = [18, 19, 21, 23]';
cS.demogS = DemographicsSo1(workStartAge_sV(1), 65, workStartAge_sV, cS.demogSettingS);
cS.nCohorts = cS.demogS.nCohorts;


cS.dirS = param_so1.directories([], cS.gNo, cS.setNo);

cS.nCohorts = cS.demogS.nCohorts;

% Age in year of birth
cS.ageInBirthYear = cS.demogS.ageInBirthYear;


if cS.useMedianWage == 1
   cS.wageStr = 'Log median wage';
else
   cS.wageStr = 'Mean log wage';
end

% Scale factors for hours and wages
if cS.wagePeriod == cS.hourlyWages
   % Wage scale makes wages roughly equal to 1
   cS.wageScale = 20;
   % Scale factor for annual hours worked
   cS.hoursScale = 2e3;
elseif cS.wagePeriod == cS.weeklyWages
   cS.wageScale = 500;
   cS.hoursScale = 40;
else
   error('Invalid');
end

   
% Self-test
if cS.dbg > 10
   param_so1.const_check(cS);
end

end