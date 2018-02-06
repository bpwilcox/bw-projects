function wx = extract(WX, inds)
  L = size(WX, 1);
  wx = cell(size(WX));
  for l = 1 : L
    wx{l, 1} = WX{l, 1}(:, inds);
    wx{l, 2} = WX{l, 2}(:, inds);
  end
