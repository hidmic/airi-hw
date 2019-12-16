include <generic/lib.scad>;

use <chassis_base.scad>;
use <chassis_base_cover.scad>;

use <base_chassis.scad>;

module mBaseChassis_PartA() {
     datasheet = vBaseChassisDatasheet();
     height = property(datasheet, "height");
     inner_diameter = property(datasheet, "inner_diameter");
     outer_diameter = property(datasheet, "outer_diameter");
     fillet_radius = property(datasheet, "fillet_radius");

     support_pin_diameter = property(datasheet, "support_pin_diameter");
     support_pin_height = property(datasheet, "support_pin_height");
     cover_support_diameter = property(datasheet, "cover_support_diameter");
     cover_support_angles = property(datasheet, "cover_support_angles");

     color($default_color) {
          render() {
               difference() {
                    mBaseChassis();
                    translate([0, 0, height/2]) {
                         mChassisBBox();
                    }
               }
               mChassisVolumeConstrain() {
                    for(angle = cover_support_angles) {
                         rotate(angle) {
                              linear_extrude(height=height/2) {
                                   translate([(outer_diameter + inner_diameter)/4, 0]) {
                                        curved_support_xsection(
                                             support_radius=cover_support_diameter/2,
                                             fillet_radius=fillet_radius,
                                             wall_outer_radius=outer_diameter/2,
                                             wall_inner_radius=inner_diameter/2);
                                   }
                              }
                              translate([(outer_diameter + inner_diameter)/4 - cover_support_diameter/2, 0, height/2]) {
                                   cylinder(d=support_pin_diameter-kEpsilon, h=support_pin_height);
                              }
                         }
                    }
               }
          }
     }
}

mBaseChassis_PartA();
