function fh = plot_by_school(xV, y_isM, xLabelStr, yLabelStr, saveFigures, cS)
% Plot a bunch of data series for each school level
% Line graph

figS = const_fig_so1;

fh = output_so1.fig_new(saveFigures);
   
hold on;
for iSchool = 1 : cS.nSchool
   yV = y_isM(:, iSchool);
   idxV = find(~isnan(yV)  &  (yV ~= cS.missVal));
   if ~isempty(idxV)
      if length(idxV) < 20
         lineStyleStr = figS.lineStyleV{iSchool};
      else
         lineStyleStr = figS.lineStyleDenseV{iSchool};
      end
      plot(xV(idxV), yV(idxV), lineStyleStr, 'Color', figS.colorM(iSchool,:));
   end
end
hold off;

xlabel(xLabelStr);
ylabel(yLabelStr);
legend(cS.schoolLabelV, 'location', 'southoutside', 'orientation', 'horizontal');
output_so1.fig_format(gca, 'line');


end