mov = avifile('test4.avi','compression', 'none');
imgCount = size(dir('*.tif'), 1);
figure
for i = 0:imgCount-1
    img = imread([num2str(i) '.tif']);
    imshow(img);
    fr = getframe;
    mov = addframe(mov,fr);
end
mov = close(mov);