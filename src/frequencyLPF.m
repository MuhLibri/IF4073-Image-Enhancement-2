function img = frequencyLPF(image, type, d0, padding, n)
    if ~(strcmp(type, 'ideal') || strcmp(type, 'gaussian') || strcmp(type, 'butterworth'))
        error('Invalid filter type. Supported types are: ideal, gaussian, butterworth.');
    end

    if nargin < 5
        n = 1;
    end
    
    [M,N,C] = size(image);
    f = im2double(image);
    
    P = M;
    Q = N;
    
    if(padding)
        P = 2*M;
        Q = 2*N;
    end
    
    F = fftshift(fft2(f, P, Q)); 
     
    u = 0:(P-1);
    v = 0:(Q-1);
    
    idx = find(u > P/2);
    u(idx) = u(idx) - P;
    idy = find(v > Q/2);
    v(idy) = v(idy) - Q;
    
    [V, U] = meshgrid(v, u);
    D = sqrt(U.^2 + V.^2);
    
    switch type
        case 'ideal'
            H = double(D <=d0);
        case 'gaussian'
            H = exp(-(D.^2)./(2*(d0^2)));
        otherwise
            H = 1./(1 + (D./d0).^(2*n));
    end
    
    H = fftshift(H); 
    G = zeros(size(H));
    for c = 1:C
        G(:,:,c) = H .* F(:,:,c);
    end
    G1 = real(ifft2(ifftshift(G)));

    img = G1(1:M, 1:N, :); 
end