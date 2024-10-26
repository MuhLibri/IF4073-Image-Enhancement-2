function img = notchRejectFilter(image, D0, threshold_factor, center_exclusion_radius, n)
    [M, N, C] = size(image);
    img = zeros(M, N, C);

    % Loop through each RGB channel
    for channel = 1:C
        f = image(:, :, channel);
        
        % Fourier Transform and shift the zero frequency to the center
        F = fft2(double(f));
        F_shifted = fftshift(F);
        
        % Compute the magnitude spectrum
        magnitude_spectrum = log(1 + abs(F_shifted));
        
        figure;
        imshow(magnitude_spectrum, []);
        title(['Magnitude Spectrum - Channel ', num2str(channel)]);
        
        % Threshold is determined based on the maximum magnitued (the
        % center) and threshold factor
        threshold = max(magnitude_spectrum(:)) * threshold_factor;
        
        % Center coordinates
        center_x = N / 2;
        center_y = M / 2;
        
        % Find coordinates of bright spots (noise peaks) that exceed the threshold
        [brightY, brightX] = find(magnitude_spectrum >= threshold);
        
        H = ones(M, N);
        [X, Y] = meshgrid(1:N, 1:M);
        
        % Generate a Butterworth notch filter for each bright spot
        for k = 1:length(brightX)
            % Coordinates of the bright spot
            x = brightX(k);
            y = brightY(k);
            
            distance_from_center = sqrt((x - center_x)^2 + (y - center_y)^2);
            
            % Ignore the brightest spot near the center
            if distance_from_center < center_exclusion_radius
                continue;
            end
            
            % Calculate the distance D from the bright spot to every point in the spectrum
            distance_from_center = sqrt((X - x).^2 + (Y - y).^2);
            
            % Butterworth notch reject filter formula
            H_notch = 1 ./ (1 + (D0 ./ distance_from_center).^(2 * n));
            
            H = H .* H_notch;
        end

        figure, imshow(H);
        
        % Apply the combined notch filter to the Fourier-transformed image
        F_filtered = F_shifted .* H;
        
        % Inverse shift and inverse Fourier Transform to get the filtered image
        F_inv_shifted = ifftshift(F_filtered);
        img_filtered = real(ifft2(F_inv_shifted));
        
        % Store the filtered channel in the output image
        img(:, :, channel) = img_filtered;
    end
    
    img = uint8(img);
end
