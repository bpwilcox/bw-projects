function [WX, loss, pe, class] = forwardprop(W, x, labs)
  % Performs forward propagation on the neural net defined by W.
  % x is a matrix containing the input vectors
  % labs is a vector of the labels
  % Returns:
  % WX, intermediate computations of weight maps and activation
  % functions.
  % loss = loss function (log likelihood, etc.) on the output nodes
  % pe = percent error (classification error)
  % class = classes (by "one-hot encoding")

  % Get some size parameters.
  % Initialize the cell structure of WX.
  L = size(W, 1);
  WX = cell(size(W));
  N = size(x, 2);

  % 'y' is the input to the linear map at each level;
  % on the first layer, this is the actual inputs.
  y = x;

  % For each layer...
  for l = 1 : L
    % Apply the weight map
    WX{l, 1} = W{l, 1} * y;
    % Apply the activation.  If not on the output layer, add a bias node.
    if l < L
      y = [ones(1, N); actfun(WX{l, 1}, W{l, 2})];
    else
      y = actfun(WX{l, 1}, W{l, 2});
    end

    % Store the results of activation function (for use elsewhere)
    WX{l, 2} = y;
  end
  % Calculate the loss after all is said and done.
  loss = costfun(WX{L, 1}, WX{L, 2}, W{L, 2}, labs);

  % Usual classification procedure with percent error.
  % (class = argmax of net results)
  M = length(labs);
  J = size(WX,1);
  [~, class] = max(WX{J,2}', [], 2);
  pe = 1 - sum(class(:) == labs) / M;
end
