include <generic/lib.scad>;

use <chassis_base.scad>;
use <bumper_base.scad>

function vBumper_PartB_Datasheet() = vBumperBaseDatasheet();

module mBumper_PartB() {
     datasheet = vBumper_PartB_Datasheet();
     bumper_height = property(datasheet, "height");
     bumper_support_diameter = property(datasheet, "support_diameter");
     bumper_support_angles = property(datasheet, "support_angles");
     bumper_support_pin_diameter = property(datasheet, "support_pin_diameter");

     chassis_datasheet = vChassisBaseDatasheet();
     chassis_height = property(chassis_datasheet, "height");
     chassis_outer_diameter = property(chassis_datasheet, "outer_diameter");
     chassis_inner_diameter = property(chassis_datasheet, "inner_diameter");
     chassis_fillet_radius = property(chassis_datasheet, "fillet_radius");

     color($default_color) {
          render(convexity=10) {
               difference() {
                    mBumperBase();
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
}

mBumper_PartB();
