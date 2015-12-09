function weights_age_school(gNo)
% Construct [age, school] weights for constant composition aggregates
%{
Uses all persons, regardless of work status
The weight is the mass of persons, NOT hours
%}

fprintf('Computing [age, school] weights \n');
cS = const_data_so1(gNo);
varS = param_so1.var_numbers;

loadS = var_load_so1(varS.vAgeSchoolYearStats, cS);

% Mass by [age, school, year]
ageV = 1 : cS.demogS.ageRetire;
mass_astM = loadS.mass_astuM(ageV, :, :, cS.dataS.iuCpsAll);
assert(all(mass_astM(:) >= 0));

% Average across years
% Take into account that some ages could have 0 mass in some years

mass_asM = zeros([length(ageV), cS.nSchool]);
for iSchool = 1 : cS.nSchool
   sAgeV = cS.demogS.workStartAgeV(iSchool) : ageV(end);
   mass_asM(sAgeV, iSchool) = sum(mass_astM(sAgeV, iSchool, :), 3);
   assert(all(mass_asM(sAgeV, iSchool) > 0));
end
validateattributes(mass_asM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   'size', [length(ageV), cS.nSchool]})

mass_asM = mass_asM ./ sum(mass_asM(:));

var_save_so1(mass_asM, varS.vAggrCpsWeights, cS);


%% Show
if 1
   saveFigures = 1;
   mass_asM(mass_asM == 0) = NaN;
   fh = output_so1.plot_by_school(ageV, mass_asM, 'Age', 'Mass', saveFigures, cS);
   output_so1.fig_save('weights_age_school', saveFigures, cS);
end

end