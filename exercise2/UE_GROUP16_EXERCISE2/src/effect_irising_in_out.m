% EFFECT_IRISING_IN_OUT(VIDEO, TRANSITION_SIZE, MIN_SIZE, MAX_SIZE, DIST_X,
% DIST_Y, PARAM1, ..) applies an irising in / out effect on a sequence of images.
% PARAMS1 should control the beginning and the duration of the effect.
%  
%   VIDEO:  a structure containing an array of frames where frame(1)
%   contains the most current frame. 
% 
%   FADES: settings for controlling the beginning and the duration of
%   the effect. An array, where the start position is held in {1..N}{1},
%   the duration of the effect is stored in {1..N}{2}. There are 'N' 
%   fade outs/ins.
%
%   VIDEO = EFFECT_IRISING_IN_OUT(VIDEO, TRANSITION_SIZE, MIN_SIZE, MAX_SIZE, DIST_X,
%   DIST_Y, FADES) returns the original video structure with the updated current
%   video.frame(1).filtered.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   IMPLEMENTATION:
%       We look in the fades array and if the current frame number falls
%       into the range of a defined fade range we set the boolean flag
%       effectIsRunning to true.
%       Furthermore we determine the start and end frame of the current
%       fade range and calculate the duration of the closing/opening
%       transistion. By using this duration knowledge we calculate the
%       necessary irisStep that is necessary to open/close the iris in each
%       frame through time.
%       We check for everyframe if the flag effectIsRunning is set to true.
%       If the effectIsRunning is set to true we have to distinguish 3
%       cases:
%           1) the iris is closing: we substract irisStep from the
%              current iris_size and call the filter
%           2) the iris is complete closed at halftime: we set the irisSize
%              to 0 to ensure a completly closed iris.
%           3) the iris is opening again: we add irisStep to the current
%              iris_size and call the filter.
%       If the effectIsRunning is set to false we call the iris filter with
%       the default defined values.
%   
%   USE OF THE EFFECT:
%       To make the transition between scenes more exiting,
%       the iris was closed at the end of a scene and then reopened.
% 
function video = effect_irising_in_out(video, transition_size, min_size, max_size, dist_x, dist_y, fades)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % CHECK IF THE FRAMES WE WANT TO WORK ON ARE AVAILABLE IN QUEUE
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (video.frame(1).frame_nr == -1)
        return;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % INITIALIZE THE FILTER AT THE FIRST CALL
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (~isfield(video, 'effect_irising_in_out'))
        video.effect_irising_in_out.iris_size = rand(1) * [max_size - min_size] + min_size;                   % iris size

        for i = 1:numel(fades)
            pos(i)       = fades{i}{1};
            duration(i)  = fades{i}{2};
        end

        video.effect_irising_in_out.pos_start = pos;
        video.effect_irising_in_out.duration  = duration;    
        video.effect_irising_in_out.pos_end   = pos+duration-1;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % GET THE IRISING PARAMETERS FOR THE CURRENT FRAME 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    effectIsRunning = false;
    
    for i = 1:numel(fades)
        if ((video.frame(1).frame_nr >= video.effect_irising_in_out.pos_start(i)) && (video.frame(1).frame_nr <= video.effect_irising_in_out.pos_end(i)))
            effectIsRunning = true;
            % Determine the start and end frames of the effect
            start_nr = video.effect_irising_in_out.pos_start(i);
            end_nr = video.effect_irising_in_out.pos_end(i);
            
            % Determine parameters
            duration = video.effect_irising_in_out.duration(i)/2;
            irisStep = video.effect_irising_in_out.iris_size/duration;
        end 
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % APPLY IRIS FILTER WITH IRISING PARAMETERS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (effectIsRunning)
        % iris is closing
        if ((end_nr - video.frame(1).frame_nr) > round(duration))
            video.effect_irising_in_out.iris_size = video.effect_irising_in_out.iris_size - irisStep;
            video = filter_iris(video, transition_size, video.effect_irising_in_out.iris_size, video.effect_irising_in_out.iris_size, dist_x, dist_y);
        end
        % iris is completly closed at halftime
        if ((end_nr - video.frame(1).frame_nr) == round(duration))
            video = filter_iris(video, transition_size, 0, 0, dist_x, dist_y);
        end
        % iris is opening again
        if ((end_nr - video.frame(1).frame_nr) < round(duration))
            video.effect_irising_in_out.iris_size = video.effect_irising_in_out.iris_size + irisStep;
            video = filter_iris(video, transition_size, video.effect_irising_in_out.iris_size, video.effect_irising_in_out.iris_size, dist_x, dist_y);
        end
    else
        % call the filter with default parameters
        video = filter_iris(video, transition_size, min_size, max_size, dist_x, dist_y);
    end
