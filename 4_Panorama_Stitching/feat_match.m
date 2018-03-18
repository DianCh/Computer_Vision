% File name: feat_match.m
% Author: Yu Sun
% Date created: 11/06/2017

function [match] = feat_match(descs1, descs2)
% Input:
%   descs1 is a 64x(n1) matrix of double values
%   descs2 is a 64x(n2) matrix of double values

% Output:
%   match is n1x1 vector of integers where m(i) points to the index of the
%   descriptor in p2 that matches with the descriptor p1(:,i).
%   If no match is found, m(i) = -1

n1 = size(descs1,2);
% initialize all m to be -1
match = -ones(n1,1);
X = descs2';
Y = descs1';
[idx,dist] = knnsearch(X,Y,'K',2);
ratio = dist(:,1)./dist(:,2);
i = ratio < 0.7;
match(i) = idx(i,1);


end