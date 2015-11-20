function var_save_so1(outV, varNo, cS)
% Save a MAT variable
%{
% IN
%  either cS or gNo and setNo

Change: 
   conversion to single probably forces passing by value +++
%}
% ----------------------------------------------

% if nargin == 3
%    gNo = cS.gNo;
%    setNo = cS.setNo;
% elseif nargin ~= 5
%    error('Invalid nargin');
% end
% 
% % gNo and setNo must be consistent with cS
% if isempty(cS)
%    cS = const_so1(gNo, setNo);
% end
% if gNo ~= cS.gNo  ||  setNo ~= cS.setNo
%    error('Mismatch');
% end


[fn, ~, fDir] = output_so1.var_fn(varNo, cS);

% Create dir if it does not exist
if ~exist(fDir, 'dir')
   filesLH.mkdir(fDir, 0);
end

% version1 = cS.version;
save(fn, 'outV');

fprintf('Saved set %i / %i  variable %i  \n',  cS.gNo, cS.setNo, varNo);

end