function ExerciseThree

% Reading the input image
inputImage = imread("input_ex3.jpg");

% Task.a: Converting the image to grey scale
greyImage = rgb2gray(inputImage);

figure;
imshow(greyImage);
title("Grey Image");

% Task.b: Apply GOG Filter to derive gradient images in x and y direction
sigma = 4.0; % Assumed
kernelRadius = 2; % Assumed 3Sigma == 2

% Computing the GOG kernel filter for x and y direction
[Gx, Gy] = ComputeGOGFilterKernel(sigma, kernelRadius);

% Computing Image Gradient
[Ix, Iy] = ComputeImageGradient(greyImage, Gx, Gy);

% Computing the gradient magnitude
I = sqrt(Ix.^2 + Iy.^2);

figure;
imshow(I, []);
title('Gradient Magnitude Image');

% Task.c: Finding an appropriate threshold on the gradient magnitude to
% extract representative edge pixels
threshold = graythresh(I) * max(I(:)); % define threshold using Otsu's method

% Performing binarization on the gradient magnitude to extract edge pixels
binaryEdgeMask = Binarization(I, threshold);

% Display the binary mask
figure;
imshow(binaryEdgeMask);
title('Binary Edge Mask');

% Task.d: Implement a function for hough line detector
[H, angleRange, rhoRange] = HoughLineDetection(binaryEdgeMask, Ix, Iy);

% Task.e: Plot the resulting Hough Voting Array
figure;
imshow(imadjust(rescale(H)), 'XData', angleRange, 'YData', rhoRange, 'InitialMagnification', 'fit');
xlabel('\theta (degrees)');
ylabel('\rho');
title("Hough Voting Array");
axis on;
axis normal;

% Task.f: Find Local Maxima of H using inbuilt function
localMax = CalculateLocalMaxima(H);

%Task.g: Plot the found extrema on top of your figure in step f.
% Plotting the detected extrema on the Hough voting array
hold on;
plot(angleRange(localMax(:, 2)), rhoRange(localMax(:, 1)), 's', 'Color', 'red');
hold off

%Task.h: Using the built-in function houghlines to derive the corresponding line segments.
lines = houghlines(binaryEdgeMask, angleRange, rhoRange, localMax);

% Task.i: Plot the original image with detected lines
figure;
imshow(inputImage);
hold on;
title('Detected Lines on Original Image');
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green');
    
    % Plot beginnings and ends of lines
    plot(xy(1,1), xy(1,2), 'x', 'LineWidth', 2, 'Color', 'yellow');
    plot(xy(2,1), xy(2,2), 'x', 'LineWidth', 2, 'Color', 'red');
end
hold off;

end

% Function for Computing GOG filter Kernel
function [Gx, Gy] = ComputeGOGFilterKernel(sigma, kernelRadius)

% Defining a matrix Cx with (2r+1) row and column and Cy
Cx = meshgrid(-kernelRadius:kernelRadius, zeros(1, 2*kernelRadius + 1));
Cy = Cx';

% Computing the GOG Filter kernels for the x and y direction
Gx = (-Cx./( 2 * pi * sigma^4)) .* exp(-(Cx.^2 + Cy.^2)/(2 * sigma^2));
Gy = (-Cy./( 2 * pi * sigma^4)) .* exp(-(Cx.^2 + Cy.^2)/(2 * sigma^2));
end

% Function for Computing Image Gradient
function [Ix, Iy] = ComputeImageGradient(greyImage, Gx, Gy)

% Computing the Image Gradient in x and y direction
Ix = conv2(greyImage, Gx, "valid");
Iy = conv2(greyImage, Gy, "valid");

end

% Function used to obtain binary edge mask
function binaryMask = Binarization(stretchedImage, threshold)
    binaryMask = stretchedImage > threshold; % Binary mask with 1 for foreground and 0 for background
end

% Function Implemented for Hough line detector
function [H, angleRange, rhoRange] = HoughLineDetection(edgeMask, Ix, Iy)

% Define the range of the angle using polar coordinates
angleRange = -90:1:89; % from -90 to 89 degrees

% Convert the range of angles to radians
angleRad = deg2rad(angleRange);

% Calculating the maximum possible values for rho
[rows, cols] = size(edgeMask);
maxRho = ceil(sqrt(rows^2 + cols^2));
rhoRange = -maxRho : maxRho;

% Initializing the Hough accumulator array
H = zeros(length(rhoRange), length(angleRange));

% Find the indices of edge pixels
[yIndices, xIndices] = find(edgeMask);

% Computing the gradient magnitudes and direction
gradientMagnitude = sqrt(Ix.^2 + Iy.^2);
gradientDirection = atan2(Iy, Ix); % in radians

% Processing each edge pixel
for i = 1:length(xIndices)
    x = xIndices(i);
    y = yIndices(i);

    % Only consider strong gradient directions
    gradDir = gradientDirection(y, x);
    if gradientMagnitude(y, x) > 0 % avoid dividing by zero
        for angleIndex = 1:length(angleRange)
            angle = angleRad(angleIndex);

            % Using the gradient direction to limit the angle search
            if abs(angle - gradDir) <= pi/4 % within +/- 45 degrees
                rho = x * cos(angle) + y * sin(angle);
                rhoIndex = round(rho) + maxRho + 1;
                H(rhoIndex, angleIndex) = H(rhoIndex, angleIndex) + 1;
            end
        end
    end
end
end

% Implementing a function to calculate local maxima
function localMax = CalculateLocalMaxima(H)

numMax = 20; % number of maxima to identify
localMax = houghpeaks(H, numMax);

end
