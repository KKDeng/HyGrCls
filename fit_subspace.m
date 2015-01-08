
function w = fit_subspace(D, indx)
    c = 5; 
    F = size(D, 2); 
    c = min(c, numel(indx));
    D_sub = D(indx, :); 
    X = bsxfun(@minus, D_sub, mean(D_sub)); 
    [U, S, V] = svd(X, 'econ'); 
    
    S = diag(S); 
    id = find(cumsum(S)/sum(S) < 0.995); 
    if numel(id) 
        if (id(end) > c); 
            c = id(end);
        end
    else
        c = 1; 
    end
    
    S = sqrt(S(1:c));
    U = V(:, 1:c); 

    D = bsxfun(@minus, D, mean(D_sub)); 
    newX = (eye(F) - U*U')*D'; 
    
    w = sum(newX.^2, 1); 
%     w = w/sum(w); 
%     w(indx) = inf;
    
end
