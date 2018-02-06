function delta = actgrad(y, W, delta, type)
  % Calculates the gradient of the activation function for the layer at hand.
  % y = results of the activation function of lower layer
  % W = weight matrix of present layer
  % delta = "slope" of previous (higher) layer
  % type = type of activation function
w =size(W)
d = size(delta)
  % Derivation for sigmoid gradient...
  if or(strcmp(type,'sig'), strcmp(type, 'sigmoid'))
    delta = (y .* (1-y)) .* (W.' * delta);
    % ...and for tanh...
  elseif strcmp(type,'tanh')
    b = 2/3;
    a = 1.7159;
    delta = (a * b) * (1 - (y.*y) / a^2) .* (W.' * delta);
  end
  % Truncate to throw away the bias node (which has no gradient)
  delta = delta(2:end, :);
end

