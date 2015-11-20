function paper_figures_so1
% Copy figures used in paper

gNo = 5;
setNo = 901;
cS = const_so1(gNo, setNo);
dirS = cS.dirS;
tgDir = dirS.paperDir;

pS = econLH.PaperFigures(dirS.outDir, tgDir, 50);

% Preamble files
pS.add(dirS.symbolFn, 'notation.tex');
pS.add(dirS.preambleTexFn, 'preamble.tex');


%% Quartic fit

srcDir = cS.dirS.quarticDir;
fnV = {'collprem_young', 'collprem_middle', 'collprem_old', 'profiles', 'cohort_effects_relative', ...
   'skill_weights', 'fit_r2.tex'};
for i1 = 1 : length(fnV)
   [~, fName, fExt] = fileparts(fnV{i1});
   if isempty(fExt)
      fExt = '.pdf';
   end
   fn = [fName, fExt];
   pS.add(fullfile(srcDir, fn), fn);
end

% By schooling
fnV = {'cohort_wage_growth', 'cohort_wage_intercept', 'cs_return_exper', 'wage_cohort', 'wage_time'};
for iSchool = 1 : cS.nSchool
   for i1 = 1 : length(fnV)
      fn = [fnV{i1}, '_', cS.schoolSuffixV{iSchool}, '.pdf'];
      pS.add(fullfile(srcDir, fn), fn);
   end
end


pS.copy;

end