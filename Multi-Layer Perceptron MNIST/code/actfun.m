function y = actfun(A, type)
  % Applies the given activation function to the supplied data.
  % A = matrix of inputs to the activation function.
  % type = string defining the activation function type.
  % Returns:
  % y = fcn values after applied to A.

  % You can do softmax...
  if strcmp(type, 'softmax')
    y = exp(A);
    y = y ./ sum(y, 1);

    % ...or sigmoid...
  elseif or(strcmp(type, 'sig'), strcmp(type, 'sigmoid'))
    y = 1 ./ (1 + exp(-A));

    % ...or that special tanh.
  elseif strcmp('tanh',type)
    b = 2/3;
    a = 1.7159;
    y = a*tanh(b*A);
  end
