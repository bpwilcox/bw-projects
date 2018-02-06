function valid = validnetdat(W, WX)
  valid = 0;
  if ~validnet(W)
    return;
  end
  N = size(WX{1,1}, 2);
  L = size(WX, 1);
  for l = 1 : L
    if any(size(WX{l, 1}) ~= size(WX{l, 2}))
      error(cstrcat('validnetdat: Internal mismatch, WX, layer ', num2str(l)));
      return;
    elseif size(WX{l, 1}, 2) ~= N
      error(cstrcat('validnetdat: WX wrong num points, layer ', num2str(l)));
      return;
    elseif size(WX{l, 1}, 1) ~= size(W{l, 1}, 1)
      error(cstrcat('validnetdat: Size mismatch, WX to W, layer '))
		    num2str(l);
    end
  end
  valid = 1;
  return;
end
