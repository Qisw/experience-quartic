function param_tb(doCalV, gNo, setNo)
% Show calibrated or not calibrated parameters

cS = const_so1(gNo, setNo);
dirS = param_so1.directories([], gNo, setNo);
paramS = param_load_so1(gNo, setNo);
symS = cS.symS;

if isequal(doCalV, cS.calBase)
   tbFn = fullfile(dirS.paramDir, 'param_tb.tex');
elseif isequal(doCalV, cS.calNever)
   tbFn = fullfile(dirS.paramDir, 'param_fixed_tb.tex');
else
   error('Invalid');
end

% Parameter table object
ptS = ParamTableLH(paramS, cS.pvector, doCalV);

% Vector of all calibrated values
% [~, paramNameV] = cS.pvector.calibrated_values(paramS, cS.calBase);
% paramUsedV = zeros(size(paramNameV));




%% ********  Table layout

nc = 0;
nc = nc + 1;   cName = nc;
nc = nc + 1;   cRole = nc;
nc = nc + 1;   cValue = nc;

nr = 20;
tbM = cell([nr, nc]);
tbS.rowUnderlineV = zeros([nr, 1]);
tbS.showOnScreen = 1;

% Header
ir = 1;
tbS.rowUnderlineV(ir) = 1;
tbM{ir,cName} = 'Parameter';
tbM{ir,cRole} = 'Description';
tbM{ir,cValue} = 'Value';


%% ********  Body: OJT

ir = ir + 1;
tbM{ir, cName} = 'On-the-job training';

add_one('logAV', [], 'Productivity', '%.3f');
add_one('gAV', [], 'Productivity growth', '%.3f');

add_vector({'alphaHSD', 'alphaHSG', 'alphaCD', 'alphaCG'}, symS.retrieve('pAlpha'), 'Curvature', '%.2f')
add_vector({'ddhHSD', 'ddhHSG', 'ddhCD', 'ddhCG'}, symS.retrieve('pDelta'), 'Depreciation', '%.2f')

add_vector({'trainTimeMin', 'trainTimeMax'},  symS.retrieve('trainTime'),  'Range for training time', '%.2f');


% ir = ir + 1;
% tbM{ir, cName} = 'Schooling';
% if cS.calB == 1
%    ir = ir + 1;
%    tbM{ir,cName} = '$B$';
%    tbM{ir,cRole} = 'Productivity';
%    tbM{ir,cValue} = sprintf('%4.3f', paramS.B);
% end




%% Skill prices
if 01
   ir = ir + 1;
   tbM{ir, cName} = 'Skill prices';


%       % *****  Skill prices
%       if any(cS.calSpGrowthV)
%          ir = ir + 1;
%          tbM{ir,cName} = '$\Delta w_{s}$';
%          tbM{ir,cRole} = sprintf('Skill price growth rate, %i-%i [pct]', cS.wageYearV(1), cS.wageYearV(end));
%          xStr = sprintf('%4.2f, ', 100 .* paramS.spGrowthV);   
%          tbM{ir,cValue} = xStr(1 : (end-2));
%       end
% 

   % Substitution elasticities (GE)
   add_one('seHS', [], [], '%.2f');
   add_one('seCG', [], [], '%.2f');
   
   for iSchool = 1 : cS.nSchool
      add_one(sprintf('logWNode_s%iV', iSchool), [], [], '%.2f');
   end
end


%% Other
if 1
   add_one('R', [], [], '%.2f');
end


%% *****  Save table

nr = ir;
tbM = tbM(1 : nr, :);
tbS.rowUnderlineV = tbS.rowUnderlineV(1 : nr);

latex_lh.latex_texttb_lh(tbFn, tbM(1:ir,:), 'Caption', 'Label', tbS);


% Check that all used
ptS.list_unused;


%% Nested: Add one parameter entry
   function add_one(nameStr, symbolStr, roleStr, fmtStr)      
      rowV = ptS.row_from_param(nameStr, symbolStr, roleStr, fmtStr);
      if ~isempty(rowV)
         ir = ir + 1;
         tbM(ir, :) = rowV;
      end
%       ps = cS.pvector.retrieve(nameStr);
%       if ps.doCal == cS.calBase
%          ir = ir + 1;
%          tbM{ir, cName} = symbolStr;
%          if isempty(roleStr)
%             roleStr = ps.descrStr;
%          end
%          tbM{ir, cRole} = roleStr;
%          tbM{ir, cValue} = valueStr;
%       
%          mark_used(nameStr);
%       end
   end


%% Add multiple params in one row
   function add_vector(nameStrV, symbolStr, roleStr, fmtStr)
      rowV = ptS.row_from_vector(nameStrV, symbolStr, roleStr, fmtStr);
      if ~isempty(rowV)
         ir = ir + 1;
         tbM(ir, :) = rowV;
      end
%       % Retrieve values for those calibrated
%       valueV = nan(size(nameStrV));
%       for i11 = 1 : length(nameStrV)
%          ps = cS.pvector.retrieve(nameStrV{i11});
%          if ps.doCal == cS.calBase
%             valueV(i11) = paramS.(nameStrV{i11});
%             mark_used(nameStrV{i11});
%          end
%       end
%       
%       if any(~isnan(valueV))
%          ir = ir + 1;
%          tbM{ir, cName} = symbolStr;
%          tbM{ir, cRole} = roleStr;
%          tbM{ir, cValue} = string_lh.string_from_vector(valueV(~isnan(valueV)), fmtStr);
%       end
   end


%% Nested: mark used
%    function mark_used(nameStr)
%       % Mark as used
%       idx1 = find(strcmp(nameStr, paramNameV));
%       if length(idx1) == 1
%          paramUsedV(idx1) = 1;
%       else
%          error('Invalid');
%       end
%    end
% 
end