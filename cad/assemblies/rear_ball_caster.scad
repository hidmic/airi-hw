include <generic/lib.scad>;

use <parts/oem/f2276_sae1070_spring.scad>;
use <parts/oem/m3x12mm_phillips_screw.scad>;
use <parts/oem/m3x6mm_phillips_screw.scad>;
use <parts/oem/m3x30mm_hex_standoff.scad>;
use <parts/oem/m3x5mm_threaded_insert.scad>;
use <parts/oem/m3_nut.scad>;
use <parts/oem/50mm_ball.scad>;

use <parts/50mm_ball_caster_support.scad>;
use <parts/50mm_ball_caster_yoke.scad>;
use <parts/50mm_ball_caster_spring_seat.scad>;


module mRearBallCaster() {
     let(mount_height = property(v50mmBallCasterYokeDatasheet(), "mount_height"),
         mount_offset = property(v50mmBallCasterYokeDatasheet(), "mount_offset"),
         base_thickness = property(v50mmBallCasterYokeDatasheet(), "base_thickness"),
         main_diameter = property(v50mmBallCasterYokeDatasheet(), "main_diameter"),
         main_height = property(v50mmBallCasterYokeDatasheet(), "main_height")) {
          translate([0, 0, base_thickness + mount_height + 30]) {
               rotate([0, 180, 0]) {
                    let(spring_length=15 - $t) {
                         translate([0, 0, base_thickness]) {
                              mF2276SAE1070Spring(length=spring_length);
                              translate([0, 0, property(v50mmBallCasterSpringSeatDatasheet(), "base_thickness") + spring_length]) {
                                   rotate([0, 180, 0]) {
                                        translate([0, 0, property(v50mmBallCasterSpringSeatDatasheet(), "base_thickness")]) {
                                             mM3x5mmThreadedInsert();
                                        }
                                        m50mmBallCasterSpringSeat();
                                   }
                              }
                         }
                    }
                    duplicate([0, 1, 0]) {
                         translate([0, mount_offset, 0]) {
                              rotate([0, 180, 0]) mM3x6mmPhillipsScrew();
                         }
                    }
                    m50mmBallCasterYoke();
               }
          }
          translate([0, 0, $t + base_thickness + mount_height + kEpsilon]) {
               translate([0, 0, property(v50mmBallCasterSupportDatasheet(), "base_thickness")]) {
                    rotate([0, 180, 0]) {
                         translate([0, 0, property(v50mmBallCasterSupportDatasheet(), "ball_z_offset")]) {
                              m50mmBall();
                         }
                         translate([0, 0, property(v50mmBallCasterSupportDatasheet(), "base_thickness")]) {
                              mM3x12mmPhillipsScrew();
                         }
                         m50mmBallCasterSupport();
                    }
                    mM3Nut();
               }
          }
          duplicate([0, 1, 0]) {
               translate([0, mount_offset, base_thickness]) {
                    mM3x30mmHexThreadedStandoff();
               }
          }
          difference() {
               m50mmBallCasterYoke();
               translate([0, 0, -kEpsilon]) {
                    cylinder(h=main_height + 2 * kEpsilon, d=main_diameter + 1);
               }
          }
          /* duplicate([0, 1, 0]) { */
          /*      translate([0, mount_offset, 0]) { */
          /*           rotate([0, 180, 0]) mM3x6mmPhillipsScrew(); */
          /*      } */
          /* } */
     }
}


mRearBallCaster();
