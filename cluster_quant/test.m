
%% set the parameters
param(1).mu1  = 10;
param(1).mu2  = 20;
param(1).sig2 = 1;
param(1).sig1 = 0.5;

values = 1:111;

%% create the data
locs = [];
vals = [];
length_res  = floor(length(values) / length(param)) * length(param);

for i = 1:length(param)
    n_cluster           = length_res / length(param);
    center_matrix       = ones(n_cluster, 2) * ...
        [param(i).mu1, 0; 0, param(i).mu2];
    tmp_locs = randn(n_cluster, 2) * ...
        [param(i).sig1, 0; 0, param(i).sig2] + ...
        center_matrix;
    
    diffs_vec           = tmp_locs - center_matrix;
    tmp_vals   = NaN(1, n_cluster);
    
    for j = 1:n_cluster
        tmp_vals(j) = norm(diffs_vec(j,:));
    end
    vals = [vals; abs(tmp_vals - max(tmp_vals))' * 10 + eps]; %#ok<AGROW>
    locs = [locs; tmp_locs]; %#ok<AGROW>
end

% order the values and replace them by original mep values according to
% their position in the order. This is done to keep the statistical
% properties (distribution) of the mep values
[throw_away, idx] = sort(vals);
s = sort(values);

% indeces for the "inverse of the sort"
inv_idx = NaN(length(idx),1);
for i=1:length(idx)
    inv_idx(idx(i)) = i;
end
vals = s(inv_idx);



%% print it
for i=1:length(vals)
    plot(locs(i,1), locs(i,2), '.', 'MarkerSize', vals(i)*0.7);
    hold on
end

for i=1:length(param)
    plot(param(i).mu1, param(i).mu2, 'xr');
end
hold off
axis equal
