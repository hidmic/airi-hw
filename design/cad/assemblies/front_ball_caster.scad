include <generic/lib.scad>;

use <parts/oem/f174_sae1070_spring.scad>;
use <parts/oem/m3_phillips_screw.scad>;
use <parts/oem/m3_hex_standoff.scad>;
use <parts/oem/m3x5mm_threaded_insert.scad>;
use <parts/oem/m3_nut.scad>;
use <parts/oem/10mm_ball.scad>;

use <parts/chassis_base.scad>;

use <parts/10mm_ball_caster_base.scad>;
use <parts/10mm_ball_caster_support.scad>;
use <parts/10mm_ball_caster_yoke.scad>;

SHOW_BALL=true;

function vFrontBallCasterDatasheet() = v10mmBallCasterSupportDatasheet();

module mFrontBallCaster() {
     support_datasheet = v10mmBallCasterSupportDatasheet();
     mount_offset = property(support_datasheet, "mount_offset");
     support_main_height = property(support_datasheet, "main_height");
     ball_z_offset = property(support_datasheet, "ball_z_offset");
     support_base_thickness = property(support_datasheet, "base_thickness");

     yoke_datasheet = v10mmBallCasterYokeDatasheet();
     yoke_base_thickness = property(yoke_datasheet, "base_thickness");
     yoke_mount_height = property(yoke_datasheet, "mount_height");

     base_datasheet = v10mmBallCasterBaseDatasheet();
     base_thickness = property(base_datasheet, "base_thickness");
     base_main_height = property(base_datasheet, "main_height");
     base_mount_height = property(base_datasheet, "mount_height");

     chassis_thickness = property(vChassisBaseDatasheet(), "thickness");

     standoff_length = property(vM3x15mmHexThreadedStandoffDatasheet(), "length");

     yoke_z_offset = base_mount_height + standoff_length + yoke_mount_height;
     spring_length = yoke_z_offset - yoke_base_thickness - base_main_height - support_base_thickness;

     translate([0, 0, yoke_z_offset]) {
          rotate([0, 180, 0]) {
               translate([0, 0, yoke_base_thickness]) {
                    mF174SAE1070Spring(spring_length);
               }
               duplicate([0, 1, 0]) {
                    translate([0, mount_offset, 0]) {
                         rotate([0, 180, 0]) mM3x6mmPhillipsScrew();
                    }
               }
               m10mmBallCasterYoke();
          }
     }
     translate([0, 0, base_main_height + support_base_thickness]) {
          rotate([0, 180, 0]) {
               translate([0, 0, ball_z_offset]) {
                    if (SHOW_BALL) m10mmBall();
               }
               m10mmBallCasterSupport();
          }
     }
     duplicate([0, 1, 0]) {
          translate([0, mount_offset, base_mount_height]) {
               if (!$simple) {
                    mM3x15mmHexThreadedStandoff();
               } else {
                    mM3x15mmHexStandoff();
               }
          }
     }
     m10mmBallCasterBase();
}

mFrontBallCaster();
