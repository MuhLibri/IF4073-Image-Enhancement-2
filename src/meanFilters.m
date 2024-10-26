function img = meanFilters(image, filter_dim, type, q)
    if ~(strcmp(type, 'arithmetic') || strcmp(type, 'geometric') || strcmp(type, 'harmonic') || strcmp(type, 'contraharmonic'))
        error('Invalid filter type. Supported types are: ideal, gaussian, butterworth.');
    end

    if nargin < 4
        q = 0;
    end

    [img_rows, img_cols, img_dims] = size(image);

    filter_center = (filter_dim + 1) / 2;
    
    img = zeros(img_rows, img_cols);
    
    for i = 1:img_rows
        for j = 1:img_cols
            for k = 1:img_dims
                if(i - (filter_center - 1) < 1 || j - (filter_center - 1) < 1 || ...
                   i + (filter_center - 1) > img_rows || ...
                   j + (filter_center - 1) > img_cols)
                    img(i, j) = image(i,j);
                else
                    window = image(i-(filter_center - 1):i+(filter_center - 1), j-(filter_center - 1):j+(filter_center - 1), k);
                    
                    switch type
                        case 'arithmetic'
                            img(i, j,k) = ceil(mean(double(window),"all"));
                        case 'geometric'
                            img(i, j,k) = ceil(prod(double(window),"all")^(1 / numel(window)));
                        case 'harmonic'
                            img(i,j,k) = ceil(numel(window) / sum(1 ./ double(window(:))));
                        otherwise
                            denominator = sum(double(window(:)).^q);
                            
                            % Calculate the contraharmonic mean
                            if denominator == 0
                                error('Denominator is zero, cannot compute contraharmonic mean.');
                            end
    
                            img(i,j,k) = sum(double(window(:)).^(q + 1)) / denominator;
                    end
                end
            end
        end
    end
    img = uint8(img);
end