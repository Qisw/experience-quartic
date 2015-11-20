function aggr_ls_test(gNo, setNo)

cS = const_so1(gNo, setNo);
cS.dbg = 111;


% spYearV = cS.spS.spYearV(1) : cS.spS.spYearV(end);
meanLPerHour_tscM = 1 + rand([cS.demogS.ageRetire, cS.nSchool, cS.nCohorts]);

aggrHours_tsyM = 3 + rand([cS.demogS.ageRetire, cS.nSchool, length(cS.wageYearV)]);

for iSchool = 1 : cS.nSchool
   ageV = 1 : (cS.demogS.workStartAgeV(iSchool) - 1);
   meanLPerHour_tscM(ageV,iSchool,:) = cS.missVal;
   aggrHours_tsyM(ageV,iSchool,:) = cS.missVal;
end

lSupply_astM = calibr_so1.aggr_ls(meanLPerHour_tscM, aggrHours_tsyM, cS);



end