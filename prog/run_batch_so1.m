function run_batch_so1(inV)
% Runs one calibration on kure
%{
Input is a cell array (b/c this is called by a generic startup routine using varargin)

IN
   solverStr
      'none'      just compute results, no calibration
      'guess'     compute results from intermediate guess, after a job crashed
   gNo, setNo
%}



%% Input check

solverStr = inV{1};
assert(isa(solverStr, 'char'));
gNo = inV{2};
validateattributes(gNo, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1})
setNo = inV{3};
validateattributes(setNo, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1})


%% Main

if strcmpi(solverStr, 'guess')
   % Run from saved intermediate guess
   %  in case a job crashed before
   param_from_guess_so1(gNo, setNo, 'noConfirm');
   % Continue with default solver
   solverStr = 'fminsearch';
end

   
% Calibrate
calibrate_so1(solverStr, gNo, setNo);


disp('Runbatch is done.');


end