# Algorithms

## Grayscale Conversion

SmartPixelProcessor uses the ITU-R BT.601 weighted grayscale formula.

```latex
I_{gray} = 0.299 R + 0.587 G + 0.114 B
```

This formula reflects human visual sensitivity to color. The green channel contributes the most because the human eye is most sensitive to green wavelengths. Red contributes moderately, and blue contributes least.

### Why BT.601 weights?

- Accurate for standard dynamic range imaging.
- Preserves perceived luminance.
- Commonly used in broadcasting and image processing.

## Linear Brightness and Contrast

The app applies a linear transform to each pixel value after optional grayscale conversion.

```latex
I_{out} = c \cdot I_{in} + b
```

Where:

```latex
c = 1 + \frac{contrast}{50}
```

- `b` is the brightness offset controlled by the Brightness slider.
- `c` is the contrast multiplier controlled by the Contrast slider.
- When `contrast = 0`, `c = 1` and the image is only shifted by `b`.
- When `contrast > 0`, the image contrast increases.
- When `contrast < 0`, the image contrast decreases.

## Clipping Rationale

Pixel values are clipped to the valid 8-bit image range using:

```latex
I_{clip} = \min\left(\max\left(I_{out},0\right),255\right)
```

Clipping ensures:

- Images remain displayable.
- No negative or overflow values create artifacts.
- Subsequent edge detection receives valid input.

## Edge Detection

### Canny

Canny is a multi-stage detector that includes noise reduction, gradient computation, non-maximum suppression, and edge tracking by hysteresis.

- Good at preserving thin edges.
- Less sensitive to noise when thresholds are chosen well.
- Recommended when you want cleaner edge outlines.

### Sobel

Sobel uses convolution kernels to approximate image gradients.

The output gradient magnitude is:

```latex
\nabla I = \sqrt{\left(G_x\right)^2 + \left(G_y\right)^2}
```

Where `G_x` and `G_y` are the image derivatives in the x and y directions.

| Method | Strength | Output Type | Use Case |
|---|---|---|---|
| Canny | Robust, multi-stage | Binary edge map | Detailed edges, low noise |
| Sobel | Fast, single-pass | Binary edge map | Simple gradients, quick preview |

### Gradient Math

For Sobel, the approximate derivative filters are:

```latex
G_x = \begin{bmatrix}-1 & 0 & 1 \\ -2 & 0 & 2 \\ -1 & 0 & 1\end{bmatrix}
```

```latex
G_y = \begin{bmatrix}-1 & -2 & -1 \\ 0 & 0 & 0 \\ 1 & 2 & 1\end{bmatrix}
```

The edge output is binarized and scaled to `0` or `255` to display clean edge maps.
