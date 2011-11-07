% FILTER_IRIS(VIDEO, PARAM1, ..) achieves an iris effect by overlaying an alpha mask 
% on the current frame video.frame(1). The size of the iris can be defined by using
% appropriate parameters.
%  
%   VIDEO:  a structure containing an array of frames where frame(1)
%   contains the most current frame.
%
%   TRANSITION_SIZE:  distance in pixels between iris size and end of
%   transition effect.
%
%   MIN_SIZE:  minimal iris size (percentage of image width).
%
%   MAX_SIZE:  maximal iris size (percentage of image width).
%
%   DIST_X:  horizontal distance in pixels between iris and image center.
%
%   DIST_Y:  vertical distance in pixels between iris and image center.
% 
%   VIDEO = FILTER_UNSHARP(VIDEO, PARAM1, ...) returns the original video structure
%   with the updated current video.frame(1).filtered. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   IMPLEMENTATION:
%       1) Calculate the distance map and max. distance from the iris
%       center
%       2) Choose (randomly) a value between min_size and max_size for the
%       iris size (diameter) relative to the frame width, calculate the
%       value for the radius, calculate the radius of the clearly viewed
%       area
%       3) Calculate the brightness map, the values between the
%       clearView_size and the iris_size are calculated with linear
%       interpolation. 
%       4) Multiply the color channels with thew brightness map
%
%   PHYSICAL BACKGROUND:
%       Iris effect (in films) is caused by an (iris-) aperture.
%       The aperture of an optical system is the opening that determines 
%       the cone angle of a bundle of rays that come to a focus in the 
%       image plane.
%
%   RANGE VALUES FOR PARAMETERS:
%       trans_size <= iris_size
%       -imgwidth/2 < dist_x < +imgwidth/2
%       -imgheight/2 < dist y < +imgheight/2
%       min_size >= 0
%       max_size <= 1
%       max_size > min_size
% 
function video = filter_iris(video, transition_size, min_size, max_size, dist_x, dist_y);   
    % create a distance map, with distances from the center of the iris
    [dist_map,maxDist] = distance_map(size(video.frame(1).filtered,1),size(video.frame(1).filtered,2), dist_x, dist_y);
    
    % calculate distances from iris center to the start and end of the transition area
    iris_size = 0;    
    while (iris_size < min_size || iris_size > max_size)
        iris_size = rand;
    end
    
    iris_pixelRadius = (iris_size * size(dist_map,2))/2;
    clearViewDist = iris_pixelRadius - transition_size;
    
    % create a brightness map
    bri_map = brightness_map(dist_map, (iris_pixelRadius/maxDist), (clearViewDist/maxDist));
   
    % apply brightness map to frame
    video.frame(1).filtered(:,:,1) = video.frame(1).filtered(:,:,1) .* bri_map;
    video.frame(1).filtered(:,:,2) = video.frame(1).filtered(:,:,2) .* bri_map;
    video.frame(1).filtered(:,:,3) = video.frame(1).filtered(:,:,3) .* bri_map;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % CREATE A DISTANCE MAP
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [map, maxDist] = distance_map(height, width, dist_x, dist_y)
        map = zeros(height,width);
        map((height/2)+dist_y,(width/2)+dist_x) = 1;
        dist = bwdist(map);
        maxDist = max(dist(:));
        map = dist/maxDist;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % CREATE A BRIGHTNESS MAP
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [map] = brightness_map(dist_map, iris_size, clearView_size)

        white = (dist_map <= clearView_size);
        map = (dist_map <= iris_size) - white;
        indices = find(map > 0);
        temp = (-1/(iris_size-clearView_size));
        
        for j=1:size(indices)
            map(indices(j)) = 1 + temp*(dist_map(indices(j))-clearView_size);
        end
        
        map = map + white;
    end
    
end