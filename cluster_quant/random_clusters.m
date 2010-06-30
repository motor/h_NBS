function [vals, locs] = random_clusters(param, values)

locs = [];
vals = [];
length_res  = floor(length(values) / length(param)) * length(param);

% for the different clusters specified in param
for i = 1:length(param)
    n_cluster           = length_res / length(param);
    center_matrix       = ones(n_cluster, 2) * [param(i).mu1, 0; 0, param(i).mu2];
    tmp_locs = randn(n_cluster, 2) * [param(i).sig1, 0; 0, param(i).sig2] + center_matrix;
    
    diffs_vec  = tmp_locs - center_matrix;
    tmp_vals   = sqrt(sum(diffs_vec.^2,2))';     % norm of each row
    
    % norm the distances, otherwise only clusters with small sigma get the
    % large values from the MEP distribution
    tmp_vals = tmp_vals / max(tmp_vals);
    
    vals = [vals; abs(tmp_vals - max(tmp_vals))']; %#ok<AGROW>
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
locs = locs';
end