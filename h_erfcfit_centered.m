function cf_ = h_erfcfit_centered(x,pX)
%H_ERFCFIT_CENTERED    Create plot of datasets and fits
%   H_ERFCFIT_CENTERED(X,PX)
%   Creates a plot, similar to the plot in the main curve fitting
%   window, using the data that you provide as input.  You can
%   apply this function to the same data you used with cftool
%   or with different data.  You may want to edit the function to
%   customize the code and this help message.
%
%   Number of datasets:  1
%   Number of fits:  1

 
% Data from dataset "pX vs. x":
%    X = x:
%    Y = pX:
%    Unweighted
%
% This function was automatically generated on 13-Nov-2008 14:03:01

% Set up figure to receive datasets and fits
f_ = clf;
figure(f_);
set(f_,'Units','Pixels','Position',[440.667 214.5 680 480]);
legh_ = []; legt_ = {};   % handles and text for legend
xlim_ = [Inf -Inf];       % limits of x axis
ax_ = axes;
set(ax_,'Units','normalized','OuterPosition',[0 0 1 1]);
set(ax_,'Box','on');
axes(ax_); hold on;

 
% --- Plot data originally in dataset "pX vs. x"
x = x(:);
pX = pX(:);
h_ = line(x,pX,'Parent',ax_,'Color',[0.333333 0 0.666667],...
     'LineStyle','none', 'LineWidth',1,...
     'Marker','.', 'MarkerSize',12);
xlim_(1) = min(xlim_(1),min(x));
xlim_(2) = max(xlim_(2),max(x));
legh_(end+1) = h_;
legt_{end+1} = 'pX vs. x';

% Nudge axis limits beyond data limits
if all(isfinite(xlim_))
   xlim_ = xlim_ + [-1 1] * 0.01 * diff(xlim_);
   set(ax_,'XLim',xlim_)
end


% --- Create fit "fit 2"
fo_ = fitoptions('method','NonlinearLeastSquares','Normalize','on');
ok_ = ~(isnan(x) | isnan(pX));
st_ = [0.0858 161 235 ];
set(fo_,'Startpoint',st_);
ft_ = fittype('a*erfc(((x-b)/c)^2)',...
     'dependent',{'y'},'independent',{'x'},...
     'coefficients',{'a', 'b', 'c'});

% Fit this model using new data
cf_ = fit(x(ok_),pX(ok_),ft_,fo_);

% Or use coefficients from the original fit:
if 0
   cv_ = {110.0779570881, 0.01188543992436, 1.264605023997};
   cf_ = cfit(ft_,cv_{:});
end

% Plot this fit
h_ = plot(cf_,'fit',0.95);
legend off;  % turn off legend from plot method call
set(h_(1),'Color',[1 0 0],...
     'LineStyle','-', 'LineWidth',2,...
     'Marker','none', 'MarkerSize',6);
legh_(end+1) = h_(1);
legt_{end+1} = 'fit 2';

% Done plotting data and fits.  Now finish up loose ends.
hold off;
h_ = legend(ax_,legh_,legt_,'Location','NorthEast');  
set(h_,'Interpreter','none');
xlabel(ax_,'');               % remove x label
ylabel(ax_,'');               % remove y label
