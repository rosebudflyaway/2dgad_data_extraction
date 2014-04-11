function newName = formImageName(imageCount, dirname, filename)
if imageCount < 10
    newName = [dirname '\' filename '_0' num2str(imageCount) '.png' ];
else
    newName = [dirname '\' filename '_' num2str(imageCount) '.png' ];
end
end