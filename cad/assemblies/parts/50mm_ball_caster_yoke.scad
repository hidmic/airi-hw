include <generic/lib.scad>;

use <generic/ball_caster_yoke.scad>;

use <oem/m3x5mm_threaded_insert.scad>
use <oem/m3_hex_standoff.scad>;

use <50mm_ball_caster_support.scad>;
use <50mm_ball_caster_spring_seat.scad>;

function v50mmBallCasterYokeDatasheet() =
     let(caster_support_datasheet=v50mmBallCasterSupportDatasheet(),
         caster_spring_seat_datasheet=v50mmBallCasterSpringSeatDatasheet())
     pvBallCasterYokeDatasheet(main_diameter=property(caster_support_datasheet, "main_diameter"),
                               base_thickness=property(caster_support_datasheet, "base_thickness"),
                               mount_offset=property(caster_support_datasheet, "mount_offset"),
                               mount_diameter=property(caster_support_datasheet, "mount_diameter"),
                               mount_height=property(caster_spring_seat_datasheet, "height"));

module m50mmBallCasterYoke() {
     datasheet = v50mmBallCasterYokeDatasheet();
     base_thickness = property(datasheet, "base_thickness");
     mount_offset = property(datasheet, "mount_offset");
     mount_height = property(datasheet, "mount_height");

     color($default_color) {
          render() {
               difference() {
                    pmBallCasterYoke(datasheet);
                    translate([0, 0, -kEpsilon]) {
                         duplicate([0, 1, 0]) {
                              translate([0, mount_offset, 0]) {
                                   translate([0, 0, mount_height]) {
                                        linear_extrude(height=base_thickness + 2 * kEpsilon) {
                                             offset(delta=kEpsilon) {
                                                  hull() projection() mM3x30mmHexStandoff();
                                             }
                                        }
                                   }
                                   let(hole_diameter=property(vM3x30mmHexStandoffDatasheet(), "hole_diameter")) {
                                        cylinder(h=mount_height + base_thickness + 2 * kEpsilon, d=hole_diameter);
                                   }
                              }
                         }
                         let(hole_diameter=property(vM3x5mmThreadedInsertDatasheet(), "nominal_diameter")) {
                              cylinder(h=base_thickness + 2 * kEpsilon, d=hole_diameter);
                         }
                    }
               }
          }
     }
}

m50mmBallCasterYoke();
