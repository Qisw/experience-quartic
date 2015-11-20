function aggr_wage_stats_show(saveFigures, gNo, setNo)
% Show wage stats model / data
%{
Uses aggregate cps wage stats

Checked: 2014-apr-8
%}
% ---------------------------------------------------

cS = const_so1(gNo, setNo);
cdS = const_so1(gNo, cS.dataSetNo);
varS = cS.varNoS;
figS = const_fig_so1;

% Data stats
tgS = var_load_so1(varS.vCalTargets, cdS);

% Aggr data stats
% use cal targets where possible
% dataS = var_load_so1(varS.vAggrCpsStats, cdS);

% Compute alternative mean log wage series, from cells
% wageS = aggr_stats_from_cells_so1(tgS.wageM, tgS.aggrDataWtM, cS);


% Model stats
% simStatS = var_load_so1(varS.vSimStats, cS);

calS = var_load_so1(varS.vCalResults, cS);
skillPrice_stM = calS.calDevS.skillPrice_stM;

% Aggr stats from sim histories
mS = var_load_so1(varS.vAggrStats, cS);
% mYearV = mS.yearV;

% Check that data and model conform
% if max(abs(dataS.wagePctV(:) - mS.wagePctV(:)) > 0.01)
%    error('Model and data do not conform');
% end



%% College premium young / old
% There is a difference between coll prem computed from ind data and computed from cell data
% Needs to be reconciled +++
if 1
   ngAge = size(cS.dataS.ageRangeYoungOldM, 1);
   nCases = 2;
   legendV = {'Model', 'Data'};
   
   % Last year has no wage data
   %  Data by [young/middle/old, year]
   data_atM = tgS.collPrem_YoungOldYearM;
   model_atM = mS.collPrem_YoungOld_tM;
   validateattributes(data_atM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '<', 2, ...
      'size', size(model_atM)})
   
   % Figure out common axis range
   [yMin, yMax] = figures_lh.yrange([model_atM(model_atM ~= cS.missVal); data_atM(data_atM ~= cS.missVal)]);

   % One plot per age
   for iAge = 1 : ngAge
      output_so1.fig_new(saveFigures);
      hold on;
      iLine = 0;
      for iCase = 1 : nCases
         if iCase == 1
            % Model
            premV = model_atM(iAge,  :);
         elseif iCase == 2
            % Data: from individual data
            premV = data_atM(iAge, :);
         else
            error('Invalid');
         end
         premV = premV(:);

         idxV = find(premV ~= cS.missVal);
         iLine = iLine + 1;
         plot(cS.wageYearV(idxV),  premV(idxV),  figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine,:));
      end
      hold off;

      xlabel('Year');
      ylabel('College wage premium');
      legend(legendV,  'location', 'best');
      figures_lh.axis_range_lh([NaN, NaN, yMin, yMax]);
      output_so1.fig_format(gca);
      output_so1.fig_save(fullfile(cS.dirS.fitDir, sprintf('aggr_coll_prem_age%i', iAge)), saveFigures, cS);   
   end
end



%% College premium
if 1
   nLines = 3;
   legendV = cell([nLines, 1]);
   output_so1.fig_new(saveFigures);
   hold on;

   model_stM  = mS.logWage_stM;
   if ~v_check(model_stM, 'f', [cS.nSchool, length(cS.wageYearV)], -10, 10, cS.missVal)
      error_so1('Invalid')
   end

   
   for iLine = 1 : nLines
      if iLine == 1
         % Model
         cgV  = model_stM(cS.schoolCG,  :);
         hsgV = model_stM(cS.schoolHSG, :);
         legendV{iLine} = 'Model';
      elseif iLine == 2
         % Data: computed from cell means
         cgV  = tgS.logWage_stM(cS.schoolCG, :);
         hsgV = tgS.logWage_stM(cS.schoolHSG, :);
         legendV{iLine} = 'Data';
      elseif iLine == 3
         % Model skill prices
         %  that coll prem grows somewhat faster; reason is discrepancy between skill prices from
         %  aggr cps stats and from cells by [cohort, age, school] +++
         idxV  = cS.wageYearV - cS.spS.spYearV(1) + 1;
         cgV   = log(skillPrice_stM(cS.schoolCG, idxV));
         hsgV  = log(skillPrice_stM(cS.schoolHSG, idxV));
         % Scale is arbitrary
         cgV   = cgV  - cgV(1)  + tgS.logWage_stM(cS.schoolCG, 1);
         hsgV  = hsgV - hsgV(1) + tgS.logWage_stM(cS.schoolHSG, 1);
         legendV{iLine} = 'Skill prices';
%       elseif iLine == 4
%          % Data
%          cgV  = dataS.meanLogWageSchoolM(cS.schoolCG,  :, dataS.iAdj);
%          hsgV = dataS.meanLogWageSchoolM(cS.schoolHSG, :, dataS.iAdj);
%          yearV = dataS.yearV;
%          legendV{iLine} = 'Data 2';
%       elseif iLine == 5
%          % Model: computed from cell means (does not make a difference)
%          cgV  = simStatS.meanLogWage_stM(cS.schoolCG, :);
%          hsgV = simStatS.meanLogWage_stM(cS.schoolHSG, :);
%          yearV = cS.wageYearV;
%          legendV{iLine} = 'Model 2';
      else
         error('Invalid');
      end
      cgV = cgV(:);
      hsgV = hsgV(:);
   
      idxV = find(cgV ~= cS.missVal  &  hsgV ~= cS.missVal);
      plot(cS.wageYearV(idxV),  cgV(idxV) - hsgV(idxV),  figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine,:));
   end
   hold off;
   xlabel('Year');
   ylabel('College wage premium');
   legend(legendV,  'location', 'best');
   output_so1.fig_format(gca);
   output_so1.fig_save(fullfile(cS.dirS.fitDir, 'coll_prem'), saveFigures, cS);
end



%% Mean or median log wage
if 0
   % currently have no data for log wage by t +++++
   output_so1.fig_new(saveFigures);
   hold on;
   iLine = 1;
   plot(mYearV, mS.logWage_tV, figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine,:));
   iLine = iLine + 1;
   idxV = find(dataS.meanLogWageM(:,2) ~= cS.missVal);
   plot(dataS.yearV(idxV), dataS.meanLogWageM(idxV,2) - log(cS.wageScale), figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine,:));
   
   hold off;
   xlabel('Year');
   ylabel('Mean log wage');
   legend({'Model', 'Data'},  'location', 'best');
   output_so1.fig_format(gca);
   output_so1.fig_save(fullfile(cS.dirS.fitDir, 'aggr_log_wage'), saveFigures, cS);
end




end