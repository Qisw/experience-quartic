function preamble_init(cS)

varS = param_so1.var_numbers;
dirS = cS.dirS;

% texFn = fullfile(dirS.tbDir, 'preamble.tex');

preamble_lh.initialize(output_so1.var_fn(varS.vDataPreamble, cS), dirS.preambleTexFn);

end