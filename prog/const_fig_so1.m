function figS = const_fig_so1
% Figure options
% --------------------------------

fileFormat = 'pdf';

% % Figure types
% figS.default = 1;
% figS.bar = 2;
% figS.type3d = 3;


% Slide output?
figS.slideOutput = false;



%% Fonts

if figS.slideOutput
   fontSizeFactor = 1.35;
else
   fontSizeFactor = 1;
end

% Font size for legend, xlabels, axes
figS.figFontSize = 10 * fontSizeFactor;
figS.figFontName = 'Times';
figS.legendFontSize = 10 * fontSizeFactor;
% Font size for latex must be a little larger
figS.latexFontSize = 12 * fontSizeFactor;


%% Figure options / sizes

% Sizes must be consistent with what's used in the paper. Otherwise fonts
% get scaled
figHeight = 4; % inches
figWidth  = 4;
if strcmpi(fileFormat, 'pdf')
   % Extension
   figS.figExt = '.pdf';
   figS.figOptS = struct('height', figHeight, 'width', figWidth, 'color', 'rgb', 'Format', 'pdf', ...
      'FontSize', 1 * fontSizeFactor, 'FontMode', 'scaled');
elseif strcmpi(fileFormat, 'eps')
   % Extension
   figS.figExt = '.eps';
   figS.figOptS = struct('preview', 'tiff', 'height', figWidth, 'width', figWidth, 'color', 'rgb', 'Format', 'eps', ...
      'FontSize', 1 * fontSizeFactor, 'FontMode', 'scaled');   
else
   error('Invalid');
end

% Always save FIG file with underlying data
figS.figOptS.saveFigFile = 1;

% 2 plots side-by-side
figS.figOpt2S = figS.figOptS;
figS.figOpt2S.height = figHeight;
figS.figOpt2S.width  = 2 * figWidth;
% 4 panel
figS.figOpt4S = figS.figOpt2S;
figS.figOpt4S.height = 2 * figHeight;
figS.figOpt4S.width  = 2 * figWidth;
figS.figOpt6S = figS.figOpt4S;
figS.figOpt6S.height = 3 * figHeight;
% Quarter size figure (4 panels or 2 side-by-side)
figS.figOptQuarterS = figS.figOptS;
% Keep sizes the same no matter how figs are displayed
%figS.figOptQuarterS.height = figS.figOptS.height * 0.7;
%figS.figOptQuarterS.width  = figS.figOptS.width  * 0.7;



%% Colors

figS.colorV = 'kbrgcmkbrgcm';

% Set default colors muted
xV = 0.2 : 0.15 : 0.96;
ncol = length(xV);
figS.colorM = zeros([2 * ncol, 3]);
for ix = 1 : length(xV)
   x = xV(ix);
   figS.colorM(ix,:) = [1-x, 0.4, x];
   figS.colorM(ncol + ix, :) = [1-x, x, 0.4];
end

% Color map
figS.colorMap = 'copper';
% This is a matrix. Each line is a color
% figS.colorMap = colormap('copper');
% figS.colorMap = figS.colorMap(5:end, :);


%% Lines

figS.lineWidth = 1.5;

% Markers for non-connected plots
figS.markerV = 'odx+*sd^vphodx+*sd^vph';
figS.lineTypeV = {'-', '--', '-.', '-', '--', '-.', '-', '--', '-.', '-', '--', '-.', '-', '--', '-.', '-', '--', '-.', '-', '--', '-.'};

% Line styles when many points are used
figS.lineStyleDenseV = figS.lineTypeV;     % cell([1,n]);

% Line styles when few points are used
n = length(figS.lineTypeV);
figS.lineStyleV = cell([1,n]);
for i1 = 1 : n
   figS.lineStyleV{i1} = [figS.markerV(i1), figS.lineTypeV{i1}];
   %figS.lineStyleDenseV{i1} = figS.lineTypeV{i1};
end



%% Bar graphs

figS.barWidth = 1;



%% Notation and labels



end