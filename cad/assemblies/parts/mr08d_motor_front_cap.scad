include <generic/lib.scad>;

use <generic/motor_cap.scad>;

use <oem/m2_nut.scad>;
use <oem/m2_phillips_screw.scad>;
use <oem/mr08d_024022_motor.scad>;

function vMR08DMotorFrontCapDatasheet() =
     let(motor_datasheet=vMR08D024022MotorDatasheet(),
         inner_diameter=property(motor_datasheet, "gear_box_diameter"),
         seat_diameter=property(motor_datasheet, "bearing_diameter"))
     pvMotorCapDatasheet(inner_diameter=inner_diameter, seat_diameter=seat_diameter, wall_thickness=1, height=6,
                         motor_datasheet=motor_datasheet, fastening_screw_datasheet=vM2PhillipsScrewDatasheet(),
                         fastening_nut_datasheet=vM2NutDatasheet());

module mMR08DMotorFrontCapNut() {
     mM2Nut();
}

module mMR08DMotorFrontCapScrew() {
     mM2x10mmPhillipsScrew();
}


module mMR08DMotorFrontCap() {
     datasheet = vMR08DMotorFrontCapDatasheet();
     wall_thickness = property(datasheet, "wall_thickness");

     color($default_color) {
          render() {
               pmMotorCap(datasheet) {
                    let (motor_datasheet=property(datasheet, "motor_datasheet")) {
                         for(angle = property(motor_datasheet, "mount_angles")) {
                              rotate([0, 0, angle]) {
                                   translate([property(motor_datasheet, "mount_r_offset")/2, 0]) {
                                        circle(d=property(motor_datasheet, "mount_hole_diameter"));
                                   }
                              }
                         }
                    }
               }
          }
     }
}

mMR08DMotorFrontCap();
