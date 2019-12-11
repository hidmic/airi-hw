include <generic/lib.scad>;

use <../chassis.scad>
use <../motor_block.scad>

function vBoardSupportDatasheet() =
     [["height", 8],
      ["length", 120],
      ["width", property(vMotorBlockDatasheet(), "outer_width")]];

module mBoardSupport() {
     datasheet = vBoardSupportDatasheet();
     color("white", 0.3) {
          linear_extrude(height=property(datasheet, "height")) {
               square([property(datasheet, "length"),
                       property(datasheet, "width")], center=true);
          }
     }
}

mBoardSupport();
