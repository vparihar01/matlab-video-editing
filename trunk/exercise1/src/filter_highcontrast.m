% FILTER_HIGHCONTRAST(VIDEO, DX, DY) increases the contrast of the current
% frame (video.frame(1).filtered) by moving the intensity values v of the image 
% towards 0 and 1 using a mapping functions f(v).
%  
%   VIDEO:  a structure containing an array of frames where frame(1)
%   contains the most current frame. 
% 
%   DX/DY:  settings for constructing the mapping function f(v) 
%
%   VIDEO = FILTER_HIGHCONTRAST(VIDEO, DX, DY) returns the original video 
%   structure with the updated current video.frame(1).filtered. Each filter
%   takes video.frame(1).filtered as input and writes the result back to this
%   array.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   IMPLEMENTATION:
%       .....
%
%   PHYSICAL BACKGROUND:
%       .....
%
%   RANGE VALUES FOR PARAMETERS:
%       .....
function video = filter_highcontrast(video, dx, dy)
    % create stepfunction (transferfunction) with dx and dy
    
    % convert to HSV colorspace
    img = rgb2hsv(video.frame(1).filtered);
    % map intensity(V=VALUE) values to [0..255]
    img(:,:,3) = img(:,:,3) * 255;
    % map each intensity value with the stepfunction
    
    % convert intensity(HS,V=VALUE) values back again to [0..1]
    img(:,:,3) = img(:,:,3) / 255;
    % convert the image back to RGB colorspace
    video.frame(1).filtered = hsv2rgb(img);
end