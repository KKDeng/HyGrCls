function [e, cost] = compute_proximity(D, nn)

    N = size(D, 1);      
    c = 5; 

    X = bsxfun(@minus, D, mean(D)); 
    [U, S, V] = svd(X, 'econ'); 
    V = D*V(:, 1:c); 
    
    A = pdist(V,'euclidean'); 
    A = squareform(A); 
    
    [vl, idx] = sort(A, 2); 
    
    e1 = repmat([1:N], [nn, 1])'; 
    e2 = idx(:, 2:nn+1); 
    e = [e1(:), e2(:)]; 
    cost = vl(:, 2:nn+1); 
    cost = cost(:); 
    
end

