function cohEffect_scM = cohort_effects(logWage_tscM, pred_tscM, saveFigures, gNo)
% Cohort effects implied by quartic regression
%{
This is exploratory
After running regression without cohort effects, find the cohort effects that minimize sum of
squared residuals
Is there an interpretation for these?
%}

cS = const_data_so1(gNo);
% qS = var_load_so1(cS.varNoS.vQuarticModel, cS);
figS = const_fig_so1;


%% Make cohort effects

[nAge, nSchool, nc] = size(logWage_tscM);

cohEffect_scM = repmat(cS.missVal, [nSchool, nc]);
for ic = 1 : nc
   for iSchool = 1 : nSchool
      idxV = find(logWage_tscM(:,iSchool,ic) ~= cS.missVal  &  pred_tscM(:,iSchool,ic) ~= cS.missVal);
      if length(idxV) > 5
         cohEffect_scM(iSchool, ic) = mean(logWage_tscM(idxV,iSchool,ic)) - mean(pred_tscM(idxV,iSchool,ic));
      end
   end
end


%% Plot them

fh = output_so1.fig_new(saveFigures, []);
hold on;

for iSchool = 1 : nSchool
   idxV = find(cohEffect_scM(iSchool, :) ~= cS.missVal);
   plot(cS.demogS.bYearV(idxV),  cohEffect_scM(iSchool, idxV),  ...
      figS.lineStyleDenseV{iSchool}, 'color', figS.colorM(iSchool,:));
end

hold off;
xlabel('Cohort');
ylabel('Cohort effect');
legend(cS.schoolLabelV, 'location', 'southoutside', 'orientation', 'horizontal');
output_so1.fig_format(fh, 'line');
output_so1.fig_save(fullfile(cS.dirS.quarticDir, 'cohort_effects'), saveFigures, cS);


%% Relative to HSG

sRef = cS.iHSG;
fh = output_so1.fig_new(saveFigures, []);
hold on;

for iSchool = 1 : nSchool
   idxV = find(cohEffect_scM(iSchool, :) ~= cS.missVal  &  cohEffect_scM(sRef, :) ~= cS.missVal);
   plot(cS.demogS.bYearV(idxV),  cohEffect_scM(iSchool, idxV) - cohEffect_scM(sRef, idxV),  ...
      figS.lineStyleDenseV{iSchool}, 'color', figS.colorM(iSchool,:));
end

hold off;
xlabel('Cohort');
ylabel('Cohort effect');
legend(cS.schoolLabelV, 'location', 'southoutside', 'orientation', 'horizontal');
output_so1.fig_format(fh, 'line');
output_so1.fig_save(fullfile(cS.dirS.quarticDir, 'cohort_effects_relative'), saveFigures, cS);




end