function cs_data_test(gNo, setNo)

cS = const_so1(gNo, setNo);
cS.dbg = 111;

rng(43);
size_ascV = [cS.demogS.ageRetire, cS.nSchool, cS.demogS.nCohorts];
indLogWage_tscM = randn(size_ascV);

indLogWageSS_tscM = randn([size_ascV(1:2), 2]);

yearV = 1980 : 2000;
ageMin = 35;
ageMax = 55;


aggr_so1.cs_data(indLogWage_tscM, indLogWageSS_tscM,  ...
   yearV, ageMin, ageMax, cS);

end