function idx = getFarthestIdxInDir(x, d)
    [~,idx] = max(x*d');
end