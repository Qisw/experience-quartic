%  Plot time effects and data wages
function time_effects(saveFigures, gNo)
   cS = const_data_so1(gNo);
   figS = const_fig_so1;
   tgS = var_load_so1(cS.varNoS.vCalTargets, cS);
   loadS = var_load_so1(cS.varNoS.vQuarticModel, cS);
   
   profileV = loadS.wrS.age_year_effects(cS.dbg);
   
   for iSchool = 1 : cS.nSchool
      regrS = profileV{iSchool};
      
      % Model time effects
      baseYear = 1965;
      baseIdx = find(regrS.yearValueV == baseYear);
      timeDummyV = regrS.yearDummyV - regrS.yearDummyV(baseIdx);

      dataWageV  = tgS.logWage_syM(iSchool,cS.wageYearIdxV)';
      baseWage   = dataWageV(cS.wageYearV == baseYear);

      vIdxV = matrixLH.find_valid([regrS.yearDummyV(:), dataWageV(:)], cS.missVal);
     
      
      output_so1.fig_new(saveFigures, []);
      hold on;
      iLine = 1;
      plot(regrS.yearValueV(vIdxV),  timeDummyV(vIdxV) + baseWage,  ...
         figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine, :));
      iLine = iLine + 1;
      plot(cS.dataS.wageYearV(vIdxV), dataWageV(vIdxV),  ...
         figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine, :));
      
      hold off;
      xlabel('Year');
      ylabel('Log wage');
      legend({'Model', 'Data'});
      output_so1.fig_format(gca, 'line');
      output_so1.fig_save(fullfile(cS.dirS.quarticDir, ['wage_time_', cS.schoolSuffixV{iSchool}]),  saveFigures, cS);
   end
end
