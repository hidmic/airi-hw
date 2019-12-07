include <generic/lib.scad>;

use <parts/oem/f058_sae1070_spring.scad>;
use <parts/oem/m3_allen_screw.scad>;
use <parts/oem/mr08d_024022_motor.scad>;

use <parts/mr08d_motor_base_support.scad>;

use <motor_bracket.scad>;

function vMotorBlockDatasheet() =
     vMR08DMotorBaseSupportDatasheet();

module mMotorBlock() {
     datasheet = vMotorBlockDatasheet();
     motor_z_offset = property(datasheet, "motor_z_offset");
     guide_length = property(datasheet, "guide_length");
     pillar_depth = property(datasheet, "pillar_depth");
     pillar_hole_to_hole_distance = property(datasheet, "pillar_hole_to_hole_distance");
     pillar_to_pillar_distance = property(datasheet, "pillar_to_pillar_distance");

     translate([guide_length + pillar_depth, 0, motor_z_offset]) {
          rotate([90, 0, -90]) {
               mMotorBracket();
          }
     }

     rotate([-90, 0, -90]) mMR08DMotorBaseSupport();

     let(spring_length=guide_length-property(vMotorBracketDatasheet(), "rear_cap_support_height")) {
          translate([0, 0, motor_z_offset]) {
               duplicate([0, 1, 0]) {
                    duplicate([0, 0, 1]) {
                         translate([0, pillar_to_pillar_distance/2, -pillar_hole_to_hole_distance/2]) {
                              translate([pillar_depth, 0, 0]) {
                                   rotate([0, 90, 0]) mF058SAE1070Spring(spring_length);
                              }
                              mM3x50mmAllenScrew();
                         }
                    }
               }
          }
     }
}

mMotorBlock();

