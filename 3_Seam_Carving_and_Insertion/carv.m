% File Name: carv.m
% Author: Dian Chen
% Date: 10/22/2017

function [Ic, T] = carv(I, nr, nc)
% Input:
%   I is the image being resized
%   [nr, nc] is the numbers of rows and columns to remove.
% 
% Output: 
% Ic is the resized image
% T is the transport map

% Write Your Code Here

% Flag to determine to generate a video or not
generateAVideo = true;
%generateAVideo = false;

% Pre-allocate space for later use
% We're going to filling in T(r, c) (zero indexing) with the minimum cost
% needed to arrive at size (N - r, M - c). And fill in repository(r, c)
% with the resulting image.
T = zeros(nr + 1, nc + 1);
repository = cell(nr + 1, nc + 1);

% Initialize the start point and image repository
T(1, 1) = 0;
repository{1, 1} = I;

% Create a frame buffer to store the carved frames and write a video
buffer = cell(2 * (nr + nc) + 1, 1);

% Create a white canvas
canvas = uint8(ones(size(I)) * 255);

% Create a route map to store the path of carve process, as well as a
% repository for images with carve indicator on them
route = zeros(nr + 1, nc + 1, 2);
indicators = cell(nr + 1, nc + 1);

% route(i, j, :) stores the 2D indices of the predecessor of this entry
route(1, :, 1) = 1;
route(:, 1, 2) = 1;
indicators{1, 1} = I;

% Populate values for the "horizontal seam" only column (the first column)
for i = 1 : nr
    
    eng = genEngMap(repository{i, 1});
    
    [My, Tby] = cumMinEngHor(eng);
    
    [repository{i + 1, 1}, E] = rmHorSeam(repository{i, 1}, My, Tby);
    
    T(i + 1, 1) = T(i, 1) + E;
    
    route(i + 1, 1, 1) = i;
    indicators{i + 1, 1} = genSeamEffectHor(repository{i, 1}, My, Tby);
end

% Populate values for the "vertical seam" only row (the first row)
for j = 1 : nc
    
    eng = genEngMap(repository{1, j});
    
    [Mx, Tbx] = cumMinEngVer(eng);
    
    [repository{1, j + 1}, E] = rmVerSeam(repository{1, j}, Mx, Tbx);
    
    T(1, j + 1) = T(1, j) + E;
    
    route(1, j + 1, 2) = j;
    indicators{1, j + 1} = genSeamEffectVer(repository{1, j}, Mx, Tbx);
end

% Perform dynamic programming on the way of searching
for i = 2 : nr + 1
    for j = 2 : nc + 1
        
        % Compute two possible way of getting (i, j)
        % From (i - 1, j), then move one more horizontal seam
        eng_1 = genEngMap(repository{i - 1, j});
        [My, Tby] = cumMinEngHor(eng_1);
        [img_1, E_1] = rmHorSeam(repository{i - 1, j}, My, Tby);
        cum_1 = T(i - 1, j) + E_1;
        
        % From (i, j - 1), then move one more vertical seam
        eng_2 = genEngMap(repository{i, j - 1});
        [Mx, Tbx] = cumMinEngVer(eng_2);
        [img_2, E_2] = rmVerSeam(repository{i, j - 1}, Mx, Tbx);
        cum_2 = T(i, j - 1) + E_2;
        
        % Determine which way to choose based on the cumulative cost
        if cum_1 < cum_2
            T(i, j) = cum_1;
            repository{i, j} = img_1;
            
            route(i, j, 1) = i - 1;
            route(i, j, 2) = j;
            indicators{i, j} = genSeamEffectHor(repository{i - 1, j}, My, Tby);
        else
            T(i, j) = cum_2;
            repository{i, j} = img_2;
            
            route(i, j, 1) = i;
            route(i, j, 2) = j - 1;
            indicators{i, j} = genSeamEffectVer(repository{i, j - 1}, Mx, Tbx);
        end
    end
end

% The carved image
Ic = repository{nr + 1, nc + 1};

if generateAVideo
    
    % Trace back the route to visit repositories and write a video
    tracer_i = nr + 1;
    tracer_j = nc + 1;
    k = 1;

    while ~(tracer_i == 1 && tracer_j == 1)
        carved = repository{tracer_i, tracer_j};
        indicated = indicators{tracer_i, tracer_j};

        carvedN = size(carved, 1);
        carvedM = size(carved, 2);
        indicatedN = size(indicated, 1);
        indicatedM = size(indicated, 2);

        canvas(1:carvedN, 1:carvedM, :) = carved;
        buffer{k, 1} = canvas;

        canvas = uint8(255 - canvas * 0);
        canvas(1:indicatedN, 1:indicatedM, :) = indicated;
        buffer{k + 1, 1} = canvas;

        canvas = uint8(255 - canvas * 0);

        tracer = route(tracer_i, tracer_j, :);
        tracer_i = tracer(1);
        tracer_j = tracer(2);
        k = k + 2;

    end

    canvas(1:size(I, 1), 1:size(I, 2), :) = I;
    buffer{2 * (nr + nc) + 1, 1} = canvas;
    buffer{2 * (nr + nc) + 2, 1} = canvas;

    fname = 'carving_sequence.avi';

    try
        % VideoWriter based video creation
        h_avi = VideoWriter(fname, 'Uncompressed AVI');
        h_avi.FrameRate = 4;
        h_avi.open();
    catch
        % Fallback deprecated avifile based video creation
        h_avi = avifile(fname,'fps',4);
    end

    for k = 2 * (nr + nc) + 2 : -1 : 1
        imagesc(buffer{k, 1});
        axis image;
        axis off;
        drawnow;
        try
            % VideoWriter based video creation
            h_avi.writeVideo(getframe(gcf));
        catch
            % Fallback deprecated avifile based video creation
            h_avi = addframe(h_avi, getframe(gcf));
        end
    end
    
    try
        % VideoWriter based video creation
        h_avi.close();
    catch
        % Fallback deprecated avifile based video creation
        h_avi = close(h_avi);
    end
    clear h_avi;
    
end

end

