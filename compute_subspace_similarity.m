function w_dst = compute_subspace_similarity(data, indx) 
% subSimi = compute_subspace_similarity(X, sampledColumns)
    No_tracks = size(data, 1); 
    No_Edge = size(indx, 2); 
    
    w_dst = zeros(No_tracks, No_Edge); 

    for count=1:No_Edge
        indtmp = indx(:, count); 
        w_dst(:, count) = fit_subspace(data, indtmp); 
    end 
end

