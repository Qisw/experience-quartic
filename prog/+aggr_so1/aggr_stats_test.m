function aggr_stats_test(gNo, setNo)

cS = const_so1(gNo, setNo);
cS.dbg = 111;

ageMin = 25;
ageMax = 60;
yearV = 1980 : 1990;
ny = length(yearV);

rng(43);
size_tsyV = [ageMax, cS.nSchool, ny];
logWage_tsyM = randn(size_tsyV);
% Make sure wages are increasing in schooling
for iSchool = 2 : cS.nSchool
   logWage_tsyM(:,iSchool,:) = max(logWage_tsyM(:,iSchool,:), logWage_tsyM(:,iSchool-1,:) + 0.1);
end
wt_tsyM = rand(size_tsyV);



aggr_so1.aggr_stats(logWage_tsyM, wt_tsyM, yearV, ageMin, ageMax, cS);


end