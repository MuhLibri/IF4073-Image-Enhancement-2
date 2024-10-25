function img = brighteningFilter(image, n)
    [M,N,~] = size(image);
    f = im2double(image);
    P = 2*M;
    Q = 2*N;

    % Fourier transform and padding at the same time    
    F = fft2(f, P, Q);
    % Shift the image    
    F = fftshift(F);
    
    % Compute H
    H = n * ones(P, Q);
    H = fftshift(H);
    
    G = H.*F;
    G1 = ifftshift(G);
    
    G2 = real(ifft2(G1));
    
    img = G2(1:M, 1:N, :);
end