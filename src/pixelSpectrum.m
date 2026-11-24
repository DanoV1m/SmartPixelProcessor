function spectrum = pixelSpectrum(image)
% Centered log-magnitude spectrum of a grayscale or RGB image.
validateattributes(image, {'numeric','logical'}, {'nonempty','real','finite'});
if ndims(image) == 3 && size(image,3) == 3
    image = rgb2gray(image);
elseif ~ismatrix(image)
    error('SmartPixel:InvalidImage','Expected grayscale or RGB image.');
end
spectrum = log1p(abs(fftshift(fft2(double(image)))));
end
