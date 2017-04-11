function progetto(image_file)
	close all;
    warning off;
	% Mostriamo l'immagine
    input_image = imread(image_file);
	figure, imshow(input_image);
    sizeIm = size(input_image);
    
    irisRadius = [160, 220];
    pupilRadius = [30, 100];
    if (sizeIm(1) > 600) && (sizeIm(2) > 800)
        eyeDetection = vision.CascadeObjectDetector('LeftEye');
        eyeDetection.MinSize = [300 300];
        bboxEye = step(eyeDetection, input_image);
        sizeBox = size(bboxEye);
        if sizeBox(1) == 0
            eyeDetection = vision.CascadeObjectDetector('RightEye');
            eyeDetection.MinSize = [300 300];
            bboxEye = step(eyeDetection, input_image);
        end
        bboxEye(3) = 800;
        bboxEye(4) = 600;
        prova = insertObjectAnnotation(input_image, 'rectangle', bboxEye, 'Eye');
        figure, imshow(prova);
        input_image = imcrop(input_image, bboxEye);
        figure, imshow(input_image);
        irisRadius = [100, 200];
        pupilRadius = [20, 40];
    end
    
    
    % Cattura zona iride
    % Preprocessing
    im2 = rgb2gray(input_image);
    im3 = im2bw(histeq(im2), 0.5);
    % Usiamo imfindcircles per trovare cerchi di raggio 
    % tra 160 e 220 all'interno dell'immagine 
    [centersI, radiI] = imfindcircles(im3, irisRadius, 'Sensitivity', .99, 'ObjectPolarity', 'dark');
    dim = size(centersI);
    if dim(1) > 1
        centersI = centersI(1,:);
        radiI = radiI(1);
    end
    % Visualizziamo l'iride, evidenziando la sua zona di blu
    viscircles(centersI, radiI, 'EdgeColor', 'b');

	% Cattura zona pupilla
    % Preprocessing
    imageSize = size(input_image);
    input_image_filled = imcomplement(imfill(imcomplement(input_image(:,:,1)),'holes'));
    %figure, imshow(input_image_filled);
    coordinatesIris = [centersI(2), centersI(1), radiI];
    [xx,yy] = ndgrid((1:imageSize(1)),(1:imageSize(2)));
    maskIris = uint8(((xx-coordinatesIris(1)).^2 + (yy-coordinatesIris(2)).^2) <= coordinatesIris(3)^2);
    croppedImage = input_image_filled.*maskIris;
    %figure, imshow(croppedImage);
	im_red = croppedImage(:,:,1);
    %figure, imshow(im_red);
	gaussian_filter = fspecial('gaussian', [800 600], 5);
	double_im = double(im_red);
	im_filter = imfilter(double_im, gaussian_filter);
    edges = edge(im_filter, 'canny', 0.1,5);
    % Usiamo imfindcircles per trovare cerchi di raggio 
    % tra 35 e 60 all'interno dell'immagine 
    [centers, radii] = imfindcircles(edges, pupilRadius, 'Sensitivity', .99, 'ObjectPolarity', 'dark');
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
    % Visualizziamo la pupilla, evidenziando la sua zona di rosso
    viscircles(centers, radii, 'EdgeColor', 'r');
    
    % Eseguiamo un post_processing dell'immagine,
    % e salviamo il file
    post_process(input_image, image_file, centers, radii, centersI, radiI);
end