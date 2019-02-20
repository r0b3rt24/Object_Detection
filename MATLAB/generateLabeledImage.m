function labeled_img = generateLabeledImage(gray_img, threshold)

bw_img = im2bw(gray_img, threshold(1));
% processed_img = bwmorph(bw_img, 'dilate', 15);
% processed_img = bwmorph(processed_img, 'erode', 15);

labeled_img = bwlabel(bw_img, 8);

end
