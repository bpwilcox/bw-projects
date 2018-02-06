function [w, out] = netreg(p)
  % Expected (or defaulted) fields of 'params'
  % tri = training images (d x N, data in columns)
  % trl = training labels
  % eta = learning parameter (def=0.1)
  % l1  = L1-penalty parameter (def=0)
  % l2  = L2-penalty parameter (def=0)
  % hoi = hold out images (d x N_h) (def=[])
  % hol = hold out labels           (def=[])
  % tsi, tsl = test images and labels (d x N_t) (def=[], [])
  % reprate = Reporting rate (integer, reports per epoch) (def=1)
  % winit = initial guess for weight vector (def=0)
  % maxit = maximum number of iterations    (def=16)
  % ann = Learning parameter annealment strategy ('exp', 'hyp', 'none')
  %       (def='none')
  % annpar = parameter for annealment strategy (def=0)
  % mom = momentum parameter (def=0)
  % esi = 'Early Stopping iterations,' consecutive it's with no improvement
  %       (def=3)


  %% ======================================================== %%
  %% ======================================================== %%

hocost= Inf;


  % Initialize some timing stuff.
  tic;
  ft = 0;
  bt = 0;
  mt = 0;

  % Enforce default parameters
  p = netregdefs(p);

  % Organize stop conditions for the iterative process
  stpmin = [p.trmin, p.tsmin, p.homin, -p.maxit, -p.esi, p.trdelmin];
  
  %% Initialize a bunch of iterative process data.
  N = size(p.tri, 2);  % Number of training examples
  it = 1;	       % Iteration number
  w = p.winit;	       % Initial net model
  L = size(w, 1);      % Number of layers
  C = size(w{L, 1}, 2);		% Number of classes
  delw = {};			% change in weights (for momentum)
  stpdat = inf(size(stpmin));	% Stop conditions
  trc = [];			% Array to record training cost and error
  tre = [];
  esits = -inf;			% Useless iteration counts
  mhc = inf;			% Min appropriate value of holdout cost
  mhe = inf;			% " " " " " classification error


  % If we are using batchsizes, make a shuffle
  if p.batchsize < N
    shuffle = randperm(N);
  end

  % If we are going to look at test and holdout data, initialize their
  % arrays
  if ~isempty(p.tsi)
    tsc = [];
    tse = [];
    Nt = length(p.tsl);
  end
  if ~isempty(p.hoi)
    hoc = [];
    hoe = [];
    Nh = length(p.hol);
    if p.batchsize < N
      hofreq = round(Nh / p.batchsize);
    else
      hofreq = 1;
    end
  end

  %% Run grad descent operations until you hit a stop condition!
  while all(stpdat > stpmin)
    eta = anneal(p.eta, p.ann, p.annpar, it);
    %% If we are using batches, select the images to be used
    %% for this batch.
    if p.batchsize < N
      inds = shuffle(1 : p.batchsize);
      tdat = p.tri(:, inds);
      tlabs = p.trl(inds);
      %% Else, use all training data!
    else
      tdat = p.tri;
      tlabs = p.trl;
    end
    %% Do a forwardprop for this iteration
    t = toc;
    [curwx, trcost, trcerr] = forwardprop(w, tdat, tlabs);
    ft = ft + (toc - t);

    %% Do a backprop to calculate the gradient.
    t = toc;
    upd = backprop(curwx, w, tdat, tlabs);
    bt = bt + (toc - t);

    %% Add in regularization terms
    if p.l1 ~= 0
      l1u = l1upd(w);
      for l = 1 : L
	upd{l} = upd{l} + p.l1 * l1u{l} / p.batchsize;
      end
    end
    if p.l2 ~= 0
      l2u = l2upd(w);
      for l = 1 : L
	upd{l} = upd{l} + p.l2 * l2u{l} / p.batchsize;
      end
    end

    %% Normalize and scale the update by the learning parameter.
    for l = 1 : L
      upd{l} = -1 / p.batchsize * eta * upd{l};
    end

    %% Add in momentum term
    if p.mom ~= 0
      if ~isempty(delw)
	t = toc;
	for l = 1 : L
	  upd{l} = upd{l} + p.mom * delw{l};
	end
	mt = mt + (toc - t);
      end
    end

    %% Record change (for future momentum)
    delw = upd;

    %% Add in the update!
    t = toc;
    for l = 1 : L
      w{l, 1} = w{l, 1} + upd{l};
    end
    mt = mt + (toc - t);

    %% Calculate current cost
    trcost = trcost / N;
    %% Calculate relative change in cost
    if it > 1
      dlcost = (trcost - pvcost) / pvcost;
    else
      dlcost = -1;
    end
    pvcost = trcost;      
    %% Record in 'trc'
    trc = [trc, trcost];
    tre = [tre, trcerr];

    %% Calculate stop condition markers
    %% If we have holdout data...
    if ~isempty(p.hoi)
      %% (Only activate every so often -- calculations are expensive)
      if mod(it, hofreq) == 1
	% 
	if it > 1
	  pvcost = hocost;
	end

	% Calculate cost and class err on holdout data
	t = toc;
	[~, hocost, hocerr] = forwardprop(w, p.hoi, p.hol);
	ft = ft + (toc - t);

	% Check to see if we actually got better... if not,
	% count this as a useless iteration.
	hocost = hocost / Nh;
	% 'mhc' and 'mhe' are running minima of cost and error.
	% If either of them is unimproved after several iterations,
	% we terminate.
	if or(hocost > mhc * (1 - p.hodelmin), hocerr > mhe * (1 - p.hodelmin))
	  esits = esits + 1;
	else
	  esits = 0;
	end
	if hocost < mhc * (1 - p.hodelmin)
	  mhc = hocost;
	end
	if hocerr < mhe * (1 - p.hodelmin)
	  mhe = hocerr;
	end

	% Append results to our record arrays...
	hoc = [hoc, hocost];
	hoe = [hoe, hocerr];
	%% if it > 1
	%%   dlcost = (hocost - pvcost) / pvcost;
	%% else
	%%   dlcost = -1;
	%% end
	%% %% This is "consecutive it's with no improvement"
	%% if p.esi > 0
	%%   if dlcost > -p.hodelmin
	%%     esits = esits + 1;
	%%   else
	%%     esits = 0;
	%%   end
	%% end
      end
    else
      hocost = 1;
    end
    %% If we have test data, calculate and record current cost
    if ~isempty(p.tsi)
      [~, tscost, tscerr] = forwardprop(w, p.tsi, p.tsl);
      tscost = tscost / Nt;
      tsc = [tsc, tscost];
      tse = [tse, tscerr];
    else
      tscost = 1;
    end

    % Finalize stop parameters and increase iteration count!
    % trcost;
    stpdat = [trcost, tscost, hocost, -it, -esits, abs(dlcost)];
    it = it + 1;

    % If we're using batches, get a new shuffle.
    if p.batchsize < N
      shuffle = randperm(N);
    end    
  end

  stpdat > stpmin;

  % Store our results in the 'out' structure.
  if ~isempty(p.tsi)
    out.tsc = tsc;
    out.tse = tse;
  end
  if ~isempty(p.hoi)
    out.hoc = hoc;
    out.hoe = hoe;
  end
  out.trc = trc;
  out.tre = tre;
  out.it = it - 1;
  out.ft = ft;
  out.bt = bt;
  out.mt = mt;
  out.tt = toc;
