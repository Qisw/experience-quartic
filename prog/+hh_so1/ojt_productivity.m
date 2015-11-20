function pProductV = ojt_productivity(iSchoolV, iCohort, paramS, cS)
% OJT productivity parameters for given abilities
% -------------------------------------------------------------

dBYear = cS.demogS.bYearV(iCohort) - median(cS.demogS.bYearV);
pProductV = exp(paramS.logAV(iSchoolV) + paramS.gAV(iSchoolV) .* dBYear);


end