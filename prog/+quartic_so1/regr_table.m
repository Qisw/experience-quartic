function regr_table(gNo)
% Show table with regression results
%{
Omit time dummies
%}

cS = const_data_so1(gNo);
qS = var_load_so1(cS.varNoS.vQuarticModel, cS);

% No of experience polynomials (clunky)
if cS.quarticS.ageEffects.equals('poly4')
   nx = 4;  
elseif cS.quarticS.ageEffects.equals('poly2')
   nx = 2;  
else
   nx = 0;
end

% No of cohort quality parameters
if cS.quarticS.cohortEffects.equals('schoolYears')
   nCoh = 2;   
else
   nCoh = 0;
end


%% Make regression result table

% ***** Make list of variables to report
varNameV = cell(nx + nCoh, 1);
varLabelV = cell(nx + nCoh, 1);

% Experience
if nx > 0
   for ix = 1 : nx
      varStr = 'exper';
      if ix > 1
         varStr = [varStr, '^', sprintf('%i', ix)];
      end
      varNameV{ix} = varStr;
      varLabelV{ix} = ['$', varStr, '$'];
   end
end
   
% Cohort effects
if nCoh > 0
   for iCoh = 1 : nCoh
      % Assume that cohort effects are the "x" regressors (clunky)
      varNameV{nx + iCoh} = qS.wrS.xNameV{iCoh};
      varLabelV{nx + iCoh} = ['$', cS.symS.retrieve('cqBeta', false), sprintf('_{%i}$', iCoh)];
   end
end

% Collect all results into a formatted regression table
tbM = regressLH.regr_table(qS.wrS.modelV, varNameV, varLabelV, cS.schoolLabelV, cS.dbg);



%% Write latex table

[nr, nc] = size(tbM);
nr = nr - 1;
nc = nc - 1;
filePath = fullfile(cS.dirS.quarticDir,  'regr_results.tex');
tS = LatexTableLH(nr, nc, 'filePath', filePath, 'rowHeaderV', tbM(2:end,1), 'colHeaderV', tbM(1, 2:end));
tS.tbM = tbM(2:end, 2:end);

tS.write_text_table

tS.write_table;


end