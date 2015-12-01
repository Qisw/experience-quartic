function skill_weights(gNo)
% Compute skill weights implied by quartic model
%{
Labor inputs = aggregate hours * exp(age profile)
Skill prices = time effects
   OR  median wages / labor inputs
%}

cS = const_data_so1(gNo);
ny = length(cS.wageYearV);

qS = var_load_so1(cS.varNoS.vQuarticModel, cS);
tgS = var_load_so1(cS.varNoS.vCalTargets, cS);

ageMax = cS.quarticS.ageMax;

% Get age effects and year effects
profileV = qS.wrS.age_year_effects(cS.dbg);

saveS.seHS = cS.quarticS.substElastInner;
saveS.seCG = cS.quarticS.substElastOuter;



%% Labor inputs

saveS.lSupply_syM = repmat(cS.missVal, [cS.nSchool, ny]);

for iSchool = 1 : cS.nSchool
   ageV = (cS.demogS.workStartAgeV(iSchool) : ageMax)';
   
   % Efficiency by age
   regrS = profileV{iSchool};
   idxV = vectorLH.find_matches(regrS.ageValueV(:), ageV, cS.dbg);
   assert(all(~isnan(idxV)));
   effV = regrS.ageDummyV(idxV);
   validateattributes(effV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>', cS.missVal})
   effV = exp(effV);
   
   for iy = 1 : ny
      hoursV = tgS.aggrHours_tsyM(ageV, iSchool, iy);
      validateattributes(hoursV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
      saveS.lSupply_syM(iSchool, iy) = sum(hoursV .* effV);
   end
end

validateattributes(saveS.lSupply_syM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
   'size', [cS.nSchool, ny]})



%% Skill prices

saveS.skillPrice_syM = repmat(cS.missVal, [cS.nSchool, ny]);

for iSchool = 1 : cS.nSchool
   % Time effects
   regrS = profileV{iSchool};
   idxV = vectorLH.find_matches(regrS.yearValueV(:), cS.wageYearV(:), cS.dbg);
   assert(all(~isnan(idxV)));
   saveS.skillPrice_syM(iSchool, :) = regrS.yearDummyV(idxV);
end

validateattributes(saveS.skillPrice_syM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>', cS.missVal})
saveS.skillPrice_syM = exp(saveS.skillPrice_syM);


%% Skill weights

% Aggregate production function (nested ces object)
%  Top level: CG vs the rest
saveS.aggrProdFct = CesNestedLH(saveS.seCG,  [cS.nSchool-1, 1], [saveS.seHS, 1]);

% Production function skill weights implied by labor supplies
%  Skill weights are computed for all spYearV years
[saveS.skillWeightTop_tlM, saveS.skillWeight_tlM, saveS.neutralAV] = calibr_so1.skill_weights(saveS.lSupply_syM, ...
   saveS.skillPrice_syM, saveS.aggrProdFct, cS);

var_save_so1(saveS, cS.varNoS.vQuarticSkillWeights, cS);


end