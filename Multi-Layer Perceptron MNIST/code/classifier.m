function [class, pe] = classifier(W, x, labs)
  % Predicts classes of x data, gives percent wrong.
  % W = net model
  % x = input data
  % labs = correct labels
  % Returns
  % class = class predictions
  % pe = percent error

  % Straight up, just run a forward prop...
  [WX, loss] = forwardprop(W, x, labs);
  N = length(labs);
  J = size(WX,1);

  % ...then do a 'one hot' to figure out prediction
  [~, class] = max(WX{J,2}', [], 2);
  pe = 1 - sum(class(:) == labs) / N;
end
