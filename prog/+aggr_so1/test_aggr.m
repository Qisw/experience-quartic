function test_aggr(testSolution, gNo, setNo)

aggr_so1.cs_data_test(gNo, setNo);
aggr_so1.aggr_stats_test(gNo, setNo);


% These require saved solution
if testSolution
   aggr_so1.sp_growth_rates(gNo, setNo)
   aggr_so1.aggr_stats_save(gNo, setNo);
end

end