include <generic/lib.scad>;

function vKW10Z1PMicroSwitchDatasheet() =
     [["width", 12.8], ["height", 6.5],
      ["depth", 5.8], ["terminal_length", 3],
      ["lever_height", 2],
      ["mounting_hole_offset", 1.5],
      ["mounting_hole_distance", 6.5],
      ["mounting_hole_diameter", 2]];

module mKW10Z1PMicroSwitch() {
     translate([kEpsilon/2, 0, 0])
     rotate([0, 0, 90]) scale(10) import("stl/kw10_z1p_micro_switch.stl");
}

mKW10Z1PMicroSwitch();
