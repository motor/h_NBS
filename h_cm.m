function CM = h_cm(y,type);
type = 'subject';
% cm
for i=1:length(y)
    ycm(i) = mean(y(1:i));
end
% reliability   
ind = find(abs(diff(ycm))<2*std(ycm(20:end)));
if isempty(ind)
    proz(1) = 100;
    ind(1) = 1;
else
    for i=1:5
        proz(i) = round(100*length(find(abs(diff(ycm(ind(i):end)))<2*std(ycm(20:end))))/length(ycm(ind(i):end)));
    end
    ind2 = find(proz == max(proz));
    ind = ind(ind2(1));
    proz = proz(ind2(1));
end
% mean
ymean = mean(ycm(ind:end));
ystd = std(ycm(ind:end));
disp(['... optimal reliability after ' num2str(ind) ' scans (' num2str(proz) '%)'])
CM.reliable = ycm(ind:end);
CM.cutoff = ind;
CM.proz = proz;
CM.mean = ymean;
CM.std = ystd;
