# Architecture

## Class Hierarchy

```mermaid
classDiagram
    class AppBase
    class SmartPixelProcessor {
        +OriginalImage
        +ProcessedImage
        +UIFigure
        +OriginalImageAxes
        +ProcessedImageAxes
        +HistogramAxes
        +BrightnessSlider
        +ContrastSlider
        +GrayscaleSwitch
        +EdgeDetectionSwitch
        +EdgeMethodDropDown
        +LoadButton
        +SaveButton
        +ResetButton
        +StatusLabel
        +FormulaLabel
        +processImage(inputImage)
        -startupFcn()
        -updateImageAndDisplay()
        -convertToGrayscale()
        -applyLinearTransform()
        -clipImage()
        -detectEdges()
        -updateHistogram()
        -setFormula()
        -onParameterChanged()
        -onLoadButtonPushed()
        -onSaveButtonPushed()
        -onResetButtonPushed()
    }
    AppBase <|-- SmartPixelProcessor
```

## Data Flow

```mermaid
flowchart TD
    Load[Load Image] -->|Read from disk| Original[OriginalImage]
    Original -->|Optional conversion| Gray{Grayscale toggle}
    Gray --> Transform[Linear Transform]
    Transform --> Clip[Clip to [0,255]]
    Clip --> Edge{Edge Detection toggle}
    Edge -->|Yes| EdgeOp[Edge Operator]
    EdgeOp --> Display[Display Processed Image]
    Edge -->|No| Display
    Display --> Histogram[Render Histogram]
```

## Processing Pipeline Sequence

```mermaid
sequenceDiagram
    participant User
    participant Slider
    participant App
    participant ProcessedAxes
    participant HistogramAxes

    User->>Slider: adjust brightness/contrast
    Slider->>App: ValueChangedFcn
    App->>App: updateImageAndDisplay()
    App->>ProcessedAxes: show processed output
    App->>HistogramAxes: update histogram
```

## Math Formulas

- Grayscale conversion:

  $$I_{gray} = 0.299 R + 0.587 G + 0.114 B$$

- Linear transform:

  $$I_{out} = c \cdot I_{in} + b$$

  where:

  $$c = 1 + \frac{contrast}{50}$$

- Clipping function:

  $$I_{clip} = \min\left(\max\left(I_{out},0\right),255\right)$$

- Edge detection gradient magnitude (Sobel):

  $$\nabla I = \sqrt{\left(\frac{\partial I}{\partial x}\right)^2 + \left(\frac{\partial I}{\partial y}\right)^2}$$

## Callback Dependency Graph

```mermaid
graph LR
    LoadButton --> App[SmartPixelProcessor]
    App --> updateImageAndDisplay
    ContrastSlider --> onParameterChanged
    BrightnessSlider --> onParameterChanged
    GrayscaleSwitch --> onParameterChanged
    EdgeDetectionSwitch --> onParameterChanged
    EdgeMethodDropDown --> onParameterChanged
    onParameterChanged --> updateImageAndDisplay
    updateImageAndDisplay --> updateHistogram
    SaveButton --> onSaveButtonPushed
    ResetButton --> onResetButtonPushed
```

## Memory Management Notes

- The application stores only two primary image buffers: `OriginalImage` and `ProcessedImage`.
- All intermediate transforms are computed on demand, minimizing long-lived temporary arrays.
- `clipImage` converts the final result back to `uint8` to keep memory consistent with standard image storage.
- Large arrays are released when the app is deleted and when new images are loaded.
- UI handles remain persistent in `UIFigure`; careful event wiring avoids anonymous function closures that capture large image data.
