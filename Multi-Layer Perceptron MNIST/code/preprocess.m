function [tri, tsi] = preprocess(tri, tsi)
  % Subtract mean from training and testing data.
  tri = tri - mean(tri, 2);
  tsi = tsi - mean(tsi, 2);
