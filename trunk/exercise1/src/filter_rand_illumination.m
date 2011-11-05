% FILTER_RAND_ILLUMINATION(VIDEO, MIN_BRIGHTNESS, MAX_BRIGHTNESS) varies the
% illumination of the most current frame and returns a random illuminated
% frame of a video structure.
%  
%   VIDEO:  a structure containing an array of frames where frame(1)
%   contains the most current frame. 
% 
%   VIDEO = FILTER_RAND_ILLUMINATION(VIDEO, MIN_BRIGHTNESS, MAX_BRIGHTNESS) returns
%   the original video structure with the updated current video.frame(1).filtered.
%   Each filter takes video.frame(1).filtered as input and write the result back to this array.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   IMPLEMENTATION:
%       First a random luma_factor value between min_brightness and
%       max_brightness is calculated. The image is converted into the HSV
%       colorspace in which VALUE represents the brightness of a color. We
%       now dampen the colors brightness by multiplying each colors VALUE
%       value by the luma_factor. This way the whole image is made darker
%       by the random luma_factor. After that we convert the image back to
%       the RGB colorspace.
%
%   PHYSICAL BACKGROUND:
%       The "darker" appearance of films in the 20s is
%       caused by less ellaborated lightening technics and light sources
%       they used as well by the fact that the monochromatic film stock 
%       was less sensitive on the incoming light rays than nowadays.
%
%   RANGE VALUES FOR PARAMETERS:
%       Values for min_brightness and may_brighness can range from 0.0 to
%       1.0 but max_brightness has to be larger then min_brightness.
% 
function video = filter_rand_illumination(video, min_brightness, max_brightness)
    % Generate a random value luma_factor
    luma_factor = min_brightness + (max_brightness - min_brightness) * rand(1);
    
    % convert image to HSV color space
    img = rgb2hsv(video.frame(1).filtered);
    
    % Multiply each color channel with this luma_factor.
    % As we want to change the brightness I would suggest changing the
    % VALUE of the HSV color space
    img(:,:,3) = img(:,:,3) * luma_factor;
    
    % convert image back to RGB color space
    video.frame(1).filtered = hsv2rgb(img);
    
end