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
%   First we create an alpha map filled with zeros. Then we generate
%   number_of_blobs seed points for the blobs. With the function
%   generate_blob and a random blob size we apply a blob at each seed
%   point to the alpha map. To smooth the eges ot the blob we apply an gaussian filter on the alpha map.
%   Finally we do an alpha blend for each color channel and save the
%   altered image in video.frame(1).filtered.
%   
%   PHYSICAL BACKGROUND:
%   In the late 1940s the cellulose triacetate was introduced to replace
%   the former used nitrate film which was highly flammable.
%
%   How is it caused?
%   When cellulose triacetate film is exposed to moisture, heat or acids a chemical reaction starts and acetic acid is
%   released during the initial acetate base deterioration, leading to the characteristic vinegar odor.
%   Technically "cellulose acetate decomposition" this self-catalyzing degradation of the film backing is 
%   therefore more commonly known as "Vinegar Syndrome".
%   Shrinkage also occurs during this process.
%   As the acetate base shrinks, the gelatin emulsion of the film and the
%   film base separate, because the emulsion is not undergoing
%   deterioration and therefore does not shrink. This causes buckling which is referred
%   to by archivists as 'channelling'.
%   In the advanced stages of deterioration the plastic film base becomes
%   brittle causing it to shatter with the slightest tension.
%   Another sign of advanced degradation is the appearance of crystalline deposits or liquid-filled bubbles on the emulsion.
%   This is caused by plasticizers becoming incompatible with the film base and oozing out on the surface.
%   In some cases, pink or blue colors appear in some sheet films. This is caused by the reaction of antihalation dyes, which are normally colorless, 
%   and the acetic acid.
%     
%   Which movies are effected by these distortions?
%   All movies that are captured on acetate film.
%
%   Can the distortion be avoided? If so, how?
%   Currently there is no practical way of halting or reversing the course of degradation.
%   A combination of low temperature and low relative humidity represents
%   the optimum storage condition for cellulose acetate base films.
%   In practice temperatures of 12°C and a relative humidity of 35% are now being used.
%   An alternative to storing the original movie material is to digitize
%   it.
%
%   Sources: 
%   http://en.wikipedia.org/wiki/Cellulose_acetate_film
%   http://www.videodocproductions.com/home.htm
%
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
    inverted_alpha = ones(size(map,1),size(map,2)) - map;
    video.frame(1).filtered(:,:,1) = inverted_alpha .* video.frame(1).filtered(:,:,1) + map * 1;
    video.frame(1).filtered(:,:,2) = inverted_alpha .* video.frame(1).filtered(:,:,2) + map * 1;
    video.frame(1).filtered(:,:,3) = inverted_alpha .* video.frame(1).filtered(:,:,3) + map * 1;
 
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
            % check if position of the new seedpoint is not outside the alpha map
            if( (seedpoint(1)+direction(1)) < size(map,2) && (seedpoint(2)+direction(2)) < size(map,1) && (seedpoint(1)+direction(1)) > 0 && (seedpoint(2)+direction(2)) > 0)
                ok = 1;
            end;
        end;
        
        seedpoint = seedpoint + direction;
    end;
end

function direction = generate_direction()
    direction = randperm(4);
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