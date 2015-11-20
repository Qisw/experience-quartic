function loadS = data_load_so1(varNo, gNo)
% Load a variable that is saved for data setNo

cdS = const_data_so1(gNo);
loadS = var_load_so1(varNo, cdS);


end