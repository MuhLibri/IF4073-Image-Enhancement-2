function img = saltPepperNoise(image, d)
    img = imnoise(image, 'salt & pepper', d);
end