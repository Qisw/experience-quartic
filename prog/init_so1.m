function init_so1
% Startup: init_so1
% All paths are already in path

gNo = 5;
setNo = 901;
dirS = param_so1.directories([], gNo, setNo);

% Make earnings data accessible
project_start('cpsearn');

cd(dirS.progDir);

% Default figure properties
fS = FigureLH;
fS.set_defaults;


end