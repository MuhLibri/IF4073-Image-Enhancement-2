function img = convolution(image, filter)
    [img_rows, img_cols, img_dims] = size(image);
    [filter_rows, filter_cols] = size(filter);

    filter_center = (filter_rows + 1) / 2;
    
    img = zeros(img_rows, img_cols);
    for i = 1:img_rows
        for j = 1:img_cols
            for k = 1:img_dims
                if(i - (filter_center - 1) < 1 || j - (filter_center - 1) < 1 || ...
                   i + (filter_center - 1) > img_rows || ...
                   j + (filter_center - 1) > img_cols)
                    img(i, j, k) = image(i,j, k);
                else
                    window = image(i-(filter_center - 1):i+(filter_center - 1), j-(filter_center - 1):j+(filter_center - 1), k);
                    
                    img(i, j, k) = sum(sum(double(window) .* double(filter)));
                end
            end
        end
    end
end