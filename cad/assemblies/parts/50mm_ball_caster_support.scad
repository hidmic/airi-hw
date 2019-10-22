include <generic/lib.scad>;

use <generic/ball_caster_support.scad>;

use <oem/m3x30mm_hex_standoff.scad>;

function v50mmBallCasterSupportDatasheet() =
     pvBallCasterSupportDatasheet(ball_diameter=50.8, ball_protrusion=20, ball_gap=3,
                                  wall_gap=10, wall_thickness=2, base_thickness=3,
                                  mount_offset=40, mount_diameter=15);

module m50mmBallCasterSupport() {
     datasheet = v50mmBallCasterSupportDatasheet();
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

m50mmBallCasterSupport();
