include <generic/lib.scad>;

use <oem/hcs04_sonar.scad>;

use <chassis_base.scad>;
use <bumper_base.scad>
use <bumper_spring_block.partA.scad>

kChassisBaseDatasheet = vChassisBaseDatasheet();
kBumper_PartB_Datasheet = vBumper_PartB_Datasheet();
kBumperSpringBlock_PartA_Datasheet = vBumperSpringBlock_PartA_Datasheet();

function vBumper_PartB_Datasheet() = vBumperBaseDatasheet();

module mBumper_PartB() {
     bumper_height = property(kBumper_PartB_Datasheet, "height");
     bumper_support_diameter = property(kBumper_PartB_Datasheet, "support_diameter");
     bumper_support_angles = property(kBumper_PartB_Datasheet, "support_angles");
     bumper_support_pin_diameter = property(kBumper_PartB_Datasheet, "support_pin_diameter");

     chassis_height = property(kChassisBaseDatasheet, "height");
     chassis_outer_diameter = property(kChassisBaseDatasheet, "outer_diameter");
     chassis_inner_diameter = property(kChassisBaseDatasheet, "inner_diameter");
     chassis_fillet_radius = property(kChassisBaseDatasheet, "fillet_radius");

     render(convexity=10) {
          difference() {
               translate([0, 0, -chassis_fillet_radius]) mBumperBase();
               translate([0, 0, -chassis_height + bumper_height/2]) mChassisBBox();
          }
          translate([0, 0, bumper_height/2]) {
               for(angle = bumper_support_angles) {
                    rotate([0, 0, angle]) {
                         linear_extrude(height=bumper_height/2) {
                              translate([(chassis_outer_diameter + chassis_inner_diameter)/4, 0, 0]) {
                                   difference() {
                                        curved_support_xsection(
                                             support_radius=bumper_support_diameter/2,
                                             fillet_radius=chassis_fillet_radius,
                                             wall_outer_radius=chassis_outer_diameter/2,
                                             wall_inner_radius=chassis_inner_diameter/2);
                                        translate([-bumper_support_diameter/2, 0]) {
                                             circle(d=bumper_support_pin_diameter);
                                        }
                                   }
                              }
                         }
                    }
               }
          }
     }
}

mBumper_PartB();

