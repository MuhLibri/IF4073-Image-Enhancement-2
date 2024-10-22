function img = convolution(image, filter)
    [img_rows, img_cols] = size(image);
    [filter_rows, filter_cols] = size(filter);
    
    filter_center = (filter_rows + 1) / 2;
    
    img = zeros(img_rows, img_cols);
    
    for i = 1:img_rows
        for j = 1:img_cols
            if(i - (filter_center - 1) < 0 || j - (filter_center - 1) < 0 || ...
               i + (filter_center - 1) >= img_rows || ...
               j + (filter_center - 1) >= img_cols)
                continue
            end
    
            window = image(i:i+filter_rows-1, j:j+filter_cols-1);
            
            img(i, j) = sum(sum(double(window) .* double(filter)));
        end
    end
end