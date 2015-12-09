function quartic_run_so1(gNo)
% Results for model with fixed experience profiles

saveFigures = 1;

cS = const_data_so1(gNo);
quartic_so1.model(gNo);

% Table with regression coefficients
%  currently only "works" with experience polynomial and cohort effects as fct of schooling
quartic_so1.regr_table(gNo);

% College premium young / old
quartic_so1.young_old(saveFigures, gNo)
quartic_so1.age_profiles(saveFigures, gNo)
quartic_so1.time_effects(saveFigures, gNo)
if cS.quarticS.cohortEffects.equals('dummies')  ||  cS.quarticS.cohortEffects.equals('schooling')  ||  ...
   cS.quarticS.cohortEffects.equals('schoolYears')
   quartic_so1.cohort_effects_show(saveFigures, gNo);
end
quartic_so1.cohort_profiles(saveFigures, gNo)
quartic_so1.experience_growth(saveFigures, gNo)
quartic_so1.cs_returns_experience(saveFigures, gNo)
quartic_so1.fit_summary(gNo);

quartic_so1.skill_weights(gNo);
quartic_so1.skill_weights_show(saveFigures, gNo);




end