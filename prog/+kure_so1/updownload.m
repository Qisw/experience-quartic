function updownload(gNo, setNoV, upDownStr)
% Upload or download sets to kure
%{
Processes all experiments for all sets
%}


%% Input check

validateattributes(gNo, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1})
validateattributes(setNoV, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1})

if strcmpi(upDownStr, 'up')
   up = true;
elseif strcmpi(upDownStr, 'down')
   up = false;
else
   error('Invalid doUpload');
end


%% Main

for ix = 1 : length(setNoV)
   % Get local and remote directories
   dirS = param_so1.directories(true, gNo, setNoV(ix));
   dirKureS = param_so1.directories(false, gNo, setNoV(ix));
   
   % Matrix files (up or download)
   kure_lh.updownload(dirS.matDir, dirKureS.matDir, upDownStr);
   
   % Out files (download only)
   if ~up
      kure_lh.updownload(dirS.outDir, dirKureS.outDir, upDownStr);
   end
end


end