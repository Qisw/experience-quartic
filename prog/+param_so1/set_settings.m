function setS = set_settings(cS)
% Set: Override group default parameters
%{
%}

setNo = cS.setNo;


%% Set numbers

% Default
setS.setDefault = 901;

setS.dataSetNo = 901;


%% Defaults

setS.isDataSetNo = false;
setS.setStr = sprintf('set%03i', setNo);


%% Individual sets

if setNo == setS.dataSetNo
   % *******  Data sets
   setS.isDataSetNo = true;
   
else      
   
   error('Invalid');
end



end