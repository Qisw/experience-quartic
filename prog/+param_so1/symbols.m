function symS = symbols
% Define symbols for preamble and figure formatting
%{
Each symbol is written into preamble
Can also define notation for calibrated parameters

For data counterparts: add a hat
%}



%% General notation

symS = SymbolTableLH({'pYear', 'pWeight'}, ...
   {'t', '\omega'});



%% Demographics

symS.add({'age', 'bYear', 'birthYear', 'lifeSpan', 'tEndow'}, ...
   {'a', 'c',  'c',  'A',  '\ell'});



%% Endowments

% symS.stdIq = '\sigma_{IQ}';



%% Schooling

% Durations
% symS.sDuration = 'T';
symS.add({'ageWorkStart'},  {'a'});


%% OJT

symS.add({'pProduct', 'pAlpha', 'pDelta', 'trainTime'}, ...
   {'B', '\alpha', '\delta', 'l'});


%% Work

symS.add({'sPrice', 'skillPrice', 'earn', 'effUnits', 'wage'}, ...
   {'p', 'p', 'y', 'e', 'w'});


%% Aggregates

% H: Labor supply in efficiency units (aggregate)
% L: Aggregate hours in a cell (data)
% A: Neutral productivity
% omega: Skill weights
symS.add({'lSupply', 'aggrHours', 'neutralProd', 'skillWeight', 'aggrOutput'}, ...
   {'H', 'L', 'B', '\mu', 'Q'});



end