include <generic/lib.scad>;

use <oem/mr08d_024022_motor.scad>;
use <oem/m3x5mm_threaded_insert.scad>;

function vMotorBracketDatasheet() =
     let(motor_datasheet=vMR08D024022MotorDatasheet())
     [["width", property(motor_datasheet, "motor_diameter") + 3],
      ["length", property(motor_datasheet, "length")],
      ["bar_width", 5], ["thickness", 1]];

module mMotorBracket() {
     datasheet = vMotorBracketDatasheet();
     length = property(datasheet, "length");
     width = property(datasheet, "width");
     bar_width = property(datasheet, "bar_width");
     thickness = property(datasheet, "thickness");

     difference() {
          hull() {
               square([length, width], center=true);
               duplicate([1, 0, 0]) {
                    // Use M3 screws for tensioner
                    translate([length/2 + 10, 0]) {
                         circle(d=10);
                    }
               }
          }
          duplicate([1, 0, 0]) {
               polygon([[length/2 - bar_width, width/2 - bar_width * width / length - bar_width/2 / sin(atan(length/width))],
                       [length/2 - bar_width, -(width/2 - bar_width * width / length - bar_width/2 / sin(atan(length/width)))],
                        [bar_width/2 / cos(atan(length/width)), 0]]);
          }
          duplicate([0, 1, 0]) {
               polygon([[-(length/2 - bar_width * length / width - bar_width/2 / sin(atan(width/length))), width/2 - bar_width],
                        [length/2 - bar_width * length / width - bar_width/2 / sin(atan(width/length)), width/2 - bar_width],
                        [0, bar_width/2 / cos(atan(width/length))]]);
          }
     }
}

mMotorBracket();
