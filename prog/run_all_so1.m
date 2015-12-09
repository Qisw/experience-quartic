function run_all_so1(gNo)
% Run everything in sequence
%{
setNo is currently not used

Need to run:
   gNo 9: baseline
   gNo 6: wage earners
%}
% ------------------------------------

% setNo = 901;
% cS = const_so1(gNo, setNo);

% Make all directories for this set
if 0
   output_so1.mkdir(gNo, setNo);
end


% Run CpsEarn to generate the data files
%  Anything that depends on cpsearn is contained here
data_so1.run_cpsearn(gNo);

% Prepare data files
run_data_so1(gNo);

% Estimate quartic model and produce results
quartic_run_so1(gNo);

% Copy figures and tables used in paper
paper_figures_so1;


%%  Testing
if 0
   setNo = 901;
   test_all_so1(gNo, setNo);   
end

end