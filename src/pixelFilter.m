function result = pixelFilter(image, mode)
% Apply spatial filtering to uint8 grayscale or RGB images.
validateattributes(image, {'uint8'}, {'nonempty'});
if ~(ismatrix(image) || (ndims(image)==3 && size(image,3)==3))
    error('SmartPixel:InvalidImage','Expected grayscale or RGB.');
end
switch mode
    case 'None'
        result = image;
    case 'Gaussian'
        result = imgaussfilt(image,1,'Padding','replicate');
    case 'Median'
        result = image;
        for channel=1:size(image,3)
            result(:,:,channel) = medfilt2(image(:,:,channel),[3 3],'symmetric');
        end
    case 'Sharpen'
        result = imsharpen(image,'Radius',1,'Amount',1);
    otherwise
        error('SmartPixel:InvalidFilter','Unsupported spatial filter.');
end
end
