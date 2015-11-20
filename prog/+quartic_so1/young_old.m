% College premium young / old
function young_old(saveFigures, gNo)
   cS = const_data_so1(gNo);
   loadS = var_load_so1(cS.varNoS.vQuarticModel, cS);
   figS = const_fig_so1;

   % Aggregate stats from data
   dataS = aggr_so1.aggr_stats(loadS.logWage_tsyM, loadS.wt_tsyM, cS.wageYearV, cS.demogS.workStartAgeV(1), ...
      cS.quarticS.ageMax, cS);
   % From fitted model
   modelS = aggr_so1.aggr_stats(loadS.pred_tsyM, loadS.wt_tsyM, cS.wageYearV, cS.demogS.workStartAgeV(1), ...
      cS.quarticS.ageMax, cS);
   
   ngAge = size(cS.dataS.ageRangeYoungOldM, 1);
   suffixV = {'young', 'middle', 'old'};

   for ig = 1 : ngAge
      dataV = dataS.collPrem_YoungOld_tM(ig, :);
      modelV = modelS.collPrem_YoungOld_tM(ig, :);
      vIdxV = matrixLH.find_valid([dataV(:), modelV(:)], cS.missVal);
      
      fh = output_so1.fig_new(saveFigures, []);
      hold on;
      iLine = 1;
      plot(cS.wageYearV(vIdxV), modelV(vIdxV), figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine,:));
      iLine = iLine + 1;
      plot(cS.wageYearV(vIdxV), dataV(vIdxV),  figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine,:));
      
      hold off;
      xlabel('Year');
      ylabel('College premium');
      legend({'Model', 'Data'}, 'location', 'northwest');
      output_so1.fig_format(fh, 'line');
      output_so1.fig_save(fullfile(cS.dirS.quarticDir, ['collprem_', suffixV{ig}]),  saveFigures,  cS);
   end
end
