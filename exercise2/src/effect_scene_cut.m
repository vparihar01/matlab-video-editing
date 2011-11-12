% EFFECT_SCENE_CUT(VIDEO) splittes up the video in existing scenes. If a
% new scene is detected, video.frame(1).scene is increased by one. A
% new scene is detected by comparing histograms of parts of an image with
% the corresponding area in the next frame.
%  
%   VIDEO:  a structure containing an array of frames where frame(1)
%   contains the most current frame. 
%
%   THRESHOLD 1:  This parameter indicates the threshold for the
%   Bhattacharyya coefficient.
%
%   THRESHOLD 2:  This threshold decides how many histograms of the parts of
%   an image should change a lot.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   IMPLEMENTATION:
%       .....
%    
function video = effect_scene_cut(video, threshold1, threshold2)

