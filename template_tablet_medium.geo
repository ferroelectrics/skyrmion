SetFactory("OpenCASCADE");

dot_r = 20;
dot_h = 20;

medium_r = 60;
medium_h = 80;

Cylinder(1) = {0, 0, 0, 0, 0, dot_h, dot_r, 2*Pi};
Cylinder(2) = {0, 0, 0, 0, 0, medium_h, medium_r, 2*Pi};
BooleanDifference(3) = { Volume{2}; Delete; }{ Volume{1}; };

Physical Surface("medium_top") = {5};
Physical Surface("shared_bottom") = {6, 3};
Physical Surface("medium_bottom") = {6};
Physical Surface("dot_bottom") = {3};
Physical Surface("dot_top") = {2};
Physical Surface("dot_side") = {1};
Physical Volume("medium") = {3};
Physical Volume("dot") = {1};

Characteristic Length {3, 4} = 8.0;
Characteristic Length {1, 2} = 1.0;
