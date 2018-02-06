function isFree = gjk2Darray(x, y)
    isFree = 1;
    for j = 1:length(y)
        for i = 1:length(x)
            if gjk2D(x{i}, y{j})
                isFree = 0;
                return;
            end
        end
    end
end