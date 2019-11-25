include <generic/lib.scad>;

use <generic/ball_caster_support.scad>;

use <oem/m3x30mm_hex_standoff.scad>;

function v10mmBallCasterSupportDatasheet() =
     pvBallCasterSupportDatasheet(ball_diameter=10, ball_protrusion=3, ball_gap=1,
                                  wall_gap=2, wall_thickness=2, base_thickness=2,
                                  mount_offset=12, mount_diameter=10);

module m10mmBallCasterSupport() {
     datasheet = v10mmBallCasterSupportDatasheet();
     base_thickness = property(datasheet, "base_thickness");
     mount_offset = property(datasheet, "mount_offset");
     difference() {
          pmBallCasterSupport(datasheet);
          translate([0, 0, -kEpsilon]) {
               duplicate([0, 1, 0]) {
                    translate([0, mount_offset, 0]) {
                         linear_extrude(height=base_thickness + 2 * kEpsilon) {
                              hull() projection() mM3x30mmHexStandoff();
                         }
                    }
               }
               cylinder(h=base_thickness + 2 * kEpsilon, d=3);
          }
     }
}

m10mmBallCasterSupport();
