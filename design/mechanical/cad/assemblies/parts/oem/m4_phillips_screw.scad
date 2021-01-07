include <generic/lib.scad>;

function vM4PhillipsScrewDatasheet() =
     [["nominal_diameter", 4], ["max_head_diameter", 8], ["max_head_height", 3.25]];

module mM4x12mmPhillipsScrew() {
     color("silver") import_mesh("stl/m4x12mm_phillips_screw.stl");
}

module mM4x16mmPhillipsScrew() {
     color("silver") import_mesh("stl/m4x16mm_phillips_screw.stl");
}


mM4x12mmPhillipsScrew();
