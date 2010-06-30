

for i = 1:length(NBS.DATA)
    locs = NBS.DATA(i).RAW(1).PP.data(:,[10 12]);
    stats(locs);
end