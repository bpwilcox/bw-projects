function W = initw(weight_opts,nin,nout)
  %% Initialize the net model based on certain parameters.
  %% weight_opts contains the sizes of the intermediate layers,
  %%   as well as the types of activation functions used
  %%   and the distribution from which initial weights shall be drawn.
  %% nin = number of input layer values (dimension of input data)
  %% nout = number of potential classes

  % Work the "meta-dimension" into the layer sizes.
  layers = [nin, weight_opts.layers, nout];
  funs = weight_opts.funs;
  distr = weight_opts.distr;

  % If you're using normally distributed weights... go for it
  if strcmp(distr,'randnorm')
    for i=1:length(layers)-1
      if i ~= 1
        W{i,1} = normrnd(0,1/sqrt(layers(i)),layers(i+1),layers(i) + 1);
      else
        W{i,1} = normrnd(0,1/sqrt(layers(i)),layers(i+1),layers(i));
      end
      W{i,2} = funs{i};
      
    end
    % Or initialize to zeros
  elseif strcmp(distr,'zeros')
    for i=1:length(layers)-1
      if i ~= 1
        W{i,1} = zeros(layers(i+1),layers(i) + 1);
      else
        W{i,1} = normrnd(0,1/sqrt(layers(i)),layers(i+1),layers(i));
      end
      W{i,2} = funs{i};
      
    end
    % Or distributed randomly...
  elseif strcmp(distr,'uniform')
    for i=1:length(layers)-1
      if i ~= 1
        W{i,1} = rand(layers(i+1),layers(i) + 1);
      else
        W{i,1} = normrnd(0,1/sqrt(layers(i)),layers(i+1),layers(i));
      end
      W{i,2} = funs{i};      
    end    
  end
end

