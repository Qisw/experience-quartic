function preamble_write(cS)
% Write preamble file
%{
make sure preamble is written to correct dir
in case it is started on server
%}
% ---------------------------------------------

% Make sure the file name for the tex is local
dirS = cS.dirS;
varS = param_so1.var_numbers;

if cS.setS.isDataSetNo
   preVarNo = varS.vDataPreamble;
else
   preVarNo = varS.vPreambleData;
end

fn = output_so1.var_fn(preVarNo, cS);

m = load(fn);
pS = m.pS;
pS.texFn = dirS.preambleTexFn;
save(fn, 'pS');

preamble_lh.write_tex(fn);

end