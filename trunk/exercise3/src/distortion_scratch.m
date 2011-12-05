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
%   	.....
%   
%   PHYSICAL BACKGROUND:
%       .....
function video = distortion_scratch(video,nr_of_scratches)


    if(video.frame(1).frame_nr == -1)
        return
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Generate a maximum of nr_of_scratches 
    % scratches randomly on the whole image. 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [r c f] = size(video.frame(1).original);
    pos_scratches = randi(c,1,nr_of_scratches);
%     pos_scratches = [100,200,300,400,500,600]
    
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
            pos_intensity(2,i) = randi([100, 200]);
        else
            pos_intensity(2,i) = randi([0, 20]);
        end
        cnt = cnt+1;
    end
    
%     pos_intensity = [100,200,300,400,500,600;0,5,50,100,200,230]
%     pos_intensity = [100,200,300,400,500,600;0,1,2,100,200,230]
    
pos_intensity
    pos_int_multi = repmat(pos_intensity(2,:),[r 1 3]);
%     size(pos_int_multi)
    
% pos_int_multi(1,1,1)
% pos_int_multi(1,1,2)
% 
% pos_int_multi(1:2,2,1)
% pos_int_multi(1:2,3,1)
% pos_int_multi(1:2,4,1)
% pos_int_multi(1:2,5,1)
% pos_int_multi(1:2,6,1)


    video.frame(1).filtered(:,pos_intensity(1,:),1:3)=  pos_int_multi;

%     video.frame(1).filtered(:,pos_intensity(1,1),1:3)=  pos_int_multi(:,1,:);
%     video.frame(1).filtered(:,pos_intensity(1,2),1:3)=  pos_int_multi(:,2,:);
%     video.frame(1).filtered(:,pos_intensity(1,3),1:3)=  pos_int_multi(:,3,:);
%     video.frame(1).filtered(:,pos_intensity(1,4),1:3)=  pos_int_multi(:,4,:);
%     video.frame(1).filtered(:,pos_intensity(1,5),1:3)=  pos_int_multi(:,5,:);
%     video.frame(1).filtered(:,pos_intensity(1,6),1:3)=  pos_int_multi(:,6,:);
%     video.frame(1).filtered(:,pos_intensity(1,1),1:3)=  50;
%     video.frame(1).filtered(:,pos_intensity(1,2),1:3)=  1;
%     video.frame(1).filtered(:,pos_intensity(1,4),1:3)=  0;
%     video.frame(1).filtered(:,pos_intensity(1,5),1:3)=  100;
%     video.frame(1).filtered(:,pos_intensity(1,6),1:3)=  50;

    