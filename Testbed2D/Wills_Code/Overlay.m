function [] = Overlay()

% This function will overlay initial positioning data over the realtime
% image.

%Take a picture and convert to binary
vid = videoinput('winvideo', 1, 'RGB24_1280x720');
snapshot = getsnapshot(vid);
grayscaleimage = rgb2gray(snapshot);
binaryimage = im2bw(grayscaleimage, .3);

% Edge detection
BW = edge(binaryimage);

% Height and width of image
[width height] = size(grayscaleimage);

max_circumference = 30;


% % This section will identify circles of the necessary radius for a pin
% % hole
% for x = 1:width
%     for y = 1:height
%         
%         % We've found an edge; let's follow it and keep track of our path
%         if BW(x, y) == 1
%             path_index = 1;
%             initial = [x; y];
%             candidate_path = cell(1);
%             candidate_path{path_index} = initial;
% 
%             found = true;
%             
%             % Initialize
%             next = initial;
% 
%             % Now we'll find a neighbor that is a part of this edge.
%             % If we've been following the path and we've reached an end,
%             % the max_circumference or the initial point, stop.
%             while (((next(1) ~= initial(1) && next(2) ~= initial(2))....
%                     || (path_index) == 1 )  ....
%                     && path_index < max_circumference && found == true)
%             
%                 found = false;
%                 
%                 % Check neighbors
%                 for i = -1:1                
%                     
%                     for j = -1:1
%                         
%                         if found
%                            break; 
%                         end
% 
%                         already_entered = false;
%                         
%                         % search to make sure we didn't already traverse
%                         % this pixel                        
%                         for p = 1:length(candidate_path)
%                             if next(1) + i == candidate_path{p}(1)....
%                                     && next(2) + j == candidate_path{p}(2)
%                                 
%                                 already_entered = true;
%                                 
%                             end
%                         end
% 
%                         if (i ~= 0 || j ~= 0) && next(1) + i > 0 && next(2) + j > 0....
%                             && next(1) + i < width && next(2) + j < height....
%                             && already_entered == false
% 
%                             % OK, We've found a valid neighbor. log it in
%                             % candidate path and keep following the edge
%                             if BW(next(1) + i, next(2) + j) == 1
%                                 next = next + [i; j];
%                                 path_index = path_index + 1;                      
%                                 candidate_path{path_index} = next;
%                                 found = true;
%                             end
%                         end
%                     end
%                 end 
%             end
%              
%             % We've left our loop, so let's check if we're back at our
%             % starting point. If so, it's a pin-hole! In this case,
%             % re-highlight this edge.
%             
%             dist_to_start = sqrt((next(1) - x)^2 + (next(2) - y)^2);
%             
%             if dist_to_start < 2 && path_index < 30 && path_index > 10
%                 for i=1:length(candidate_path)
%                     x_path = candidate_path{i}(1);
%                     y_path = candidate_path{i}(2);
%                     BW(x_path, y_path) = 1;
%                 end
%             else
%                 for i=1:length(candidate_path)
%                     x_path = candidate_path{i}(1);
%                     y_path = candidate_path{i}(2);
%                     BW(x_path, y_path) = 0;
%                 end
%             end
%         end
%     end
% end
% 
% imshow(BW);

% Run hough circles to find pin holes
% Previous good settings were: houghcircle(BW, 4, 14)
[y0detect, x0detect, Accumulator] = houghcircle(BW,4,7);


%%%%%%%%%%%%%%%%%%% NEW SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now we must prune to find correct fixel locations. A hole is a 
% valid fixel location if:
% 1. The fixel location is 1 unit from another fixel location and:
% 2. There exists another fixel location 1 unit from this location, perpendicular to
% the other fixel location vector

% For every candidate fixel location, we slowly expand a circle kernel of radius r
% about the candidate. Once we have engulfed two nearest neighbors, check
% to see if they are the same distance, and perpendicular to each other.

probable_search_radius = 20;

for f = 1:length(x0detect)
    
    nearest_neighbors = 0;
    
    for r = 0:max_search_radius
        
    end
end


% Size of circles to draw
circle_radius = 4;
[width height] = size(grayscaleimage);

%Limits so we don't draw off the image
circle_limit_x = height - circle_radius;
circle_limit_y = width - circle_radius;

% Rotational increment that we will rotate the circles
theta = -pi/1000;
rotation_matrix = [cos(theta) -sin(theta); sin(theta) cos(theta)];

% Amount of acceptable error
epsilon_error = .03;
error = true;

% Dummy initial variables
min_dist = 1000;
min_dist_point_1_index = -1;
min_dist_point_2_index = -1;

% Determine which 2 circles are closest together
    for u = 1:length(x0detect)
        for l = 1:length(x0detect)
            
            if(u ~= l)
            
                x_1 = x0detect(u);
                y_1 = y0detect(u);

                x_2 = x0detect(l);
                y_2 = y0detect(l);

                dist = sqrt((x_2 - x_1)^2 + (y_2 - y_1)^2);
                
                if (dist < min_dist)
                    min_dist_point_1_index = u;
                    min_dist_point_2_index = l;
                    min_dist = dist;
                end
                
            end
        end
    end
       
%     % Rotate until x or y distance between these two circles is close to
%     % zero by epsilon_error 
%     num_rotations = 0;
%     
%     while(error)
%         for j = 1:length(x0detect)
%             vector = [x0detect(j) - width/2; y0detect(j) - height/2];
%             rotated_vector = rotation_matrix*vector;
%             x0detect(j) = rotated_vector(1) + width/2;
%             y0detect(j) = rotated_vector(2) + height/2;
%         end
%        
%         x_error = abs(x0detect(min_dist_point_1_index) - x0detect(min_dist_point_2_index));
%         y_error = abs(y0detect(min_dist_point_1_index) - y0detect(min_dist_point_2_index));
%         
%         if (y_error < epsilon_error || x_error < epsilon_error)
%             error = false;
%         end
%         
%         num_rotations = num_rotations + 1;
%         
%     end
%     
%     % Now that we've rotated the grid to be straight, fill in the missing
%     % gaps.
%     
%     x_error = 17;
%     if abs(y_error) < abs(x_error)
%         interval = abs(x_error);
%     else
%         interval = abs(y_error);
%     end
%     
%      x_start = rem(x0detect(min_dist_point_1_index), interval);
%      y_start = rem(y0detect(min_dist_point_1_index), interval);
%      
%      tot_index = 1;
% 
%      x_num = ((width - x_start)/interval);
%      y_num = ((height - y_start)/interval);
%      
%     for a=x_start:interval:width - x_start
%         for b=y_start:interval:height - y_start
%             x0detect(tot_index) = b;
%             y0detect(tot_index) = a;
%             tot_index = tot_index + 1;
%         end
%     end
%     
%     %Rotate back
%     theta = (num_rotations - 10)*(pi/1000);
%     rotation_matrix = [cos(theta) -sin(theta); sin(theta) cos(theta)];
%     for j = 1:length(x0detect)
%         vector = [x0detect(j) - width/2; y0detect(j) - height/2];
%         rotated_vector = rotation_matrix*vector;
%         x0detect(j) = rotated_vector(1) + width/2;
%         y0detect(j) = rotated_vector(2) + height/2;
%     end
%     
%     % Round back for pixels
%     for o = 1:length(x0detect)
%         x0detect(o) = round(x0detect(o));
%         y0detect(o) = round(y0detect(o));
%     end
%     
% Draw grid
for i=1:length(x0detect)
    if(x0detect(i) > circle_radius...
                && y0detect(i) > circle_radius...
                && x0detect(i) < circle_limit_x...
                && y0detect(i) < circle_limit_y)
            grayscaleimage = MidpointCircle(grayscaleimage, circle_radius, y0detect(i), x0detect(i), 255);
    end
end

imshow(grayscaleimage);



end

