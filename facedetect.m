


video_obj = VideoReader('mockup1.wmv');

N_frames = video_obj.NumberOfFrames     ;
width_   = video_obj.Width              ;
height_  = video_obj.Height   ;

movie_data(1:N_frames) = struct('gray',zeros(height_,width_,'uint8'),'colormap',[]);


for index = 1 : N_frames
movie_data(index).gray = rgb2gray(read(video_obj,index));
end


BW1 = im2bw(movie_data(1).gray,0.6);


figure('units','normalized','outerposition',[0 0 1 1])
subplot(2,2,1)
imshow(movie_data(1).gray)


subplot(2,2,2)
imshow(BW1)








% video = videoinpit('winvideo',1)
% video = videoinput('winvideo',1)
% preview(video)
% aa =snapshot(video)
% aa = getsnapshot(video)
% imshow (aa)
% get(video)
% BW = im2bw(aa,1);
% imshow(BW)
% imshow(0.5)
% BW = im2bw(aa,1);
% BW = im2bw(aa,0.5);
% imshow(0.5)
% imshow(BW)
% BW = im2bw(aa,0.1);
% imshow(BW)
% BW = im2bw(aa,0.8);
% imshow(BW)
% BW = im2bw(aa,0.9);
% imshow(BW)