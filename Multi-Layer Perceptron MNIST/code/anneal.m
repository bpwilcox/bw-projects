function etap = anneal(eta, ann, annpar, it)
  % This function returns the "annealed" learning parameter etap (eta prime)
  % eta     = base learning parameter
  % ann     = annealment mode ('exp', 'hyp', or 'none')
  % annpar  = parameter controlling annealment strategy
  % it      = current iteration number

  % hyperbolic annealment
  if strcmp(ann, 'hyp')
    etap = eta / (1 + (it - 1) * annpar);
  % exponential annealment
  elseif strcmp(ann, 'exp')
    etap = eta * annpar^(it - 1);
  % no annealment
  else
    etap = eta;
  end
