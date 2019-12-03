
function vM2PhillipsScrewDatasheet() =
     [["nominal_diameter", 2], ["max_head_diameter", 4], ["max_head_height", 1.72]];

module mM2x6mmPhillipsScrew() {
     import("stl/m2x6mm_phillips_screw.stl");
}

mM2x6mmPhillipsScrew();
