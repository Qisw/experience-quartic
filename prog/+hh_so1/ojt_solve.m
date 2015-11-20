function outS = ojt_solve(skillPrice_asM, iCohort, paramS, cS)
% Solve OJT part of household problem
%{
One cohort, all school groups

IN:
   skillPrice_asM
      skill prices by [phys age, school]

OUT:
   hM(physical age, school)
      individual age profiles
   pvLtyAge1M(school)
      present value of lifetime earnings, discounted to age 1
%}

%% Input check

ageRetire = cS.demogS.ageRetire;

if cS.dbg > 10
   validateattributes(skillPrice_asM(cS.demogS.age1:end, :), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
      'size', [cS.demogS.ageRetire - cS.demogS.age1 + 1, cS.nSchool]})
end


%% Main

outS.pvLtyAge1_sV = zeros(cS.nSchool, 1);
size_tsV = [ageRetire, cS.nSchool];
outS.h_tsM = zeros(size_tsV);
outS.sTime_tsM = zeros(size_tsV);
outS.wage_tsM = zeros(size_tsV);

for iSchool = 1 : cS.nSchool
   workAgeV = cS.demogS.workStartAgeV(iSchool) : cS.demogS.ageRetire;
   
   % Make a Ben-Porath structure
   %  The productivity parameter does not matter
   bpS = BenPorathLH(skillPrice_asM(workAgeV, iSchool), paramS.tEndow_tscM(workAgeV, iSchool, iCohort), ...
      paramS.alphaV(iSchool), paramS.ddhV(iSchool), 1, paramS.R, paramS.trainTimeMax, cS.hMax);

   % Productivity parameters
   pProduct = hh_so1.ojt_productivity(iSchool, iCohort, paramS, cS);

   % Solve OJT problem, using generic Ben-Porath routine
   [outS.h_tsM(workAgeV,iSchool), outS.sTime_tsM(workAgeV,iSchool), outS.wage_tsM(workAgeV,iSchool), ...
      earn_tV] = bpS.solve(paramS.h1, pProduct, cS.dbg);
   outS.earnM(:,workAgeV,iSchool) = earn_tV;

   % Present value of lifetime earnings, discounted to first work age
   outS.pvLtyAge1_sV(iSchool) = econLH.present_value(earn_tV(:)', paramS.R - 1, workAgeV(1), cS.dbg);
end


%%  Self-test

validateattributes(outS.pvLtyAge1_sV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})

if cS.dbg > 10
   for iSchool = 1 : cS.nSchool
      ageV = cS.demogS.workStartAgeV(iSchool) : cS.demogS.ageRetire;
      validateattributes(outS.sTime_tsM(ageV, iSchool), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0})
      validateattributes(outS.wage_tsM(ageV, iSchool), {'double'}, ...
         {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
      validateattributes(outS.h_tsM(ageV, iSchool), {'double'}, ...
         {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
   end
end


end