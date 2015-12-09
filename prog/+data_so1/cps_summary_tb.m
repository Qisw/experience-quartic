function cps_summary_tb(gNo)
% Table with summary stats for cps data
% ---------------------------------------

cS = const_data_so1(gNo);
varS = param_so1.var_numbers;
dirS = cS.dirS;

% Notation
ageStr = cS.symS.retrieve('age', false);
sStr = cS.symS.retrieve('sIndex', false);
cohSchoolStr = cS.symS.retrieve('cohSchool', false);


% Years to show
yearV = 1965 : 5 : 2005;
ny = length(yearV);

% Age range to report
ageRangeV = cS.dataS.aggrAgeRangeV(1) : cS.dataS.aggrAgeRangeV(2);

% Load summary data
outS = output_so1.var_load(varS.vAgeSchoolYearStats, cS);


%% *****  Table layout

% Rows are years
nr = 1 + ny;

% Columns
nc = 1;
nc = nc + 1;   cNobs = nc;
% no of obs in each [by, school, age] cell
%  in age range used to compute wages
nc = nc + 1;   cNobsCell = nc;
cNobsMinMax = -1;
% nc = nc + 1;   cNobsMinMax = nc;
nc = nc + 1;   cAvgSchool = nc;
nc = nc + 1;   cWageMedian = nc;

tbM = cell([nr, nc]);
tbS.rowUnderlineV = zeros([nr, 1]);
tbS.rowUnderlineV(1) = 1;

% Header row
ir = 1;
tbM{ir, 1} = 'Year';
tbM{ir, cNobs} = '$N$';
tbM{ir, cNobsCell} = ['$N_{', ageStr, ',', sStr, '}$'];
if cNobsMinMax > 0
   tbM{ir, cNobsMinMax} = '$N$ range';
end
tbM{ir, cAvgSchool} = cS.symS.retrieve('cohSchool', true);
tbM{ir, cWageMedian} = 'Median wage';


%% ******  Table body

for iy = 1 : ny
   ir = 1 + iy;
   tbM{ir, 1} = sprintf('%i', yearV(iy));
   
   % Universe: wage earners
   iu = cS.dataS.iuCpsEarn;
   yrIdx = find(outS.yearV == yearV(iy));
   
   nObs_asM = outS.nObs_astuM(ageRangeV, :, yrIdx, iu);
   nObs_asM = max(0, nObs_asM);
   
   if sum(nObs_asM(:)) < 1e3      
      error_so1('Too few obs in a year');
   end
   
   tbM{ir, cNobs} = separatethousands(sum(nObs_asM(:)), ',', 0);
   
   % No of obs
   nObsPosV = nObs_asM(nObs_asM > 0);
   tbM{ir, cNobsCell} = sprintf('%i', round(median(nObsPosV)));
   if cNobsMinMax > 0
      tbM{ir, cNobsMinMax} = sprintf('%i - %i', min(nObsPosV), max(nObsPosV));
   end
   
   % Average years of schooling
   avgSchool_asM = outS.schoolYrMean_astuM(ageRangeV, :, yrIdx, iu);
   avgSchool = sum(avgSchool_asM(:) .* nObs_asM(:)) ./ sum(nObs_asM(:));
   tbM{ir, cAvgSchool} = sprintf('%.1f', avgSchool);
   
   % Median wage
   wageMedian_asM = outS.wageMedian_astuM(ageRangeV, :, yrIdx, iu);
   wageMedian = sum(wageMedian_asM(:) .* nObs_asM(:)) ./ sum(nObs_asM(:));
   [~, tbStr] = string_lh.dollar_format(wageMedian, ',', 0);
   tbM{ir, cWageMedian} = tbStr;
   
end


%% ******  Write table

tbS.noteV = {['Notes: ',  tbM{1, cNobs}, ' is the number of observations in the year. '], ...
   [tbM{1, cNobsCell}, ' is the median number of observations in each (age, school) cell. '], ...
   [tbM{1, cAvgSchool}, ' denotes average years of schooling.'], ...
   };
   % '$N$ range shows the minimum and maximum number of observations in each cell. ', ...
   % sprintf('Cells cover age range %i-%i.', ageRangeV(1), ageRangeV(end))};

fid = fopen(fullfile(dirS.tbDir, 'cps_tb.tex'), 'w');
latex_lh.latex_texttb_lh(fid, tbM, 'Caption', 'Label', tbS);
fclose(fid);
disp('Saved table  cps_tb.tex');




end