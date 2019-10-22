include <generic/lib.scad>;

use <parts/oem/f174_sae1070_spring.scad>;
use <parts/oem/m3x12mm_phillips_screw.scad>;
use <parts/oem/m3x6mm_phillips_screw.scad>;
use <parts/oem/m3x15mm_hex_standoff.scad>;
use <parts/oem/m3x5mm_threaded_insert.scad>;
use <parts/oem/m3_nut.scad>;
use <parts/oem/10mm_ball.scad>;

use <parts/10mm_ball_caster_support.scad>;
use <parts/10mm_ball_caster_yoke.scad>;


module mFrontBallCaster() {
     let(mount_height = property(v10mmBallCasterYokeDatasheet(), "mount_height"),
         mount_offset = property(v10mmBallCasterYokeDatasheet(), "mount_offset"),
         base_thickness = property(v10mmBallCasterYokeDatasheet(), "base_thickness"),
         main_diameter = property(v10mmBallCasterYokeDatasheet(), "main_diameter"),
         main_height = property(v10mmBallCasterYokeDatasheet(), "main_height")) {
          translate([0, 0, base_thickness + mount_height + 15]) {
               rotate([0, 180, 0]) {
                    let(spring_length=12 - $t) {
                         translate([0, 0, base_thickness]) {
                              mF174SAE1070Spring(length=spring_length);
                         }
                    }
                    duplicate([0, 1, 0]) {
                         translate([0, mount_offset, 0]) {
                              rotate([0, 180, 0]) mM3x6mmPhillipsScrew();
                         }
                    }
                    m10mmBallCasterYoke();
               }
          }
          translate([0, 0, $t + base_thickness + mount_height + kEpsilon]) {
               translate([0, 0, property(v10mmBallCasterSupportDatasheet(), "base_thickness")]) {
                    rotate([0, 180, 0]) {
                         translate([0, 0, property(v10mmBallCasterSupportDatasheet(), "ball_z_offset")]) {
                              m10mmBall();
                         }
                         m10mmBallCasterSupport();
                    }
               }
          }
          duplicate([0, 1, 0]) {
               translate([0, mount_offset, base_thickness]) {
                    mM3x15mmHexThreadedStandoff();
               }
          }
          difference() {
               m10mmBallCasterYoke();
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

mFrontBallCaster();
