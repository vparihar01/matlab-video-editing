% FILTER_UNSHARP(VIDEO, GAUSSIAN_SIZE, GAUSSIAN_STD) changes the sharpness 
% of the current frame video.frame(1). GAUSSIAN_SIZE and GAUSSIAN_STD
% effect the size respectively the standard deviation of the applied
% filter.
%  
%   VIDEO:  a structure containing an array of frames where frame(1)
%   contains the most current frame. 
% 
%   VIDEO = FILTER_UNSHARP(VIDEO, GAUSSIAN_SIZE, GAUSSIAN_STD) returns the original video structure
%   with the updated current video.frame(1).filtered. The unsharpness of the final image can
%   be modified by PARAM1...
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   IMPLEMENTATION:
%       We create a gaussian filter kernel (that we use for convolution)
%       with the command fspecial. The filterSize determines the kernels
%       size whereas sigma is the standard deviation. The current frame is
%       then convoluted with the created filterKernel and written-back to
%       the current frame data.
%
%   PHYSICAL BACKGROUND:
%       If the image plane is not in focus of the optical system things get
%       blurred. The circle of confusion (CoC) is then larger than one
%       pixel. Normally this depends on the distance of an object but we
%       blur the whole image as an approximation. In the early days optical
%       systems were not that accuarate and things like autofocus did not
%       exist so a lot of things were out of focus and blurry.
%
%   RANGE VALUES FOR PARAMETERS:
%       filterSize is the dimension of the filterKernel square matrix and
%       should be odd > 1 to have a nice filterkernel (3, 5, 7 and so on).
%       sigma is the standard deviation an should be a positive value.
function video = filter_unsharp(video, filterSize, sigma)
    filterkernel = fspecial('gaussian', filterSize, sigma);
    video.frame(1).filtered = imfilter(video.frame(1).filtered, filterkernel,'replicate', 'same', 'conv');
end