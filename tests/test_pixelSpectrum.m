function tests = test_pixelSpectrum
tests = functiontests(localfunctions);
end
function testConstantImage(testCase)
result = pixelSpectrum(ones(8,8));
testCase.verifyEqual(result(5,5), log1p(64), 'AbsTol',1e-10);
result(5,5) = 0;
testCase.verifyEqual(max(abs(result(:))),0,'AbsTol',1e-10);
end
function testImpulse(testCase)
image = zeros(8,8); image(1,1) = 1;
testCase.verifyEqual(pixelSpectrum(image),log(2)*ones(8,8),'AbsTol',1e-10);
end
