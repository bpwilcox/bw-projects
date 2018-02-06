% x_vec and f_vec must be assigned outside the script
% recall x_vec points not necessarily equi-distant


x_vec =1:length(filt(:,1));
x_vec = x_vec.'/100;
f_vec = filt(:,1);

N = length(x_vec);

fprime_h_vec = zeros(1,N-1);
fprime_h_vec = ( f_vec([2:N]) - f_vec([1:N-1]) )./( x_vec([2:N])-x_vec([1:N-1]) );

xpos_fprime_h_vec = x_vec(find(fprime_h_vec>=0));


xneg_fprime_h_vec =x_vec(find(fprime_h_vec<0));