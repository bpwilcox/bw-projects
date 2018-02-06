function opars = logregdefs(params)

  opars = params;
  d = size(params.tri, 1);
  if ~isfield(params, 'eta')
    opars.eta = 0.1;
  end
  if ~isfield(params, 'l1')
    opars.l1 = 0;
  end
  if ~isfield(params, 'l2')
    opars.l2 = 0;
  end
  if ~isfield(params, 'hoi')
    opars.hoi = [];
    opars.hol = [];
    opars.homin = -1;
  elseif ~isfield(params, 'homin')
    opars.homin = 0.01;      
  end
  if ~isfield(params, 'tsi')
    opars.tsi = [];
    opars.tsl = [];
    opars.tsmin = -1;
  elseif ~isfield(params, 'tsmin')
    opars.tsmin = 0.01;
  end
  if ~isfield(params, 'reprate')
    opars.reprate = 1;
  end
  if ~isfield(params, 'winit')
    if ~isfield(params, 'ncl')
      opars.ncl = max(params.trl);
    end
    if opars.ncl == 2
      opars.winit = zeros(d, 1);
    else
      opars.winit = zeros(d, opars.ncl);
    end
  else
    opars.ncl = size(params.winit, 2);
  end
  if ~isfield(params, 'maxit')
    opars.maxit = 16;
  end
  if ~isfield(params, 'ann')
    opars.ann = 'none';
  end
  if ~isfield(params, 'annpar')
    opars.annpar = 0;
  end
  if ~isfield(params, 'mom')
    opars.mom = 0;
  end
  if ~isfield(params, 'esi')
    opars.esi = inf;
  end
  if ~isfield(params, 'delwmin')
    opars.delwmin = -1;
  end
  if ~isfield(params, 'trmin')
    opars.trmin = -1;
  end
  if ~isfield(params, 'trdelmin')
    opars.trdelmin = -1;
  end
  if ~isfield(params, 'shuffle')
    opars.shuffle = 0;
  end
