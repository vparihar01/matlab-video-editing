% function out = getFrames(filename)
function getFrames(filename)

%% read in video
video = VideoReader(filename);


%% get all Frames of video and save in videoframes
% array for storing first 30 Frames 
% A = cell(30,1);

%number of Frames in video
numberFrames = video.NumberOfFrames;
numberFrames = 30;
begin = 300;
ending = 350;
vidHeight = video.Height
vidWidth = video.Width

% Preallocate movie structure.
mov(begin:ending) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),'colormap', []);

% Read one frame at a time.
cnt = 1;
for k = begin : ending
    mov(cnt).cdata = read(video, k);
%     imshow(mov(cnt).cdata);
    imwrite(mov(cnt).cdata,['D:/VA_SVN/exercise1/images2_2/TestIMG_',num2str(k),'.png'],'png')
%     saveas(gcf,['D:/VVAoutput/TestIMG_',num2str(k)],'png')
%     pause
    cnt = cnt + 1;
end

out=mov.cdata;
% Size a figure based on the video's width and height.
% hf = figure;
% set(hf, 'position', [150 150 vidWidth vidHeight])

% Play back the movie once at the video's frame rate.
% movie(hf, mov, 1, video.FrameRate);    