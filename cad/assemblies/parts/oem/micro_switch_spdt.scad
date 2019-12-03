include <generic/lib.scad>;


function vMicroSwitchSPDTDatasheet() =
     [["width", 12], ["height", 6], ["depth", 6],
      ["mounting_hole_distance", 6.5], ["mounting_hole_diameter", 2]];

module mMicroSwitchSPDT() {
     translate([0, 0, -0.5])
     import("stl/micro_switch_spdt.stl");
}

mMicroSwitchSPDT();
