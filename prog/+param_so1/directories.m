function dirS = directories(runLocal, gNo, setNo)
%  Directories
%{
Keep all mat files in 1 sub-dir for easier copying to kure
This cannot call const_so1

IN
   runLocal
      may be []. Then it is determined by dir structure
%}

lhS = const_lh;
pS = project_load('so1');

if isempty(runLocal)
   runLocal = lhS.runLocal;
end
dirS.runLocal = runLocal;

dirS.groupStr = sprintf('g%02i', gNo);
dirS.setStr   = sprintf('set%03i', setNo);


dirS.localBaseDir = pS.baseDirV{pS.cLocal};
dirS.kureBaseDir  = pS.baseDirV{pS.cRemote};
if runLocal
   dirS.baseDir = dirS.localBaseDir;
   dirS.progDir = pS.progDirV{pS.cLocal};
else
   dirS.baseDir = dirS.kureBaseDir;
   dirS.progDir = pS.progDirV{pS.cRemote};
end


%% Directories that hang off base dir 
% Everything but shared progs

% baseDir = dirS.basDir;

dirS.matBaseDir  = fullfile(dirS.baseDir, 'mat');
dirS.outBaseDir  = fullfile(dirS.baseDir, 'out');

   % Specific to group and set
   dirS.outDir = fullfile(dirS.outBaseDir, dirS.groupStr, dirS.setStr);
   dirS.matDir = fullfile(dirS.matBaseDir, dirS.groupStr, dirS.setStr);
   

dirS.figDir = dirS.outDir;
dirS.tbDir  = dirS.outDir;
   dirS.fitDir = fullfile(dirS.outDir, 'fit');
   dirS.paramDir = fullfile(dirS.outDir, 'param');
   dirS.schoolDir = fullfile(dirS.outDir, 'school');
   dirS.ojtDir = fullfile(dirS.outDir, 'ojt');
   dirS.profileDir = fullfile(dirS.outDir, 'profiles');
   dirS.aggrDir = fullfile(dirS.outDir, 'aggregates');
   % Quartic wage regressions
   dirS.quarticDir = fullfile(dirS.outDir, 'quartic');


% Preamble tex file
dirS.preambleTexFn = fullfile(dirS.tbDir, 'preamble.tex');

% Preamble with notation
dirS.symbolFn = fullfile(dirS.tbDir, 'notation.tex');

% Directory with figures for paper
dirS.paperDir = fullfile(dirS.baseDir, 'PaperFigures');


end