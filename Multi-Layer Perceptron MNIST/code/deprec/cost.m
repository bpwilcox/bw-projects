function [E, pe] = cost(w, x, t)

% w - weight vector: dim [d+1 x k] 
% x - input vector : dim [d+1 x N]
% t - class labels : dim [N x 1]

  k = size(w, 2);
  N = length(t);

  if k == 1
    [y, wx] = sigmoid(w, x);
    E = -(sum(log(y(t == 1))) + sum(log(1 - y(t == 2))));
    g = 1 * (wx >= 0) + 2 * (wx < 0);
    pe = 1 - sum(g(:) == t) / N;
    return;
  else
    
    a = w'*x;
    a_exp = exp(a);
    a_sum = sum(a_exp);
    y = a_exp./a_sum;

    index= sub2ind(size(a),t', 1:length(t));
    E = -sum(log(y(index)));
    [~, g] = max(a', [], 2);
    pe = 1 - sum(g(:) == t) / N;
  end
end
