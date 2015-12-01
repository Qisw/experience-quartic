function dataS = data_const
% Data constants. Can be changed by gNo, setNo

% The universe dimension of the files copied from cpsearn
%  hard coded +++
dataS.iuCpsEarn = 2;    % only wage earners
dataS.iuCpsAll =  1;    % 'all'

% Must count this. Otherwise cannot use universe of 'all'
dataS.fracBusInc = 2/3;

% Give all cohorts the same hours profiles?
dataS.sameHoursAllCohorts = true;

% Age range that defines young / middle / old
%  Card / Lemieux 2001
dataS.ageRangeYoungOldM = [26, 35;    36, 44;    45, 60];
ng = size(dataS.ageRangeYoungOldM, 2);
dataS.label_yoV = cell(ng, 1);
for ig = 1 : ng
   dataS.label_yoV{ig} = sprintf('Age %i-%i', dataS.ageRangeYoungOldM(:, ig));
end

% Age range for computing aggregates
dataS.aggrAgeRangeV = [25; 60];  % +++ how to set this?

% Compute wage growth over this age range
dataS.wageGrowthAgeV = [25; 40];

% HP filter param for smooth hours profiles
dataS.hpFilterHours = 20;


end