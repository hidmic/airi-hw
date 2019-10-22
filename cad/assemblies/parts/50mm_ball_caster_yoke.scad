include <generic/lib.scad>;

use <generic/ball_caster_yoke.scad>;

use <oem/f2276_sae1070_spring.scad>;
use <oem/m3x30mm_hex_standoff.scad>;

use <50mm_ball_caster_support.scad>;

k50mmBallCasterSupportDatasheet = v50mmBallCasterSupportDatasheet();
kF2276SAE1070SpringDatasheet = vF2276SAE1070SpringDatasheet();

function v50mmBallCasterYokeDatasheet() =
     concat(
          pvBallCasterYokeDatasheet(main_diameter=property(k50mmBallCasterSupportDatasheet, "main_diameter"),
                                    base_thickness=property(k50mmBallCasterSupportDatasheet, "base_thickness"),
                                    mount_offset=property(k50mmBallCasterSupportDatasheet, "mount_offset"),
                                    mount_diameter=property(k50mmBallCasterSupportDatasheet, "mount_diameter"),
                                    mount_height=8),
          [["main_height", property(k50mmBallCasterSupportDatasheet, "base_thickness") + 5],
           ["seat_diameter", property(kF2276SAE1070SpringDatasheet, "outer_diameter")],
           ["seat_height", 5], ["seat_thickness", 2]]
     );


module m50mmBallCasterYoke() {
     datasheet = v50mmBallCasterYokeDatasheet();
     base_thickness = property(datasheet, "base_thickness");
     mount_offset = property(datasheet, "mount_offset");
     mount_height = property(datasheet, "mount_height");
     seat_height = property(datasheet, "seat_height");
     seat_thickness = property(datasheet, "seat_thickness");
     seat_diameter = property(datasheet, "seat_diameter");
     difference() {
          union() {
               pmBallCasterYoke(datasheet);
               translate([0, 0, base_thickness]) {
                    linear_extrude(height=seat_height) {
                         ring(outer_radius=seat_diameter / 2 - kEpsilon,
                              inner_radius=seat_diameter / 2 - seat_thickness);
                    }
               }
          }
          duplicate([0, 1, 0]) {
               translate([0, mount_offset, -kEpsilon]) {
                    translate([0, 0, base_thickness]) {
                         linear_extrude(height=mount_height + 2 * kEpsilon) {
                              hull() projection() mM3x30mmHexStandoff();
                         }
                    }
                    cylinder(h=base_thickness + 2 * kEpsilon, d=3);
               }
          }
     }
}

m50mmBallCasterYoke();
