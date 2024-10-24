function img = motionBlur(image, length, theta)
    H = fspecial('motion', length, theta);
    img = imfilter(image,H,'circular');
end