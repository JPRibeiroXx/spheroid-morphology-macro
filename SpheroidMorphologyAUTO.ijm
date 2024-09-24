// Macro: Spheroid Analysis
macro "Spheroid Analysis" {

    // Create the main dialog for scaling parameters and expected sizes
    Dialog.create("Spheroid Analysis Settings");

    // Add numeric fields for scaling parameters
    Dialog.addNumber("Distance in pixels (e.g., length of scale bar):", 100);
    Dialog.addNumber("Known distance in micrometers (e.g., length represented by scale bar):", 50);

    // Show the dialog
    Dialog.show();

    // Get the values entered by the user
    distance_in_pixels = Dialog.getNumber();
    known_distance = Dialog.getNumber();

    // Check for invalid inputs
    if (isNaN(distance_in_pixels) || isNaN(known_distance) ||
        distance_in_pixels <= 0 || known_distance <= 0) {
        exit("Macro canceled by the user or invalid input.");
    }

    // Set scale for images in pixels per micron
    pixel_per_micron = distance_in_pixels / known_distance;

    // Initialize the Results table (ensure it's cleared at the start)
    run("Clear Results");

    // ---- SIZE CALCULATOR -----
    // Provide a size calculator dialog where the user can input min and max diameters
    Dialog.create("Size Calculator for Analyze Particles");
    Dialog.addNumber("Minimum Diameter (µm):", 100);
    Dialog.addNumber("Maximum Diameter (µm):", 400);
    Dialog.show();

    // Get the min and max diameter values entered by the user
    min_diameter = Dialog.getNumber();
    max_diameter = Dialog.getNumber();

    // Calculate the minimum and maximum area (size) in µm²
    min_area = PI * pow(min_diameter / 2, 2); // Minimum size (µm²)
    max_area = PI * pow(max_diameter / 2, 2); // Maximum size (µm²)

    // Show a message with the calculated area values for the user to input in the Analyze Particles window
    msg = "Calculated Size (µm²) for Analyze Particles: \n";
    msg += "Minimum Size: " + min_area + " µm²\n";
    msg += "Maximum Size: " + max_area + " µm²\n";
    msg += "Use these values in the Size field when prompted in the Analyze Particles dialog.";
    showMessage("Size Calculator Results", msg);

    // ---- END SIZE CALCULATOR ----

    // Prompt the user to select the directory containing the images
    dir = getDirectory("Choose a Directory with Images to Process");

    // Get the list of image files in the directory
    list = getFileList(dir);

    // Loop over each image in the directory
    for (i = 0; i < list.length; i++) {

        // Open the image
        open(dir + list[i]);

        // Get the image title
        imageTitle = getTitle();

        // Convert the image to 8-bit
        run("8-bit");

        // Set the scale for the current image
        run("Set Scale...", "distance=" + distance_in_pixels + " known=" + known_distance + " pixel=1 unit=µm global");

        // Apply initial automatic threshold
        setAutoThreshold("Default");

        // Display the Threshold dialog for user adjustment
        run("Threshold...");
        waitForUser("Adjust the threshold for " + list[i] + ", then click OK to continue.");

        // Get the number of results before running Analyze Particles
        previousNumResults = nResults();

        // Show the Analyze Particles window for user interaction
        run("Analyze Particles...");

        // Get the number of results after running Analyze Particles
        newNumResults = nResults();

        // If new particles were detected, assign the image name to the new results
        if (newNumResults > previousNumResults) {
            // Assign the image name to the newly added results
            for (j = previousNumResults; j < newNumResults; j++) {
                setResult("Image", j, imageTitle);  // Assign the image name to the current row
            }
        } else {
            // No particles detected
            showMessage("No particles detected in " + list[i] + ". Please adjust the threshold or size/circularity settings.");
        }

        // Close the image window
        selectWindow(imageTitle);
        close();
    }

    // Save all accumulated results to an Excel file after all images are processed
    saveAs("Results", dir + "Spheroid_Analysis_Results.xls");

    // Close the Results table
    run("Close");
}
