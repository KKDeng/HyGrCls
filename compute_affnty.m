function W = compute_affnty(data, indx, No_Edge, No_clusters) 
    No_tracks = size(data, 1); 
%     No_clusters = max(label); 
    s = 0;
%     load('s.mat', 's');
    
    w_dst = zeros(No_tracks, No_Edge); 
%     indx = zeros(k_order, No_Edge); 
%     tic
%     matlabpool open local 4; 
%     parfor count=1:No_Edge
    for count=1:No_Edge
%         i = floor((count-1)/Trc_order) + 1; 
%         indtmp = sample_points(U_lbs{label(i)}, k_order, No_tracks, th/100, s); 
        indtmp = indx(:, count); 
%         w_dst(:, count) = fit_funda(data, indtmp, jmp); 
        w_dst(:, count) = fit_subspace(data, indtmp, No_clusters); 
%         w_dst(:, count) = fit_ssim(data(1:2, :, :), indtmp, jmp);         
%         indx(:, count) = indtmp; 
%         s = rng; 
    end
%     matlabpool close;
%     toc
    
%     w_dst = w_dst./repmat(sum(w_dst), [No_tracks, 1]); 
    
    
    [vl, idx] = sort(w_dst, 2); 
    vl = vl(:, 1:round(No_Edge/(No_clusters))); 
    [vl, idx] = sort(vl, 1); 
    vl = vl(1:round(No_tracks/No_clusters), :); 
    
    sigm = mean(vl(:)); 
%     cls = 60/No_clusters; 
%     if sigm > cls
%         sigm = cls; 
%     end
%     if sigm < 5
%         sigm = 5; 
%     end
%     sigm = 10;
%     disp(sigm)
    w = exp(-w_dst/(2*sigm)); 

    idx = (sum(w, 2) < eps); 
    w(idx, :) = 1/No_tracks; 
    w = w./repmat(sqrt(sum(w, 2)), [1, No_Edge]); 
    
    W = 1-pdist(w,'cosine'); 
    W = squareform(W); 

%     W = w*w';
    
    figure(3), imshow(W, []); 
%     pause;
    
end