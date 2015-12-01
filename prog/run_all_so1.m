function run_all_so1(gNo, setNo)
% Run everything in sequence
%{
Making a new setNo
   Give it a name
   Override its options
   Use run_all to create cal targets etc
   Perhaps also copy paramS from another setNo
   If a grid: create a shell script to run it
   chmod +x script.sh
%}
% ------------------------------------

cS = const_so1(gNo, setNo);

% Make all directories for this set
if 0
   output_so1.mkdir(gNo, setNo);
end


%% Run data routines (cpsojt must be on path)
%  Run only once
if cS.isDataSetNo
   % Run CpsEarn to generate the data files
   %  Anything that depends on cpsearn is contained here
   data_so1.run_cpsearn(gNo);
   run_data_so1(gNo);
   quartic_run_so1(gNo);
   return;
end




%%  Testing
if 0
   test_all_so1(gNo, setNo);   
end

end