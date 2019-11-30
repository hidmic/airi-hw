
function vM3x12mmPhillipsScrewDatasheet() =
     [["nominal_diameter", 3], ["max_head_diameter", 5.7], ["max_head_height", 2.4]];

module mM3x12mmPhillipsScrew() {
     import("stl/m3x12mm_phillips_screw.stl");
}

mM3x12mmPhillipsScrew();
