function makeplots(iters,out,titlep,filename)

figure

plot(iters,1-out.tre)
hold on
if isfield(out,'tse') 
    plot(iters,1-out.tse)
   
end

xlabel('iterations')
ylabel('percent correct')
title(titlep)
legend('training','test','Location','Best')

saveas(gcf,filename,'jpg')




end