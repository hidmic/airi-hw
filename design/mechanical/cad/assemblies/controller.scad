include <generic/lib.scad>;

use <parts/oem/stm32_disco.scad>;

function vControllerDatasheet() =
     [["width", 120], ["length", 85], ["height", 54],
      ["support_locations", [[39, 56.5], [-39, -56.5]]]];

module mControllerConnectorCutout() {
     translate([0, 57]) square([65, 7.5], center=true);
     translate([0, -57]) square([65, 7.5], center=true);
     translate([-38, -20.75]) square([7.5, 65], center=true);
}

module mController() {
     rotate([0, 0, -90]) {
          translate([-60, -42.5, 0]) {
               import_mesh("stl/power_board.stl");
               translate([20, 10, 24]) {
                    color("green") import_mesh("stl/base_board.stl");
               }
               translate([0, 0, 37]) {
                    color("red") import_mesh("stl/bridge_board.stl");
               }
               translate([54, 47, 48]) {
                    rotate([0, 0, -90]) mSTM32Disco();
               }
          }
     }
}

mController();
