function upd = loggradopt(wx, dat, labs)
  % Returns gradient for logistic regression/SoftMax given:
  % w    : Current estimate of weight vectors (d x C, C is number of classes)
  % k    : The class weight vector we're gradient-ing
  % dat  : Training data vectors (d x N)
  % labs : Ground truth training data labels (1 x N)

  C = size(wx, 1);
  N = size(wx, 2);
  if C > 1
    wexp = exp(wx);
    wsum = sum(wexp, 1);
    y = wexp ./ wsum;
  else
    wexp = exp(-wx);
    y = 1 ./ (1 + wexp);
  end  
  t = (labs == (1:C));
  y = y';

  upd = dat * (y - t);
