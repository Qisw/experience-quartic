function dataS = data_const
% Data constants. Can be changed by gNo, setNo

% Years with data (matrices are indexed by this)
dataS.yearV = 1964 : 2010;

% Years with wage data
dataS.wageYearV = 1964 : 2009;

dataS.cpiBaseYear = 2010;


% The universe dimension of the files copied from cpsearn
%  hard coded +++
dataS.iuCpsEarn = 2;    % only wage earners
dataS.iuCpsAll =  1;    % 'all'

% Must count this. Otherwise cannot use universe of 'all'
dataS.fracBusInc = 2/3;

% Age range that defines young / middle / old
%  Card / Lemieux 2001
dataS.ageRangeYoungOldM = [26, 35;    36, 44;    45, 60];
ng = size(dataS.ageRangeYoungOldM, 2);
dataS.label_yoV = cell(ng, 1);
for ig = 1 : ng
   dataS.label_yoV{ig} = sprintf('Age %i-%i', dataS.ageRangeYoungOldM(:, ig));
end

% Age range for computing aggregates
dataS.aggrAgeRangeV = [25; 60];  

% Compute wage growth over this age range
dataS.wageGrowthAgeV = [25; 40];

% Compute cohort schooling over this age range
dataS.schoolAgeRangeV = [30, 50];

% HP filter param for smooth hours profiles
% dataS.hpFilterHours = 20;

% Min no of wage obs to keep a cell
dataS.minWageObs = 50;



end