function paramS = param_derived_so1(updateTimeM, param0S, cS)
% Set derived params
% Also override params that are not calibrated
%{
IN
   updateTimeM
      update time endowments from loaded data?
      switch off when running calibration for efficiency

Checked: 2015-Oct-26
%}


% ***** Make sure that skill price nodes have right length
fieldStr = sprintf('logWNode_s%iV', 1);
% Does this case have nodes?
if isfield(param0S, fieldStr)
   nNodes = length(cS.spS.spNodeIdxV);
   % Are they of the right length?
   if length(param0S.(fieldStr)) ~= nNodes
      for iSchool = 1 : cS.nSchool
         fieldStr = sprintf('logWNode_s%iV', iSchool);
         oldV = param0S.(fieldStr);
         if length(oldV) > nNodes
            oldV((nNodes+1) : end) = [];
         else
            oldV = [oldV(:);  oldV(end) * ones(nNodes - length(oldV), 1)];
         end
         param0S.(fieldStr) = oldV;
      end
   end
end


% Fix all parameters that are not calibrated (doCal no in cS.doCalV)
%  also add missing params
paramS = cS.pvector.struct_update(param0S, cS.doCalV);



%% Add missing fields

if 0
   % Update when skill price handling clarified +++++
   % In case the skill price stucture has changed
   nsp = length(cS.spNodeV) - length(cS.spNodeZeroV);
   if ~isequal(size(paramS.logWNodeM), [cS.nSchool, nsp])
      dn = nsp - size(paramS.logWNodeM, 2);
      if dn > 0
         paramS.logWNodeM = [paramS.logWNodeM, zeros([cS.nSchool,1]) * ones([1, dn])];
      else
         paramS.logWNodeM = paramS.logWNodeM(:, 1:nsp);
      end
   end
end

%%  Time endowments

% Load hours profiles
% by [phys age, school, cohort], in model units
if ~isfield(paramS, 'tEndow_tscM')
   updateTimeM = true;
elseif ~isequal(size(paramS.tEndow_tscM), [cS.demogS.ageRetire, cS.nSchool, cS.nCohorts])
   updateTimeM = true;
end
if updateTimeM
   cdS = const_data_so1(cS.gNo);
   varS = param_so1.var_numbers;
   tgS = var_load_so1(varS.vCalTargets, cdS);

   % Avoid values very close to 0 which would run into computational issues
   paramS.tEndow_tscM = max(paramS.trainTimeMin + 0.01, tgS.hours_tscM);
   clear cdS;
end

validateattributes(paramS.tEndow_tscM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
   '<', 10,  'size', [cS.demogS.ageRetire, cS.nSchool, cS.nCohorts]})




%%  OJT

paramS.alphaV = [paramS.alphaHSD; paramS.alphaHSG; paramS.alphaCD; paramS.alphaCG];
paramS.ddhV = [paramS.ddhHSD; paramS.ddhHSG; paramS.ddhCD; paramS.ddhCG];

% Impose non-calibrated alpha
%  Only when mean alpha not fixed (then n-1 alphas are calibrated and the other is implied)
if cS.fixMeanAlpha
   error('Not updated');
end
if cS.sameAlpha == 1
   error('Not updated');
   % Only 2 alphas are calibrated
   paramS.alphaV(cS.schoolHSD) = paramS.alphaV(cS.schoolHSG);
   paramS.alphaV(cS.schoolCD)  = paramS.alphaV(cS.schoolCG);
elseif cS.sameAlpha == 2
   error('Not updated');
   % All alpha are the same
   paramS.alphaV(2:cS.nSchool) = paramS.alphaV(1);
end

if cS.sameDdh == 1
   error('Not updated');
   % Only 2 deltas are calibrated
   paramS.ddhV(cS.schoolHSD) = paramS.ddhV(cS.schoolHSG);
   paramS.ddhV(cS.schoolCD)  = paramS.ddhV(cS.schoolCG);
elseif cS.sameDdh == 2
   error('Not updated');
   paramS.ddhV(2 : cS.nSchool) = paramS.ddhV(1);
end



%%  Skill prices + aggregate technology

if cS.fixGCollPrem == 1
   error('Not updated');
   % Fixed growth of college premium
   if cS.calSpGrowthV(cS.schoolCG) == 1
      error('Not compatible');
   end
   paramS.spGrowthV(cS.schoolCG) = paramS.spGrowthV(cS.schoolHSG) + cS.gCollPrem;
end


% Substitution elasticities
paramS.rhoCG = 1 - 1 / paramS.seCG;
paramS.rhoHS = 1 - 1 / paramS.seHS;


% Aggregate production function (nested ces object)
%  Top level: CG vs the rest
paramS.aggrProdFct = CesNestedLH(paramS.seCG,  [cS.nSchool-1, 1], [paramS.seHS, 1]);



% Check params
param_so1.param_check(paramS, cS)


end