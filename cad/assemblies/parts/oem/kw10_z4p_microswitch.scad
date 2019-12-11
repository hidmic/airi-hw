include <generic/lib.scad>;

function vKW10Z4PMicroSwitchDatasheet() =
     [["width", 12.8], ["height", 6.5], ["depth", 5.8],
      ["full_width", 16], ["terminal_length", 3],
      ["mounting_hole_offset", 1.5],
      ["mounting_hole_distance", 6.5],
      ["mounting_hole_diameter", 2]];

module mKW10Z4PMicroSwitch() {
     translate([0, 0, -0.5])
     import("stl/micro_switch_spdt.stl");
}

mKW10Z4PMicroSwitch();
