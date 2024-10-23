function img = convolution(image, filter)
    if ndims(image) == 3
        red_channel = image(:,:,1);
        green_channel = image(:,:,2);
        blue_channel = image(:,:,3);
        
        red_result = slidingWindow(double(red_channel), filter);
        green_result = slidingWindow(double(green_channel), filter);
        blue_result = slidingWindow(double(blue_channel), filter);
        
        img = cat(3, uint8(red_result), uint8(green_result), uint8(blue_result));
    else
        img = slidingWindow(image, filter);
    end
end

function img = slidingWindow(image, filter)
    [img_rows, img_cols] = size(image);
    [filter_rows, filter_cols] = size(filter);

    filter_center = (filter_rows + 1) / 2;
    
    img = zeros(img_rows, img_cols);
    
    for i = 1:img_rows
        for j = 1:img_cols
            if(i - (filter_center - 1) < 1 || j - (filter_center - 1) < 1 || ...
               i + (filter_center - 1) > img_rows || ...
               j + (filter_center - 1) > img_cols)
                img(i, j) = image(i,j);
            else
                window = image(i-(filter_center - 1):i+(filter_center - 1), j-(filter_center - 1):j+(filter_center - 1));
                
                img(i, j) = sum(sum(double(window) .* double(filter)));
            end
            
        end
    end
end