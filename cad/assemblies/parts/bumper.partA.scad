include <generic/lib.scad>;

use <chassis_base.scad>;
use <bumper_base.scad>

function vBumper_PartA_Datasheet() = vBumperBaseDatasheet();

module mBumper_PartA() {
     datasheet = vBumper_PartA_Datasheet();
     bumper_height = property(datasheet, "height");
     bumper_support_diameter = property(datasheet, "support_diameter");
     bumper_support_angles = property(datasheet, "support_angles");
     bumper_support_pin_diameter = property(datasheet, "support_pin_diameter");
     bumper_support_pin_height = property(datasheet, "support_pin_height");

     chassis_datasheet = vChassisBaseDatasheet();
     chassis_outer_diameter = property(chassis_datasheet, "outer_diameter");
     chassis_inner_diameter = property(chassis_datasheet, "inner_diameter");
     chassis_fillet_radius = property(chassis_datasheet, "fillet_radius");

     color($default_color) {
          difference() {
               mBumperBase();
               translate([0, 0, bumper_height/2]) {
                    mChassisBBox();
               }
          }
          for(angle = bumper_support_angles) {
               rotate([0, 0, angle]) {
                    linear_extrude(height=bumper_height/2) {
                         translate([(chassis_outer_diameter + chassis_inner_diameter)/4, 0]) {
                              curved_support_xsection(
                                   support_radius=bumper_support_diameter/2,
                                   fillet_radius=chassis_fillet_radius,
                                   wall_outer_radius=chassis_outer_diameter/2,
                                   wall_inner_radius=chassis_inner_diameter/2);
                         }
                    }
               }
          }
          for(angle = bumper_support_angles) {
               rotate(angle) {
                    translate([(chassis_outer_diameter + chassis_inner_diameter)/4 - bumper_support_diameter/2 + kEpsilon,
                               0, bumper_height/2]) {
                         cylinder(d=bumper_support_pin_diameter-kEpsilon, h=bumper_support_pin_height);
                    }
               }
          }
     }
}

mBumper_PartA();
