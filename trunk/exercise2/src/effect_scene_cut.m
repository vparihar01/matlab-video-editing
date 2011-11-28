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

    % we need at least two frames
    if( numel(video.frame(2).original) == 0 )
        return;
    end

    patch_diff_cnt = 0; % number of patches whose bhattacharyya coefficient exceeds threshold1
    patch_size = 15;
    patch_cnt = threshold2 * 2;
    
    frameHeight = size(video.frame(1).original,1);
    frameWidth = size(video.frame(1).original,2);
    
    h_range = frameHeight - (patch_size-1);
    w_range = frameWidth - (patch_size-1);
    
    % matrix contains top_left and bottom_right positions of the patches
%%%    patch_positions = zeros(2,2,patch_cnt);
    patch_pos = zeros(2,2);

    % matrices for patches of previous and current frame
%%%    patches1 = zeros(patch_size,patch_size,3,patch_cnt);    % patches of current frame
%%%    patches2 = zeros(patch_size,patch_size,3,patch_cnt);    % patches of previous frame
    
    % determine patches from image
    for i=1:patch_cnt
        % determine patch positions
%%%        patch_positions(1,1,i) = floor(w_range * rand );  % x1 
%%%        patch_positions(1,2,i) = floor(h_range * rand );  % y1
%%%        patch_positions(1,1,i) = patch_positions(1,1,i) + patch_size-1;  % x2
%%%        patch_positions(2,2,i) = patch_positions(1,2,i) + patch_size-1;  % y2
        patch_pos(1,1) = floor(w_range * rand );  % x1 
        patch_pos(1,2) = floor(h_range * rand );  % y1
        if(patch_pos(1,1) < 1)
            patch_pos(1,1) = 1;
        end
        if(patch_pos(1,2) < 1)
            patch_pos(1,2) = 1;
        end
        patch_pos(2,1) = patch_pos(1,1) + patch_size-1;  % x2
        patch_pos(2,2) = patch_pos(1,2) + patch_size-1;  % y2 
        
        
        % get patches
%%%        patches1(:,:,:,i) = video.frame(1).original(patch_positions(1,1,i):patch_positions(2,1,i), ...
%%%                                                    patch_positions(1,2,i):patch_positions(2,2,i), :);
                                                
%%%        patches2(:,:,:,i) = video.frame(2).original(patch_positions(1,1,i):patch_positions(2,1,i), ...
%%%                                                    patch_positions(1,2,i):patch_positions(2,2,i), :);
                                                
%%%        patch1 = patches1(:,:,:,i);
%%%        patch2 = patches2(:,:,:,i);
        
        patch1 = video.frame(1).original(patch_pos(1,2):patch_pos(2,2),patch_pos(1,1):patch_pos(2,1),:);
                                   
        patch2 = video.frame(2).original(patch_pos(1,2):patch_pos(2,2),patch_pos(1,1):patch_pos(2,1),:);
                                                
        % normalize histogram patch1
        [n,xout] = hist(patch1(:),0:0.01:1);
        norm_hist_patch1 = n/sum(n);
        
        % normalize histogram patch2
        [n,xout] = hist(patch2(:),0:0.01:1);
        norm_hist_patch2 = n/sum(n);
        
        
        bins = numel(n);
    
        % estimate the bhattacharyya co-efficient
        bcoeff = 0;
 %%%       for j=1:bins
 %%%           bcoeff = bcoeff + sqrt(norm_hist_patch1(j) * norm_hist_patch2(j));
 %%%       end
    
        temp = norm_hist_patch1 .* norm_hist_patch2;
        temp = sqrt(temp);
        bcoeff = sum(temp);
        
        % get the distance between the two distributions as follows
        bdist = sqrt(1 - bcoeff);
        
        if bdist > threshold1
            patch_diff_cnt = patch_diff_cnt + 1;
        end
        
    end
    
    if patch_diff_cnt > threshold2
        video.frame(1).scene = video.frame(2).scene + 1;
    else
        video.frame(1).scene = video.frame(2).scene;
    end

% GET THE HISTOGRAM FOR EACH PART AND NORMALIZE IT
% CALCULATE THE BHATTACHARYYA DISTANCE AND COMPARE IT WITH threshold1

end