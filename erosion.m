function image = erosion(img);


ring = strel('disk', 4);
image = imerode(img, ring);
end