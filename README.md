## Straight-Line-Detection-in-an-Image-Based-on-Hough-Voting-Algorithm

# Steps to Implement Algorithm

* I. use the provided image (input_ex3.jpg)
* II. Read the input image and convert it to a grayscale image with a value range [0,1]. Plot the resulting image.
* III. Apply a GoG filter to derive gradient images in the x- and y-direction and compute the gradient magnitude.
* IV. Find and apply an appropriate threshold on the gradient magnitude to extract representative edge pixels. Plot the binary edge mask.
* V. Implement a function for Hough line detection:
        * Input: Binary edge mask from (III) and gradient images from (II)
        * Output: Hough voting array 𝐻, index arrays for the ranges of 𝜃 and 𝜌
        * Hints:
                * 1. Use the polar line representation.
                * 2. Incorporate information about the gradient direction to speedup processing.
* VI. Plot the resulting Hough voting array 𝐻.
* VII. Find local maxima of 𝐻. You may use the built-in function houghpeaks.
* VIII. Plot the found extrema on top of your figure in step f.
* IX. Use the built-in function houghlines to derive the corresponding line segments.
* X. Plot the lines on the figure of step a.



