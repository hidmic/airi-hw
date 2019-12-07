include <generic/lib.scad>;

use <generic/ball_caster_yoke.scad>;

use <oem/f174_sae1070_spring.scad>;
use <oem/m3x15mm_hex_standoff.scad>;

use <10mm_ball_caster_support.scad>;

k10mmBallCasterSupportDatasheet = v10mmBallCasterSupportDatasheet();
kF174SAE1070SpringDatasheet = vF174SAE1070SpringDatasheet();

function v10mmBallCasterYokeDatasheet() =
     let(mount_height=4)
     concat(
          pvBallCasterYokeDatasheet(main_diameter=property(k10mmBallCasterSupportDatasheet, "main_diameter"),
                                    base_thickness=property(k10mmBallCasterSupportDatasheet, "base_thickness"),
                                    mount_offset=property(k10mmBallCasterSupportDatasheet, "mount_offset"),
                                    mount_diameter=property(k10mmBallCasterSupportDatasheet, "mount_diameter"),
                                    mount_height=mount_height),
          [["seat_diameter", property(kF174SAE1070SpringDatasheet, "inner_diameter")],
           ["seat_height", mount_height], ["seat_thickness", 2]]
     );


module m10mmBallCasterYoke() {
     datasheet = v10mmBallCasterYokeDatasheet();
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
                    translate([0, 0, mount_height]) {
                         linear_extrude(height=base_thickness + 2 * kEpsilon) {
                              hull() projection() mM3x15mmHexStandoff();
                         }
                    }
                    let(hole_diameter=property(vM3x15mmHexStandoffDatasheet(), "hole_diameter")) {
                         cylinder(h=base_thickness + 2 * kEpsilon, d=hole_diameter);
                    }
               }
          }
     }
}

m10mmBallCasterYoke();
