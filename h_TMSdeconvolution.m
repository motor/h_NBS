% Deconvolution of TMS maps

% 2D matrix half swap module
% Load DATA/
% TMS maps P(n=y, m=x, V)
% induced electric field I (n=y, m=x)
% sensitivity function data: S(v), MEP in microV as functon of stim output
% --> S = gaussian fit on 
% --> y = [200 202 250 550 750 1250 1750 1900 2000]
% --> x = [22 26 27 29 31 32 33 34 35]
datinp = 'measured response data';
impinp = 'impulse function';
mvsinp =  'sensitivity data';
threshold = 25.5;
stmout = 1.10*threshold;

function TMSdeconvolution
% "Deconvolutio of TMS maps" Bohning et al 2002
% pseudocode in paper
% compute dependent variables, reverse data matrix vertically, and
% normalize instrument functon

dsz = length(datainp):


function sensitivity
% sensitivity function data: S(v), MEP in microV as functon of stim output
% --> S = gaussian fit on 
x = [200 202 250 550 750 1250 1750 1900 2000];
y = [22 26 27 29 31 32 33 34 35];
% f = ezfit(y,x, 'a(1 + erf([x-b]/s))/2; a = 2000; b = 30; s = 4');
figure, 
plot(y,x)
showfit('a(1 + erf([x-b]/s))/2; a = 2000; b = 30; s = 4')
