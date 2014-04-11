function [ pixel_location, x_axis_vector ] = Find_Actuator_Sticker()
% This function will accept an image, and determine the position of the
% actuator sticker in the image

%Take a picture and convert to binary
vid = videoinput('winvideo', 1, 'RGB24_1280x720');
snapshot = getsnapshot(vid);
grayscaleimage = rgb2gray(snapshot);

%Add contrast here
%grayscaleimage = imadjust(grayscaleimage, stretchlim(grayscaleimage), [0 1])
%grayscaleimage = imadjust(grayscaleimage,[.3 .7], []);

%imshow(grayscaleimage);

binaryimage = im2bw(grayscaleimage, .3);

% Edge detection
BW = edge(binaryimage);

imshow(BW)

% %Radius of actuator circle = 18 pixels
% circle_radius = 18;
% confidence = 35;
% 
% %%radius of object circle = 18 pixels
% % circle_radius = 17;
% % confidence = 20;
% % 
% % Height and width of image
% [width height] = size(grayscaleimage);
% 
% %Limits so we don't draw off the image
% circle_limit_x = height - circle_radius;
% circle_limit_y = width - circle_radius;
% 
% [y0detect, x0detect, Accumulator] = houghcircle(BW,circle_radius,confidence);
% 
% for i=1:length(x0detect)
%     if(x0detect(i) > circle_radius...
%                 && y0detect(i) > circle_radius...
%                 && x0detect(i) < circle_limit_x...
%                 && y0detect(i) < circle_limit_y)
%             grayscaleimage = MidpointCircle(grayscaleimage, circle_radius, y0detect(i), x0detect(i), 255);
%     end
% end
% 
% % Orientation is the vector from [718, 85] to [578, 692] in the current
% % setup
% 
% hold on
% 
% pixel_location = [x0detect(1); y0detect(1)];
% actuator_path_terminal = [578; 692];
% 
% x_axis_vector = pixel_location - actuator_path_terminal;
% 
% imshow(grayscaleimage);
% 
% plot([actuator_path_terminal(1), pixel_location(1)], [actuator_path_terminal(2), pixel_location(2)], 'Color', 'r', 'LineWidth', 2);
% 
% rectangle()







end

