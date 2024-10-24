function img = meanFilters(image, filter_dim, type, q)
    if ~(strcmp(type, 'arithmetic') || strcmp(type, 'geometric') || strcmp(type, 'harmonic') || strcmp(type, 'contraharmonic'))
        error('Invalid filter type. Supported types are: ideal, gaussian, butterworth.');
    end

    if nargin < 4
        q = 0;
    end

    [img_rows, img_cols] = size(image);

    filter_center = (filter_dim + 1) / 2;
    
    img = zeros(img_rows, img_cols);
    
    for i = 1:img_rows
        for j = 1:img_cols
            if(i - (filter_center - 1) < 1 || j - (filter_center - 1) < 1 || ...
               i + (filter_center - 1) > img_rows || ...
               j + (filter_center - 1) > img_cols)
                img(i, j) = image(i,j);
            else
                window = image(i-(filter_center - 1):i+(filter_center - 1), j-(filter_center - 1):j+(filter_center - 1));
                
                switch type
                    case 'arithmetic'
                        img(i, j) = ceil(mean(double(window),"all"));
                    case 'geometric'
                        img(i, j) = ceil(geomean(double(window), "all"));
                    case 'harmonic'
                        img(i, j) = ceil(harmmean(double(window), [], "all"));
                    otherwise
                        img(i,j) = ceil(sum(double(window).^(q + 1)) / sum(double(window).^q));
                end
            end
            
        end
    end
end