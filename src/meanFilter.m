function img = meanFilter(image, filter_dim)
    img = uint8(convolution(image, (ones(filter_dim) / (filter_dim^2))));
end