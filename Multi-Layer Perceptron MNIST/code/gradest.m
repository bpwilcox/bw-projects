% Do the calculations to get a candidate for gradient...
gradestprep;

% Define a perturbation
pert = 1e-3;

% Grab all size parameters, appropriate matrices for testing
% second layer.
L = size(W, 2);
[m, n] = size(W{L, 1});
wx = WX{L, 1};
y = WX{L-1, 2};
w = W{L, 1};
af = W{L, 2};

% For each entry in the weight matrix...
for i = 1 : m
  for j = 1 : n
    % Perturb the weights...
    wxp = wx;
    wxp(i, :) = wxp(i, :) + pert * y(j, :);
    wxm = wx;
    wxm(i, :) = wxm(i, :) - pert * y(j, :);
    wp = w;
    wp(i, j) = wp(i, j) + pert;
    wm = w;
    wm(i, j) = wm(i, j) - pert;
    % ...calculate the resulting loss...
    yp = actfun(wxp, af);
    ym = actfun(wxm, af);
    lp = costfun(wxp, yp, af, labs);
    lm = costfun(wxm, ym, af, labs);
    % ...estimate derivative.
    g{L}(i, j) = (lp - lm) / (2 * pert);
  end
end

% Display the results
disp('Error between grads, layer 2:');
max(abs(g{L} - G{L})(:))

% Glean data to test the first layer.
[m, n] = size(W{1, 1});
wx = WX{1, 1};
y = dats;
af1 = W{1, 2};
af2 = W{2, 2};
w = W{2, 1};

% Repeat the previous process...
for i = 1 : m
  for j = 1 : n
    wxp = wx;
    wxp(i, :) = wxp(i, :) + pert * y(j, :);
    wxm = wx;
    wxm(i, :) = wxm(i, :) - pert * y(j, :);
    yp = [ones(1, N); actfun(wxp, af1)];
    ym = [ones(1, N); actfun(wxm, af1)];
    ap = w * yp;
    am = w * ym;
    yp = actfun(ap, af2);
    ym = actfun(am, af2);
    lp = costfun(ap, yp, af2, labs);
    lm = costfun(am, ym, af2, labs);
    g{1}(i, j) = (lp - lm) / (2 * pert);
  end
end

% Display results.
disp('Error between grads, layer 1:');
max(abs(g{1} - G{1})(:))
