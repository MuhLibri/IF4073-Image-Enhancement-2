function img = meanFilter(image, filter_dim)
    img = convolution(image, (ones(filter_dim) / (filter_dim^2)));
end