function post_process(input_image, image_file, centers, radii, centersI, radiI)
     
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
    imwrite(finalCropped, [image_file, '_segw.jpg'], 'jpg');
    
    %Post processing - crop della zona dell'iride nell'immagine originale
    croppedImage = uint8(zeros(size(input_image)));
    finalCropped = finalCropped./255;
    croppedImage(:,:,1) = input_image(:,:,1).*finalCropped;
    croppedImage(:,:,2) = input_image(:,:,2).*finalCropped;
    croppedImage(:,:,3) = input_image(:,:,3).*finalCropped;
    figure, imshow(croppedImage);
    imwrite(croppedImage, [image_file, '_segc.jpg'], 'jpg');
end

