include <generic/lib.scad>;

use <parts/oem/m3x5mm_threaded_insert.scad>;

use <parts/chassis_base.scad>;
use <parts/base_chassis.scad>;
use <parts/base_chassis.partA.scad>;
use <parts/base_chassis.partB.scad>;

function vChassisDatasheet() =
     concat(vBaseChassisDatasheet(), vChassisBaseDatasheet());

module mChassis() {
     datasheet = vChassisDatasheet();

     difference() {
          union() {
               mBaseChassis_PartA();
               mBaseChassis_PartB();
          }
          translate([0, 0, property(datasheet, "height")]) {
               for(angle = property(datasheet, "cover_support_angles")) {
                    rotate([0, 0, angle]) {
                         translate([property(datasheet, "cover_support_r_offset"), 0, 0]) {
                              mM3x5mmThreadedInsertTaperCone();
                         }
                    }
               }
          }
          translate([0, 0, property(datasheet, "thickness")]) {
               duplicate([0, 1, 0]) {
                    translate([property(datasheet, "battery_stop_x_offset"),
                               property(datasheet, "battery_stop_y_offset"),
                               property(datasheet, "battery_stop_height")]) {
                         mM3x5mmThreadedInsertTaperCone();
                    }
               }
          }
     }
     translate([0, 0, property(datasheet, "height")]) {
          for(angle = property(datasheet, "cover_support_angles")) {
               rotate([0, 0, angle]) {
                    translate([property(datasheet, "cover_support_r_offset"), 0, 0]) {
                         mirror([0, 0, 1]) mM3x5mmThreadedInsert();
                    }
               }
          }
     }
     translate([0, 0, property(datasheet, "thickness")]) {
          duplicate([0, 1, 0]) {
               translate([property(datasheet, "battery_stop_x_offset"),
                          property(datasheet, "battery_stop_y_offset"),
                          property(datasheet, "battery_stop_height")]) {
                    mirror([0, 0, 1]) mM3x5mmThreadedInsert();
               }
          }
     }
}

mChassis();
