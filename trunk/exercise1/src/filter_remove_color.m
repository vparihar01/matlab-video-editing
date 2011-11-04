% FILTER_REMOVE_COLOR(VIDEO, MODE) removes the color information of the current
% frame (video.frame(1).filtered). MODE can be either BW (function returns an RGB
% image where only intensity values are considered) or SEPIA ( function returns
% an RGB image transformed into a yellow-brownish image).
%  
%   VIDEO:  a structure containing an array of frames where frame(1)
%   contains the most current frame. 
% 
%   VIDEO = FILTER_REMOVE_COLOR(VIDEO, MODE) returns the original video structure
%   with the updated current video.frame(1).filtered. Each filter takes
%   video.frame(1).filtered as input and writes the result back to this array.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   IMPLEMENTATION:
%       For converting the image into a black and white (grayscale)
%       representation the image is first converted from the (original) RGB
%       colorspace to the HSV (Hue,Saturation,Value) colorspace. In this
%       colorspace a saturation value of 0 means no colorfulness. So we set
%       the staturation value of every color triple to 0 and get a
%       grayscale image. We then convert the image from the HSV colorspace
%       back to RGB colorspace.
%       For converting the image into a sepia colorspace we mutliply each
%       RGB color with a sepia value 3x3 matrix (from the left side)
%       resulting in an RGB triple lying in the "new" sepia colorspace 
%       (still normal RGB representation).
%
%   PHYSICAL BACKGROUND:
%       Sepia-Effect: Processed through a silver sulfide ferrocyanide or uranium ferrocyanide solution
function [video] = filter_remove_color(video, mode)    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Black / White Mode
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (strcmp(mode,'bw'))                
        video.frame(1).filtered = black_white(video.frame(1).filtered);
        return;
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Sepia Mode
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (strcmp(mode,'sepia'))
        video.frame(1).filtered = sepia(video.frame(1).filtered);
        return;
    end

    disp_error('Only ''bw'' and ''sepia'' mode supported!');




    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % REMOVE COLOUR INFORMATION FROM AN RGB IMAGE
    %
    % 1) CONVERT img FROM RGB TO YCbCr COLORSPACE
    % 2) SET CHROMA CHANNELS APPROPRIATELY (NEUTRAL CHROMA CHANNELS)
    % 3) CONVERT IMAGE BACK TO RGB
    % 4) RETURN 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [bw] = black_white(img)
        % convert to HSV
        bw = rgb2hsv(img);
        % we need to remove Saturation S - thats "channel" 2
        bw(:,:,2) = 0;
        % convert it back to RGB
        bw = hsv2rgb(bw);
    end
    %%    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % CONVERT RGB IMAGE TO SEPIA
    %
    % 1) USE SEPIA CONVERSION MATRIX FOR CONVERTING RGB IMAGE img TO SEPIA
    % 2) RETURN CONVERTED IMAGE 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [sepia] = sepia(img)
        % define SepiaValues 3x3 matrix
        values = [0.4 0.769 0.189 ; 0.349 0.686 0.168 ; 0.272 0.534 0.131];
        % get color vectors YxXxRGB
        red = img(:,:,1);
        red = red(:);
        green = img(:,:,2);
        green = green(:);
        blue = img(:,:,3);
        blue = blue(:);
        colors = zeros(3,size(red));
        colors(1,:) = red; 
        colors(2,:) = green; 
        colors(3,:) = blue;
        
        % calculate sepia colors
        temp = values*colors(:,1:size(colors,2));
        
        % get calculated colors back into rgb matrix
        red = temp(1,:);
        green = temp(2,:);
        blue = temp(3,:);
        temp = zeros(size(img,1),size(img,2));

        sepia = zeros(size(img,1),size(img,2),size(img,3));
        temp(:) = red;
        sepia(:,:,1) = temp;
        temp(:) = green;
        sepia(:,:,2) = temp;
        temp(:) = blue;
        sepia(:,:,3) = temp;
    end
end
