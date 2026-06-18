% Demo script for SmartPixelProcessor headless processing

app = SmartPixelProcessor;

% Create a synthetic checkerboard image
testImage = uint8(repmat([0, 255; 255, 0], 128, 128));
checkerboardImage = cat(3, testImage, testImage, testImage);

% Load the synthetic image into the app
app.OriginalImage = checkerboardImage;

% Mode 1: No transform
app.BrightnessSlider.Value = 0;
app.ContrastSlider.Value = 0;
app.GrayscaleSwitch.Value = false;
app.EdgeDetectionSwitch.Value = false;
output1 = app.processImage(app.OriginalImage);
imwrite(output1, 'examples/checkerboard_no_transform.png');

% Mode 2: Grayscale + brightness/contrast
app.GrayscaleSwitch.Value = true;
app.BrightnessSlider.Value = 20;
app.ContrastSlider.Value = 25;
app.EdgeDetectionSwitch.Value = false;
output2 = app.processImage(app.OriginalImage);
imwrite(output2, 'examples/checkerboard_grayscale_brightness_contrast.png');

% Mode 3: Edge detection with Canny
app.EdgeDetectionSwitch.Value = true;
app.EdgeMethodDropDown.Value = 'Canny';
output3 = app.processImage(app.OriginalImage);
imwrite(output3, 'examples/checkerboard_edges_canny.png');

% Mode 4: Edge detection with Sobel
app.EdgeMethodDropDown.Value = 'Sobel';
output4 = app.processImage(app.OriginalImage);
imwrite(output4, 'examples/checkerboard_edges_sobel.png');

fprintf('Demo script complete. Outputs saved in examples/.\n');
