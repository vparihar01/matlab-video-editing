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
%       We first create an array called double_frame that is of size
%       source_fps. This array is made persistent in memory for this
%       function so every successive call can read it. The array is
%       initializer with zeros meaning that no frame has to be doubled. A
%       value of 1 means that the current image is discarded and copied
%       from the previous one.
%       Only if source and target fps do not match we calculate what frames
%       have to be doubled to reach source_fps but with only target_fps
%       unique images. With our algorithm frames that need not to be
%       doubled get equidistantly aligned.
%       Every frame then gets looked up by it's frame number modulo the
%       source_fps in the double_frame array. It then gets either doubled
%       from the previous frame (lookup value is 1) or not (lookup value is
%       0)
%
%   PHYSICAL BACKGROUND:
%       Early movie recording devices were no capable of recording at high
%       frame rates. Early silent movies used framerates ranging from 7 to
%       20 fps while todays hollywood blockbusters are (still) recorded at
%       24 fps. Playback often happens at higher framerates and therefore
%       it's necessary to double frames to reach for example 25/50/60/100/200
%       Hz.
function video = filter_low_framerate(video, source_fps, target_fps)

    % persistant array in memory for this function
    persistent double_frame;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Check if we process the first frame and init filter 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (~isfield(video, 'filter_low_framerate'))
        video.filter_low_framerate.start_frame = video.start_frame;
        % init array once
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
        %double_frame
    else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % do for every frame
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        my_frame_nr = video.frame(1).original_frame_nr;
        dropFlag = double_frame(mod(my_frame_nr-1, source_fps)+1);
        if (dropFlag == 1)
            video.frame(1).filtered = video.frame(2).filtered;
        end
    end
    
end
