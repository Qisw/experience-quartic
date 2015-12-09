function var_save_so1(outV, varNo, cS)
% Save a MAT variable
%{
% IN
%  either cS or gNo and setNo

%}
% ----------------------------------------------

[fn, ~, fDir] = output_so1.var_fn(varNo, cS);

% Create dir if it does not exist
if ~exist(fDir, 'dir')
   filesLH.mkdir(fDir, 0);
end

% version1 = cS.version;
save(fn, 'outV');

fprintf('Saved set %i / %i  variable %i  \n',  cS.gNo, cS.setNo, varNo);

end