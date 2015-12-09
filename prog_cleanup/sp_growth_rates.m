function spGrowthS = sp_growth_rates(gNo, setNo)
% Compute average skillprice growth rates (also wage growth rates from the data)

cS = const_so1(gNo, setNo);
varS = param_so1.var_numbers;


%%  Load

% Load calibration results
loadS = var_load_so1(varS.vCalResults, cS);
% paramS = loadS.paramS;
outS = loadS.calDevS;
tgS  = loadS.tgS;


%% Average over entire period with wage data
if true
   % Find common year range. Data are always the constraint
   spGrowthS.spGrowthYearV = cS.wageYearV([1, end]);
   dy = diff(spGrowthS.spGrowthYearV);

   % Data
   idxV = spGrowthS.spGrowthYearV - cS.wageYearV(1) + 1;
   spGrowthS.spDataGrowthV = (tgS.logWage_stM(:,idxV(2)) - tgS.logWage_stM(:,idxV(1))) ./ dy;
   
   idxV = spGrowthS.spGrowthYearV - cS.spS.spYearV(1) + 1;
   spGrowthS.spModelGrowthV = (log(outS.skillPrice_stM(:,idxV(2))) - log(outS.skillPrice_stM(:,idxV(1)))) ./ dy;  

   if cS.dbg > 10
      if ~v_check(spGrowthS.spDataGrowthV, 'f', [cS.nSchool, 1], -0.3, 0.3, [])
         error_so1('Invalid sp growth', cS);
      end
      if ~v_check(spGrowthS.spModelGrowthV, 'f', [cS.nSchool, 1], -0.3, 0.3, [])
         error_so1('Invalid sp growth', cS);
      end
   end
end




end