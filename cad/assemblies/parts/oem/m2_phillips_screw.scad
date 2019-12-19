include <generic/lib.scad>;


function vM2PhillipsScrewDatasheet() =
     [["nominal_diameter", 2], ["max_head_diameter", 4], ["max_head_height", 1.72]];

module mM2x6mmPhillipsScrew() {
     color("silver") import_mesh("stl/m2x6mm_phillips_screw.stl");
}

module mM2x10mmPhillipsScrew() {
     color("silver") import_mesh("stl/m2x10mm_phillips_screw.stl");
}


translate([10, 0, 0])
mM2x6mmPhillipsScrew();

mM2x10mmPhillipsScrew();
