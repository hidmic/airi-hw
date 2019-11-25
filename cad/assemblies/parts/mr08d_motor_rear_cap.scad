include <generic/lib.scad>;

use <oem/mr08d_024022_motor.scad>;
use <oem/35x1_5mm_oring.scad>;


function vMR08DMotorRearCapDatasheet() =
     [["main_diameter", property(vMR08D024022MotorDatasheet(), "bottom_diameter") + 2],
      ["seat_diameter", property(vMR08D024022MotorDatasheet(), "bottom_diameter") - 2],
      ["main_height", 10], ["wall_thickness", 1]];


module mMR08DMotorRearCap() {
     module front_view_section() {
          ring(outer_radius=property(vMR08DMotorRearCapDatasheet(), "main_diameter") / 2,
               inner_radius=property(vMR08DMotorRearCapDatasheet(), "seat_diameter") / 2);
     }
     linear_extrude(height=property(vMR08DMotorRearCapDatasheet(), "main_height")) {
          contour(delta=-property(vMR08DMotorRearCapDatasheet(), "wall_thickness")) {
               front_view_section();
          }
     }
     linear_extrude(height=property(vMR08DMotorRearCapDatasheet(), "wall_thickness")) {
          front_view_section();
     }
}


mMR08DMotorRearCap();
