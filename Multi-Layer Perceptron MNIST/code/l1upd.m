function upd = l1upd(W)
  % Returns the gradient of the L1 norm of w

  N= size(W,1);
  upd = cell(N,1);
  
  for i=1:N
        
  upd{i} = (W{i,1} > 0) - (W{i,1} < 0);
  
  end