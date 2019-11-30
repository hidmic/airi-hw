include <generic/lib.scad>;

use <oem/mr08d_024022_motor.scad>;
// use <oem/35x1_5mm_oring.scad>;


function vMR08DMotorRearCapDatasheet() =
     let (motor_datasheet=vMR08D024022MotorDatasheet())
     [["main_diameter", property(motor_datasheet, "bottom_diameter") + 2],
      ["seat_diameter", property(motor_datasheet, "bottom_diameter") - 2],
      ["main_height", 10], ["wall_thickness", 1]];

module mMR08DMotorRearCap() {
     datasheet = vMR08DMotorRearCapDatasheet();
     main_diameter = property(datasheet, "main_diameter");
     seat_diameter = property(datasheet, "seat_diameter");
     main_height = property(datasheet, "main_height");
     wall_thickness = property(datasheet, "wall_thickness");

     module front_view_section() {
          union() {
               translate([main_diameter / 4, 0]) {
                    square([main_diameter / 2, main_diameter * 0.8], center=true);
               }
               circle(d=main_diameter);
          }
     }

     linear_extrude(height=main_height) {
          outline(delta=-wall_thickness) {
               front_view_section();
          }
     }
     linear_extrude(height=wall_thickness) {
          difference() {
               front_view_section();
               circle(d=seat_diameter);
          }
     }
}

mMR08DMotorRearCap();
