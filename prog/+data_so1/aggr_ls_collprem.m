function aggr_ls_collprem(saveFigures, gNo)
% Show aggregate labor supply college/non-college vs college premium
%{
Checked: 2015-Dec-1
%}

cS = const_data_so1(gNo);
yearV = cS.dataS.yearV;
nYr = length(yearV);
varS = param_so1.var_numbers;
figS = const_fig_so1;

tgS = var_load_so1(varS.vCalTargets, cS);

logWage_syM = matrix_lh.Matrix(tgS.logWage_syM, cS.missVal);
% hours_syM = matrix_lh.Matrix(tgS.aggrHours_syM, cS.missVal);
logHours_syM = matrix_lh.Matrix(log_lh(tgS.aggrHours_syM, cS.missVal), cS.missVal);


%%  Construct labor by school


% Hours by college / non-college
% Count half of CD as unskilled; as in Autor et al 

% Years with data
idxV = find(min(tgS.aggrHours_syM) > 0);

hours2M = zeros([2, nYr]);
hours2M(1, :) = sum(tgS.aggrHours_syM(cS.iHSD,:) + tgS.aggrHours_syM(cS.iHSG,:) + ...
   0.5 .* tgS.aggrHours_syM(cS.iCD, :));
hours2M(2, :) = 0.5 .* tgS.aggrHours_syM(cS.iCD, :) + tgS.aggrHours_syM(cS.iCG, :);

relLSV = repmat(cS.missVal, [nYr, 1]);
relLSV(idxV) = log_lh(hours2M(2,idxV) ./ hours2M(1,idxV), cS.missVal)';
validateattributes(relLSV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [nYr, 1]})

% Detrend
idxV = find(relLSV ~= cS.missVal);
gLS = (relLSV(idxV(end)) - relLSV(idxV(1))) ./ (idxV(end) - idxV(1));
relLSV(idxV) = relLSV(idxV) - gLS .* (idxV - idxV(1));


%%  College premium
% Years match cS.wageYearV
% Constant composition wage premium

relLogWage_syM = logWage_syM.vector_operOut(tgS.logWage_syM(cS.iHSG,:), logWage_syM.minus);

collPremV = relLogWage_syM(cS.iCG, :)';
validateattributes(collPremV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [nYr, 1]})

% Detrend
idxV = find(collPremV ~= cS.missVal);
gLS = (collPremV(idxV(end)) - collPremV(idxV(1))) ./ (idxV(end) - idxV(1));
collPremV(idxV) = collPremV(idxV) - gLS .* (idxV - idxV(1));


%%  Plot

output_so1.fig_new(saveFigures);
idxV = find(relLSV ~= cS.missVal  &  collPremV ~= cS.missVal);
hold on;
iLine = 1;
plot(yearV(idxV),  relLSV(idxV) - relLSV(idxV(1)),  figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine,:));
iLine = iLine + 1;
plot(yearV(idxV),  collPremV(idxV) - collPremV(idxV(1)),  figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine,:));
hold off;

xlabel('Year');
legend({'Rel LS', 'Coll prem'}, 'location', 'best');
output_so1.fig_format(gca, 'line');
output_so1.fig_save('aggr_ls_collprem', saveFigures, cS);


%% Relative labor supplies
if 1
   % Hours in year 1 normalized to 0
   y_syM = logHours_syM.vector_operOut(logHours_syM.mM(:, 1), logHours_syM.minus);
   
   fh = output_so1.plot_by_school(yearV, y_syM', 'Year', 'Log hours', saveFigures, cS);
   output_so1.fig_save('aggr_ls', saveFigures, cS);
end


end