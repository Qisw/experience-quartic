function fit_wage_st(saveFigures, gNo, setNo)
%  How does model fit log median wage by (s,t)?

cS = const_so1(gNo, setNo);
varS = cS.varNoS;
figS = const_fig_so1;
tgS = data_load_so1(varS.vCalTargets, gNo);
mS = var_load_so1(varS.vAggrStats, cS);


plotYearV = cS.wageYearV;

for iSchool = 1 : cS.nSchool
   output_so1.fig_new(saveFigures);
   hold on;

   iLine = 0;

   % Model
   iLine = iLine + 1;
   mYearV = mS.yearV;
   modelV = mS.logWage_stM(iSchool,:);
   idxV = find(mYearV >= plotYearV(1)  &  mYearV <= plotYearV(end)  &  modelV ~= cS.missVal);
   plot(mYearV(idxV), modelV(idxV), figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine,:));

   % Data
   iLine = iLine + 1;
   dataV = tgS.logWage_stM(iSchool, :);  
   if length(dataV) ~= length(plotYearV)
      error_so1('Years do not match');
   end
   idxV = find(dataV ~= cS.missVal);
   plot(plotYearV(idxV), dataV(idxV), figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine,:));


   hold off;
   xlabel('Year');
   ylabel('Log wage');
   legend({'Model', 'Data'}, 'location', 'south', 'orientation', 'horizontal');
   output_so1.fig_format(gca);
   output_so1.fig_save(fullfile(cS.dirS.fitDir, ['aggr_wage_', cS.schoolSuffixV{iSchool}]), saveFigures, cS);
end

end

