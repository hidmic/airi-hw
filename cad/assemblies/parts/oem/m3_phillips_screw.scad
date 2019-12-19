include <generic/lib.scad>;

function vM3PhillipsScrewDatasheet() =
     [["nominal_diameter", 3], ["max_head_diameter", 6], ["max_head_height", 2.52]];

module mM3x6mmPhillipsScrew() {
     color("silver") import_mesh("stl/m3x6mm_phillips_screw.stl");
}

module mM3x12mmPhillipsScrew() {
     color("silver") import_mesh("stl/m3x12mm_phillips_screw.stl");
}

module mM3x20mmPhillipsScrew() {
     color("silver") import_mesh("stl/m3x20mm_phillips_screw.stl");
}


mM3x12mmPhillipsScrew();
