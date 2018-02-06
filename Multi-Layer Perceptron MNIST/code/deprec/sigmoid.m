function [sig, wx] = sigmoid(w,xt)

  wx = w' * xt;
  sig = 1 ./ (1+exp(-wx));

end
