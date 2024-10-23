function IHPF(image, D0)
    f = im2double(image);
    [M,N] = size(image);
    P = 2*M;
    Q = 2*N;

    % Fourier transform and padding at the same time    
    F = fft2(f, P, Q);
    % Shift the image    
    F = fftshift(F);
    S2 = log(1+abs(F));
    figure, imshow(S2,[]); title('Fourier spectrum');

    % Set up range of variables.
    u = 0:(P-1);
    v = 0:(Q-1);
    % Compute the indices for use in meshgrid
    idx = find(u > P/2);
    u(idx) = u(idx) - P;
    idy = find(v > Q/2);
    v(idy) = v(idy) - Q;
    
    % Compute H
    [V, U] = meshgrid(v, u);
    D = sqrt(U.^2 + V.^2);
    H = double(D <=D0);
    H = 1 - H;
    H = fftshift(H); figure;imshow(H);title('LPF Ideal Mask');
    figure, mesh(H);
    
    G = H.*F;
    G1 = ifftshift(G);
    
    G2 = real(ifft2(G1));
    figure; imshow(G2);title('output image after inverse 2D DFT');
    
    G2 = G2(1:M, 1:N);
    figure, imshow(G2); title('output image');
end