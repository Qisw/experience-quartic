function replace_text_so1
% Replace text in program files

dirS = param_so1.directories([], 1,1);

% Remember to escape special characters: _, \
% These are regex's
oldTextV = {'DataWt\_asM'};
newTextV = {'DataWt\_tsM'};

baseDir = dirS.progDir;
fileMaskIn = '*.m';
inclSubDirs = true;
noConfirm = 'x';
% Exclude this file from replacement
filesLH.replace_text_many_files(baseDir, fileMaskIn, inclSubDirs, oldTextV, newTextV, ...
   {[mfilename, '.m']}, noConfirm);

end