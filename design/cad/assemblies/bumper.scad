include <generic/lib.scad>;

use <parts/oem/hcs04_sonar.scad>;
use <parts/oem/kw10_micro_switch.scad>;
use <parts/oem/f066_sae1070_spring.scad>;
use <parts/oem/m2_countersunk_screw.scad>;
use <parts/oem/m2_nut.scad>;

use <parts/hcs04_sonar_bracket.scad>;

use <parts/chassis_base.scad>;

use <parts/bumper_base.scad>;
use <parts/bumper_spring_block.scad>;
use <parts/bumper.partA.scad>;
use <parts/bumper.partB.scad>;

function vBumperDatasheet() = vBumperBaseDatasheet();

module mBumper() {
     datasheet = vBumperDatasheet();
     bumper_height = property(datasheet, "height");
     bumper_z_offset = property(datasheet, "z_offset");
     sonar_mounting_angles = property(datasheet, "sonar_mounting_angles");
     sonar_mounting_radius = property(datasheet, "sonar_mounting_radius");
     sonar_mounting_z_offset = property(datasheet, "sonar_mounting_z_offset");

     sonar_mounting_polar_angle = property(vHCS04SonarBracketDatasheet(), "mounting_polar_angle");
     bracket_thickness = property(vHCS04SonarBracketDatasheet(), "thickness");

     translate([0, 0, bumper_z_offset]) {
          union() {
               mBumper_PartA();
               mBumper_PartB();
          }
          for (angle = sonar_mounting_angles) {
               rotate([0, 0, angle]) {
                    translate([sonar_mounting_radius, 0, sonar_mounting_z_offset])  {
                         rotate([0, sonar_mounting_polar_angle, 0]) {
                              mHCS04SonarBracket();
                              translate([0, 0, bracket_thickness + 2]) {
                                   mHCS04Sonar();
                              }
                         }
                    }
               }
          }
          translate([0, 0, bumper_height/2]) {
               duplicate([0, 1, 0]) {
                    duplicate([0, 0, 1]) {
                         translate([0, 0, -bumper_height/2]) {
                              let (spring_block_datasheet=vBumperSpringBlockDatasheet()) {
                                   translate([property(spring_block_datasheet, "x_offset"),
                                              property(spring_block_datasheet, "y_offset"),
                                              0]) {
                                        translate([property(spring_block_datasheet, "switch_x_offset"),
                                                   property(spring_block_datasheet, "switch_y_offset"),
                                                   0]) {
                                             translate([0, 0, property(spring_block_datasheet, "switch_z_offset")]) {
                                                  mKW10Z1PMicroSwitch();
                                             }
                                             let(switch_datasheet=vKW10Z1PMicroSwitchDatasheet(),
                                                 switch_height=property(switch_datasheet, "height"),
                                                 switch_mounting_hole_offset=property(switch_datasheet, "mounting_hole_offset"),
                                                 switch_mounting_hole_distance=property(switch_datasheet, "mounting_hole_distance")) {
                                                  translate([switch_height/2 - switch_mounting_hole_offset + 2 * kEpsilon, 0, 0]) {
                                                       duplicate([0, 1, 0]) {
                                                            translate([0, switch_mounting_hole_distance/2, 0]) {
                                                                 translate([0, 0, -kEpsilon]) mM2x20mmCountersunkScrew();
                                                                 translate([0, 0, (property(spring_block_datasheet, "switch_z_offset") +
                                                                                   property(switch_datasheet, "depth")/2)]) {
                                                                      mM2Nut();
                                                                 }
                                                            }
                                                       }
                                                  }
                                             }
                                        }
                                        translate([property(spring_block_datasheet, "spring_x_offset"),
                                                   property(spring_block_datasheet, "spring_y_offset"),
                                                   property(spring_block_datasheet, "spring_z_offset")]) {
                                             rotate([0, -90, 0]) mF066SAE1070Spring(
                                                  property(spring_block_datasheet, "spring_length")
                                             );
                                        }

                                   }
                              }
                         }
                    }
               }
          }
          let(outer_diameter=property(vChassisBaseDatasheet(), "outer_diameter"),
              rubber_angular_width=property(datasheet, "angular_width") - 20,
              rubber_thickness=5, rubber_width=15) {
               color("black") {
                    for (z = [12.5, 35, 90]) {
                         translate([0, 0, z]) {
                              rotate([0, 0, -rubber_angular_width/2]) {
                                   rotate_extrude(angle=rubber_angular_width) {
                                        translate([outer_diameter/2, -rubber_width/2, 0]) {
                                             square([rubber_thickness, rubber_width]);
                                        }
                                   }
                              }
                         }
                    }
               }
          }
     }
}


mBumper();
