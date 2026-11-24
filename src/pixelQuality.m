function [p,s] = pixelQuality(reference, processed)
% Full-reference similarity metrics for same-size uint8 grayscale or RGB.
% SSIM is the mean of per-channel SSIM, not a perceptual color metric.
validateattributes(reference,{'uint8'},{'nonempty'});
validateattributes(processed,{'uint8'},{'nonempty','size',size(reference)});
if ~(ismatrix(reference) || (ndims(reference)==3 && size(reference,3)==3))
    error('SmartPixel:InvalidImage','Expected grayscale or RGB.');
end
difference = double(reference)-double(processed);
mse = mean(difference(:).^2);
if mse==0, p=Inf; else, p=10*log10(255^2/mse); end
scores=zeros(1,size(reference,3));
for c=1:size(reference,3)
    scores(c)=ssim(processed(:,:,c),reference(:,:,c),'DynamicRange',255);
end
s=mean(scores);
end
