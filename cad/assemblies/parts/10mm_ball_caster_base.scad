include <generic/lib.scad>;

use <generic/ball_caster_yoke.scad>;
use <oem/m3_hex_standoff.scad>;

use <10mm_ball_caster_support.scad>;
use <chassis_base.scad>;

function v10mmBallCasterBaseDatasheet() =
     let(chassis_datasheet=vChassisBaseDatasheet(),
         support_datasheet=v10mmBallCasterSupportDatasheet(),
         chassis_thickness=property(chassis_datasheet, "thickness"),
         base_thickness=property(support_datasheet, "base_thickness"),
         main_height=property(support_datasheet, "main_height"))
     concat(
          pvBallCasterYokeDatasheet(main_diameter=property(support_datasheet, "main_diameter"),
                                    base_thickness=base_thickness,
                                    mount_offset=property(support_datasheet, "mount_offset"),
                                    mount_diameter=property(support_datasheet, "mount_diameter"),
                                    mount_height=main_height - 2 * base_thickness - chassis_thickness),
          [["support_opening_diameter", property(support_datasheet, "main_diameter") + 1]]
     );


module m10mmBallCasterBase() {
     datasheet = v10mmBallCasterBaseDatasheet();
     base_thickness = property(datasheet, "base_thickness");
     mount_offset = property(datasheet, "mount_offset");
     mount_height = property(datasheet, "mount_height");

     support_opening_diameter = property(datasheet, "support_opening_diameter");

     color($default_color) {
          render() {
               difference() {
                    pmBallCasterYoke(datasheet);
                    translate([0, 0, -kEpsilon]) {
                         duplicate([0, 1, 0]) {
                              translate([0, mount_offset, 0]) {
                                   translate([0, 0, mount_height]) {
                                        linear_extrude(height=base_thickness + 2 * kEpsilon) {
                                             hull() projection() mM3x15mmHexStandoff();
                                        }
                                   }
                                   let(hole_diameter=property(vM3x15mmHexStandoffDatasheet(), "hole_diameter")) {
                                        cylinder(h=mount_height + base_thickness + 2 * kEpsilon, d=hole_diameter);
                                   }
                              }
                         }
                         cylinder(d=support_opening_diameter, h=base_thickness + 2 * kEpsilon);
                    }
               }
               difference() {
                    cylinder(d=support_opening_diameter + 2 * base_thickness, h=base_thickness);
                    translate([0, 0, -kEpsilon]) {
                         cylinder(d=support_opening_diameter, h=base_thickness + 2 * kEpsilon);
                    }
               }
          }
     }
}

m10mmBallCasterBase();
