function cs_returns_experience(saveFigures, gNo)
% Show cross-sectional returns to experience; model vs data
%{
Using log wages by [age,school,year], run cross-sectional wage regressions for each year / school
Plot the predicted gap between 2 ages
%}

cS = const_data_so1(gNo);
figS = const_fig_so1;
loadS = var_load_so1(cS.varNoS.vQuarticModel, cS);
ageMax = 55;
outDir = cS.dirS.quarticDir;

ny = length(cS.wageYearV);

%    % Wage growth between these 2 experience levels (should not be hard coded +++)
%    experLow = 5;
%    experHigh = 25;


%% Compute wage growth by [school, year]

iModel = 1;
iData = 2;
growth_syxM = nan(cS.nSchool, ny, 2);
for iSchool = 1 : cS.nSchool
   for iy = 1 : ny
      % Data: fit a quadratic
      ageV = (cS.demogS.workStartAgeV(iSchool) : ageMax)';
%      ageV = (cS.dataS.wageGrowthAgeV(1) : cS.dataS.wageGrowthAgeV(2))';
      dataV = loadS.logWage_tsyM(ageV, iSchool, iy);
      growth_syxM(iSchool,iy,iData) = wage_growth(dataV, ageV, cS);

%       ageV = cS.dataS.wageGrowthAgeV;
%       dataV = loadS.logWage_tsyM(ageV, iSchool, iy);
%       growth_syxM(iSchool,iy,iData) = dataV(2) - dataV(1);
      
      % Model: raw wage growth
      ageV = cS.dataS.wageGrowthAgeV;
      dataV = loadS.pred_tsyM(ageV, iSchool, iy);
      if all(dataV ~= cS.missVal)
         growth_syxM(iSchool,iy,iModel) = dataV(2) - dataV(1);
      end
%       if ~any(modelV([experLow, experHigh]) == cS.missVal)
%          growth_syxM(iSchool,iy,iModel) = modelV(experHigh) - modelV(experLow);
%             % wage_growth(modelV, cS);
%       end
   end
end


%% Plot
for iSchool = 1 : cS.nSchool
   fh = output_so1.fig_new(saveFigures, []);
   hold on;
   
   for iLine = [iModel, iData]
      plot(cS.wageYearV,  squeeze(growth_syxM(iSchool,:,iLine)),  ...
         figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine,:))
   end
   
   hold off;
   xlabel('Year');
   ylabel('Cross-sectional wage growth');
   legend({'Model', 'Data'}, 'location', 'southoutside', 'orientation', 'horizontal');
   output_so1.fig_format(fh, 'line');
   output_so1.fig_save(fullfile(outDir, ['cs_return_exper_', cS.schoolSuffixV{iSchool}]),  saveFigures,  cS);
end


end



%% Wage growth from fitted wage regression
function wageGrowth = wage_growth(logWageV, ageV, cS)
   grAgeV = cS.dataS.wageGrowthAgeV;
   
   validateattributes(logWageV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
   
   vIdxV = find(logWageV ~= cS.missVal);
   logWageV = logWageV(vIdxV);
   ageV = ageV(vIdxV);
   
   %if any(logWageV([experLow, experHigh]) == cS.missVal)
   if ~any(ageV == grAgeV(1))  &&  ~any(ageV == grAgeV(2))
      % This year does not have fitted data for the requested ages
      wageGrowth = NaN;
      return;
   end
   
   % Fit the model
   tbM = table(logWageV, ageV, 'VariableNames', {'logWage', 'exper'});
   mdl = fitlm(tbM, 'logWage~1+exper^4');
   
   % Get predicted wages at the 2 experience levels
   %predV = feval(mdl, [experLow; experHigh] ./ 10);
   predV = feval(mdl, grAgeV);
   validateattributes(predV(:), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [2,1]})
   wageGrowth = predV(2) - predV(1);
   
   validateattributes(wageGrowth, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
   assert(abs(wageGrowth) < 2);
end