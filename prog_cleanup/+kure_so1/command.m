function cmdStr = command(solverStr, gNo, setNo)
% Create a string that can be submitted to run a calibration
% -------------------------------------------------

% cS = const_so1(gNo, setNo);
% saveHistory = 0;

nCpus = 1;

% Log file name
logStr = sprintf('g%02i_set%03i.out', gNo, setNo);

% Arguments in cell array for run_batch
% argStr = sprintf('{''%s'',%i,%i}',  solverStr, gNo, setNo);
% 
% mFileStr = ['project_kure(''so1'',', argStr,  ')'];
% 
% cmdStr = kure_lh.command(mFileStr, logStr, nCpus);


kS = KureLH;
cmdStr = kS.command('so1',  {solverStr, gNo, setNo},  logStr,  nCpus);

% if cS.runLocal
%    clipboard('copy', cmdStr);
% end

   
end