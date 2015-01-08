%% Main function that does the clustering 
%############################################################################################################
%% Clustering with Hypergraphs: The Case for Large Hyperedges  
% This package contains the source code which implements Hypergrapgh Clustering with large Hyperedges proposed in
% P. Purkait, T.J. Chin, H. Ackermann and D. Suter
% Clustering with Hypergraphs: The Case for Large Hyperedges  
% In Proc. Europian Conf. on Computer Vision (ECCV),  Zurich, Switzerland, 2014.
% 
% Copyright (c) 2014 Pulak Purkait (pulak.purkait@adelaide.edu.au.)
% School of Computer Science, The University of Adelaide, Australia
% The Australian Center for Visual Technologies
% http://www.cs.adelaide.edu.au/directory/pulak.purkait
% 
% Please acknowledge the authors by citing the above paper in any academic publications that have made use of 
% this package or part of it.
%############################################################################################################

function label = hypergraph_clustering(data, d, No_clss, No_Edge, itm, k_order, dsply_flg)
     
    No_tracks = size(data, 1); 
    nn = 3;                     % Nearest Neighbour Taken To compute the Auxiliary Graph
    label = ones(No_tracks, 1); 
    
    [edge, edge_costs] = compute_proximity(data, nn); 
        
    OPTIONS.c = No_Edge;    % Sampling Parameters
    OPTIONS.n = k_order; 
    OPTIONS.seedType = 'hard';
    OPTIONS.normalizeU = 1;
    OPTIONS.normalizeW = 1;
    OPTIONS.alpha = 0;
        
    old_error = Inf; 
    for j=1:itm
        OPTIONS.lambda = 3*j; 
        indx = rcm_sampling(edge, edge_costs, label, OPTIONS); 
 
        w_dst = compute_subspace_similarity(data, indx); 
        [vl, idx] = sort(w_dst, 2); 
        vl = vl(:, 1:round(No_Edge/(No_clss))); 

        sigm = std(vl(:)); 
        no_iteration = 10;

        labelAll = zeros(No_tracks, no_iteration); 
        labelError = zeros(1, no_iteration); 
        tic
        for i = 1:no_iteration

            lambda = 1.2^(i-1)/(sigm); 

            w = exp(-lambda*w_dst); 
            idx = (sum(w, 2) < eps); 
            w(idx, :) = 1/No_tracks; 
            w = w./repmat(sqrt(sum(w, 2)), [1, No_Edge]); 

            W = w*w';    

            labelAll(:, i) = processing_affinities(W, No_clss, OPTIONS); 
            labelError(i) = computing_average_L2_error(data,d,labelAll(:, i));
            if dsply_flg
                figure(1), imshow(W, []); 
                figure(2), plot(labelAll(:, i)); 
                disp(labelError(i)); 
                pause(0.2);
            end
        end
        toc

        [newError, id] = min(labelError); 
        if newError < old_error
            label = labelAll(:, id); 
            old_error = newError; 
%         elseif newError == old_error
%             return; 
        end
    end
end

