function var_save_test_so1(gNo, setNo)

cS = const_so1(gNo, setNo);

x = rand(4,3);
var_save_so1(x, cS.varNoS.vTest, cS);

x2 = var_load_so1(cS.varNoS.vTest, cS);

checkLH.approx_equal(x2, x, 1e-8, []);

end