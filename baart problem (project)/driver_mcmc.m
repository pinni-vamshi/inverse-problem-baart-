%% A Possible Driver Function

clear
rand('state',0);
randn('state',0);

% Generate the data set.
global A;
global xtrue;
global ytrue;
global stepsize;
global x;
global reg_corner;
global sigma;
[A,ytrue,xtrue,x]=baartm_mcmc(8);
sigma=0.01*ones(8,1);

yn=ytrue+sigma.*randn(size(ytrue));


% Find the L-Curve
[U , S , V] = svd(A);
s = diag(S);
npoints = 100;

[rho, eta, reg_param] = l_curve_tikh_svd(U, s, yn, npoints);
subplot(3,3,3);
plot(rho , eta);
title("l curve")
% Find the L-corner
[reg_corner, ireg_corner, kappa] = l_curve_corner(rho, eta, reg_param);
disp("----------")
disp(reg_corner)
disp("----------") 

% Take that corner point and find Tikhonov regularized solutions
x_reg = (A'*A + reg_corner^2 * eye(8))\ A'*ytrue;
% plot the solution
subplot(3,3,4);
plot(x(2:9),x_reg);
title("x regularized")

%% MCMC


%set the MCMC parameters
%number of skips to reduce autocorrelation of models

%burn-in steps

%number of posterior distribution samples
N=1;
%MVN step size
stepsize = 0.005*ones(8,1);

% We assume flat priors here
%initialize model parameters
m0 = randn(8,1);
%% Define Log Prior in a separate function

%% Define Log Likelihood in a separate function

%% Define generate 

%% Log proposal distribution

%% MCMC iterations
[mout, mMAP, accrate] = mcmc(@logprior, @loglikelihood, @logproposal, @generate ,m0 , N);
subplot(3,3,5);
plot(mMAP);
title("MCMC")
disp(accrate);

% estimate the 95% credible intervals

%downsample results to reduce correlation
%number of skips to reduce autocorrelation of models
skip=000001;
%burn-in steps
BURNIN=000001;
k=(BURNIN:skip:N);
 
mskip=mout(:,k);
for i=1:8
  msort=sort(mskip(i,:));
  m2(i) = msort(round(2.5/100*length(mskip)));
  m9(i) =  msort(round(97.5/100*length(mskip)));
  disp(['95% confidence interval for m', num2str(i),' is [', num2str(m2(i)),',', num2str(m9(i)),']'])
end

for i=1:8
  msort=sort(mskip(i,:));
  m2(i) = msort(round(0.5/100*length(mskip)));
  m9(i) =  msort(round(99.5/100*length(mskip)));
  disp(['99% confidence interval for m', num2str(i),' is [', num2str(m2(i)),',', num2str(m9(i)),']'])
end
%subplot(3,3,5);
%plot(x(2:33),mMAP);
%title("MCMC solution")
%downsample results to reduce correlation
% plot