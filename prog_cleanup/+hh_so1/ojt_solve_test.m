function ojt_solve_test(gNo, setNo)

fprintf('Testing ojt_solve \n');

cS = const_so1(gNo, setNo);
cS.dbg = 111;
paramS = param_load_so1(gNo, setNo);

skillPrice_asM = linspace(1, 2, cS.demogS.ageRetire)'  *  linspace(1, 2, cS.nSchool);
iCohort = 2;

hh_so1.ojt_solve(skillPrice_asM, iCohort, paramS, cS);


end