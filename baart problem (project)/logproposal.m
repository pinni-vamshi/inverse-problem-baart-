% Example 11.4
% from Parameter Estimation and Inverse Problems, 3rd edition, 2018
% by R. Aster, B. Borchers, C. Thurber
% lr=logr(x,y)
%
% For this problem, we'll use a multivariate normal generator, with 
% standard deviations specified by the vector step.

% Note that logproposal.m and generate.m
% are closely tied to each other.
%
function lr=logproposal(x,y)
global stepsize;

lr_sum=(-1/2)*sum((x-y).^2./stepsize.^2);
lr = lr_sum;
