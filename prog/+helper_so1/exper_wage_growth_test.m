function exper_wage_growth_test(gNo)

disp('Testing exper_wage_growth');

cS = const_data_so1(gNo);

ageMax = 60;
logWage_tscM = randn([ageMax, cS.nSchool, cS.nCohorts]);

dWage_scM = randn(cS.nSchool, cS.nCohorts);

age2 = cS.dataS.wageGrowthAgeV(end);
age1 = cS.dataS.wageGrowthAgeV(1);

for ic = 1 : cS.nCohorts
   for iSchool = 1 : cS.nSchool
      logWage_tscM(age2,iSchool,ic) = logWage_tscM(age1,iSchool,ic) + dWage_scM(iSchool,ic);
   end
end

wGrowth_scM = helper_so1.exper_wage_growth(logWage_tscM, cS);

checkLH.approx_equal(wGrowth_scM, dWage_scM, 1e-6, []);


end