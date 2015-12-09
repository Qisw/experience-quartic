function upload_progs(uploadShared)

% dirS = param_so1.directories(false, 1,1);
% dirKureS = param_so1.directories(true, 1,1);

pS = project_load('so1');

% kure_lh.updownload(dirS.progDir, dirKureS.progDir, 'up');
kure_lh.updownload(pS.progDirV{pS.cLocal},  pS.progDirV{pS.cRemote}, 'up');

% Shared progs
if uploadShared
   kS = KureLH;
   kS.upload_shared_code;
end
% for i1 = 1 : size(pS.sharedDirM, 1)
%    kure_lh.updownload(pS.sharedDirM{i1, pS.cLocal}, pS.sharedDirM{i1, pS.cRemote}, 'up');
% end

end