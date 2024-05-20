function ExerciseThree

%Reading the input image
inputImage = imread("input_ex3.jpg");

%Task.a: Converting the image to grey scale
greyImage = rgb2gray(inputImage);

figure;
imshow(greyImage);
title("Grey Image");

%Task.b: Apply GOG Filter to derive gradient images in x and y direction

sigma = 4.0; %Assumed
kernelRadius = 2; %Assumed 3Sigma == 2

%Computing the GOG kernel filter for x and y direction
[Gx, Gy] = ComputeGOGFilterKernel(sigma, kernelRadius);

%Computing Image Gradient
[Ix, Iy] = ComputeImageGradient(greyImage, Gx, Gy);

%Computing the gradient magnitude
I = sqrt(Ix.^2 + Iy.^2);
figure;
imshow(I);
title('Gradient Magnitude Image');




end

%Function for Computing GOG filter Kernel
function [Gx, Gy] = ComputeGOGFilterKernel(sigma, kernelRadius)

%Defining a matrix Cx with (2r+1) row and column and Cy
Cx = meshgrid(-kernelRadius:kernelRadius, zeros(1, 2*kernelRadius + 1));
Cy = Cx';

%Computing the GOG Filter kernels for the x and y direction
Gx = (-Cx./( 2 * pi * sigma^4)) .* exp(-(Cx.^2 + Cy.^2)/(2 * sigma^2));
Gy = (-Cy./( 2 * pi * sigma^4)) .* exp(-(Cx.^2 + Cy.^2)/(2 * sigma^2));
end

%Function for Computing Image Gradient
function [Ix, Iy] = ComputeImageGradient(greyImage, Gx, Gy)

%Computing the Image Gradient in x and y direction
Ix = conv2(greyImage, Gx,"valid");
Iy = conv2(greyImage, Gy,"valid");

end

