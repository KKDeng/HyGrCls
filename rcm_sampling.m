
function inds  = rcm_sampling(e, cost, f, OPTIONS)
% Follows Swendsen-Wang cut of Barbu and Zhu.
%-------
% Input:
%-------
% e (|E|x2)     : Edges.
% cost (|E|x1)  : Edge costs. 
% f (|V|x1)     : label of the vertices
% OPTIONS       : Options for rcm sampling 

%--------
% Output:
%--------
% inds          : Sampled hyperedges 

No_Edge = OPTIONS.c; 
n = OPTIONS.n-1;            % Its a dense hypergrapgh, model is evaluated rest of the points
lambda = OPTIONS.lambda; 

N = length(f);

csts = cost.^2; 
mn_csts = mean(csts); 
q = exp(-csts./(lambda^2*mn_csts)); % Edge probabilities.


% Sample the connected component.
% Edges that remain 'on' due to same labels.
eon_det = f(e(:,1))==f(e(:,2));
inds = zeros(n, No_Edge); 

k = 1;

while (k <= No_Edge)
    % Edges that are turned 'on' stochastically.
    eon_sto = rand(length(q),1)<=q;

    % Either the edge is already 'off' due to different labels, or
    % the edge is turned 'off' stochastically.
    eon = logical(eon_det.*eon_sto);

    % Get current set of connected components.
    Eon = sparse(e(eon,1),e(eon,2),ones(sum(eon),1),N,N);
    Eon = Eon + Eon';   % Make it symmetric.
    [S,C] = graphconncomp(Eon);

    % Pick a connected component R probabilistically.
    q2 = q(eon); 
    w = ones(1,S);
    for s=1:S
        id = find(C==s); 
        if numel(id) < n % Remove small clusters having less than 8 points
            w(s) = 1e-1000;
        else
            [X, Y] = meshgrid(id, id); 
            [vl, idb, idc] = intersect(e(eon, :), [X(:), Y(:)], 'rows'); 
            w(s) = sum(q2(idb))/(numel(idb)); 
    %         w(s) = sum(q(idb))/(numel(id)*nn);
        end
    end
    
    if sum(w) < eps
        continue;
    end
    
    
    for i=1:sum(w>0)
        if k > No_Edge
            return; 
        end
        R = randsample(S,1,true,w);
        % indices of points in cluster k and its size
        inds_k = find(C == R);
        rsmpl = randsample(inds_k, n)';
        flag = 1;
        for kk =1:k-1
            id = double(inds(:, kk) == rsmpl); 
            if sum(id) == n
                flag = 0;
            end
        end
        if flag
            inds(:,k) = rsmpl; 
            k = k+1; 
        end
    end
end

        


