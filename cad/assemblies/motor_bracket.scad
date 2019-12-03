include <generic/lib.scad>;

use <parts/oem/m2_nut.scad>;
use <parts/oem/mr08d_024022_motor.scad>;

use <parts/mr08d_motor_base_bracket.scad>;
use <parts/mr08d_motor_front_cap.scad>;
use <parts/mr08d_motor_rear_cap.scad>;


function vMotorBracketDatasheet() =
     vMR08DMotorBaseBracketDatasheet();

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
}

mMotorBracket();

