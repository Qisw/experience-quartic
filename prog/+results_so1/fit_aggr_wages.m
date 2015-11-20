function fit_aggr_wages(saveFigures, gNo, setNo)
% Compare model with aggregate wage stats
%{
Duplicates showing calibration targets, but that is hard to avoid

Checked: 2014-apr-8
%}

cS = const_so1(gNo, setNo);
varS = cS.varNoS;
figS = const_fig_so1;

loadS = var_load_so1(varS.vCalResults, cS);
outS = loadS.calDevS;

simS = var_load_so1(varS.vSimResults, cS);
simStatS = var_load_so1(varS.vSimStats, cS);

cdS = const_so1(gNo, cS.dataSetNo);
tgS = var_load_so1(varS.vCalTargets, cdS);




%%  IQ: Model vs data
if cS.calS.tgIq > 0
   error('Not updated');
   output_so1.fig_new(saveFigures);
   
   hold on;
   plot(cS.demogS.bYearV, tgS.iqPctM(1,:), figS.lineStyleV{1}, 'Color', figS.colorM(1,:));
   plot(cS.demogS.bYearV, simS.meanIqPctM(1,:), figS.lineStyleV{2}, 'Color', figS.colorM(1,:));
   
   plot(cS.demogS.bYearV, tgS.iqPctM(2,:), figS.lineStyleV{1}, 'Color', figS.colorM(2,:));
   plot(cS.demogS.bYearV, simS.meanIqPctM(2,:), figS.lineStyleV{2}, 'Color', figS.colorM(2,:));
   hold off;
   
   axisV = axis;
   axisV(3) = 0;
   axis(axisV);
   xlabel('Birth year');
   ylabel('Mean IQ percentile score');
   legend({'College data', 'College model',  'No college data', 'No college model'},  'Location', 'South');

   output_so1.fig_format(gca);
   figFn = 'iq_model_data';
   output_so1.fig_save(figFn, saveFigures, [], cS);
   
   %return;
end





%%  Labor inputs per hour, by [age, school, year]
if 0
   error('Not updated');
   % Show these years
   yearV = cS.wageYearV(1 : 4 : 20);
   legendV = arrayfun(@(x) {sprintf('%d', x)}, yearV);
  
   for iSchool = 1 : cS.nSchool
      ageV = cS.demogS.workStartAgeV(iSchool) : cS.demogS.ageRetire;
      output_so1.fig_new(saveFigures);
      hold on;
      
      for iLine = 1 : length(yearV)
         dataV = outS.meanLPerHour_astM(ageV, iSchool, yearV(iLine)-cS.spS.spYearV(1)+1);
         idxV = find(dataV ~= cS.missVal);
         plot(ageV(idxV),  dataV(idxV),  figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine,:));         
      end
      
      hold off;
   
      xlabel('Age');
      ylabel('Mean L per hour');
      legend(legendV)
      output_so1.fig_format(gca);
      output_so1.fig_save(['mean_l_perhour_at_', cS.schoolSuffixV{iSchool}], saveFigures, [], cS);
   end
end





   

end



