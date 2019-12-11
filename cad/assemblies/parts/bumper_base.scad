include <generic/lib.scad>;

use <oem/hcs04_sonar.scad>;
use <oem/kw10_micro_switch.scad>;

use <chassis_base.scad>;
use <hcs04_sonar_bracket.scad>;
use <bumper_spring_block.scad>;


function vBumperBaseDatasheet() =
     let(chassis_datasheet=vChassisBaseDatasheet(),
         spring_block_datasheet=vBumperSpringBlockDatasheet(),
         switch_datasheet=vKW10Z1PMicroSwitchDatasheet(),
         sonar_bracket_datasheet=vHCS04SonarBracketDatasheet(),
         switch_width=property(switch_datasheet, "width"),
         chassis_height=property(chassis_datasheet, "height"),
         base_chassis_height=property(chassis_datasheet, "base_height"),
         chassis_thickness=property(chassis_datasheet, "thickness"),
         chassis_outer_diameter=property(chassis_datasheet, "outer_diameter"),
         chassis_fillet_radius=property(chassis_datasheet, "fillet_radius"),
         chassis_support_diameter=property(chassis_datasheet, "support_diameter"),
         sonar_distance_to_wall=property(sonar_bracket_datasheet, "distance_to_wall"),
         sonar_mounting_polar_angle=property(sonar_bracket_datasheet, "mounting_polar_angle"),
         angular_width=2 * property(spring_block_datasheet, "angular_offset"),
         spring_block_width=property(spring_block_datasheet, "front_block_width"),
         spring_gap_width=property(spring_block_datasheet, "spring_gap_width"))
     [["height", base_chassis_height - chassis_fillet_radius], ["z_offset", chassis_fillet_radius],
      ["angular_width", angular_width], ["lock_width", spring_block_width - switch_width - 1],
      ["sonar_mounting_radius", chassis_outer_diameter/2 - sonar_distance_to_wall],
      ["sonar_mounting_z_offset", (chassis_height / 2 - chassis_fillet_radius -
                                   sonar_distance_to_wall * sin(90 - sonar_mounting_polar_angle))],
      ["sonar_mounting_angles", [-40, 0, 40]], ["support_pin_diameter", 4],
      ["support_pin_height", 4], ["support_diameter", chassis_support_diameter],
      ["support_angles", [-angular_width/2+10, -22.5, 22.5, angular_width/2-10]]];


module mBumperLockXSection() {
     datasheet = vBumperBaseDatasheet();
     chassis_datasheet = vChassisBaseDatasheet();
     lock_width = property(datasheet, "lock_width");
     angular_width = property(datasheet, "angular_width");
     chassis_outer_diameter = property(chassis_datasheet, "outer_diameter");
     chassis_inner_diameter = property(chassis_datasheet, "inner_diameter");
     chassis_thickness = property(chassis_datasheet, "thickness");

     difference() {
          ring(outer_radius=chassis_outer_diameter/2,
               inner_radius=chassis_inner_diameter/2,
               angles=[-90, 90], fn=128);
          translate([0, -chassis_inner_diameter/2 * sin(angular_width/2)]) {
               square([chassis_outer_diameter/2, chassis_inner_diameter * sin(angular_width/2)]);
          }
     }
     duplicate([0, 1, 0]) {
          difference() {
               translate([(chassis_outer_diameter + chassis_inner_diameter)/4 * cos(angular_width/2) + chassis_thickness,
                          -chassis_inner_diameter/2 * sin(angular_width/2)]) {
                    square([lock_width, chassis_thickness]);
               }
          }
     }
}

module mBumperBaseComplement() {
     datasheet = vBumperBaseDatasheet();
     height = property(datasheet, "height");
     angular_width = property(datasheet, "angular_width");

     chassis_datasheet = vChassisBaseDatasheet();
     chassis_outer_diameter = property(chassis_datasheet, "outer_diameter");
     chassis_inner_diameter = property(chassis_datasheet, "inner_diameter");
     chassis_fillet_radius = property(chassis_datasheet, "fillet_radius");

     translate([0, -chassis_inner_diameter/2 * sin(angular_width/2), chassis_fillet_radius]) {
          cube([chassis_outer_diameter, chassis_inner_diameter * sin(angular_width/2), height + kEpsilon]);
     }
}

module mBumperBase() {
     datasheet = vBumperBaseDatasheet();
     height = property(datasheet, "height");
     lock_width = property(datasheet, "lock_width");
     angular_width = property(datasheet, "angular_width");
     sonar_mounting_angles = property(datasheet, "sonar_mounting_angles");

     sonar_bracket_datasheet = vHCS04SonarBracketDatasheet();
     sonar_distance_to_wall = property(sonar_bracket_datasheet, "distance_to_wall");
     sonar_mounting_polar_angle = property(sonar_bracket_datasheet, "mounting_polar_angle");

     chassis_datasheet = vChassisBaseDatasheet();
     chassis_height = property(chassis_datasheet, "height");
     chassis_outer_diameter = property(chassis_datasheet, "outer_diameter");
     chassis_inner_diameter = property(chassis_datasheet, "inner_diameter");
     chassis_thickness = property(chassis_datasheet, "thickness");
     base_chassis_height = property(chassis_datasheet, "base_height");
     chassis_fillet_radius = property(chassis_datasheet, "fillet_radius");

     spring_block_datasheet = vBumperSpringBlockDatasheet();
     spring_block_x_offset = property(spring_block_datasheet, "x_offset");
     spring_block_y_offset = property(spring_block_datasheet, "y_offset");
     spring_block_width = property(spring_block_datasheet, "front_block_width");

     difference() {
          union() {
               translate([0, 0, chassis_height/2 - chassis_fillet_radius]) {
                    difference() {
                         translate([0, 0, chassis_fillet_radius + height/2 - chassis_height/2]) {
                              difference() {
                                   translate([0, 0, -chassis_fillet_radius - height/2]) {
                                        mChassisShell();
                                   }
                                   translate([-chassis_outer_diameter/2 * (1 - cos(angular_width/2)), 0, -chassis_height/2]) {
                                        mChassisBBox();
                                   }
                                   translate([0, 0, -chassis_height - height/2]) mChassisBBox();
                                   translate([0, 0, height/2]) mChassisBBox();
                              }
                              duplicate([0, 1, 0]) {
                                   duplicate([0, 0, 1]) {
                                        translate([spring_block_x_offset, spring_block_y_offset, -height/2]) {
                                             mBumperSpringFrontBlock();
                                        }
                                   }
                              }
                         }
                         for (angle = sonar_mounting_angles) {
                              rotate([0, 0, angle]) {
                                   translate([chassis_outer_diameter/2 - sonar_distance_to_wall, 0,
                                              -sonar_distance_to_wall * sin(90 - sonar_mounting_polar_angle)])  {
                                        rotate([0, sonar_mounting_polar_angle, 0]) {
                                             mHCS04SonarBracket();
                                             translate([0, 0, chassis_thickness]) {
                                                  mHCS04SonarFrustum();
                                             }
                                        }
                                   }
                              }
                         }
                    }
               }
               duplicate([0, 1, 0]) {
                    translate([spring_block_x_offset, spring_block_y_offset, 0]) {
                         cube([lock_width, lock_width, height]);
                    }
               }
          }
          linear_extrude(height=height) {
               for (x = [0:lock_width]) {
                    translate([x, 0, 0]) {
                         offset(delta=2*kEpsilon) mBumperLockXSection();
                    }
               }
          }
     }
}

mBumperBase();
