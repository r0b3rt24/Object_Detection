function [db, out_img] = compute2DProperties(orig_img, labeled_img)


num_img = max(max(labeled_img));
% 1: Obj_label, 2: Row position of the center, 3. Column Position of the
% center, 4: the minum moment of the inertia 5: The orientation
% 6 the roundness

% Get boundries
[B,L] = bwboundaries(labeled_img,'noholes');
db = zeros(8,num_img);
fh1 = figure();
imshow(orig_img);

stats = regionprops('table',labeled_img,'Centroid',...
    'MajorAxisLength','MinorAxisLength', 'orientation')

for i = 1:num_img
    disp(i);
    % Get all seperated shapes
    [row, col] = find(labeled_img == i);
    Xcenter = round(mean(col));  % calculate center of columns
    Ycenter = round(mean(row));  % calculate center of rows
    hold on;plot(Xcenter, Ycenter, '.', 'MarkerSize', 15); % Plot the dot
    
    % shift it to origin
    shiftedI = row - Ycenter;
    shiftedJ = col - Xcenter;
    
    % calculate a, b, c
    a = sumsqr(shiftedI);
    b = 2 * sum(shiftedJ.*shiftedI);
    c = sumsqr(shiftedJ);
    disp("abc:");disp(a);disp(b);disp(c);
    
    % calculate the orientation 
    oriRadMax = atan2(b, a-c)/2; % In radius
    oriRad = atan2(b, a-c)/2 + 0.5*pi; % in degree
    ori = radtodeg(oriRad); % adujest the position
    cosOri = cosd(ori);
    sinOri = sind(ori);
    disp("Ori:");
    disp(ori);
    
    %Calculate the Emax and Emin 
    E1 = a.*(sin(oriRad)^2) - b.* sin(oriRad) .* cos(oriRad) + c.*(cos(oriRad)^2);
    E2 = a.*(sin(oriRadMax)^2) - b.* sin(oriRadMax) .* cos(oriRadMax) + c.*(cos(oriRadMax)^2);
    Emax = max(E1,E2);
    Emin = min(E1,E2);
    
    disp("Emin, Emax:")
    disp(Emin);
    disp(Emax);
    
    %Calculus roundness
    boundary = B{i};
    delta_sq = diff(boundary).^2;
    area = numel(find(labeled_img == i));
    roundness = Emin/Emax;
    disp("Roundness:")
    disp(roundness)
    
    % My own property
    propEmaxArea = Emax/area;
    
    % Draw the line
    xcoords = Xcenter + 100 * [cosOri -cosOri];
    ycoords = Ycenter + 100 * [-sinOri sinOri];
    line(xcoords, ycoords,'LineWidth',3);
    
    db(1,i) = i;
    db(2,i) = Ycenter;
    db(3,i) = Xcenter;
    db(4,i) = Emin;
    db(5,i) = ori;
    db(6,i) = roundness;
    db(7,i) = propEmaxArea;
    
end
out_img = saveAnnotatedImg(fh1);

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