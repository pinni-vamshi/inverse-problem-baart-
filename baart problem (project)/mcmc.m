% Parameter Estimation and Inverse Problems, 3rd edition, 2018
% by R. Aster, B. Borchers, C. Thurber
%
% mout=mcmc(logprior,loglikelihood,generate,logproposal,m0,niter)
%
%  logprior           Name of a function that computes the log of
%                     the prior distribution.
%  loglikelihood      Name of a function the computes the log of
%                     the likelihood.
%  generate           Name of a function that generates a random
%                     model from the current model using the
%                     proposal distribution.
%  logproposal        Name of a function that computes the log of
%                     the proposal distribution r(x,y).
%  m0                 Initial model.
%  niter              Number of iterations to perform.
%
%  mout               MCMC samples.
%  mMAP               Best model found in the MCMC simulation.
%  accrate            Acceptance rate
%

function [mout, mMAP, accrate] = mcmc( logprior,loglikelihood, logproposal, generate, m0, niter)
%
%  Figure out some size information.
%
global xtrue;
global x;
n = size(m0);

%
% Allocate space for the results.
%
mout = zeros(8, niter);
%
% Initialize the starting point.
%
mout(:, 1) = m0;
current = m0;
lMAP = -Inf;

mMAP = current;
nacc = 0;
%
% The main loop.
%
for k = 2:niter
    %disp("nacc");
    %disp(nacc);
    %
    % Generate a candidate model from the previous model.
    %
    candidate = feval(generate, current);
    %
    % Evalate the logarithm of the acceptance ratio.
    %
    lpcandidate = feval(logprior, candidate);
    %disp("lpcandidate");
    %disp(lpcandidate);
    llcandidate = feval(loglikelihood, candidate);
    %disp("llcandidate");
    %disp(llcandidate);
    lr1 = feval(logproposal, candidate, current);
    %disp("lr1");
    %disp(lr1);
    lr2 = feval(logproposal, current, candidate);
    %disp("lr2");
    %disp(lr2);
    lpcurrent = feval(logprior, current);
    %disp("lpcurrent");
    %disp(lpcurrent);
    llcurrent = feval(loglikelihood, current);
    %disp("llcurrent");
    %disp(llcurrent);
    logalpha =  llcandidate + lpcandidate + lr1  - llcurrent - lpcurrent -lr2  ;
    %disp("logalpha");
    %disp(logalpha);
   
    

    %
    % Take the minimum of the log(alpha) and 0.
    %
    if (logalpha > 0)
        logalpha = 0;
    end
    %
    % Generate a U(0,1) random number and take its logarithm.
    %
    logt = log(rand());
    %disp("logt");
    %disp(logt);
    %
    % Accept or reject the step.
    % 
    if (logt < logalpha)
        %
        % Accept the step.
        %
        
        current = candidate;
        nacc = nacc + 1;
        
        %
        % Update the MAP solution if this one is better.
        %
        
        if (( llcandidate + lpcandidate) > lMAP)
            lMAP =  llcandidate + lpcandidate;
            
            
            mMAP = candidate;
          

        end
    else
        %
        % Reject the step.
        %
    end
    %
    % Record the result.
    %
    disp(nacc);
    disp(lMAP);
    mout(:, k) = current;
    accrate = nacc / niter;
end