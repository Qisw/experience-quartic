%% Normalize skill weights so that HSG have weight of 1 in each period
% This can be plotted directly
% Rising skill weights mean: productivity rises relative to HSG
function skillWeight_stM = skill_weights_normalize(modelS, cS)
   iRef = cS.iHSG;
   T = size(modelS.skillWeight_tlM, 1);
   skillWeight_stM = zeros(cS.nSchool, T);
   skillWeight_stM(cS.iCG, :) = (modelS.skillWeightTop_tlM(:, 2) ./ modelS.skillWeightTop_tlM(:, 1));
   skillWeight_stM(1 : cS.iCD, :) = modelS.skillWeight_tlM(:, 1 : cS.iCD)';
   skillWeight_stM = skillWeight_stM ./ (ones(cS.nSchool, 1) * skillWeight_stM(iRef, :));
   
   if cS.dbg > 10
      validateattributes(skillWeight_stM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
         'size', [cS.nSchool, T]})
   end
end