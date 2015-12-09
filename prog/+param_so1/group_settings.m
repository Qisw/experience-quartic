function cS = group_settings(cInS)
%{
Groups determine data construction
Everything else can be changed by sets
%}

cS = cInS;
gNo = cS.gNo;


%% Group numbers

groupS.gDefault = 9;

% Age dummies
groupS.gAgeDummies = 5;
% Quartic, only workers
groupS.gQuarticWorkers = 6;
% Quartic, cohort effects fit ex post
groupS.gQuarticCohortExPost = 7;
% No cohort effects
groupS.gNoCohortEffects = 8;
% Quartic model (not age dummies)
groupS.gExperQuartic = 9;


%% Default Model Features

groupS.groupStr = sprintf('g%03i', gNo);

% Which filter settings to use for cps sample?
% 'all': keep everyone
% 'wageEarners': only keep persons who work for wages, have valid wages
groupS.cpsEarnFlt = EnumLH('all', {'all', 'wageEarners'});




%% Group settings

if gNo == groupS.gAgeDummies
   groupS.groupStr = 'Age dummies';
   cS.quarticS.ageEffects.set('ageDummies');

elseif gNo == groupS.gQuarticCohortExPost
   cS.quarticS.cohortEffects.set('expost');
   
elseif gNo == groupS.gQuarticWorkers
   groupS.groupStr = 'Wage earners';
   groupS.cpsEarnFlt.set('wageEarners');
   
elseif gNo == groupS.gNoCohortEffects
   groupS.groupStr = 'No cohort effects';
   cS.quarticS.cohortEffects.set('none');

elseif gNo == groupS.gExperQuartic
   groupS.groupStr = 'ExperQuartic';
   
else
   error('Invalid gNo');
end


cS.groupS = groupS;


end