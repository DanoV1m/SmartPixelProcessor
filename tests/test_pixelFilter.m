function tests = test_pixelFilter
tests = functiontests(localfunctions);
end
function testConstant(testCase)
image = uint8(80*ones(9,9));
for mode = {'None','Gaussian','Median','Sharpen'}
    testCase.verifyEqual(pixelFilter(image,mode{1}), image);
end
end
function testMedianImpulse(testCase)
image = zeros(9,9,'uint8'); image(5,5)=255;
testCase.verifyEqual(pixelFilter(image,'Median'),zeros(9,9,'uint8'));
end
function testGaussianImpulse(testCase)
image = zeros(9,9,'uint8'); image(5,5)=255;
out = pixelFilter(image,'Gaussian');
testCase.verifyGreaterThan(out(5,5),out(5,4));
testCase.verifyGreaterThan(out(5,4),uint8(0));
testCase.verifyLessThan(out(5,5),uint8(255));
end
function testRGB(testCase)
image = uint8(cat(3,20*ones(9),80*ones(9),150*ones(9)));
testCase.verifyEqual(pixelFilter(image,'Median'),image);
end
