# User Guide

## Getting Started

1. Open MATLAB.
2. Navigate to the project folder.
3. Run the app by entering:

```matlab
app = SmartPixelProcessor;
```

4. The application window appears with three main panels:
   - Original image on the left
   - Processed image in the center
   - Histogram on the right

![App Layout Placeholder](docs/assets/user-guide-layout.png)

## Load an Image

- Click **Load**.
- Select a PNG, JPG, TIFF, or BMP image.
- The original image appears in the left panel.
- The processed image and histogram update automatically.

## Controls

### Brightness Slider

- Range: `-100` to `100`
- Adds an offset `b` to every pixel.
- Formula: `I_{out} = c \cdot I_{in} + b`
- Use positive values to brighten the image.
- Use negative values to darken the image.

### Contrast Slider

- Range: `-50` to `50`
- Applies a scaling factor `c = 1 + contrast/50`.
- If contrast is `0`, then `c = 1`.
- Positive contrast amplifies differences.
- Negative contrast compresses the dynamic range.

### Grayscale Switch

- Converts color images to grayscale using ITU-R BT.601 weights.
- This conversion uses the formula:

```latex
I_{gray} = 0.299 R + 0.587 G + 0.114 B
```

- If the switch is off, the app preserves the original color channels.

### Edge Detection Switch

- Enables edge extraction after linear transform and clipping.
- The edge output is shown as a binary image in the processed preview.
- Switch the toggle on to see edge boundaries.

### Edge Method Dropdown

- Choose between **Canny** and **Sobel**.
- **Canny** is more robust for multistage edge detection.
- **Sobel** computes gradient magnitude using a simple filter.

## Status and Formula Labels

- **Status Label** shows the current app state and actions.
- **Formula Label** displays the current brightness and contrast transform.

## Histogram Interpretation

- The histogram shows pixel counts versus intensity.
- For grayscale images, it visualizes a single channel distribution.
- For color images, the histogram displays the distribution of the current processed output.
- Sharp peaks indicate a limited tonal range.
- A broad spread indicates greater contrast.

## Saving Results

- Click **Save** to write the processed image to disk.
- Choose a file type and location in the dialog.
- The saved image matches the current processed preview.

## Resetting the App

- Click **Reset** to return sliders to zero.
- This also disables grayscale and edge detection.
- Use reset to clear temporary adjustments and begin again.

## Tips & Tricks

- Use **Grayscale** with slight contrast increases when preparing edge detection for low-contrast photos.
- Enable **Edge Detection** after clipping to avoid invalid pixel values.
- If output appears too dark, increase brightness before adjusting contrast.
- Use the histogram to identify whether highlights or shadows are clipped.
