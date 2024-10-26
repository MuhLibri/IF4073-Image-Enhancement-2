function img = orderStatisticFilters(image, filter_dim, type, d)
    % Validate the filter type
    if ~(strcmp(type, 'max') || strcmp(type, 'min') || strcmp(type, 'median') || ...
         strcmp(type, 'alpha-trimmed') || strcmp(type, 'midpoint'))
        error('Invalid filter type. Supported types are: max, min, median, alpha-trimmed, midpoint.');
    end

    % Set default value for d in case it's not provided
    if nargin < 4
        d = 0;
    end

    [img_rows, img_cols, img_dims] = size(image);

    % Define filter center
    filter_center = floor((filter_dim + 1) / 2);
    
    img = zeros(img_rows, img_cols, img_dims);
    
    for i = 1:img_rows
        for j = 1:img_cols
            for k = 1:img_dims
                % If near the boundary, copy the original pixel
                if (i - (filter_center - 1) < 1 || j - (filter_center - 1) < 1 || ...
                    i + (filter_center - 1) > img_rows || j + (filter_center - 1) > img_cols)
                    img(i, j, k) = image(i,j,k);
                else
                    % Extract the window of pixels
                    window = image(i-(filter_center - 1):i+(filter_center - 1), ...
                                   j-(filter_center - 1):j+(filter_center - 1), k);
                    
                    switch type
                        case 'median'
                            img(i, j, k) = median(double(window), "all");
                        case 'max'
                            img(i, j, k) = max(double(window), [], "all");
                        case 'min'
                            img(i, j, k) = min(double(window), [], "all");
                        case 'midpoint'
                            img(i, j, k) = (max(double(window), [], "all") + min(double(window), [], "all")) / 2;
                        case 'alpha-trimmed'
                            % Sort the values in the window
                            sorted_window = sort(double(window(:)));
            
                            % Determine the number of elements to trim
                            trim_d = min(d, floor(length(sorted_window) / 2));
                            
                            % Apply trimming
                            trimmed_window = sorted_window(1 + trim_d:end - trim_d);
            
                            % Calculate the mean of the trimmed window
                            img(i, j, k) = mean(trimmed_window);
                    end
                end
            end
        end
    end
    img = uint8(img);
end
