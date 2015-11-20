% Show quartic age profiles
function age_profiles(saveFigures, gNo)

cS = const_data_so1(gNo);
figS = const_fig_so1;
baseAge = 25;

loadS = var_load_so1(cS.varNoS.vQuarticModel, cS);

% Get age effects and year effects
profileV = loadS.wrS.age_year_effects(cS.dbg);

fh = output_so1.fig_new(saveFigures, []);
hold on;
for iSchool = 1 : cS.nSchool
   regrS = profileV{iSchool};
   plot(regrS.ageValueV,  regrS.ageDummyV - regrS.ageDummyV(regrS.ageValueV == baseAge),  ...
      figS.lineStyleDenseV{iSchool}, 'color', figS.colorM(iSchool,:));
end
hold off;
xlabel('Age');
ylabel('Log wage');
legend(cS.schoolLabelV, 'location', 'south');
output_so1.fig_format(fh, 'line');
output_so1.fig_save(fullfile(cS.dirS.quarticDir, 'profiles'), saveFigures, cS);

end
