function aggr_wages_show(saveFigures, gNo)
% Show aggregate wages
%{
%}

cS = const_data_so1(gNo);
varS = param_so1.var_numbers;
figS = const_fig_so1;

tgS = output_so1.var_load(varS.vCalTargets, cS);


%% Levels
if 1
   fh = output_so1.plot_by_school(cS.dataS.yearV, tgS.logWage_syM', 'Year', 'Log wage', saveFigures, cS);
   output_so1.fig_save('aggr_wage', saveFigures, cS);
end


%% Relative to HSG
if 1
   data_syM = tgS.logWage_syM - repmat(tgS.logWage_syM(cS.iHSG,:), [cS.nSchool, 1]);
   data_syM(tgS.logWage_syM == cS.missVal) = cS.missVal;
   
   fh = output_so1.plot_by_school(cS.dataS.yearV, data_syM', 'Year', 'Log wage relative to HSG', saveFigures, cS);
   output_so1.fig_save('aggr_collprem', saveFigures, cS);
end



end