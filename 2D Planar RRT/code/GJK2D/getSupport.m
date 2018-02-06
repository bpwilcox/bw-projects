function minkD = getSupport(A, B, d)
    minkD = A(getFarthestIdxInDir(A,d),:) - B(getFarthestIdxInDir(B,-d),:);
end