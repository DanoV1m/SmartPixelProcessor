function tests = test_pixelQuality
tests = functiontests(localfunctions);
end
function testIdentity(testCase)
a=uint8(100*ones(16));
[p,s]=pixelQuality(a,a);
testCase.verifyEqual(p,Inf);
testCase.verifyEqual(s,1,'AbsTol',1e-10);
end
function testKnownMse(testCase)
a=uint8(100*ones(16)); b=uint8(110*ones(16));
[p,s]=pixelQuality(a,b);
testCase.verifyEqual(p,20*log10(255/10),'AbsTol',1e-10);
testCase.verifyLessThan(s,1);
end
function testColorIdentity(testCase)
a=uint8(cat(3,ones(16),20*ones(16),200*ones(16)));
[p,s]=pixelQuality(a,a);
testCase.verifyEqual(p,Inf);
testCase.verifyEqual(s,1,'AbsTol',1e-10);
end
