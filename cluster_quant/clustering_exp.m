
% file for clustering experiments
% we want to quantify the influence of noise and cluster-distance on the
% outcome of the clustering method

% * is the method reliable?
% * does the smoothing (kernel) destroy existing subclusters
% * maybe try hierarchical clustering (k_neares_neighbours or similar)


%% Load the data, initialization and settings
clear
load ../../data/GROUP-DATA-OE
logg = cell(0);

% fixed for the first subject first condition
subj        = 1;
sess        = 1;
cond_idx    = 1;

scl1            = 1;        % scaling of map
kernel_size     = 100;      % size of kernel matrix
sgm             = 5;        % sigma (width) of kernel
conds           = [1 3 5];
chnnls          = {'APB','LATapb','FDI','LATfdi','ADM','LATadm'};
random_data     = 1;        % run the whole thing for random data or recorded MEPS



%% random data and cluster parameters
noise_sig       = 1;
noise_perc      = 20;
xrange          = [0 60];           % map size
yrange          = [0 60]; 
    
param(1).mu1  = 10;
param(1).mu2  = 20;
param(1).sig2 = 7;
param(1).sig1 = 10;

param(2).mu1  = 40;
param(2).mu2  = 40;
param(2).sig2 = 10;
param(2).sig1 = 7;

param(3).mu1  = 10;
param(3).mu2  = 50;
param(3).sig2 = 5;
param(3).sig1 = 5;

n_events = 150;


%% get data
if random_data
    % get a distribution of MEP values for a certain condition
    dist = [];
    for i=1:length(NBS.DATA)
        for j=1:length(NBS.DATA(i).RAW)
            dist = [dist; NBS.DATA(i).RAW(j).AMPS(:,conds(cond_idx))]; %#ok<AGROW>
        end
    end
    rand_perm    = randperm(length(dist));
    amps         = dist(rand_perm(1:n_events));
    [amps, locs] = random_clusters(param, amps);

    % create random meps
    noisemap    = randn(xrange(2),yrange(2)) * noise_sig;
    n_rand      = round(noise_perc / 100) * length(amps);
    rand_perm   = randperm(length(dist));
    amps        = [amps; dist(rand_perm(1:n_rand))];
    locs        = [locs [rand(1,n_rand)*xrange(2); rand(1,n_rand)*yrange(2)]];

else
    amps    = NBS.DATA(subj).RAW(sess).AMPS(:,conds(cond_idx)); %#ok<UNRCH>
    locs    = NBS.DATA(subj).RAW(sess).PP.data(:,[10 12])'*scl1;  
    xrange  = [floor(min(locs(1,:))*scl1) ceil(max(locs(1,:))*scl1)];
    yrange  = [floor(min(locs(1,:))*scl1) ceil(max(locs(2,:))*scl1)];
end



%% create the map 
M           = zeros(yrange(2),xrange(2)); 
bin_count   = zeros(yrange(2),xrange(2));
for i=1:length(amps)
    
    % compute iterative mean when already something in bin
    x = floor((locs(1,i)+1)*scl1);
    y = floor((locs(2,i)+1)*scl1);
    if amps(i) ~= 0
        M(y,x) = M(y,x) + (1/(bin_count(y,x)+1)) * (amps(i)-M(y,x));
    end
end

% add white noise
% NOTE does it make sense to add this white noise?
% M = M(1:yrange(2), 1:xrange(2)) + noisemap;


%% smooth map (get kernel, smoot and normalize)
%h   = fspecial('log',[kernel_size*scl1 kernel_size*scl1],sgm*scl1)*-1;
h   = fspecial('gaussian',[kernel_size*scl1 kernel_size*scl1],sgm*scl1);
Ms  = imfilter(M,h,'same');
Ms  = Ms .* max(max(M))/max(max(Ms));

% negative values cannot happen anymore with the gaussian kernel
assert(min(min(Ms)) >= 0);


%% STATISTICS ON the map

logg{end+1} = '.........................................';
logg{end+1} = [chnnls{conds(cond_idx)} '; cond:' num2str(cond_idx)];
logg{end+1} = [num2str(length(amps)) ' events; ' num2str(length(find(amps))) ' MEPS'] ;


%% clustering on raw data
% idee für mein clustering
% ich nehme nur die punkte an welchen die amps größer sind als 90 prozent
% des rests, diese dann mit clusterdata clustern
% erstmal nehme ich den mean weil ich vergessen habe wie man das mit den 90
% prozent nennt

% TODO which threshold to choose and how to choose the inconsistent (magic) number

thresh          = mean(Ms(:));
[y_s, x_s]      = find(Ms > thresh);
magic_number    = 0.0000001;
labels          = clusterdata([y_s x_s], magic_number); 


%% test from seins code
bw = Ms;
bw(bw < thresh) = 0;
D = bwdist(~bw);
%figure, imshow(D,[],'InitialMagnification','fit')
%title('Distance transform of ~bw')
D = -D;
D(~bw) = -Inf;
L = watershed(D);
rgb = label2rgb(L,'jet',[.5 .5 .5]);
%imshow(rgb,'InitialMagnification','fit')
%title('Watershed transform of D')


%% plots

for s=logg
    disp(s)
end

fig = figure(1);
set(gcf,'name',['condition ' chnnls{conds(cond_idx)}])

subplot(2,2,1),
% plot highest amps latest, otherwise they are often covered
[throwaway, idx] = sort(amps, 'descend');
scatter( locs(1,idx), locs(2,idx), 10, amps(idx)/1000, 'filled');
title([chnnls{conds(cond_idx)} ': scatter plot' ])
grid on
axis('image', 'ij', [xrange yrange])

subplot(2,2,2)
hold on
imagesc(Ms)
contour(Ms,20)
hold off
title('contour of MAP (smoothed)')
axis('image', 'ij', [xrange yrange])
grid on


subplot(2,2,3)
scatter(x_s, y_s, 10, labels, 'filled');
grid on
axis('image', 'ij', [xrange yrange])

subplot(2,2,4)
imshow(rgb,'InitialMagnification','fit')


