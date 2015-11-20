function mkdir(gNo, setNo)
% Make all dirs for this set

dbg = 111;
dirS = param_so1.directories([], gNo, setNo);

dirV = {dirS.matDir, dirS.outDir, dirS.aggrDir, dirS.fitDir, dirS.paramDir};

for i1 = 1 : length(dirV)
   filesLH.mkdir(dirV{i1}, dbg);
end


end