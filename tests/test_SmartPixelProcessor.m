classdef test_SmartPixelProcessor < matlab.unittest.TestCase
    methods (TestClassSetup)
        function addSrcToPath(testCase)
            % Add src folder to the MATLAB path so the app can be resolved
            addpath(fullfile(fileparts(mfilename('fullpath')), '../src'));
        end
    end

    methods (Test)
        function testGrayscaleConversion(testCase)
            app = SmartPixelProcessor;
            image = uint8(cat(3, 255, 0, 0));
            app.GrayscaleSwitch.Value = true;
            result = app.processImage(image);
            expected = uint8(round(0.299 * 255));
            testCase.verifyEqual(result, expected);
            delete(app);
        end

        function testLinearTransformClamping(testCase)
            app = SmartPixelProcessor;
            img = uint8([0, 255]);
            app.ContrastSlider.Value = 50;
            app.BrightnessSlider.Value = 100;
            result = app.processImage(img);
            testCase.verifyEqual(result, uint8([100, 255]));
            delete(app);
        end

        function testEdgeDetectionBinaryUint8(testCase)
            app = SmartPixelProcessor;
            img = uint8(ones(10, 10) * 128);
            app.EdgeDetectionSwitch.Value = true;
            app.EdgeMethodDropDown.Value = 'Sobel';
            result = app.processImage(img);
            testCase.verifyClass(result, 'uint8');
            testCase.verifyTrue(all(ismember(unique(result), [0, 255])));
            delete(app);
        end

        function testResetReturnsSlidersToZero(testCase)
            app = SmartPixelProcessor;
            app.BrightnessSlider.Value = 50;
            app.ContrastSlider.Value = -25;
            app.GrayscaleSwitch.Value = true;
            app.EdgeDetectionSwitch.Value = true;
            app.onResetButtonPushed();
            testCase.verifyEqual(app.BrightnessSlider.Value, 0);
            testCase.verifyEqual(app.ContrastSlider.Value, 0);
            testCase.verifyFalse(app.GrayscaleSwitch.Value);
            testCase.verifyFalse(app.EdgeDetectionSwitch.Value);
            delete(app);
        end
    end
end
