


function [A, ytrue, xtrue,x] = baartm_mcmc(n)
    % BAART Test problem: Fredholm integral equation of the first kind.
    % This function has been extended to include Gaussian noise in b,
    % predict x using the noisy b, and plot x before and after adding noise.

    % Check if n is even
    if rem(n,2) ~= 0
        error('The order n must be even');
    end

   
    % Generate the matrix A
    hs = pi / (2 * n);
    ht = pi / n;
    c = 1 / (3 * sqrt(2));
    A = zeros(n, n);
    x = (0:n)' * hs;
    n1 = n + 1;
    nh = n / 2;
    
    f3 = exp(x(2:n1)) - exp(x(1:n));
    for j = 1:n
        f1 = f3;
        co2 = cos((j - 0.5) * ht);
        co3 = cos(j * ht);
        f2 = (exp(x(2:n1) * co2) - exp(x(1:n) * co2)) / co2;
        if j == nh
            f3 = hs * ones(n, 1);
        else
            f3 = (exp(x(2:n1) * co3) - exp(x(1:n) * co3)) / co3;
        end
        A(:, j) = c * (f1 + 4 * f2 + f3);
    end

    % Generate the right-hand side b
    si = (0.5:0.5:n)' * hs;
    si = sinh(si) ./ si;
    ytrue = zeros(n, 1);
    ytrue(1) = 1 + 4 * si(1) + si(2);
    ytrue(2:n) = si(2:2:2*n-2) + 4 * si(3:2:2*n-1) + si(4:2:2*n);
    ytrue = ytrue * sqrt(hs) / 3;
  

    % Generate the solution x
    xtrue = -diff(cos((0:n)' * ht)) / sqrt(ht);

    disp(x(2:9));
    disp(xtrue);
    disp(ytrue);

    subplot(3,3,1);
    plot(x(2:9) , xtrue);
    title("input (solution)")

    subplot(3,3,2);
    plot(x(2:9)  , ytrue);
    title("output (data)")


end


