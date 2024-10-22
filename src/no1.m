f = imread('../images/shore.jpg');
figure, imshow(f);
g = [0 -1 0; -1 4 -1; 0 -1 0];

if ndims(f) == 3
    red_channel = f(:,:,1);
    green_channel = f(:,:,2);
    blue_channel = f(:,:,3);
    
    red_result = convolution(double(red_channel), g);
    green_result = convolution(double(green_channel), g);
    blue_result = convolution(double(blue_channel), g);
    
    result = cat(3, uint8(red_result), uint8(green_result), uint8(blue_result));
else
    result = convolution(f, g);
end


figure; imshow(uint8(result));

h = uint8(convn(double(f), double(g)));
figure; imshow(h);