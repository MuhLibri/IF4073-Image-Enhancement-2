f = imread('images/butterfly.bmp');
figure, imshow(f);
g = [0 -1 0; -1 4 -1; 0 -1 0];

[img_rows, img_cols] = size(f);
[filter_rows, filter_cols] = size(g);

filter_center = (filter_rows + 1) / 2;

result = zeros(img_rows, img_cols);

for i = 1:img_rows
    for j = 1:img_cols
        if(i - (filter_center - 1) < 0 || j - (filter_center - 1) < 0 || ...
           i + (filter_center - 1) >= img_rows || ...
           j + (filter_center - 1) >= img_cols)
            continue
        end

        window = f(i:i+filter_rows-1, j:j+filter_cols-1);
        
        result(i, j) = sum(sum(double(window) .* double(g)));
    end
end

figure; imshow(uint8(result));

h = uint8(conv2(double(f), double(g)));
figure; imshow(h);