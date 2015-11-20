function hist_resid(modelV, dataV, wtV, cS)
% Histogram of residuals
% Show histogram of residuals + some stats about fit

figS = const_fig_so1;
modelV = modelV(:);
dataV  = dataV(:);
wtV    = wtV(:);

idxV   = find(dataV ~= cS.missVal  &  modelV ~= cS.missVal  &  wtV > 0);
wtV    = wtV(idxV) ./ sum(wtV(idxV));
modelV = modelV(idxV);
dataV  = dataV(idxV);
residV = modelV - dataV;
totalWt = sum(wtV);

% binEdgesV = -0.5 : 0.05 : 0.5;
% binEdgesV(end) = max(binEdgesV(end), max(residV) + 0.01);

[rStd, rMean] = stats_lh.std_w(residV, wtV, cS.dbg);
rss = sum(residV .^ 2  .* wtV) ./ totalWt;
dMean = sum(dataV .* wtV) ./ totalWt;
tss = sum((dataV - dMean) .^ 2  .* wtV) ./ totalWt;
fprintf('std resid: %5.2f    mean resid: %5.2f    tss: %5.2f    rss: %5.2f    R2: %5.2f \n', ...
   rStd, rMean,  tss, rss, 1 - rss / tss);

[yV, xV] = ksdensity(residV, 'weights', wtV);

plot(xV, yV);
axisV = axis;

% showPlot = 1;
% hist_weighted(residV, wtV, binEdgesV, showPlot, cS.dbg);
text(axisV(1) + 0.1 * (axisV(2)-axisV(1)), axisV(3) + 0.1 * (axisV(4)-axisV(3)), ...
   sprintf('R^2: %4.2f   std: %4.2f', 1-rss/tss, rStd), 'Fontsize', figS.figFontSize);

end

