include <generic/lib.scad>;

use <parts/oem/5mm_flat_top_led.scad>;
use <parts/chassis_base_bay.scad>;

function vChassisBayDatasheet() = vChassisBaseBayDatasheet();

module mChassisBay() {
     datasheet = vChassisBaseBayDatasheet();

     mChassisBaseBay();
     for (angle = property(datasheet, "light_source_angles")) {
          rotate(angle) {
               translate([property(datasheet, "light_source_r_offset"), 0]) {
                    m5mmFlatTopLED();
               }
          }
     }
}

mChassisBay();
