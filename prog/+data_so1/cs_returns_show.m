function cs_returns_show(saveFigures, gNo)

cS = const_data_so1(gNo);
figS = const_fig_so1;

loadS = var_load_so1(cS.varNoS.vAgeSchoolYearStats, cS);

logWage_tsyM = log_lh(loadS.wageMedian_astuM(:,:,:,cS.dataS.iuCpsEarn), cS.missVal, cS.dbg);
ny = size(logWage_tsyM, 3);

mass_tsyM = max(0, loadS.mass_astuM(:,:,:,cS.dataS.iuCpsEarn));
wt_tsM = squeeze(sum(mass_tsyM, 3));

ratio_syM = repmat(cS.missVal, [cS.nSchool, ny]);
for iSchool = 1 : cS.nSchool
   age1 = cS.demogS.workStartAgeV(iSchool);
   ageYoungV = age1 + (0 : 4) + 5;
   ageOldV   = age1 + (30 : 34);
   dAge = mean(ageOldV) - mean(ageYoungV);
  
   for iy = 1 : ny
      % Young
      yV = logWage_tsyM(ageYoungV, iSchool, iy);
      wtV = wt_tsM(ageYoungV, iSchool);
      idxV = find(yV ~= cS.missVal  &  wtV > 0);
      logWageYoung = sum(yV(idxV) .* wtV(idxV)) ./ sum(wtV(idxV));
      
      % Old
      yV = logWage_tsyM(ageOldV, iSchool, iy);
      wtV = wt_tsM(ageOldV, iSchool);
      idxV = find(yV ~= cS.missVal  &  wtV > 0);
      logWageOld = sum(yV(idxV) .* wtV(idxV)) ./ sum(wtV(idxV));
      
      ratio_syM(iSchool, iy) = (logWageOld - logWageYoung) ./ dAge;
   end
end


%% Plot

iSchoolV = [cS.iHSG, cS.iCG];
fh = output_so1.fig_new(saveFigures, []);
hold on;

for i1 = 1 : length(iSchoolV)
   iLine = i1;
   plot(cS.wageYearV, ratio_syM(iSchoolV(i1), :), figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine,:));
end

hold off;
xlabel('Year');
ylabel('Return to experience');
output_so1.fig_format(fh, 'line');
output_so1.fig_save('cs_return_experience', saveFigures, cS);

end