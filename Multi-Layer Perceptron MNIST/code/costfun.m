function E = costfun(wx, y, type, labs)
  % Calculates the cost function of the neural net.
  % wx = weighted sums going into the output layer
  % y = results of output layer activations function
  % type = type of activation function
  % labs = data labels

  % So far... only handles softmax activation :)
  if ~strcmp(type, 'softmax')
    return
  else
    % Just sum the logs of the properly labeled softmax values!
    N = size(wx, 2);
    index = sub2ind(size(wx), labs', 1:N);
    E = -sum(log(y(index)));
  end
  
