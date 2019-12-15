
function vM3PhillipsScrewDatasheet() =
     [["nominal_diameter", 3], ["max_head_diameter", 6], ["max_head_height", 2.52]];

module mM3x6mmPhillipsScrew() {
     import("stl/m3x6mm_phillips_screw.stl");
}

module mM3x12mmPhillipsScrew() {
     import("stl/m3x12mm_phillips_screw.stl");
}

module mM3x20mmPhillipsScrew() {
     import("stl/m3x20mm_phillips_screw.stl");
}


mM3x12mmPhillipsScrew();
