%function progetto(input_image)
	close all;
	% Mostriamo l'immagine
    input_image = imread('../UBIRIS_800_600/Sessao_1/2/Img_2_1_2.jpg');
	figure, imshow(input_image);

	%Inizio preprocessing

	% Controllando le immagini, abbiamo notato che la parte rossa
	% si presta meglio alla segmentazione (rimane più nitida)
	im_red = input_image(:,:,1);
    figure, imshow(im_red);

	% Applichiamo un filtro gaussiano
	gaussian_filter = fspecial('gaussian', [800 600], 5);
	double_im = double(im_red);
	im_filter = imfilter(double_im, gaussian_filter);
    %%figure, imshow(im_filter);

    %Edge detection
    %Usiamo un canny edge detector
    edges = edge(im_filter, 'canny', 0.1,5);
    figure, imshow(edges);
       
    % Usiamo imfindcircles per trovare oggetti circolari
    % all''interno dell''immagine
    
    % Pupilla
    [centers, radii, metric] = imfindcircles(edges, [35, 60]);
    %%[accum, centers, radii] = CircularHough_Grd(edges, [40 70]);
    viscircles(centers, radii, 'EdgeColor', 'r');
    %%figure, imshow(accum);
    %DrawCircle(accum)
    
    % Iride, fatto in modo diverso perchè imfindcircles non funziona
    % altrimenti
    im2 = rgb2gray(input_image);
    im3 = im2bw(im2, 0.5);
    [centers, radii] = imfindcircles(im3, [180, 220], 'Sensitivity', .99, 'ObjectPolarity', 'dark');
    viscircles(centers(1,:), radii(1), 'EdgeColor', 'b');
