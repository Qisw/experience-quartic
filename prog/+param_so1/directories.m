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

% May want to move that out of dropbox +++
dirS.matBaseDir  = fullfile(dirS.baseDir, 'mat');
dirS.outBaseDir  = fullfile(dirS.baseDir, 'out');

   % Specific to group and set
   dirS.outDir = fullfile(dirS.outBaseDir, dirS.groupStr, dirS.setStr);
   dirS.matDir = fullfile(dirS.matBaseDir, dirS.groupStr, dirS.setStr);
   
% if dirS.runLocal
%    dirS.sharedDirV = lhS.sharedDirV;
% else
%    dirS.sharedDir = fullfile(dirS.baseDir, 'LH');
% end
% 


% %% Kure directories, must always be set
% 
% % baseDir = '/nas02/home/l/h/lhendri/school_ojt/experience/';
% % dirS.kureBaseDir = baseDir;
% 
% % dirS.kureProgDir = fullfile(baseDir, 'prog');
% dirS.kureSharedDir = fullfile(baseDir, 'LH');
% % dirS.kureMatBaseDir  = fullfile(baseDir, 'mat');
% % dirS.kureOutBaseDir  = fullfile(baseDir, 'out');
% % 
% %    dirS.kureOutDir = fullfile(dirS.kureOutBaseDir, dirS.groupStr, dirS.setStr);
% %    dirS.kureMatDir = fullfile(dirS.kureMatBaseDir, dirS.groupStr, dirS.setStr);
% % 


% %% Directories that apply on this machine
% 
% % Running locally?
% if exist('/Users/lutz/', 'dir')    
%    dirS.runLocal = true;
%    dirS.baseDir = '/Users/lutz/dropbox/hc/school_ojt/experience/';
%       
%    dirS.sharedDir = lhS.sharedDir;
%       
% else
%    % Kure
%    dirS.runLocal = false;
%    dirS.baseDir = dirS.kureBaseDir;
%    dirS.progDir = dirS.kureProgDir;
%    dirS.matBaseDir  = dirS.kureMatBaseDir;
%    dirS.outBaseDir  = dirS.kureOutBaseDir;
%       
%       % Specific to group and set
%       dirS.outDir = dirS.kureOutDir;
%       dirS.matDir = dirS.kureMatDir;
%       
%    dirS.sharedDir = dirS.kureSharedDir;
% end
% 

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