include <generic/lib.scad>;

use <chassis_base.scad>;
use <chassis_base_cover.scad>;

use <base_chassis.scad>;

module mBaseChassis_PartB() {
     datasheet = vBaseChassisDatasheet();
     height = property(datasheet, "height");
     inner_diameter = property(datasheet, "inner_diameter");
     outer_diameter = property(datasheet, "outer_diameter");
     fillet_radius = property(datasheet, "fillet_radius");

     support_pin_diameter = property(datasheet, "support_pin_diameter");
     support_pin_height = property(datasheet, "support_pin_height");

     chassis_cover_datasheet = vChassisBaseCoverDatasheet();
     cover_support_diameter = property(chassis_cover_datasheet, "support_diameter");
     cover_support_angles = concat(property(chassis_cover_datasheet, "support_angles"),
                                   property(chassis_cover_datasheet, "bay_support_angles"));

     render() {
          difference() {
               mBaseChassis();
               translate([0, 0, height/2]) {
                    mirror([0, 0, 1]) mChassisBBox();
               }
          }
          mChassisVolumeConstrain() {
               translate([0, 0, height/2]) {
                    for(angle = cover_support_angles) {
                         rotate(angle) {
                              difference() {
                                   linear_extrude(height=height/2) {
                                        translate([(outer_diameter + inner_diameter)/4, 0]) {
                                             curved_support_xsection(
                                                  support_radius=cover_support_diameter/2,
                                                  fillet_radius=fillet_radius,
                                                  hole_radius=support_pin_diameter/2,
                                                  wall_outer_radius=outer_diameter/2,
                                                  wall_inner_radius=inner_diameter/2);
                                        }
                                   }
                              }
                         }
                    }
               }
          }
     }
}

mBaseChassis_PartB();
