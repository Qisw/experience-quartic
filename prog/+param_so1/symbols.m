function symS = symbols
% Define symbols for preamble and figure formatting
%{
Each symbol is written into preamble
Can also define notation for calibrated parameters

For data counterparts: add a hat
%}



%% General notation

symS = SymbolTableLH({'pYear', 'pWeight', 'na', 'grRate'}, ...
   {'t', '\omega', 'n/a', 'g'});



%% Demographics

symS.add({'age', 'bYear', 'birthYear', 'lifeSpan', 'tEndow',      'sIndex', 'sMax'}, ...
   {'a', 'c',  'c',  'A',  '\ell',     's', 'S'});



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

symS.add({'sPrice', 'skillPrice', 'earn', 'effUnits', 'wage', ...
   'cohortQuality', 'cohQualFct', 'cohSchool', 'cqBeta'}, ...
   {'p', 'p', 'y', 'e', 'w',     'q', 'Q', '\bar{s}', '\phi'});


%% Aggregates

% H: Labor supply in efficiency units (aggregate)
% L: Aggregate hours in a cell (data)
% A: Neutral productivity
% omega: Skill weights
symS.add({'lSupply', 'aggrHours', 'neutralProd', 'skillWeight', 'muIntercept',      'aggrOutput'}, ...
   {'H', 'L', 'B', '\mu', '\bar{\mu}',     'Y'});



end