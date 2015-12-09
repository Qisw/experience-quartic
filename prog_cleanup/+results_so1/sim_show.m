function sim_show(saveFigures, gNo, setNo)
% Show simulation results
%{

Checked: 2014-apr-4
%}
% ----------------------------------------------

cS = const_so1(gNo, setNo);
varS = param_so1.var_numbers;
dirS = cS.dirS;

% Skill price growth rates
spGrowthS = aggr_so1.sp_growth_rates(gNo, setNo);

calS = var_load_so1(varS.vCalResults, cS);
outS = calS.calDevS;



%% ********  Table with summary stats
if 1
   nr = 20;
   nc = 2;
   tbM = cell([nr, nc]);
   tbS.rowUnderlineV = zeros([nr, 1]);
   tbS.showOnScreen = 1;

   % Header row
   ir = 1;
   tbM{ir,1} = 'Statistic';
   tbM{ir,2} = 'Value';
   

   % ******  Technicalities
   
   ir = ir + 1;
   tbM{ir, 1} = 'Set description';
   tbM{ir, 2} = ' ';
   
   % Set name
   ir = ir + 1;
   tbM{ir, 1} = 'Label';
   tbM{ir, 2} = cS.setStr;

   % Exit flag
   ir = ir + 1;
   tbM{ir, 1} = 'exit flag';
   tbM{ir, 2} = sprintf('%i', calS.exitFlag);
   
%    % Version of settings
%    ir = ir + 1;
%    tbM{ir, 1} = 'Version';
%    tbM{ir, 2} = sprintf('%i', version1);
   

   % *****  Deviations
   
   ir = ir + 1;
   tbM{ir, 1} = 'Deviations';
   tbM{ir, 2} = ' ';
   
   % Deviation
   ir = ir + 1;
   tbM{ir, 1} = 'Deviation';
   tbM{ir, 2} = sprintf('%6.4f', calS.dev);
   
   % Mean log wage deviation
   if isfield(outS, 'scalarMeanDev')
      ir = ir + 1;
      tbM{ir, 1} = 'Dev log wage';
      tbM{ir, 2} = sprintf('%6.4f', outS.scalarMeanDev);
   end

   % Growth rate of skill prices
   ir = ir + 1;
   tbM{ir, 1} = 'g(w)';
   xStr = sprintf('%4.1f, ',  100 .* spGrowthS.spModelGrowthV);
   tbM{ir, 2} = xStr(1 : (end-2));

   
   % Write table
   tbS.rowUnderlineV = tbS.rowUnderlineV(1 : ir);
   fid = fopen(fullfile(dirS.tbDir, 'tb_stats.tex'), 'w');
   latex_lh.latex_texttb_lh(fid, tbM(1:ir,:), 'Caption', 'Label', tbS);
   fclose(fid);
   disp('Saved table  tb_stats.tex');
end





end