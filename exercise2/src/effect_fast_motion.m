% EFFECT_FAST_MOTION(VIDEO, DROP_FRAMES) applies a fast motion effect on
% a sequence of images. The array DROP_FRAMES stores the beginning of
% the effect in {i}{1}, the number of frames used before the effect in {i}{2}
% and the number of frames used after the effect in {i}{3}. The effect
% drops {i}{2}-{i}{3} frames randomly. The effect is applied 'i' times.
% The array posFrames stores the positions of original frames (value=0) and
% the inserted text frames
%  
%   VIDEO:  a structure containing an array of frames where frame(1)
%   contains the most current frame. 
% 
%   EFFECT_FAST_MOTION(VIDEO, DROP_FRAMES, posFrames) returns the original video
%   structure with the current video.frame(1).filtered.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   IMPLEMENTATION:
%       1. find indices of the original frames(not text frames)
%       2. for loop, for all the relevant elements in drop_frames
%       2.1 create a new array dropFrames with all elements from drop_frame, 
%           where the position is smaller or equal than the original frame 
%           sequence.
%       2.2 take the indices from the original image sequence (regarding to 
%           begin and duration from dropFrames) save it into array 
%           'indPartOrig' and save the number of frames, which should be 
%           deleted, in variable 'noDelFrames'
%       2.3 call the function 'delFrames' to find (noDelFrames) indices  
%          in the array  'indPartOrig' and return array 'delete' 
%          (repectively 'outputDrop') 
%       3. delete the frames with the indices (created before in the loop)
%           from the video.input_files struct
%   
%   USE OF THE EFFECT:
%       To shorten long lasting and therefore often boring scenes, the film
%       makers cuted out some frames. Even nowadays it is still in use 
%       (time laps), for example to show cloud movements of a whole day or
%       even longer period.
%
function video = effect_fast_motion(video, drop_frames, posFrames)

%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Generate a list of all input frames we want to remove
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    % find original (not text) frames in video.input_files
    indFramesOrig = find(posFrames<1);
    noOrigF = length(indFramesOrig);
    
%     for test=1:length( video.input_files)
%         video.input_files(test).name
%     end
    
    %create cell array with frames to drop, whose position is in the range
    %of original frames
    vectorDrop = [];
    cntDrop = 1; 
    delete = [];
    for i=1:length(drop_frames)
        if(drop_frames{i}{1}<noOrigF)
            dropFrames{cntDrop}= drop_frames{i};
            begin = dropFrames{cntDrop}{1};
            dur = dropFrames{cntDrop}{2};
            noDelFrames = dur-dropFrames{cntDrop}{3};
            cntDrop = cntDrop+1;
%           find frames to drop
%           create array of indices to delete from
            indPartOrig = indFramesOrig(begin:(begin+dur-1));
            delete = [delFrames(indPartOrig, noDelFrames),delete]
        end
    end   

%%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %  Remove frames from input list
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    video.input_files(delete)=[];

    for test=1:length(video.input_files)
        video.input_files(test).name
    end
    
    %% Method for finding indices of frames to drop
%   input: 
%           indFrPart: part of the indices array of the original frame
%                       sequence
%           nrDrop: number of frames (elements) of indFrPart to delete
%   output:
%           outputDrop: array with indices to delete from original frame
%           sequence
    function outputDrop = delFrames(indFrPart, nrDrop)
        outputDrop = [];
        cntDropDown = nrDrop;
%         indFrPart
%         cntOutputDrop = 1;
        while(cntDropDown>0)
            cacheDrop = randi([1,length(indFrPart)]);
            outputDrop(end+1) = indFrPart(cacheDrop);
            indFrPart(cacheDrop)=[];
            cntDropDown = cntDropDown-1;
        end
    end


end               