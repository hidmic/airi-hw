include <generic/lib.scad>;

use <parts/oem/f058_sae1070_spring.scad>;
use <parts/oem/m3_allen_screw.scad>;
use <parts/oem/mr08d_024022_motor.scad>;

use <parts/mr08d_motor_base_support.scad>;

use <motor_bracket.scad>;

function vMotorBlockDatasheet() =
     let(base_support_datasheet=vMR08DMotorBaseSupportDatasheet(),
         pillar_height=property(base_support_datasheet, "pillar_height"),
         pillar_depth=property(base_support_datasheet, "pillar_depth"),
         guide_length = property(base_support_datasheet, "guide_length"),
         bracket_datasheet=vMotorBracketDatasheet(),
         motor_z_offset_in_bracket=property(bracket_datasheet, "motor_z_offset"),
         rear_cap_z_offset_in_bracket=property(bracket_datasheet, "rear_cap_z_offset"),
         rear_cap_support_height=property(bracket_datasheet, "rear_cap_support_height"),
         rear_cap_datasheet=property(bracket_datasheet, "rear_cap_datasheet"),
         rear_cap_outer_diameter=property(rear_cap_datasheet, "outer_diameter"),
         min_bracket_x_offset=rear_cap_z_offset_in_bracket + rear_cap_outer_diameter + pillar_depth,
         min_motor_x_offset=min_bracket_x_offset - motor_z_offset_in_bracket,
         max_bracket_x_offset=rear_cap_support_height + guide_length + pillar_depth,
         max_motor_x_offset=max_bracket_x_offset - motor_z_offset_in_bracket)
     concat(
          base_support_datasheet, bracket_datasheet,
          [["main_height", pillar_height],
           ["min_bracket_x_offset", min_bracket_x_offset],
           ["max_bracket_x_offset", max_bracket_x_offset],
           ["min_motor_x_offset", min_motor_x_offset],
           ["max_motor_x_offset", max_motor_x_offset],
           ["bracket_x_offset", (min_bracket_x_offset + max_bracket_x_offset)/2],
           ["motor_x_offset", (min_motor_x_offset + max_motor_x_offset)/2]]
     );


module mMotorBlock() {
     datasheet = vMotorBlockDatasheet();
     motor_z_offset = property(datasheet, "motor_z_offset");
     guide_length = property(datasheet, "guide_length");
     pillar_depth = property(datasheet, "pillar_depth");
     pillar_hole_to_hole_distance = property(datasheet, "pillar_hole_to_hole_distance");
     pillar_to_pillar_distance = property(datasheet, "pillar_to_pillar_distance");
     bracket_x_offset = property(datasheet, "bracket_x_offset");

     support_height = property(vMotorBracketDatasheet(), "rear_cap_support_height");

     translate([bracket_x_offset, 0, motor_z_offset]) {
          rotate([90, 0, -90]) {
               mMotorBracket();
          }
     }

     rotate([-90, 0, -90]) mMR08DMotorBaseSupport();

     let(spring_length=bracket_x_offset - support_height - pillar_depth) {
          translate([0, 0, motor_z_offset]) {
               duplicate([0, 1, 0]) {
                    duplicate([0, 0, 1]) {
                         translate([0, pillar_to_pillar_distance/2,
                                    -pillar_hole_to_hole_distance/2]) {
                              translate([pillar_depth, 0, 0]) {
                                   rotate([0, 90, 0]) {
                                        mF058SAE1070Spring(spring_length);
                                   }
                              }
                              mM3x50mmAllenScrew();
                         }
                    }
               }
          }
     }
}

mMotorBlock();

