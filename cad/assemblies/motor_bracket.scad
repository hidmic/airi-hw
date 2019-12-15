include <generic/lib.scad>;

use <parts/oem/m2_nut.scad>;
use <parts/oem/m3_phillips_screw.scad>;
use <parts/oem/mr08d_024022_motor.scad>;
use <parts/oem/gt2_pulley.scad>;

use <parts/mr08d_motor_base_bracket.scad>;
use <parts/mr08d_motor_front_cap.scad>;
use <parts/mr08d_motor_rear_cap.scad>;


function vMotorBracketDatasheet() =
     let (motor_datasheet=vMR08D024022MotorDatasheet())
     concat(
          [["shaft_y_offset", (property(motor_datasheet, "length")/2 +
                               property(motor_datasheet, "shaft_length"))]],
          vMR08DMotorBaseBracketDatasheet()
     );

module mMotorBracket() {
     datasheet = vMotorBracketDatasheet();

     mMR08DMotorBaseBracket();

     translate([property(datasheet, "rear_cap_x_offset"), 0, property(datasheet, "rear_cap_z_offset")]) {
          let(cap_datasheet=property(datasheet, "rear_cap_datasheet")) {
               translate([-property(cap_datasheet, "height")/2, 0, property(cap_datasheet, "outer_diameter")/2]) {
                    rotate([0, 90, 0]) {
                         mMR08DMotorBracketRearCap();
                         for (loc = property(cap_datasheet, "fastening_locations")) {
                              translate(loc) {
                                   let(nut_datasheet=property(cap_datasheet, "fastening_nut_datasheet")) {
                                        translate([0, 0, property(cap_datasheet, "height") - property(nut_datasheet, "m_max")]) {
                                             mMR08DMotorBracketRearCapNut();
                                        }
                                        translate([0, 0, -property(cap_datasheet, "wall_thickness")]) {
                                             mMR08DMotorBracketRearCapScrew();
                                        }
                                   }
                              }
                         }
                    }
               }
          }
     }

     translate([property(datasheet, "front_cap_x_offset"), 0, property(datasheet, "front_cap_z_offset")]) {
          let(cap_datasheet=property(datasheet, "front_cap_datasheet")) {
               translate([property(cap_datasheet, "height")/2, 0, property(cap_datasheet, "outer_diameter")/2]) {
                    rotate([0, 90, 180]) {
                         mMR08DMotorBracketFrontCap();
                         for (loc = property(cap_datasheet, "fastening_locations")) {
                              translate(loc) {
                                   let(nut_datasheet=property(cap_datasheet, "fastening_nut_datasheet")) {
                                        translate([0, 0, property(cap_datasheet, "height") - property(nut_datasheet, "m_max")]) {
                                             mMR08DMotorBracketFrontCapNut();
                                        }
                                        translate([0, 0, -property(cap_datasheet, "wall_thickness")]) {
                                             mMR08DMotorBracketFrontCapScrew();
                                        }
                                   }
                              }
                         }
                         let (motor_datasheet=property(cap_datasheet, "motor_datasheet")) {
                              for(angle = property(motor_datasheet, "mount_angles")) {
                                   rotate([0, 0, angle]) {
                                        translate([property(motor_datasheet, "mount_r_offset")/2, 0]) {
                                             mirror([0, 0, 1]) mM3x6mmPhillipsScrew();
                                        }
                                   }
                              }
                         }
                    }
               }
          }
     }

     let (hole_to_hole_x_distance=property(datasheet, "hole_to_hole_x_distance"),
          hole_to_hole_y_distance=property(datasheet, "hole_to_hole_y_distance"),
          height=property(property(datasheet, "rear_cap_support_datasheet"), "height"),
          base_thickness=property(datasheet, "base_thickness")) {
          for (x = [-hole_to_hole_x_distance/2, hole_to_hole_x_distance/2]) {
               for (y = [-hole_to_hole_y_distance/2, hole_to_hole_y_distance/2]) {
                    translate([x, y, base_thickness + height]) mMR08DMotorBracketThreadInsert();
               }
          }
     }
     translate([0, 0, property(datasheet, "motor_z_offset")]) {
          translate([property(datasheet, "inner_length")/2, 0, 0]) {
               mMR08D024022Motor();
          }
     }
}

mMotorBracket();

