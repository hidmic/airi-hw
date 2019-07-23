include <specs.scad>;


translate([0, 32, 0])
mWormGear();


mRubberWheel();

translate([-40, 32, 24])
rotate([0, 90, 0])
mMM012003();
