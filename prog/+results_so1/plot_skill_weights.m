function plot_skill_weights(skillWeight_syM, yearV, figFn, saveFigures, cS)
% Local: plot model or data skill weights
%{
IN
   skillWeight_syM
%}

figS = const_fig_so1;

iSchoolV = 1 : cS.nSchool;
iSchoolV(cS.iHSG) = [];
legendV = cS.schoolLabelV(iSchoolV);

output_so1.fig_new(saveFigures, figS.figOpt2AcrossS);   
hold on;
iLine = 0;

for iSchool = iSchoolV
   yV = log(skillWeight_syM(iSchool, :));
   iLine = iLine + 1;
   plot(yearV,  yV,  figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine,:));      
end

% Also plot linear trends
iLine = 0;
for iSchool = iSchoolV
   yV = log(skillWeight_syM(iSchool, :));
   mdl = fitlm(yearV, yV, 'linear');
   yFitV = mdl.Fitted;
   iLine = iLine + 1;
   plot(yearV,  yFitV,  '-.', 'color', figS.colorM(iLine,:));      

end

hold off;
xlabel('Year');
ylabel('Log skill weights (relative)');
legend(legendV, 'location', 'best');
output_so1.fig_format(gca, 'line');
output_so1.fig_save(figFn, saveFigures, cS);

end
