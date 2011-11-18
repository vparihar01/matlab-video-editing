% EFFECT_ADD_TEXT(VIDEO, TEXT) adds additional images to the input image list. 
% This can be used for adding images with text description of the next scene.
% 
%   VIDEO:  a structure containing an array of frames where frame(1)
%           contains the most current frame. 
%
%   TEXT:   is a cell array containing 3 entires. The
%           i-th cell array has the format:
%
%     text{i}{1} = Name of image file containing the scene text
%
%     text{i}{2} = Number of the input file where we want to add the additional
%                  images. e.g. 1 -> text images are inserted before the 
%                  first input image
%
%     text{i}{3} = Duration of the text scene. 
%
%
% Example:
%     >> effect_add_text(video, {{'../text/scene_text1.png', 1, 5}});
%
%     adds the image in file '../text/scene_text1.png' before input image 1
%     and displays it for 5 frames. 
%
%     Original image order (Ix is the x-th input frame):
%
%       I1, I2, I3, I4, .... 
%
%     New image order (Tx is the image added for the x-th text insertion):
%
%       T1, T1, T1, T1, T1, I1, I2, I3, I4, ...
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   
%   IMPLEMENTATION:
%       .....
%   
%   USE OF THE EFFECT:
%       Early films were produced without sound, so they inserted frames
%       with text to substitute spoken dialogs or additional information
%       (f.i. scene numbers)
%
function video = effect_add_text(video, text)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get positions/durations of text scenes
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    posDur = zeros(length(text),2);
    
    for i=1:size(text,2)
        cellCache = text(1,i);
        posDur(i,1) = cellCache{1}{2};
        posDur(i,2) = cellCache{1}{3};
    end
    
    %sort ascending regarding to the position of frame
    posDur = sortrows(posDur);  
    
    %delete frames where frame number is bigger than original frameNumber
    noFr = length(video.input_files);
    [row, col] = find(posDur(:,1)>noFr);
    
    posDur = posDur(1:(row-1),:)
   
%%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Insert entries into video.input_files array
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%   Insert Frames in correct order
    posInput = 0;
    cachePosInput = 0;
    for j=1:size(posDur,1)
        inputStruct = struct('name',{},'frame_nr',{});
        cnt2=0;
        while(cnt2<posDur(j,2))
            inputStruct(cnt2+1).name = text{j}{1};
            inputStruct(cnt2+1).frame_nr = posDur(j,1)+cnt2;
            cnt2 = cnt2+1;
        end
            
        posInput = posDur(j,1)+cachePosInput;
        cachePosInput = posDur(j,2);
        
        video.input_files = insertField(video.input_files,posInput,inputStruct);  
        
    end
    
        %% Testoutput

    for iTest= 1:length(video.input_files)
        iTest
        frame = video.input_files(iTest).name
    end
    %     blub = length(video.input_files)
    
    %% insert struct array into struct array 
    function [output_struct] = insertField(input_struct, pos, fillin_struct)
        output_struct = input_struct;
        lengthFill = length(fillin_struct);
        lengthFillin = length(fillin_struct);
        lengthInput = length(input_struct);
        outputLength =  lengthFill+lengthInput;
        output_struct((pos+lengthFill):(outputLength)) = input_struct(pos:lengthInput);
        output_struct(pos:(pos+lengthFillin-1)) = fillin_struct;
    end
end
