include <generic/lib.scad>;

use <oem/hcs04_sonar.scad>;

use <chassis_base.scad>;
use <hcs04_sonar_bracket.scad>;
use <bumper_spring_block.partA.scad>

kChassisBaseDatasheet = vChassisBaseDatasheet();
kBumperSpringBlock_PartA_Datasheet = vBumperSpringBlock_PartA_Datasheet();
kHCS04SonarBracketDatasheet = vHCS04SonarBracketDatasheet();

function vBumperBaseDatasheet() =
     let(chassis_height=property(kChassisBaseDatasheet, "height"),
         base_chassis_height=property(kChassisBaseDatasheet, "base_height"),
         chassis_outer_diameter=property(kChassisBaseDatasheet, "outer_diameter"),
         chassis_fillet_radius=property(kChassisBaseDatasheet, "fillet_radius"),
         chassis_support_diameter=property(kChassisBaseDatasheet, "support_diameter"),
         sonar_distance_to_wall=property(kHCS04SonarBracketDatasheet, "distance_to_wall"),
         sonar_mounting_polar_angle=property(kHCS04SonarBracketDatasheet, "mounting_polar_angle"),
         angular_width=2 * property(kBumperSpringBlock_PartA_Datasheet, "angular_offset"),
         travel_distance=property(kBumperSpringBlock_PartA_Datasheet, "spring_travel_distance"))
     [["height", base_chassis_height - chassis_fillet_radius], ["z_offset", chassis_fillet_radius],
      ["angular_width", angular_width], ["travel_distance", travel_distance],
      ["sonar_mounting_radius", chassis_outer_diameter/2 - sonar_distance_to_wall],
      ["sonar_mounting_z_offset", (chassis_height / 2 - chassis_fillet_radius -
                                   sonar_distance_to_wall *
                                   sin(90 - sonar_mounting_polar_angle))],
      ["sonar_mounting_angles", [-40, 0, 40]], ["support_pin_diameter", 4],
      ["support_pin_height", 4], ["support_diameter", chassis_support_diameter],
      ["support_angles", [-angular_width/2+7.5, -22.5, 22.5, angular_width/2-7.5]]];


module mBumperLockXSection() {
     datasheet = vBumperBaseDatasheet();
     angular_width = property(datasheet, "angular_width");

     spring_slot_width = property(kBumperSpringBlock_PartA_Datasheet, "spring_slot_width");
     chassis_outer_diameter = property(kChassisBaseDatasheet, "outer_diameter");
     chassis_inner_diameter = property(kChassisBaseDatasheet, "inner_diameter");
     chassis_thickness = property(kChassisBaseDatasheet, "thickness");

     difference() {
          ring(outer_radius=chassis_outer_diameter/2,
               inner_radius=chassis_inner_diameter/2,
               angles=[-90, 90]);
          translate([0, -chassis_inner_diameter/2 * sin(angular_width/2)]) {
               square([chassis_outer_diameter/2, chassis_inner_diameter * sin(angular_width/2)]);
          }
     }
     duplicate([0, 1, 0]) {
          difference() {
               translate([chassis_inner_diameter/2 * cos(angular_width/2),
                          chassis_inner_diameter/2 * sin(angular_width/2) - chassis_thickness]) {
                    square([chassis_thickness + spring_slot_width, chassis_thickness]);
               }
          }
     }
}

module mBumperBaseComplement() {
     datasheet = vBumperBaseDatasheet();
     height = property(datasheet, "height");
     angular_width = property(datasheet, "angular_width");

     chassis_outer_diameter = property(kChassisBaseDatasheet, "outer_diameter");
     chassis_inner_diameter = property(kChassisBaseDatasheet, "inner_diameter");
     chassis_fillet_radius = property(kChassisBaseDatasheet, "fillet_radius");

     translate([0, -chassis_inner_diameter/2 * sin(angular_width/2), chassis_fillet_radius]) {
          cube([chassis_outer_diameter, chassis_inner_diameter * sin(angular_width/2), height + kEpsilon]);
     }
}



module mBumperBase() {
     datasheet = vBumperBaseDatasheet();
     height = property(datasheet, "height");
     angular_width = property(datasheet, "angular_width");
     travel_distance = property(datasheet, "travel_distance");
     sonar_mounting_angles = property(datasheet, "sonar_mounting_angles");
     sonar_distance_to_wall = property(kHCS04SonarBracketDatasheet, "distance_to_wall");
     sonar_mounting_polar_angle = property(kHCS04SonarBracketDatasheet, "mounting_polar_angle");

     chassis_height = property(kChassisBaseDatasheet, "height");
     chassis_outer_diameter = property(kChassisBaseDatasheet, "outer_diameter");
     chassis_inner_diameter = property(kChassisBaseDatasheet, "inner_diameter");
     chassis_thickness = property(kChassisBaseDatasheet, "thickness");
     base_chassis_height = property(kChassisBaseDatasheet, "base_height");
     chassis_fillet_radius = property(kChassisBaseDatasheet, "fillet_radius");

     render()
     difference() {
          translate([0, 0, chassis_height/2 - chassis_fillet_radius]) {
               difference() {
                    translate([0, 0, chassis_fillet_radius + height/2 - chassis_height/2]) {
                         difference() {
                              translate([0, 0, -chassis_fillet_radius - height/2]) {
                                   mChassisShell();
                              }
                              translate([-chassis_outer_diameter/2 * (1 - cos(angular_width/2)), // - 2 * chassis_thickness,
                                         0, -chassis_height/2]) {
                                   mChassisBBox();
                              }
                              translate([0, 0, -chassis_height - height/2]) mChassisBBox();
                              translate([0, 0, height/2]) mChassisBBox();
                         }
                         duplicate([0, 1, 0]) {
                              duplicate([0, 0, 1]) {
                                   translate([chassis_outer_diameter/2 * cos(angular_width/2),
                                              -chassis_outer_diameter/2 * sin(angular_width/2),
                                              -height/2]) {
                                        mBumperSpringBlock_PartA();
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
          linear_extrude(height=height) {
               for (x = [0:travel_distance]) {
                    translate([x, 0, 0]) {
                         offset(delta=2*kEpsilon) mBumperLockXSection();
                    }
               }
          }
     }
}

mBumperBase();
