function fh = plot_by_year(data_itM, yearV, yLabelStr, legendV, saveFigures, cS)

figS = const_fig_so1;

fh = output_so1.fig_new(saveFigures);
hold on;

% Keep track of series plotted
ns = size(data_itM, 1);
plottedV = zeros(ns, 1);

for i1 = 1 : size(data_itM, 1)
   yV = data_itM(i1,:)';
   idxV = find(yV ~= cS.missVal  &  ~isnan(yV));
   if length(idxV) > 3
      plot(yearV(idxV), yV(idxV), figS.lineStyleDenseV{i1}, 'color', figS.colorM(i1,:));
      plottedV(i1) = 1;
   end
end

hold off;
if any(plottedV)
   legend(legendV(find(plottedV)));
end
xlabel('Year');
ylabel(yLabelStr);
output_so1.fig_format(fh, 'line');



end