include <generic/lib.scad>;

use <generic/ball_caster_yoke.scad>;

use <oem/f174_sae1070_spring.scad>;
use <oem/m3x15mm_hex_standoff.scad>;

use <10mm_ball_caster_support.scad>;

function v10mmBallCasterYokeDatasheet() =
     let(support_datasheet=v10mmBallCasterSupportDatasheet())
     pvBallCasterYokeDatasheet(main_diameter=property(support_datasheet, "main_diameter"),
                               base_thickness=property(support_datasheet, "base_thickness"),
                               mount_offset=property(support_datasheet, "mount_offset"),
                               mount_diameter=property(support_datasheet, "mount_diameter"),
                               mount_height=4);

module m10mmBallCasterYoke() {
     datasheet = v10mmBallCasterYokeDatasheet();
     base_thickness = property(datasheet, "base_thickness");
     mount_offset = property(datasheet, "mount_offset");
     mount_height = property(datasheet, "mount_height");

     color($default_color) {
          difference() {
               union() {
                    pmBallCasterYoke(datasheet);
                    translate([0, 0, base_thickness]) {
                         cylinder(d=property(vF174SAE1070SpringDatasheet(), "inner_diameter"), h=mount_height);
                    }
               }
               duplicate([0, 1, 0]) {
                    translate([0, mount_offset, -kEpsilon]) {
                         translate([0, 0, mount_height]) {
                              linear_extrude(height=base_thickness + 2 * kEpsilon) {
                                   hull() projection() mM3x15mmHexStandoff();
                              }
                         }
                    }
               }
          }
     }
}

m10mmBallCasterYoke();
