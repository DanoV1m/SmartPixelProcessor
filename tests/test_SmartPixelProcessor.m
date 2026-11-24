classdef test_SmartPixelProcessor < matlab.unittest.TestCase
    methods (TestClassSetup)
        function addSrcToPath(testCase)
            % Add src folder to the MATLAB path so the app can be resolved
            classPath = which(class(testCase));
            if ~isempty(classPath)
                addpath(fullfile(fileparts(classPath), '../src'));
            else
                addpath('src');
            end
        end
    end

    methods (Test)
        function testGrayscaleConversion(testCase)
            app = SmartPixelProcessor;
            testCase.addTeardown(@() delete(app));
            image = uint8(cat(3, 255, 0, 0));
            app.GrayscaleSwitch.Value = 'On';
            result = app.processImage(image);
            expected = uint8(round(0.299 * 255));
            testCase.verifyEqual(result, expected);

        end

        function testLinearTransformClamping(testCase)
            app = SmartPixelProcessor;
            testCase.addTeardown(@() delete(app));
            img = uint8([0, 255]);
            app.ContrastSlider.Value = 50;
            app.BrightnessSlider.Value = 100;
            result = app.processImage(img);
            testCase.verifyEqual(result, uint8([100, 255]));

        end

        function testEdgeDetectionBinaryUint8(testCase)
            app = SmartPixelProcessor;
            testCase.addTeardown(@() delete(app));
            img = uint8(ones(10, 10) * 128);
            app.EdgeDetectionSwitch.Value = 'On';
            app.EdgeMethodDropDown.Value = 'Sobel';
            result = app.processImage(img);
            testCase.verifyClass(result, 'uint8');
            testCase.verifyTrue(all(ismember(unique(result), [0, 255])));

        end

        function testResetReturnsSlidersToZero(testCase)
            app = SmartPixelProcessor;
            testCase.addTeardown(@() delete(app));
            app.BrightnessSlider.Value = 50;
            app.ContrastSlider.Value = -25;
            app.GrayscaleSwitch.Value = 'On';
            app.EdgeDetectionSwitch.Value = 'On';
            app.resetControls();
            testCase.verifyEqual(app.BrightnessSlider.Value, 0);
            testCase.verifyEqual(app.ContrastSlider.Value, 0);
            testCase.verifyEqual(app.GrayscaleSwitch.Value, 'Off');
            testCase.verifyEqual(app.EdgeDetectionSwitch.Value, 'Off');

        end
    end
end
