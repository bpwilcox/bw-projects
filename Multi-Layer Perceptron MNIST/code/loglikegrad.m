function delta = loglikegrad(y, labs, actfun)
  %% Calculate the gradient of the loglikelihood at the end
  %% y = activation results of last layer
  %% labs = correct labels of data
  %% actfun = activation function type for last layer
  
  actfun = deblank(actfun);
  % Right now... only using softmax at end.
  if or(strcmp(actfun,'soft'), strcmp(actfun, 'softmax'))
    % Calculate the gradient according to derivation.
    N = size(y, 2);
    index = sub2ind(size(y), labs', 1:N);
    C = size(y, 1);
    t = (labs == (1 : C))';
    delta = y - t;    
    return;
  end
