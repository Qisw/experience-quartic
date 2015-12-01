function preamble_make(gNo)
% Write data for preamble -- DATA constants only
%{
Various functions can add to preamble.
It must be initialized with preamble_init first
%}

cS = const_data_so1(gNo);
varS = param_so1.var_numbers;



%% Data constants

% +++ cpi base year : where is it set?
add_one('cpiBaseYear',  2010, '%i',  'CPI base year',  cS);
add_one('dataYearOne',  cS.wageYearV(1) + 1, '%i', 'Data year 1', cS);
add_one('dataYearLast', cS.wageYearV(end) + 1, '%i', 'Data year N', cS);
add_one('wageYearOne',  cS.wageYearV(1), '%i', 'Wage year 1', cS);
add_one('wageYearLast', cS.wageYearV(end), '%i', 'Wage year N', cS);

demogS = cS.demogS;
add_one('bYearFirst', demogS.bYearV(1), '%i', 'Birth year 1', cS);
add_one('bYearLast', demogS.bYearV(end), '%i', 'Birth year N', cS);
add_one('nCohorts', demogS.nCohorts, '%i', 'No of cohorts', cS);
add_one('ageOne', demogS.age1, '%i', 'Age 1', cS);
add_one('ageRetire', demogS.ageRetire, '%i', 'Retirement age', cS);
add_one('ageOneHSD',  demogS.workStartAgeV(cS.iHSD), 'i', 'Work start', cS);
add_one('ageOneHSG',  demogS.workStartAgeV(cS.iHSG), 'i', 'Work start', cS);
add_one('ageOneCG',  demogS.workStartAgeV(cS.iCG), 'i', 'Work start', cS);

dataS = cS.dataS;
add_one('ageRangeYoung', sprintf('%i-%i', dataS.ageRangeYoungOldM(1, :)), '%s', 'Young ages', cS);
add_one('ageRangeMiddle', sprintf('%i-%i', dataS.ageRangeYoungOldM(2, :)), '%s', 'Middle ages', cS);
add_one('ageRangeOld', sprintf('%i-%i', dataS.ageRangeYoungOldM(3, :)), '%s', 'Old ages', cS);

% For computing cohort schooling
add_one('schoolAgeRangeOne', cS.schoolAgeRangeV(1), '%i', 'for school aggregation', cS);
add_one('schoolAgeRangeLast', cS.schoolAgeRangeV(end), '%i', 'for school aggregation', cS);


add_one('hpParamHours', cS.dataS.hpFilterHours, '%i', 'Smoothing hours', cS);


%% CPS filter

fltS = data_load_so1(varS.vCpsEarnFilter, gNo);

add_one('fracBusInc', fltS.fracBusInc .* 100, '%.0f', 'Fraction of business income', cS);
add_one('hoursMin', fltS.hoursMin, '%.0f', 'Min hours', cS);
add_one('weeksMin', fltS.weeksMin, '%.0f', 'Min weeks', cS);



%% Quartic model

add_one('qAgeMax', cS.quarticS.ageMax, '%i', 'Max age', cS);
add_one('substElastOuter', cS.quarticS.substElastOuter, '%.1f', 'Subst elast outer', cS);
add_one('substElastInner', cS.quarticS.substElastInner, '%.1f', 'Subst elast inner', cS);

results_so1.preamble_write(cS);

end



function add_one(nameStr, value, fmtStr, descrStr, cS)
   if isa(value, 'char')
      valueStr = value;
   elseif length(value) == 1
      valueStr = sprintf(fmtStr, value);
   elseif isempty(value)
      valueStr = cS.symS.retrieve('na');
   else
      error('Not implemented');
   end
   results_so1.preamble_add(nameStr, valueStr, descrStr, cS);
end