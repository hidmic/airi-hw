include <generic/lib.scad>;

use <oem/hcs04_sonar.scad>;

use <chassis_base.scad>;
use <hcs04_sonar_bracket.scad>;
use <bumper_spring_block.partA.scad>

kChassisBaseDatasheet = vChassisBaseDatasheet();
kBumperSpringBlock_PartA_Datasheet = vBumperSpringBlock_PartA_Datasheet();
kHCS04SonarBracketDatasheet = vHCS04SonarBracketDatasheet();

function vBumperBaseDatasheet() =
     let(base_chassis_height=property(kChassisBaseDatasheet, "base_height"),
         chassis_fillet_radius=property(kChassisBaseDatasheet, "fillet_radius"),
         chassis_support_diameter=property(kChassisBaseDatasheet, "support_diameter"),
         angular_width=2 * property(kBumperSpringBlock_PartA_Datasheet, "angular_offset"),
         travel_distance=property(kBumperSpringBlock_PartA_Datasheet, "spring_travel_distance"))
     [["height", base_chassis_height - chassis_fillet_radius], ["angular_width", angular_width],
      ["travel_distance", travel_distance], ["sonar_mounting_angles", [-40, 0, 40]],
      ["support_diameter", chassis_support_diameter], ["support_pin_diameter", 4], ["support_pin_height", 4],
      ["support_angles", [-angular_width/2+7.5, -22.5, 22.5, angular_width/2-7.5]]];

module mBumperBase() {
     datasheet = vBumperBaseDatasheet();
     height = property(datasheet, "height");
     angular_width = property(datasheet, "angular_width");
     sonar_mounting_angles = property(datasheet, "sonar_mounting_angles");
     sonar_distance_to_wall = property(kHCS04SonarBracketDatasheet, "distance_to_wall");
     sonar_mounting_polar_angle = property(kHCS04SonarBracketDatasheet, "mounting_polar_angle");

     chassis_height = property(kChassisBaseDatasheet, "height");
     chassis_outer_diameter = property(kChassisBaseDatasheet, "outer_diameter");
     chassis_thickness = property(kChassisBaseDatasheet, "thickness");
     base_chassis_height = property(kChassisBaseDatasheet, "base_height");
     chassis_fillet_radius = property(kChassisBaseDatasheet, "fillet_radius");

     render()
     difference() {
          // TBD
          translate([0, 0, height/2]) { // chassis_height/2 - chassis_fillet_radius]) {
               difference() {
                    translate([0, 0, 0]) { //chassis_fillet_radius + height/2 - chassis_height/2]) {
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
          /* linear_extrude(height=kChassisBaseHeight + kEpsilon) { */
          /*      for (x = [0:kBumperTravelDistance]) { */
          /*           translate([x, 0, 0]) { */
          /*                offset(delta=2 * kEpsilon) */
          /*                projection(cut=true) { */
          /*                     translate([0, 0, -kChassisBaseHeight/2]) mChassisBase(); */
          /*                } */
          /*           } */
          /*      } */
          /* } */
     }
}

mBumperBase();
