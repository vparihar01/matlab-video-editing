% DISTORTION_SCRATCH(VIDEO, NR_OF_SCRATCHES) adds less or equal
% NR_OF_SCRATCHES black and white vertical scratches to an existing frame
% in VIDEO.FRAME(1).FILTERED.
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
%       generate random values done with matlab function randi
%       - If the given nr_of_scratches is bigger than the max, 
%       set to max_nr_scratches.
%       - set nr_of_scratches to a random value between nr_of_scratches/2 
%       and nr_of_scratches to generate a random number of scratches in every
%       frame
%       - generate random (column)x-positions for scratches and save in pos_scratches vector
%       - generate intensity values for the previous calculated x-positions
%       and save to pos_intensity matrix(first half between 200 and 230
%       second half between 50 and 80)
%       - set range of intensity values from 0 to 1 instead of 1 to 255
%       - normalise intensity values replicate intensity vector of pos_intensity matrix 3 times (for
%       every color component/channel and set intensity values of colums at 
%       x-positions of pos_intensity matrix at the actual frame.
%       - Paramter values: nr_of_scratches is the number of added vertical 
%           scratches to the frames. This number can diversify from
%           0 to the img width, because the film print can hypothetically
%           be in a perfect shape or totally destroyed. We have chosen a
%           max value of 15% of the image width, because otherwise the
%           images won't be recognizeable any more         
%   PHYSICAL BACKGROUND:
%       How is it caused?
%           Black scratches are created during the shoot (perhaps by a dirty 
%           gate) and appear on the negative as white lines. When the positive 
%           print is made (the one you see in the theatre), the white becomes 
%           black. White scratches are created on the print of the film after it
%           has been run through too many dirty projectors and the emulsion is 
%           scratched off.
%        Which movies are effected by these distortions?
%           - Films that are recorded with a camera
%           - Analog films played on (contaminated) projectors
%        Can the distortion be avoided? If so, how?
%           - Clean the gate of the camera perfectly
%           - Clean the projector or to be really sure, only play it once on a
%           projector and make a digital copy to play it more often.

function video = distortion_scratch(video,nr_of_scratches)

    if(video.frame(1).frame_nr == -1)
        return
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Generate a maximum of nr_of_scratches 
    % scratches randomly on the whole image. 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [r c f] = size(video.frame(1).original);
    max_nr_scratches = round(c*0.15);
    if(nr_of_scratches>max_nr_scratches)
        nr_of_scratches=max_nr_scratches;
    end
    
    nr_of_scratches = randi([ceil(nr_of_scratches/2),nr_of_scratches]);
    pos_scratches = randi(c,1,nr_of_scratches);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Generate half of nr_of scratches dark and half of
    % them bright intensities and apply them on the
    % intensity image. 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

    pos_intensity = [pos_scratches; zeros(1,length(pos_scratches))];
    
    cnt = 1;
    length_pos_int = length(pos_scratches);
    length_pos_int_half = floor(length_pos_int/2);
    
    for i = 1:length_pos_int
        if(cnt<=length_pos_int_half)
            pos_intensity(2,i) = randi([200, 230]);
        else
            pos_intensity(2,i) = randi([50, 80]);
        end
        cnt = cnt+1;
    end
    
    pos_intensity(2,:) = pos_intensity(2,:)/255;
    intensity_multi = repmat(pos_intensity(2,:),[r 1 3]);
    
    video.frame(1).filtered(:,pos_intensity(1,:),1:3)=  intensity_multi;
    
    figure(2);
    imshow(video.frame(1).filtered);
    