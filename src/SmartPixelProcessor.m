classdef SmartPixelProcessor < matlab.apps.AppBase
    % SmartPixelProcessor MATLAB App
    %   App for loading images, applying grayscale conversion, linear
    %   brightness/contrast transform, clipping, edge detection, and
    %   real-time histogram display.

    properties (Access = public)
        UIFigure matlab.ui.Figure
        OriginalImageAxes matlab.ui.control.UIAxes
        ProcessedImageAxes matlab.ui.control.UIAxes
        HistogramAxes matlab.ui.control.UIAxes
        BrightnessSlider matlab.ui.control.Slider
        ContrastSlider matlab.ui.control.Slider
        GrayscaleSwitch matlab.ui.control.Switch
        EdgeDetectionSwitch matlab.ui.control.Switch
        EdgeMethodDropDown matlab.ui.control.DropDown
        LoadButton matlab.ui.control.Button
        SaveButton matlab.ui.control.Button
        ResetButton matlab.ui.control.Button
        StatusLabel matlab.ui.control.Label
        FormulaLabel matlab.ui.control.Label
    end

    properties (Access = private)
        OriginalImage uint8
        ProcessedImage uint8
    end

    methods (Access = private)
        function startupFcn(app)
            app.StatusLabel.Text = 'Ready. Load an image to begin.';
            app.FormulaLabel.Text = sprintf('I_{out} = c \cdot I_{in} + b    |    c = 1 + contrast/50');
            app.updateImageAndDisplay();
        end

        function updateImageAndDisplay(app)
            if isempty(app.OriginalImage)
                cla(app.OriginalImageAxes);
                cla(app.ProcessedImageAxes);
                cla(app.HistogramAxes);
                return;
            end

            image = app.OriginalImage;
            if app.GrayscaleSwitch.Value
                image = app.convertToGrayscale(image);
            end

            image = app.applyLinearTransform(image);
            image = app.clipImage(image);

            if app.EdgeDetectionSwitch.Value
                image = app.detectEdges(image);
            end

            app.ProcessedImage = image;

            imshow(app.OriginalImage, 'Parent', app.OriginalImageAxes);
            app.OriginalImageAxes.Visible = 'off';
            imshow(app.ProcessedImage, 'Parent', app.ProcessedImageAxes);
            app.ProcessedImageAxes.Visible = 'off';
            app.updateHistogram(app.ProcessedImage);
            app.StatusLabel.Text = 'Processed image updated.';
        end

        function gray = convertToGrayscale(app, image)
            if size(image, 3) == 1
                gray = image;
                return;
            end

            rgb = im2double(image);
            weights = [0.299, 0.587, 0.114];
            gray = rgb(:, :, 1) * weights(1) + ...
                   rgb(:, :, 2) * weights(2) + ...
                   rgb(:, :, 3) * weights(3);
            gray = im2uint8(gray);
        end

        function imageOut = applyLinearTransform(app, image)
            c = 1 + app.ContrastSlider.Value / 50;
            b = app.BrightnessSlider.Value;
            imageOut = c .* double(image) + b;
        end

        function clipped = clipImage(app, image)
            clipped = min(max(image, 0), 255);
            if ~isa(clipped, 'uint8')
                clipped = uint8(round(clipped));
            end
        end

        function edgeImage = detectEdges(app, image)
            if size(image, 3) == 3
                image = rgb2gray(image);
            end
            image = im2double(image);
            method = app.EdgeMethodDropDown.Value;
            if strcmp(method, 'Canny')
                edges = edge(image, 'Canny');
            else
                edges = edge(image, 'Sobel');
            end
            edgeImage = uint8(edges) * 255;
        end

        function updateHistogram(app, image)
            if isempty(image)
                return;
            end
            histogram(app.HistogramAxes, image(:), 0:255, ...
                'FaceColor', [0.2, 0.6, 0.9], 'EdgeColor', 'none');
            app.HistogramAxes.XLim = [0, 255];
            app.HistogramAxes.Title.String = 'Intensity Distribution';
            app.HistogramAxes.XLabel.String = 'Intensity';
            app.HistogramAxes.YLabel.String = 'Pixel Count';
        end

        function setFormula(app)
            c = 1 + app.ContrastSlider.Value / 50;
            b = app.BrightnessSlider.Value;
            app.FormulaLabel.Text = sprintf('I_{out} = %.3f \cdot I_{in} %+d', c, b);
        end

        function setStatus(app, message)
            app.StatusLabel.Text = message;
        end

        function createComponents(app)
            app.UIFigure = uifigure('Name', 'SmartPixelProcessor', 'Position', [100, 100, 1250, 720]);

            app.OriginalImageAxes = uiaxes(app.UIFigure, 'Position', [25, 360, 380, 340], 'Title', 'Original Image');
            app.ProcessedImageAxes = uiaxes(app.UIFigure, 'Position', [420, 360, 380, 340], 'Title', 'Processed Image');
            app.HistogramAxes = uiaxes(app.UIFigure, 'Position', [815, 360, 380, 340], 'Title', 'Histogram');

            app.BrightnessSlider = uislider(app.UIFigure, ...
                'Position', [165, 300, 520, 3], ...
                'Limits', [-100, 100], 'Value', 0, 'MajorTicks', -100:50:100, ...
                'ValueChangedFcn', @(src, event) app.onParameterChanged());
            uilabel(app.UIFigure, 'Position', [25, 285, 120, 22], 'Text', 'Brightness');

            app.ContrastSlider = uislider(app.UIFigure, ...
                'Position', [165, 250, 520, 3], ...
                'Limits', [-50, 50], 'Value', 0, 'MajorTicks', -50:25:50, ...
                'ValueChangedFcn', @(src, event) app.onParameterChanged());
            uilabel(app.UIFigure, 'Position', [25, 235, 120, 22], 'Text', 'Contrast');

            app.GrayscaleSwitch = uiswitch(app.UIFigure, 'toggle', ...
                'Position', [165, 200, 45, 20], 'ValueChangedFcn', @(src, event) app.onParameterChanged());
            uilabel(app.UIFigure, 'Position', [25, 200, 120, 22], 'Text', 'Grayscale');

            app.EdgeDetectionSwitch = uiswitch(app.UIFigure, 'toggle', ...
                'Position', [165, 160, 45, 20], 'ValueChangedFcn', @(src, event) app.onParameterChanged());
            uilabel(app.UIFigure, 'Position', [25, 160, 140, 22], 'Text', 'Edge Detection');

            app.EdgeMethodDropDown = uidropdown(app.UIFigure, ...
                'Position', [165, 120, 120, 22], ...
                'Items', {'Canny', 'Sobel'}, 'Value', 'Canny', ...
                'ValueChangedFcn', @(src, event) app.onParameterChanged());
            uilabel(app.UIFigure, 'Position', [25, 120, 120, 22], 'Text', 'Edge Method');

            app.LoadButton = uibutton(app.UIFigure, 'push', ...
                'Text', 'Load', 'Position', [25, 60, 100, 35], ...
                'ButtonPushedFcn', @(src, event) app.onLoadButtonPushed());
            app.SaveButton = uibutton(app.UIFigure, 'push', ...
                'Text', 'Save', 'Position', [140, 60, 100, 35], ...
                'ButtonPushedFcn', @(src, event) app.onSaveButtonPushed());
            app.ResetButton = uibutton(app.UIFigure, 'push', ...
                'Text', 'Reset', 'Position', [255, 60, 100, 35], ...
                'ButtonPushedFcn', @(src, event) app.onResetButtonPushed());

            app.StatusLabel = uilabel(app.UIFigure, 'Position', [420, 60, 620, 40], ...
                'Text', '', 'FontWeight', 'bold', 'HorizontalAlignment', 'left');

            app.FormulaLabel = uilabel(app.UIFigure, 'Position', [420, 20, 620, 40], ...
                'Text', '', 'FontAngle', 'italic', 'HorizontalAlignment', 'left');
        end

        function onParameterChanged(app)
            app.setFormula();
            app.updateImageAndDisplay();
        end

        function onLoadButtonPushed(app)
            [file, path] = uigetfile({'*.png;*.jpg;*.jpeg;*.tif;*.tiff;*.bmp', 'Images (*.png,*.jpg,*.jpeg,*.tif,*.tiff,*.bmp)'}, 'Load Image');
            if isequal(file, 0)
                return;
            end
            fullPath = fullfile(path, file);
            img = imread(fullPath);
            app.OriginalImage = im2uint8(img);
            app.StatusLabel.Text = sprintf('Loaded image: %s', file);
            app.updateImageAndDisplay();
        end

        function onSaveButtonPushed(app)
            if isempty(app.ProcessedImage)
                app.StatusLabel.Text = 'No processed image available to save.';
                return;
            end
            [file, path] = uiputfile({'*.png', 'PNG Image (*.png)'; '*.jpg;*.jpeg', 'JPEG Image (*.jpg, *.jpeg)'; '*.tif;*.tiff', 'TIFF Image (*.tif, *.tiff)'}, 'Save Processed Image');
            if isequal(file, 0)
                return;
            end
            fullPath = fullfile(path, file);
            imwrite(app.ProcessedImage, fullPath);
            app.StatusLabel.Text = sprintf('Saved processed image: %s', file);
        end

        function onResetButtonPushed(app)
            app.BrightnessSlider.Value = 0;
            app.ContrastSlider.Value = 0;
            app.GrayscaleSwitch.Value = false;
            app.EdgeDetectionSwitch.Value = false;
            app.EdgeMethodDropDown.Value = 'Canny';
            app.setFormula();
            app.updateImageAndDisplay();
            app.StatusLabel.Text = 'Reset controls to default values.';
        end
    end

    methods (Access = public)
        function outputImage = processImage(app, inputImage)
            if nargin < 2 || isempty(inputImage)
                inputImage = app.OriginalImage;
            end
            if isempty(inputImage)
                outputImage = uint8([]);
                return;
            end
            image = inputImage;
            if app.GrayscaleSwitch.Value
                image = app.convertToGrayscale(image);
            end
            image = app.applyLinearTransform(image);
            image = app.clipImage(image);
            if app.EdgeDetectionSwitch.Value
                image = app.detectEdges(image);
            end
            outputImage = image;
        end
    end
end
