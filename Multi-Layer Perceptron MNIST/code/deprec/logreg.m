function [w, out] = logreg(p)
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

  % Enforce default parameters
  p = logregdefs(p);
  % Ascertain size of training set
  N = size(p.tri, 2);
  % Organize stop conditions for the iterative process
  stpmin = [p.trmin, p.tsmin, p.homin, p.delwmin, -p.maxit, -p.esi, p.trdelmin];
  
  % Initialize a bunch of iterative process data.
  it = 1;
  w = p.winit;
  C = size(w, 2);
  delw = zeros(size(w));
  repits = floor(linspace(0, N, p.reprate + 1));
  stpdat = inf(size(stpmin));
  trc = [];
  tre = [];
  esits = -inf;
  if ~isempty(p.tsi)
    tsc = [];
    tse = [];
    Nt = length(p.tsl);
  end
  if ~isempty(p.hoi)
    hoc = [];
    hoe = [];
    Nh = length(p.hol);
  end

  %% wx = w' * p.tri;
  %% trcost = precost(wx, p.trl);
  x = p.tri;
  [wx, loss] = forwardprop(w, p.tri, p.trl);

  if p.shuffle
    shuffle = randperm(N);
  else
    shuffle = 1 : N;
  end

  % Run grad descent operations until you hit a stop condition!
  while all(stpdat > stpmin)
    eta = anneal(p.eta, p.ann, p.annpar, it);
    % Previous w...
    pw = w;
    % If we are going to record data within each run through training set
    for i = 1:p.reprate
      % Take data for this training slice.
      inds = (repits(i) + 1) : repits(i + 1);
      inds = shuffle(inds);
      tdat = p.tri(:, inds);
      tlabs = p.trl(inds);
      [curw, curwx] = extract(w, wx, inds);

      % Add in the gradient term.
      %% upd = - 1 / N * eta * loggrad(w, k, tdat, tlabs);
      grad = backprop(curwx, curw, tdat, tlabs);
      % Add in regularization termsn
      if p.l1 ~= 0
	if i == 1
	  l1u = l1upd(w);
	end
        grad = celladd(grad, l1u, 1, -p.l1);
      end
      if p.l2 ~= 0
	if i == 1
	  l2u = l2upd(w);
	end
	grad = celladd(grad, l2u, 1, -p.l2);
      end
      % Add in momentum term
      if p.mom ~= 0
	grad = celladd(grad, delw, 1, p.mom);
        upd = upd + p.mom * delw;
      end
      w = w + delw;
    end

    wx = w' * p.tri;
    % Calculate current cost and change in cost
    regcost = (p.l1 * sum(abs(w(:))) + p.l2 * w(:)' * w(:)) / N;
    pvcost = trcost;
    [trcost, trcerr] = precost(wx, p.trl);
    trcost = trcost / N + regcost;
    dlcost = (trcost - pvcost) / pvcost;
    % Record in 'trc'
    trc = [trc, trcost];
    tre = [tre, trcerr];
    % Calculate stop condition markers
    % If we have holdout data, calculate and record current cost
    if ~isempty(p.hoi)
      [hocost, hocerr] = cost(w, p.hoi, p.hol);
      hocost = hocost / Nh + regcost;
      hoc = [hoc, hocost];
      hoe = [hoe, hocerr];
    else
      hocost = 1;
    end
    % If we have test data, calculate and record current cost
    if ~isempty(p.tsi)
      [tscost, tscerr] = cost(w, p.tsi, p.tsl);
      tscost = tscost / Nt + regcost;
      tsc = [tsc, tscost];
      tse = [tse, tscerr];
    else
      tscost = 1;
    end
    % This is "consecutive it's with no improvement"
    if p.esi > 0
      if dlcost > 0
	esits = esits + 1;
      else
	esits = 0;
      end
    end
    % Calculate relative change in weight vector size(s)
    if p.delwmin > 0
      delwit = norm(w - pw, 'fro') / norm(w, 'fro');
    else
      delwit = 1;
    end
    % Finalize stop parameters and increase iteration count!
    % trcost;
    stpdat = [trcost, tscost, hocost, delwit, -it, -esits, abs(dlcost)];
    it = it + 1;
    if p.shuffle
      shuffle = randperm(N);
    end    
  end

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
