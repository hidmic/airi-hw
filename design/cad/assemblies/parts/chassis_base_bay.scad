include <generic/lib.scad>;

use <oem/5mm_flat_top_led.scad>;

use <chassis_base.scad>;
use <chassis_base_cover.scad>;

function vChassisBaseBayDatasheet() =
     let(outer_diameter=property(vChassisBaseDatasheet(), "outer_diameter"),
         width=15, inner_diameter=outer_diameter - 2 * width,
         height=property(vChassisBaseCoverDatasheet(), "bay_height"))
     [["outer_diameter", outer_diameter],
      ["inner_diameter", inner_diameter],
      ["height", height], ["width", width],
      ["light_source_angles", [30:60:360-30]],
      ["light_source_r_offset", (outer_diameter + inner_diameter)/4]];

module mChassisBaseBay() {
     datasheet = vChassisBaseBayDatasheet();
     inner_diameter = property(datasheet, "inner_diameter");
     outer_diameter = property(datasheet, "outer_diameter");
     height = property(datasheet, "height");

     chassis_cover_datasheet = vChassisBaseCoverDatasheet();
     support_angles = concat(property(chassis_cover_datasheet, "support_angles"),
                             property(chassis_cover_datasheet, "bay_support_angles"));
     support_r_offset = property(chassis_cover_datasheet, "support_r_offset");

     support_screw_datasheet = vChassisCoverSupportScrewDatasheet();
     support_screw_diameter = property(support_screw_datasheet, "nominal_diameter");

     light_source_angles = property(datasheet, "light_source_angles");
     light_source_r_offset = property(datasheet, "light_source_r_offset");

     light_source_diameter = property(v5mmFlatTopLEDDatasheet(), "diameter");

     color("white", 0.3) {
          linear_extrude(height=height) {
               difference() {
                    ring(inner_radius=inner_diameter/2, outer_radius=outer_diameter/2);
                    for (angle = light_source_angles) {
                         rotate(angle) {
                              translate([light_source_r_offset, 0]) {
                                   circle(d=light_source_diameter);
                              }
                         }
                    }
                    for (angle = support_angles) {
                         rotate(angle) {
                              translate([support_r_offset, 0]) {
                                   circle(d=support_screw_diameter);
                              }
                         }
                    }
               }
          }
     }
}

projection()
mChassisBaseBay();
