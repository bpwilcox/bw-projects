function upd = loggrad(w, k, dat, labs)
  % Returns gradient for logistic regression/SoftMax given:
  % w    : Current estimate of weight vectors (d x C, C is number of classes)
  % k    : The class weight vector we're gradient-ing
  % dat  : Training data vectors (d x N)
  % labs : Ground truth training data labels (1 x N)

  C = size(w, 2);
  wx = exp(w' * dat);
  if C > 1
    wsum = sum(wx, 1);
    y = wx(k, :) ./ wsum;
  else
    y = sigmoid(w, dat);
  end  
  t = (labs == k);
  y = y(:);
  t = t(:);

  upd = dat * (y - t);
