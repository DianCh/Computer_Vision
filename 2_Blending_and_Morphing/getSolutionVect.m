function solVectorb = getSolutionVect(indexes, source, target, offsetX, offsetY)
%% Enter Your Code Here

% Record the total number of interior pixels of interest
logic = true(size(indexes));
logic = logic & indexes;
N = sum(sum(logic));

% Pre-allocate the b vector
solVectorb = zeros(N, 1);

% Construct a Laplacian kernel
L = [0, -1, 0;
    -1, 4, -1;
    0, -1, 0];

% Get the desired Laplacian map of the source image
sourceL = conv2(source, L, 'same');

% Loop over each pixel in the indexes map
for i = 1 : size(indexes, 1)
    for j = 1 : size(indexes, 2)
        
        % Only pay attention to the indexed pixels
        if (indexes(i, j))
            solVectorb(indexes(i, j)) = sourceL(i - offsetY, j - offsetX);
            % Determine whether the boundary conditions need to be added
            if ~(indexes(i, j - 1))
                solVectorb(indexes(i, j)) = solVectorb(indexes(i, j)) + target(i, j - 1);
            end
            if ~(indexes(i, j + 1))
                solVectorb(indexes(i, j)) = solVectorb(indexes(i, j)) + target(i, j + 1);
            end
            if ~(indexes(i - 1, j))
                solVectorb(indexes(i, j)) = solVectorb(indexes(i, j)) + target(i - 1, j);
            end
            if ~(indexes(i + 1, j))
                solVectorb(indexes(i, j)) = solVectorb(indexes(i, j)) + target(i + 1, j);
            end
        end
    end
end

end
