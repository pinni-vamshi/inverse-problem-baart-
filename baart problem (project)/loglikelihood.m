% Example 11.4
% from Parameter Estimation and Inverse Problems, 3rd edition, 2018
% by R. Aster, B. Borchers, C. Thurber
% l=loglikelihood(m)
%


function l=loglikelihood(m)
%
% global variables.
%

global A;
global ytrue;
global sigma;
global x;

% Compute the standardized residuals.
%
fvec= (ytrue-fun(m))./sigma;
%disp("fvec");
%disp(fvec)
sm = sum(fvec.^2);
%disp("sm");
%disp(sm);

%
% The log likelihood is (-1/2)*sum(fvec(i)^2,i=1..n);
%
l=-(1/2)*sm;

%disp("loglikelihood");
%disp(l)