% FILTER_LOW_FRAMERATE(VIDEO, SOURCE_FRAMERATE, TARGET_FRAMERATE) is a time based
% filter which changes the framerate from SOURCE_FRAMERATE to TARGET_FRAMERATE.
%  
%   VIDEO:  a structure containing an array of frames where frame(1)
%   contains the most current frame.
%
%   VIDEO = FILTER_LOW_FRAMERATE(VIDEO, SOURCE_FRAMERATE, TARGET_FRAMERATE)
%   returns the original video structure with the updated current video.frame(1).filtered. 
% 
% Example:
%   VIDEO = FILTER_LOW_FRAMERATE(VIDEO, 25, 19) returns in total 25 frames per second
%   but only 19 different ones. 6 frames are randomly replaced by their forerunners. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   IMPLEMENTATION:
%       .....
%
%   PHYSICAL BACKGROUND:
%       .....
function video = filter_low_framerate(video, source_fps, target_fps)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Check if we process the first frame and init filter 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (~isfield(video, 'filter_low_framerate'))
        video.filter_low_framerate.start_frame = video.start_frame;
        % init filter once
        double_frame = zeros(1, source_fps);
        % if framerates do not match
        if (source_fps ~= target_fps)
            % double frames with this mask
            double_frame(:) = 1;
            distance = source_fps/target_fps;
            j = distance;
            for (i=1:source_fps)
                % decide what frames to not to double
                if (i==floor(j))
                    double_frame(i) = 0;
                    j = j + distance;
                end
            end
        end
        % show me the array
        double_frame
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % do for every frame 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

end