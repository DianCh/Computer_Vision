function coeffA = getCoefficientMatrix(indexes)
%% Enter Your Code Here

% Record the total number of interior pixels of interest
logic = true(size(indexes));
logic = logic & indexes;
N = sum(sum(logic));

% Pre-allocate the A matrix
coeffA = zeros(N, N);

% Loop over each pixel in the indexes map
for i = 1 : size(indexes, 1)
    for j = 1 : size(indexes, 2)
        
        % Only pay attention to the indexed pixels
        if (indexes(i, j))
            coeffA(indexes(i, j), indexes(i, j)) = 4;
            % Consider its four neighbors
            if (indexes(i, j - 1))
                coeffA(indexes(i, j), indexes(i, j - 1)) = -1;
            end
            if (indexes(i, j + 1))
                coeffA(indexes(i, j), indexes(i, j + 1)) = -1;
            end
            if (indexes(i - 1, j))
                coeffA(indexes(i, j), indexes(i - 1, j)) = -1;
            end
            if (indexes(i + 1, j))
                coeffA(indexes(i, j), indexes(i + 1, j)) = -1;
            end
        end
    end
end

end
