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
    patch_size = 25;
    patch_cnt = threshold2 * 2;
    
    frameHeight = size(video.frame(1).original,1);
    frameWidth = size(video.frame(1).original,2);
    
    h_range = frameHeight - (patch_size-1);
    w_range = frameWidth - (patch_size-1);
    
    % matrix contains top_left and bottom_right positions of a patch
    patch_pos = zeros(2,2);

   
    % determine patches from image
    for i=1:patch_cnt
        % determine patch positions
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
        patch1 = video.frame(1).original(patch_pos(1,2):patch_pos(2,2),patch_pos(1,1):patch_pos(2,1),:);
                                   
        patch2 = video.frame(2).original(patch_pos(1,2):patch_pos(2,2),patch_pos(1,1):patch_pos(2,1),:);
        
    %%% GENERATE RGB HISTOGRAMS - start
    %%% bestes ergebnis mit effect_scene_cut(video, 0.5, 23)
        % normalize histogram patch1
        [n,xout] = hist(patch1(:),0:0.01:1);
        norm_hist_patch1 = n/sum(n);
        
        % normalize histogram patch2
        [n,xout] = hist(patch2(:),0:0.01:1);
        norm_hist_patch2 = n/sum(n);
    %%% GENERATE RGB HISTOGRAMS - end
        
%     %%% GENERATE EDGE HISTOGRAMS - start
%         h = fspecial('sobel');  % detect horizontal edge
%         h_edges_patch1 = imfilter(patch1,h);
%         v_edges_patch1 = imfilter(patch1,h');
%         h_edges_patch2 = imfilter(patch2,h);
%         v_edges_patch2 = imfilter(patch2,h');
%         
%         % normalize histogram patch1
%         edges_patch1 = sqrt((h_edges_patch1.^2)+(v_edges_patch1.^2));
%         [n,xout] = hist(edges_patch1(:),0:0.01:1);
%         norm_hist_patch1 = n/sum(n);
%         
%         % normalize histogram patch2
%         edges_patch2 = sqrt((h_edges_patch2.^2)+(v_edges_patch2.^2));
%         [n,xout] = hist(edges_patch2(:),0:0.01:1);
%         norm_hist_patch2 = n/sum(n);
%     %%% GENERATE EDGE HISTOGRAMS - end


%     %%% GENERATE EDGE HISTOGRAMS (with dilation) - start
%     %%% recht guter erfolg mit effect_scene_cut(video, 0.4, 13)
%         h = fspecial('sobel');  % detect horizontal edge
%         h_edges_patch1 = imfilter(patch1,h);
%         v_edges_patch1 = imfilter(patch1,h');
%         h_edges_patch2 = imfilter(patch2,h);
%         v_edges_patch2 = imfilter(patch2,h');
%         
%         % normalize histogram patch1
%         edges_patch1 = sqrt((h_edges_patch1.^2)+(v_edges_patch1.^2));
%         se = strel('diamond', 1);
%         edges_dil_patch1 = imdilate(edges_patch1,se);
%         [n,xout] = hist(edges_dil_patch1(:),0:0.01:1);
%         norm_hist_patch1 = n/sum(n);
%         
%         % normalize histogram patch2
%         edges_patch2 = sqrt((h_edges_patch2.^2)+(v_edges_patch2.^2));
%         edges_dil_patch2 = imdilate(edges_patch2,se);
%         [n,xout] = hist(edges_dil_patch2(:),0:0.01:1);
%         norm_hist_patch2 = n/sum(n);
%     %%% GENERATE EDGE HISTOGRAMS (with dilation) - end

    
        % estimate the bhattacharyya co-efficient
        bcoeff = 0;
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