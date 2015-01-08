
function percnt = compute_accuracy(no_cls, no_per_cls, C)
    % Calculate Accuracy 
    % The actual accuracy should be computed using the function below. 
    % However this is a faster way to compute the approximate accuracy. 
    
    label = [];
    for i=1:no_cls
        label = [label; i*ones(no_per_cls, 1)]; 
    end

    No_clss = max(label); 
    sm = 0; 
    for i=1:No_clss
        C2 = C((i-1)*no_per_cls+1:i*no_per_cls); 
        md = median(C2); 
        sm = sm + sumabs(sign(C2 - md*ones(no_per_cls, 1))); 
    end
    percnt = 100*(numel(label) - sm)/numel(label); 

end

% function [percnt, prms] = compute_accuracy(no_cls, no_per_cls, C)
%     % Calculate Accuiracy 
%     
%     label = [];
%     for i=1:no_cls
%         label = [label, i*ones(1, no_per_cls)]; 
%     end
% 
%     No_clss = max(label); 
%     % Calculate Accuiracy 
%     P = perms([1:No_clss]); 
%     mn = zeros(1, size(P, 1)); 
%     for i=1:size(P, 1)
%         prms = P(i, :); 
%         mn(i) = sumabs(sign(label - prms(C))); 
%     end
%     
%     [min_mn, id] = min(mn);
%     percnt = 100*(numel(label) - min_mn)/numel(label);
%     prms = P(id, :);
% 
% end