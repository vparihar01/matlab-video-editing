% DISTORTION_VINEGAR(VIDEO, NR_OF_BLOBS) adds nr_of_blobs white randomly
% growing regions to an existing frame in VIDEO.FRAME(1).FILTERED. 
%  
%   VIDEO:  a structure containing an array of frames where frame(1)
%   contains the most current frame. 
%
%   VIDEO = DISTORTION_SCRATCH(VIDEO, NR_OF_SCRATCHES) returns the original video structure
%   with the updated current video.frame(1).filtered.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   IMPLEMENTATION:
%       .....
%   
%   PHYSICAL BACKGROUND:
%       .....
function video = distortion_vinegar(video, number_of_blobs, max_blob_size)

    if(video.frame(1).frame_nr == -1)
        return
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Generate alpha map 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    map = zeros(size(video.frame(1).filtered,1),size(video.frame(1).filtered,2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Generate the seed points of the regions randomly
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %generate seed points
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    seedpoint_x = randperm(size(map,2));
    seedpoint_x = seedpoint_x(1:number_of_blobs);
    seedpoint_y = randperm(size(map,1));
    seedpoint_y = seedpoint_y(1:number_of_blobs);
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %generate a new blob
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:number_of_blobs
        blob_size = randperm(max_blob_size);
        map = generate_blob(map, seedpoint_x(i), seedpoint_y(i), blob_size(1));
    end;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Apply unsharpen filter on alhpa map
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    map = imfilter(map,fspecial('gaussian'),'replicate','same');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Alpha-Blending between alpha map and 'white' image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % video.frame(1).filtered = (1-alpha) * video.frame(1).filtered + alpha * 1
    video.frame(1).filtered(:,:,1) = (ones(size(map,1),size(map,2))-map) .* video.frame(1).filtered(:,:,1) + map * 1;
    video.frame(1).filtered(:,:,2) = (ones(size(map,1),size(map,2))-map) .* video.frame(1).filtered(:,:,2) + map * 1;
    video.frame(1).filtered(:,:,3) = (ones(size(map,1),size(map,2))-map) .* video.frame(1).filtered(:,:,3) + map * 1;
 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function for generating a new blob
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function map = generate_blob(map, x, y, blob_size)
    seedpoint = [x,y];
    
    for i=1:blob_size
        ok = 0;
        map(seedpoint(2),seedpoint(1)) = 1;

        while ok == 0
            direction = generate_direction();
            if( (seedpoint(1)+direction(1)) < size(map,2) && (seedpoint(2)+direction(2)) < size(map,1) && (seedpoint(1)+direction(1)) > 0 && (seedpoint(2)+direction(2)) > 0)
                ok = 1;
            end;
        end;
        
        seedpoint = seedpoint + direction;
    end;
end

function direction = generate_direction()
    direction = randperm(4);%round(mod(rand*100,3));
    if( direction(1) == 1 )
        direction = [-1,0];
    elseif( direction(1) == 2 )
        direction = [1,0];
    elseif( direction(1) == 3 )
        direction = [0,1];
    else
        direction = [0,-1];
    end;
end