function [outV, success] = var_load_so1(varNo, cS)

fn = output_so1.var_fn(varNo, cS);

if ~exist(fn, 'file')
   outV = [];
   success = 0;
else
   load(fn, 'outV');
   success = 1;
end


end