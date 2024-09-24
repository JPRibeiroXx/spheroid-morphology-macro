# Spheroid Analysis Macro

## Overview
This ImageJ macro provides an automated tool for morphological assessment of cell spheroids. The macro calculates:
- **Diameter**
- **Circularity**
- **Roundness**
- **Sphericity Index** (which is the square root of circularity)

The macro helps users process multiple images by setting up a pixel-to-micron scale, and allows for size filtering of spheroids based on user-defined minimum and maximum diameters.

## Prerequisites
Before using the macro, ensure that:
- You have **ImageJ/Fiji** installed.
- You know the conversion between **pixels and microns** for your images (e.g., the number of pixels that correspond to a known distance in micrometers).
- The images of your spheroids are prepared and located in a single directory.

## How to Use
1. **Set the Pixel-to-Micron Scale**:
    - You will be prompted to input the **distance in pixels** (e.g., the length of a scale bar in pixels) and the corresponding **known distance in microns**. This will ensure that all your measurements are correctly scaled in micrometers.
  
2. **Size Calculator**:
    - The macro will ask for the **minimum and maximum diameters** (in micrometers) of spheroids you're interested in analyzing. It will then calculate the area range in square micrometers for filtering objects in your images.
    - These values will be used in the "Analyze Particles" dialog in ImageJ to filter out spheroids outside the specified size range.

3. **Image Processing**:
    - The macro will prompt you to select a directory containing your images.
    - For each image:
        - It will automatically convert the image to 8-bit and apply an initial threshold.
        - You'll have the opportunity to manually adjust the threshold for better segmentation.
        - The macro will then run the "Analyze Particles" feature to detect spheroids.
        - Each detected spheroid will be listed in the **Results table** along with its size and morphological measurements.

4. **Saving Results**:
    - After all images are processed, the macro will automatically save the results as an Excel file named `Spheroid_Analysis_Results.xls` in the selected directory.

## Output
- The results will include:
    - **Diameter** of each detected spheroid.
    - **Circularity**: A value between 0 and 1, where 1 indicates a perfect circle.
    - **Roundness**: Another measure of how circular the object is.
    - **Sphericity Index**: The square root of the circularity.
    - **Image Name**: The name of the image from which the spheroid was detected.

## Example
Here is an example of the output file:

| Image Name | Diameter (µm) | Circularity | Roundness | Sphericity Index |
|------------|----------------|-------------|-----------|------------------|
| img1.tif   | 150            | 0.89        | 0.90      | 0.943            |
| img2.tif   | 170            | 0.76        | 0.80      | 0.871            |

## Notes
- If no particles are detected in an image, the macro will inform you and allow you to adjust the threshold or size/circularity settings.
- Ensure all your images are consistently scaled and oriented for best results.

## Requirements
- **ImageJ/Fiji**: Download from [ImageJ website](https://imagej.nih.gov/ij/download.html) or [Fiji website](https://fiji.sc/).
  
## License
This macro is distributed under the MIT License. See `LICENSE` for more details.
