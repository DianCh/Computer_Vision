function [f precision recall] = edgeEval(E, groundTruth)

%% Instructions to run the evaluation script:  
% E is the output of your edge detector (a logical map). 
% To test this, do the following:
% Run your edge detector: cannyEdge(img) which should return a logical map: E
% Load the corresponding groundTruth mat file into MATLAB. It should load
% as a variable named "groundTruth" in your workspace. 
% Call this script as edgeEval(E, groundTruth) and it will print out
% precision, recall and f scores.

%% Code Begins   
E = double(E);
accP = zeros(size(E));
maxDist = 0.0075;
sumR = 0;
cntR = 0;
for i = 1:length(groundTruth)
    % compute the correspondence
    [match1,match2] = correspondPixels(E, double(groundTruth{i}.Boundaries), maxDist);
    % accumulate machine matches
    accP = accP | match1;
    % compute recall
    sumR = sumR + sum(groundTruth{i}.Boundaries(:));
    cntR = cntR + sum(match2(:)>0);
end

sumP = sum(E(:));
cntP = sum(accP(:));
precision = cntP / sumP;
recall = cntR / sumR;
f = 2*precision*recall / (precision+recall);

