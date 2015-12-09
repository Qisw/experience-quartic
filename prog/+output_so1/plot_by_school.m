function fh = plot_by_school(x_isM, y_isM, xLabelStr, yLabelStr, saveFigures, cS)
% Plot a bunch of data series for each school level
%{
Line graph

IN
   x_isM
      x values by [observation, school group]
      can be a single vector, applied then to all school groups
%}

if min(size(x_isM)) == 1
   % Vector; expand to matrix
   x_isM = repmat(x_isM(:), [1, cS.nSchool]);
end
validateattributes(x_isM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(y_isM)})


figS = const_fig_so1;
fh = output_so1.fig_new(saveFigures, figS.figOpt2AcrossS);
   
hold on;
for iSchool = 1 : cS.nSchool
   yV = y_isM(:, iSchool);
   xV = x_isM(:, iSchool);
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
legend(cS.schoolLabelV, 'location', 'best');
output_so1.fig_format(gca, 'line');


end