function wage_skillPrice_growth(saveFigures, gNo, setNo)
% Growth of wages versus model skill prices

cS = const_so1(gNo, setNo);

spGrowthS = aggr_so1.sp_growth_rates(gNo, setNo);



%%  Table: wage growth rates
if 01
   dataGrowthV = spGrowthS.spDataGrowthV(:);
   modelGrowthV = spGrowthS.spModelGrowthV(:);
   
   
   % ********  Bar graph
   output_so1.fig_new(saveFigures);
   bar(1 : cS.nSchool, [dataGrowthV(:), modelGrowthV(:)]);
   set(gca, 'XTick', 1 : cS.nSchool,  'XTickLabel', cS.schoolLabelV);
   ylabel(sprintf('Change in mean log wage, %i-%i', spGrowthS.spGrowthYearV));
   xlabel('School group');
   legend({'Data', 'Model'}, 'Location', 'Northwest');
   output_so1.fig_format(gca, 'bar');
   output_so1.fig_save('wage_growth_bar', saveFigures, cS);
   

   % ********  Bar graph: wage premium
   output_so1.fig_new(saveFigures);
   sIdxV = 1 : cS.nSchool;
   sIdxV(cS.schoolHSG) = [];
   dataSpV  = dataGrowthV(sIdxV)  - dataGrowthV(cS.schoolHSG);
   modelSpV = modelGrowthV(sIdxV) - modelGrowthV(cS.schoolHSG);
   bar(1 : (cS.nSchool-1), [dataSpV(:), modelSpV(:)]);
   set(gca, 'XTick', 1 : (cS.nSchool-1),  'XTickLabel', cS.schoolLabelV(sIdxV));
   ylabel(sprintf('Change in wage relative to HSG, %i-%i', spGrowthS.spGrowthYearV));
   xlabel('School group');
   legend({'Data', 'Model'}, 'Location', 'Northwest');
   output_so1.fig_format(gca, 'bar');
   output_so1.fig_save('sp_growth_bar', saveFigures, cS);

   
   % ********  Table layout

   nc = 5;

   nr = 6;
   tbM = cell([nr, nc]);
   tbS.rowUnderlineV = zeros([nr, 1]);
   tbS.lineStrV = cell([nr, 1]);
   tbS.colLineV = zeros([nc, 1]);
   tbS.colLineV([2, 4]) = 1;
   tbS.showOnScreen = 1;

   % Header
   tbS.lineStrV{1} = ' & \multicolumn{2}{|c|}{Skill price growth}  &  \multicolumn{2}{|c}{Skill premium growth}';
   ir = 2;
   tbS.rowUnderlineV(ir) = 1;
   tbM(ir, :) = {'School group', 'Data', 'Model', 'Data', 'Model'};

   for iSchool = 1 : cS.nSchool
      ir = ir + 1;
      tbM{ir, 1} = cS.schoolLabelV{iSchool};
      
      tbM{ir, 2} = sprintf('%4.1f', dataGrowthV(iSchool) .* 100);
      tbM{ir, 3} = sprintf('%4.1f', modelGrowthV(iSchool) .* 100);
      
      tbM{ir, 4} = sprintf('%4.1f', (dataGrowthV(iSchool)  - dataGrowthV(cS.schoolHSG)) .* 100);
      tbM{ir, 5} = sprintf('%4.1f', (modelGrowthV(iSchool) - modelGrowthV(cS.schoolHSG)) .* 100);
   end

   
   fid = fopen(fullfile(cS.dirS.tbDir, 'wage_growth.tex'), 'w');
   latex_lh.latex_texttb_lh(fid, tbM, 'Caption', 'Label', tbS);
   fclose(fid);
   disp('Saved table  wage_growth.tex');
   fprintf('Year range: %i - %i \n', spGrowthS.spGrowthYearV);
   %keyboard;
end

end