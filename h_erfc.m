% An integrative TMS mapping technique using non-liniear curve fitting
% (Kohl et al 2006)

% a = amplitudeparameter, a = 2;
% b = position, b = 0.5;
% c = width, c = 2.35;
 
clear x y
x = [-100:1:100];
for i=1:length(x)
    y(i) = a * erfc((x(i)-b/c)^2);
end
y = y+rand(length(y),1)';
figure, 
plot(y)
showfit('a * erfc((x-b/c)^2); c = 2.35; a = 2; b=230')
f = ezfit(y,x,'a * erfc(([x-b]/c)^2): a = 2; c = 2.35');

