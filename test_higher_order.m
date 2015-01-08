%% This file is the implementation of the following work
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

clear; 
close all; 
load('yaleFacesB.mat'); 
rng(0);

%% Parameter Settings ... We encourage user to run with different settings 

d = 2;         % Subspace Dimension 
No_Edge = 50; % Number of Hyperedes  
k_order = 20;  % Hypergraph Order 
itm = 6;       % Iteration Used for SW Sampling 
dsply_flg = 1; 

%% Select the number of classes and apply SVD to reduce the dimension     
no_cls = 10; % Try with different numbers <= 10
no_per_cls = 64; 
D = 2*no_cls; 
cls_elmnts = randsample(10, no_cls); 
data = []; 
for i=1:no_cls
    data = [data; I(:, (cls_elmnts(i)-1)*no_per_cls+1:cls_elmnts(i)*no_per_cls)']; 
end

X = bsxfun(@minus, data, mean(data)); 
[U, S, V] = svd(X, 'econ'); 
newX = X*V(:, 1:D); 

%% Clustering and accuracy 

tic            
sampleLabels = hypergraph_clustering(newX, d, no_cls, No_Edge, itm, k_order, dsply_flg); 
toc
percnt = compute_accuracy(no_cls, no_per_cls, sampleLabels);
fprintf('Parcentage of Face Clustering Accuracy %0.2f. \n', percnt); 

