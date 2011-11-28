% EFFECT_SOFT_FOCUS(VIDEO, BLUR_FACTOR, FOCUS) applies a soft focus
% effect on a sequence of images beginning with START_FRAME. The sequence lasts
% DURATION seconds. The strongest blur filter is applied to the START_FRAME of a sequence and decreases with 
% each following frame. After DURATION frames the blur stops. BLUR_FACTOR
% determines the 'strongness' of the blur at START_FRAME.
%
%   VIDEO:  a structure containing an array of frames where frame(1)
%   contains the most current frame. 
% 
%   BLUR_FACTOR: parameter determines the 'strongness' of the blur at
%   START_FRAME
%
%   FOCUS: contains the start position of each blur and the duration of the blur effect until
%   the blur effect vanishes.
%
%   VIDEO = EFFECT_SOFT_FOCUS(VIDEO, BLUR_FACTOR, FOCUS) returns the original video structure
%   with a blur filter applied to video.frame(X).filtered. A circular averaging filter kernel 
%   (fspecial('disk',..) is used for the blur operation.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   IMPLEMENTATION:
%       Look if the frame number of the current frame is between pos_start and
%       pos_end of video.effect_soft_focus. video.effect_soft_focus
%       contains the information of sets of frames which are going to get
%       blurred. If the current frame number lies between pos_start and
%       pos_end the blur factor for this frame is calculated by
%       interpolating between pos_start and pos_end. 
%       The calculated blur factor is used as the radius of a
%       disk-filterkernel which is applied on the frame.
%       The blur factor decreases towards pos_end.
%  
%   USE OF THE EFFECT:
%       Used to draw attention to certain points in the film. (to enhance
%       romantic or dreamy scenes)
%
function video = effect_soft_focus(video, blur_factor, focus)


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % INITIALIZ FILTER AT FIRST CALL
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (~isfield(video, 'effect_soft_focus'))

        for i = 1:numel(focus)
            pos(i)       = focus{i}{1};         
            duration(i)  = focus{i}{2}; 
        end

        video.effect_soft_focus.pos_start = pos;
        video.effect_soft_focus.duration  = duration;    
        video.effect_soft_focus.pos_end   = pos+duration-1;
        video.effect_soft_focus.focus_idx = 1;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % CHECK IF THE CURRENT FRAME IS PROCESSED BY THIS EFFECT 
    % (frame(x).frame_nr between pos(i) and pos(i)+duration(i)-1)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    index = video.effect_soft_focus.focus_idx;
    
    if( index > numel(focus) )
        return;
    end
    
    pos_start = video.effect_soft_focus.pos_start(index);
    pos_end = video.effect_soft_focus.pos_end(index);
    
    if( (video.frame(1).frame_nr >= pos_start) && ...
        (video.frame(1).frame_nr <= pos_end) )
        
        if( video.frame(1).frame_nr == pos_end )
            video.effect_soft_focus.focus_idx = video.effect_soft_focus.focus_idx + 1;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % GET THE FRAME DEPENDENT FOCUS PARAMETERS FOR THE BLUR FILTER
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % linear interpolation
        %y = y0 + ((x-x0)*y1 - (x-x0)*y0)/(x1-x0);
        if( pos_end > pos_start )
            frame_blur = blur_factor + (video.frame(1).frame_nr-pos_start) * ((0 - blur_factor)/((pos_end+1) - pos_start));
        else
            frame_blur = blur_factor;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % APPLY CIRCULAR AVERAGE FILTER WITH CHANGING RADIUS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%% video = filter_unsharp(video, [17 17], frame_blur);
        filterkernel = fspecial('disk', frame_blur);
        video.frame(1).filtered = imfilter(video.frame(1).filtered, filterkernel,'replicate', 'same', 'conv');

    end  
 end

    