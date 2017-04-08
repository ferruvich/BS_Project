function progetto(image_file)
	close all;
	% Mostriamo l'immagine
    input_image = imread(image_file);
	figure, imshow(input_image);

	%Inizio preprocessing

	% Controllando le immagini, abbiamo notato che la parte rossa
	% si presta meglio alla segmentazione (rimane più nitida)
	im_red = input_image(:,:,1);

	% Applichiamo un filtro gaussiano
	gaussian_filter = fspecial('gaussian', [800 600], 5);
	double_im = double(im_red);
	im_filter = imfilter(double_im, gaussian_filter);

    %Edge detection
    %Usiamo un canny edge detector
    edges = edge(im_filter, 'canny', 0.1,5);
       
    % Usiamo imfindcircles per trovare oggetti circolari
    % all''interno dell''immagine
    
    % Iride, fatto in modo diverso perchè imfindcircles non funziona
    % altrimenti
    im2 = rgb2gray(input_image);
    im3 = im2bw(histeq(im2), 0.55);
    [centersI, radiI] = imfindcircles(im3, [160, 220], 'Sensitivity', .99, 'ObjectPolarity', 'dark');
    dim = size(centersI);
    if dim(1) > 1
        centersI = centersI(1,:);
        radiI = radiI(1);
    end
    viscircles(centersI, radiI, 'EdgeColor', 'b');
    
    % Pupilla
    [centers, radii] = imfindcircles(edges, [35, 60], 'Sensitivity', .95);
    dim = size(centers);
    if dim(1) > 1
        for i = 1:dim(1)
            diffY = (centers(i,1)-centersI(1))^2;
            diffX = (centers(i,2)-centersI(2))^2;
            if (diffX < 1000) && (diffY < 1000)
                centers = centers(i,:);
                radii = radii(i);
                break;
            end
        end
    end
    viscircles(centers, radii, 'EdgeColor', 'r');

    % Post processing - versione bianca
    imageSize = size(input_image);
    coordinatesIris = [centersI(2), centersI(1), radiI];
    coordinatesPupil = [centers(2), centers(1), radii];
    [xx2,yy2] = ndgrid((1:imageSize(1)),(1:imageSize(2)));
    maskIris = uint8(((xx2-coordinatesIris(1)).^2 + (yy2-coordinatesIris(2)).^2) <= coordinatesIris(3)^2);
    maskPupil = uint8(((xx2-coordinatesPupil(1)).^2 + (yy2-coordinatesPupil(2)).^2) <= coordinatesPupil(3)^2);
    croppedImageIris = uint8(ones(size(input_image(:,:,1)))).*255;
    croppedImagePupil = uint8(ones(size(input_image(:,:,1)))).*255;
    croppedImageIris = croppedImageIris.*maskIris;
    croppedImagePupil = croppedImagePupil.*maskPupil;
    finalCropped = croppedImageIris-croppedImagePupil;
    figure, imshow(finalCropped);
    
    %Post processing - crop della zona dell'iride nell'immagine originale
    croppedImage = uint8(zeros(size(input_image)));
    finalCropped = finalCropped./255;
    croppedImage(:,:,1) = input_image(:,:,1).*finalCropped;
    croppedImage(:,:,2) = input_image(:,:,2).*finalCropped;
    croppedImage(:,:,3) = input_image(:,:,3).*finalCropped;
    figure, imshow(croppedImage);