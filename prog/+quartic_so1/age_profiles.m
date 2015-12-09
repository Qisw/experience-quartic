% Show quartic age profiles
function age_profiles(saveFigures, gNo)

cS = const_data_so1(gNo);
baseAge = 25;


%% Get age effects and year effects

loadS = var_load_so1(cS.varNoS.vQuarticModel, cS);
profileV = loadS.wrS.age_year_effects(cS.dbg);

x_isM = repmat(cS.missVal, [100, cS.nSchool]);
y_isM = repmat(cS.missVal, [100, cS.nSchool]);

for iSchool = 1 : cS.nSchool
   regrS = profileV{iSchool};
   idxV = 1 : length(regrS.ageValueV);
   x_isM(idxV,iSchool) = regrS.ageValueV;
   y_isM(idxV,iSchool) = regrS.ageDummyV - regrS.ageDummyV(regrS.ageValueV == baseAge);
end


%% Plot

fh = output_so1.plot_by_school(x_isM, y_isM, 'Age', 'Log wage', saveFigures, cS);
output_so1.fig_save(fullfile(cS.dirS.quarticDir, 'profiles'), saveFigures, cS);

end
