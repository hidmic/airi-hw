include <generic/lib.scad>;

use <parts/oem/f2276_sae1070_spring.scad>;
use <parts/oem/m3_phillips_screw.scad>;
use <parts/oem/m3_hex_standoff.scad>;
use <parts/oem/m3x5mm_threaded_insert.scad>;
use <parts/oem/m3_nut.scad>;
use <parts/oem/50mm_ball.scad>;

use <parts/50mm_ball_caster_base.scad>;
use <parts/50mm_ball_caster_support.scad>;
use <parts/50mm_ball_caster_spring_seat.scad>;
use <parts/50mm_ball_caster_yoke.scad>;

function vRearBallCasterDatasheet() =
     v50mmBallCasterBaseDatasheet();

module mRearBallCaster() {
     base_datasheet = v50mmBallCasterBaseDatasheet();
     support_z_offset = property(base_datasheet, "support_z_offset");
     standoff_length = property(base_datasheet, "standoff_length");

     spring_seat_datasheet = v50mmBallCasterSpringSeatDatasheet();
     seat_base_thickness = property(spring_seat_datasheet, "base_thickness");

     support_datasheet = v50mmBallCasterSupportDatasheet();
     ball_z_offset = property(support_datasheet, "ball_z_offset");
     mount_offset = property(support_datasheet, "mount_offset");
     support_base_thickness = property(support_datasheet, "base_thickness");

     yoke_datasheet = v50mmBallCasterYokeDatasheet();
     yoke_base_thickness = property(yoke_datasheet, "base_thickness");
     yoke_mount_height = property(yoke_datasheet, "mount_height");

     yoke_z_offset = yoke_mount_height + support_z_offset + standoff_length/2;
     spring_length = yoke_z_offset - yoke_base_thickness - seat_base_thickness - support_z_offset;
     translate([0, 0, yoke_z_offset]) {
          rotate([0, 180, 0]) {
               m50mmBallCasterYoke();
               translate([0, 0, yoke_base_thickness]) {
                    translate([0, 0, 5]) {
                         let(e_min=property(vM3NutDatasheet(), "e_min"), m_max=property(vM3NutDatasheet(), "m_max")) {
                              difference() {
                                   m50mmBallCasterSpringSeat();
                                   translate([0, 0, -kEpsilon]) cylinder(d=e_min, h=m_max + kEpsilon);
                                   translate([0, 0, m_max]) {
                                        mirror([0, 0, 1]) mM3x5mmThreadedInsertTaperCone();
                                   }
                              }
                              translate([0, 0, m_max]) mM3x5mmThreadedInsert();
                              translate([0, 0, seat_base_thickness]) {
                                   mF2276SAE1070Spring(spring_length - 5);
                              }
                         }
                    }
                    mM3Nut();
               }
               duplicate([0, 1, 0]) {
                    translate([0, mount_offset, 0]) {
                         rotate([0, 180, 0]) mM3x12mmPhillipsScrew();
                    }
               }
               rotate([0, 180, 0]) mM3x12mmPhillipsScrew();
          }
     }
     translate([0, 0, support_z_offset]) {
          rotate([0, 180, 0]) {
               translate([0, 0, ball_z_offset]) {
                    m50mmBall();
               }
               m50mmBallCasterSupport();
          }
     }
     translate([0, 0, support_z_offset - support_base_thickness/2]) {
          duplicate([0, 1, 0]) {
               translate([0, mount_offset, -standoff_length/2]) {
                    mM3x30mmHexThreadedStandoff();
               }
          }
     }
     m50mmBallCasterBase();
}


mRearBallCaster();
