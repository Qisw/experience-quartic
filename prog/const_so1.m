function cS = const_so1(gNo, setNo)
% Set constants
%{
If setNo invalid: set cS.validSet = 0


Index order
   [age t,  year y,  s,  cohort c]
   matrices are indexed by physical age

Conventions
   in birth year, person is age cS.demogS.ageInBirthYear
      year = [birth year] + age - 1

Checked: 2015-Oct-26
%}


% Start with constants that do not depend on group or set
cS = constants_so1;


cS.gNo   = gNo;
cS.setNo = setNo;
cS.validSet = 1;

% Directories
cS.dirS = param_so1.directories([], cS.gNo, cS.setNo);

% Notation
cS.symS = param_so1.symbols;

% Variable numbers
cS.varNoS = param_so1.var_numbers;

% Data parameters
cS.dataS = data_so1.data_const;
% Years with wage data
cS.wageYearV = cS.dataS.wageYearV;

% Use median or mean log wage?
cS.useMedianWage = 1;

% for cps data routines (as string, b/c we don't know the number)
cS.cpsSetNoStr = 'setExperDefault';

% Hourly or weekly wages
%  Make sure this matches what cps profiles use +++
cS.hourlyWages = 53;
cS.weeklyWages = 33;
cS.wagePeriod = cS.weeklyWages;

% Demographics
% Named choices go here. The actual parameter are derived later
cS.demogSettingS.cohDefStr = EnumLH('quartic', {'annual', 'default', 'quartic', 'bowlus', 'long'});

% Quartic model settings
cS.quarticS = param_so1.QuarticModel;

% Result settings
cS.resultS = param_so1.result_settings;

%  Groups override parameters
cS = param_so1.group_settings(cS);

%  Sets override settings again
cS.setS = param_so1.set_settings(cS);


%%  Implied parameters
% Only here are actual parameter set. Before we just choose named settings

% Demographics
workStartAge_sV = [18, 19, 21, 23]';
cS.demogS = DemographicsSo1(workStartAge_sV(1), 65, workStartAge_sV, cS.demogSettingS);
cS.nCohorts = cS.demogS.nCohorts;

% Indices of years with wages
cS.wageYearIdxV = cS.dataS.wageYearV - cS.dataS.yearV(1) + 1;
assert(isequal(cS.dataS.yearV(cS.wageYearIdxV),  cS.dataS.wageYearV));


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


% ******  Result display

% Age range to display for cohort wage profiles
cS.resultS.ageRange_asM = [cS.demogS.workStartAgeV(:)';  repmat(cS.quarticS.ageMax, [1, cS.nSchool])];

   
end