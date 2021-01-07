include <generic/lib.scad>;

use <generic/ball_caster_support.scad>;

use <oem/m3_hex_standoff.scad>;

use <chassis_base.scad>;

function v50mmBallCasterSupportDatasheet() =
     let(chassis_datasheet=vChassisBaseDatasheet(),
         chassis_z_offset=property(chassis_datasheet, "z_offset"))
     pvBallCasterSupportDatasheet(ball_diameter=50.8, ball_protrusion=chassis_z_offset,
                                  ball_gap=3, wall_gap=10, wall_thickness=2,
                                  base_thickness=3, mount_offset=40, mount_diameter=15);

module m50mmBallCasterSupport() {
     datasheet = v50mmBallCasterSupportDatasheet();
     base_thickness = property(datasheet, "base_thickness");
     mount_offset = property(datasheet, "mount_offset");

     color($default_color) {
          difference() {
               pmBallCasterSupport(datasheet);
               translate([0, 0, -kEpsilon]) {
                    duplicate([0, 1, 0]) {
                         translate([0, mount_offset, 0]) {
                              linear_extrude(height=base_thickness + 2 * kEpsilon) {
                                   offset(delta=kEpsilon) {
                                        hull() projection() mM3x40mmHexStandoff();
                                   }
                              }
                         }
                    }
               }
          }
     }
}

m50mmBallCasterSupport();
