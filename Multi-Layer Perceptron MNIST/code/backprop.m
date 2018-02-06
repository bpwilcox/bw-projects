function [G] = backprop(WX, W, x, labs)
  % Does back propagation on the neural net.
  % WX = Intermediate calculations (weighted sums and activation results)
  % W = Neural net model
  % x = input to the net
  % labs = correct labels

  % Size parameters and basic initializes
  L = size(W, 1);
  Npts = size(WX{1, 1}, 2);
  G = cell(size(W, 1), 1);

  % Isolate a vector of activation function names.
  actfuns=cell(L,1);
  for l = 1 : L
    actfuns{l} = W{l, 2};
  end

  % Calculate delta for output layer...
  a = WX{L, 1};
  y = WX{L, 2};
  delta = loglikegrad(y, labs, actfuns{L});

  % For each layer, traversing backwards...
  for l = L : -1 : 1

    % Except for the first layer, "inputs" were the activation results
    % of the previous layer.
    if l > 1
      y = WX{l - 1, 2};
      % For first layer, "inputs" were actual inputs
    else
      y = x;
    end

    % Gradient of weights is outer product of delta and inputs to layer
    % according to derivation
    G{l} = delta * y';

    % Calculate gradient of activation function, delta for next layer.
    if l > 1
      delta = actgrad(y, W{l, 1}, delta, actfuns{l-1, :});
    end
  end
end
