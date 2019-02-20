function output_img = recognizeObjects(orig_img, labeled_img, obj_db)


% Generate the information we need from the target
% 1. Xcenter 2. Ycenter%
% 3. Roundness 4. Inertia/Area

target_db = compute2DProperties(orig_img, labeled_img);
[rows_target, cols_target] = size(target_db);
[rows_obj, cols_obj] = size(obj_db);

fh1 = figure();
imshow(orig_img);
for i = 1 : cols_obj
    for j = 1 : cols_target
        if  (abs(target_db(7,j) - obj_db(7,i)) < 63) && ((abs(target_db(6,j) - obj_db(6,i)) < 0.048))
            hold on;plot(target_db(3, j), target_db(2, j), '.', 'MarkerSize', 15);
            cosOri = cosd(target_db(5, j));
            sinOri = sind(target_db(5, j));
            xcoords = target_db(3, j) + 100 * [cosOri -cosOri];
            ycoords = target_db(2, j) + 100 * [-sinOri sinOri];
            line(xcoords, ycoords,'LineWidth',3);
        end
    end
end

output_img = saveAnnotatedImg(fh1);


function annotated_img = saveAnnotatedImg(fh)
figure(fh); % Shift the focus back to the figure fh

% The figure needs to be undocked
set(fh, 'WindowStyle', 'normal');

% The following two lines just to make the figure true size to the
% displayed image. The reason will become clear later.
img = getimage(fh);
truesize(fh, [size(img, 1), size(img, 2)]);

% getframe does a screen capture of the figure window, as a result, the
% displayed figure has to be in true size.
frame = getframe(fh);
frame = getframe(fh);
pause(0.5);
% Because getframe tries to perform a screen capture. it somehow
% has some platform depend issues. we should calling
% getframe twice in a row and adding a pause afterwards make getframe work
% as expected. This is just a walkaround.
annotated_img = frame.cdata;