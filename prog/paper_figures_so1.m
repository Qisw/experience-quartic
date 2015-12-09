function paper_figures_so1
% Copy figures used in paper

gNo = 9;
setNo = 901;
cS = const_so1(gNo, setNo);
dirS = cS.dirS;
tgDir = dirS.paperDir;

pS = econLH.PaperFigures(dirS.outDir, tgDir, 50);

% Preamble files
pS.add(dirS.symbolFn, 'notation.tex');
data_so1.preamble_make(gNo);
cS.symS.preamble_write(cS.dirS.symbolFn);
pS.add(dirS.preambleTexFn, 'preamble.tex');

pS.add(fullfile(dirS.tbDir, 'cps_tb.tex'));


%% Data figures

fnV = {'cohort_school', 'cohort_school_fractions'};
add_multiple(fnV, dirS.outDir);


% By schooling
fnV = {'wage_growth_exper_aggr'};
for iSchool = 1 : cS.nSchool
   for i1 = 1 : length(fnV)
      fn = [fnV{i1}, '_', cS.schoolSuffixV{iSchool}, '.pdf'];
      pS.add(fn, fn);
   end
end



%% Quartic fit

srcDir = dirS.quarticDir;
fnV = {'collprem_young', 'collprem_middle', 'collprem_old', ...
   'profiles', 'cohort_effects_relative', ...
   'skill_weights', 'fit_r2.tex', 'regr_results.tex'};
add_multiple(fnV, srcDir);
% for i1 = 1 : length(fnV)
%    [~, fName, fExt] = fileparts(fnV{i1});
%    if isempty(fExt)
%       fExt = '.pdf';
%    end
%    fn = [fName, fExt];
%    pS.add(fullfile(srcDir, fn), fn);
% end

% By schooling
fnV = {'cohort_wage_growth', 'cohort_wage_intercept', 'cs_return_exper', 'wage_cohort', 'wage_time'};
for iSchool = 1 : cS.nSchool
   for i1 = 1 : length(fnV)
      fn = [fnV{i1}, '_', cS.schoolSuffixV{iSchool}, '.pdf'];
      pS.add(fullfile(srcDir, fn), fn);
   end
end


pS.copy;


%% Nested: Add some
   function add_multiple(fnV, srcDir)
      for i2 = 1 : length(fnV)
         fnNew = make_file_name(fnV{i2});
         pS.add(fullfile(srcDir, fnNew), fnNew);
      end      
   end

end


%% Local
function fn = make_file_name(fnIn)
   [~, fName, fExt] = fileparts(fnIn);
   if isempty(fExt)
      fExt = '.pdf';
   end
   fn = [fName, fExt];
end