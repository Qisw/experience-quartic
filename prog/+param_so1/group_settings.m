function [cS, groupS] = group_settings(cInS)
%{
Groups determine data construction
Everything else can be changed by sets

IN
   pvec :: pvectorLH

%}

cS = cInS;
gNo = cS.gNo;


%% Group numbers

cS.gDefault = 5;
% Quartic
cS.gQuartic = 5;
% Quartic, only workers
cS.gQuarticWorkers = 6;
% Quartic, cohort effects fit ex post
cS.gQuarticCohortExPost = 7;
% No cohort effects
cS.gNoCohortEffects = 8;


%% Default Model Features

groupS.groupStr = sprintf('g%03i', gNo);

% Does model have any IQ targets?
cS.hasIQ = 0;

% Which filter settings to use for cps sample?
% 'all': keep everyone
% 'wageEarners': only keep persons who work for wages, have valid wages
groupS.cpsEarnFlt = EnumLH('all', {'all', 'wageEarners'});

% % Year range over which constant sbtc is assumed
% gS.sbtcAllYears = 21;
% gS.sbtcWageYears = 23;     % only gS.wageYearV (in sample)
% gS.sbtcYears = gS.sbtcAllYears;
% 
% % How to handle out of sample skill prices
% % Penalty from constant SBTC
% gS.spOutOfSampleSbtc = 39;
% % On growth trend in first / last year of skill prices (these years are arbitrary +++)
% gS.spOutOfSampleOnTrend = 41;
% gS.spOutOfSample = gS.spOutOfSampleSbtc;



%% Group settings

if any(gNo == [cS.gQuartic, cS.gQuarticCohortExPost])
   groupS.groupStr = 'Quartic';
   %cS.demogSettingS.cohDefStr.set('quartic');
   if gNo == cS.gQuarticCohortExPost
      cS.quarticS.cohortEffects.set('expost');
   end
   
elseif gNo == cS.gQuarticWorkers
   groupS.groupStr = 'QuarticWorkers';
   %cS.demogSettingS.cohDefStr.set('quartic');
   groupS.cpsEarnFlt.set('wageEarners');
   
elseif gNo == cS.gNoCohortEffects
   cS.quarticS.cohortEffects.set('none');

elseif gNo == cS.gDefault
   groupS.groupStr = 'Default';
   
else
   error('Invalid gNo');
end


end