function indexes = getIndexes(mask, targetH, targetW, offsetX, offsetY)
%% Enter Your Code Here

% Pre-allocate an array for the indices map
indexes = zeros(targetH, targetW);

% Initializa the index allocator
k = 1;

for i = 1 : size(mask, 1)
    for j = 1 : size(mask, 2)
        if (mask(i, j))
            indexes(i + offsetY, j + offsetX) = k;
            k = k + 1;
        end
    end
end
        
end