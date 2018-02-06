function upd = l2upd(W)
  % Returns the gradient of the L2 norm of w

  N = size(W,1);
  upd = cell(N,1);
  
  for i = 1:N
      
  upd{i} = 2 * W{i,1};
  
  end