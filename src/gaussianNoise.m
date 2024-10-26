function img = gaussianNoise(image, mean, var)
    img = imnoise(image, 'gaussian', mean, var);
end