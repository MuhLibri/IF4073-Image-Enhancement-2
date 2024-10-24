function img = deconvolution(image, psf, nsr)
    f = im2double(image);
    [image_row, image_col, image_dim] = size(f);

    % Get the size of the PSF
    [filter_row, filter_col] = size(psf);

    % Calculate padding sizes
    pad_row = floor((image_row - filter_row) / 2);
    pad_col = floor((image_col - filter_col) / 2);
    
    % Pad the kernel (H)
    H = padarray(psf, [pad_row, pad_col], 0, 'both');  % Pad with zeros on both sides
    [filter_row, filter_col] = size(H);

    disp(pad_row);
    if rem(pad_row, 2) == 0 && filter_row ~= image_row
        H = padarray(H, [1, 0], 0, 'pre');
    end
    if rem(pad_col, 2) == 0 && filter_col ~= image_col
        H = padarray(H, [0, 1], 0, 'pre');
    end
    
    % Shift the kernel (PSF) to center for frequency domain
    F = fft2(f);
    H = fft2(ifftshift(H));

    % Wiener deconvolution (applies the inverse filter with noise handling)
    G = zeros(size(F));
    for c = 1:image_dim
        G(:,:,c) = (conj(H) ./ (abs(H).^2 + nsr)) .* F(:,:,c);
    end

    % Inverse FFT to get the restored image
    G1 = real(ifft2(G));

    % Crop the image to original size
    img = G1(1:image_row, 1:image_col, :);
end
