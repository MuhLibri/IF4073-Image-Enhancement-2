function img = gaussianFilter(image, filter_dim, sigma)
    img = convolution(image, fspecial("gaussian", [filter_dim, filter_dim], sigma));
end