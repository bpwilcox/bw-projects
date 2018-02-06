function [E, pe] = precost(wx, labs)
  C = size(wx, 1);
  N = size(wx, 2);

  if C == 1
    y = 1 ./ (1 + exp(-wx));
    E = -(sum(log(y(labs == 1))) + sum(log(1 - y(labs == 2))));
    g = 1 * (wx >= 0) + 2 * (wx < 0);
    pe = 1 - sum(g(:) == labs) / N;
    return;
  else
    wexp = exp(wx);
    wsum = sum(wexp, 1);
    index = sub2ind(size(wx), labs', 1:N);
    wexp = wexp(index);
    y = wexp ./ wsum;
    E = -sum(log(y));
    [~, g] = max(wx', [], 2);
    pe = 1 - sum(g(:) == labs) / N;
  end
