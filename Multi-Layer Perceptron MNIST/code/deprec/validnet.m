function valid = validnet(W)
  valid = 0;
  ACTFUNS = ['softmax'; 'sigmoid'; 'sig'; 'tanh'];
  L = size(W, 1);
  for l = 1 : (L-1)
    if size(W{l, 1}, 1) ~= size(W{l + 1, 1}, 2)
      error(cstrcat('validnet: Size mismatch layer', num2str(l)));
      return;
    elseif ~stringin(W{l, 2}, ACTFUNS)
      error(cstrcat('validnet: Bad act. fcn -- ', W{l, 2}));
      return;
    end
  end

  valid = 1;
end
