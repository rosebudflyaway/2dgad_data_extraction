function [ success ]= extractImageFromVideo(videoName, imageDir)

%% read avi information

videoInfo = aviinfo(videoName);
totalLen = videoInfo.NumFrames;

% if image files are already existing, then exit
imageFiles = dir(imageDir);
if size(imageFiles, 1) == totalLen + 2
    success = true;
    disp('Images have already been extracted, skipped... ');
else
    k = 1;
    while k <= totalLen
        disp(strcat('Extracting frame ', num2str(k), ' ..'));
        try
            mov = aviread(videoName, k);
            tmp = num2str(k);
            strtemp = strcat(imageDir, '/',tmp,'.','tif');
            imwrite(mov.cdata(:,:,:),strtemp,'tif');
            k = k+1;
        catch me
            disp('Error .. Exit extraction');
            break;
        end
    end
    
    if k > totalLen
        success = true;
        disp('done');
    else
        success = false;
        disp('frames followed skipped .. ');
    end
end



end