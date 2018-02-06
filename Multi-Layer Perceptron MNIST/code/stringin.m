function rv = stringin(str, strlist)
  % Just want to check if 'str' is an element of 'strlist'
  rv = 0;
  N = size(strlist, 2);
  for i = 1 : N
    if strcmp(str, deblank(strlist(i, :)))
      rv = 1;
      return;
    end
  end
  return;
end
