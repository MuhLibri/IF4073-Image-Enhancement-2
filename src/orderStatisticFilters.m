function img = orderStatisticFilters(image, filter_dim, type, d)
    if ~(strcmp(type, 'max') || strcmp(type, 'min') || strcmp(type, 'median') || strcmp(type, 'alpha-trimmed') || strcmp(type, 'midpoint'))
        error('Invalid filter type. Supported types are: ideal, gaussian, butterworth.');
    end

    if nargin < 4
        d = 0;
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
                    case 'median'
                        img(i, j) = median(double(window), "all");
                    case 'max'
                        img(i, j) = max(double(window), [], "all");
                    case 'min'
                        img(i, j) = min(double(window), [], "all");
                    case 'midpoint'
                        img(i, j) = (max(double(window), [], "all") + min(double(window), [], "all")) / 2;
                    otherwise
                        copy = window;
                        for k = 1:d
                            copy = copy(copy~=min(double(copy), [], "all"));
                            copy = copy(copy~=max(double(copy), [], "all"));
                        end
                        img(i, j) = ceil(mean(copy,"all")); 
                end
            end
            
        end
    end
end