function pvec = pvector_default(cS)
% Defaults: which params are calibrated?
%{
Only set calBase and calNever here
Experiments can override with calExper
%}

% Collection of calibrated parameters
pvec = pvectorLH(30, cS.doCalValueV);


%% Endowments

pvec.change('h1',  'h_{1}',  'Human capital endowment', 1, 0.1, 2, cS.calNever);


%% OJT

% pvec.change('alphaV', '\alpha_{s}', 'Curvature parameters', 0.4 * ones(cS.nSchool,1), ...
%    0.15 * ones(cS.nSchool,1), 0.85 * ones(cS.nSchool,1), cS.calBase);
% Default: 4 alphas
alphaMin = 0.3;
pvec.change('alphaHSD', '\alpha_{HSD}', 'Curvature', 0.4, alphaMin, 0.85, cS.calBase);
pvec.change('alphaHSG', '\alpha_{HSG}', 'Curvature', 0.4, alphaMin, 0.85, cS.calBase);
pvec.change('alphaCD',  '\alpha_{CD}', 'Curvature', 0.4, alphaMin, 0.85, cS.calBase);
pvec.change('alphaCG',  '\alpha_{CG}', 'Curvature', 0.4, alphaMin, 0.85, cS.calBase);

pvec.change('ddhHSD', '\delta_{HSD}', 'Depreciation', 0.05, 0, 0.15, cS.calBase);
pvec.change('ddhHSG', '\delta_{HSG}', 'Depreciation', 0.05, 0, 0.15, cS.calBase);
pvec.change('ddhCD',  '\delta_{CD}', 'Depreciation',  0.05, 0, 0.15, cS.calBase);
pvec.change('ddhCG',  '\delta_{CG}', 'Depreciation',  0.05, 0, 0.15, cS.calBase);

pvec.change('trainTimeMax',  'lMax', 'Max training time',  0.9,  0.5, 1, cS.calNever);
pvec.change('trainTimeMin',  'lMin', 'Min training time',  0.02, 0, 0.1, cS.calNever);

pvec.change('logAV', 'log(A)', 'Log(A)', ...
   -2 * ones([cS.nSchool, 1]),  -4 * ones([cS.nSchool, 1]),  0 * ones([cS.nSchool, 1]),  cS.calBase);
pvec.change('gAV',  'g(A)', 'Growth of A',  0 .* ones([cS.nSchool,1]), ...
   -0.05 .* ones([cS.nSchool,1]), 0.05 .* ones([cS.nSchool,1]), cS.calBase);


%% Aggregate output

% Substitution elasticity between college and non-college labor
if cS.calWhatS.substElast
   doCal = cS.calBase;
else
   doCal = cS.calNever;
end
pvec.change('seCG',  '\rho_{CG}', 'Substitution elasticity',  3, 0.5, 10, doCal);
pvec.change('seHS',  '\rho_{HS}', 'Substitution elasticity',  5, 0.5, 10, doCal);



%% Other

pvec.change('R',  'R', 'Gross interest rate',  1.04, 1, 1.1, cS.calNever);



end