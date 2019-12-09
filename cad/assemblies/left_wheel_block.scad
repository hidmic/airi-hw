include <generic/lib.scad>;

use <parts/oem/100mm_rhino_rubber_wheel.scad>;
use <parts/oem/70mm_shock_absorber.scad>;
use <parts/oem/8mm_clamping_hub.scad>;
use <parts/oem/amt112s_encoder.scad>;
use <parts/oem/gt2_pulley.scad>;
use <parts/oem/m3x5mm_threaded_insert.scad>;
use <parts/oem/steel_shaft.scad>;

use <parts/wheel_block_frame.scad>;
use <wheel_suspension_arm.scad>;
use <wheel_suspension_frame.scad>;


function vLeftWheelBlockDatasheet() =
     let(shaft_datasheet=v100x8mmSteelShaftDatasheet())
     concat(
          [["wheel_axle_y_offset", -property(shaft_datasheet, "length")/2 -3]],
          vWheelBlockFrameDatasheet()
     );


module mLeftWheelBlock() {
     datasheet = vLeftWheelBlockDatasheet();
     wheel_block_frame_datasheet = vWheelBlockFrameDatasheet();
     suspension_arm_datasheet = vWheelSuspensionArmDatasheet();
     suspension_frame_datasheet = vWheelSuspensionFrameDatasheet();

     translate([0, 0, property(wheel_block_frame_datasheet, "wheel_axle_z_offset")]) {
          rotate([0, 0, 180]) {
               m100mmRhinoRubberWheel();
               translate([0, property(v8mmClampingHubDatasheet(), "height")/2, 0])
               rotate([0, 0, -90]) m8mmClampingHub();
          }
          translate([0, property(datasheet, "wheel_axle_y_offset"), 0]) {
               rotate([-90, 0, 0]) m100x8mmSteelShaft();
          }
          translate([0, property(wheel_block_frame_datasheet, "width")/2 + property(suspension_frame_datasheet, "height")/2, 0]) {
               translate([property(suspension_arm_datasheet, "length") * 0.45, 0, 0]) {
                    mirror([0, 0, 1]) m70mmShockAbsorber();
               }
               mWheelSuspensionFrame();
               translate([0, property(suspension_arm_datasheet, "height")/2 + kEpsilon, 0]) {
                    rotate([0, -90, 0]) {
                         mAMT112SEncoder();
                    }
               }
               rotate([90, 0, 0]) {
                    translate([0, 0, -property(suspension_arm_datasheet, "height")/2]) {
                         mWheelSuspensionArm();
                    }
               }
          }

          translate([0, -property(wheel_block_frame_datasheet, "width")/2 - property(suspension_frame_datasheet, "height")/2, 0]) {
               translate([property(suspension_arm_datasheet, "length") * 0.45, 0, 0]) {
                    mirror([0, 0, 1]) m70mmShockAbsorber();
               }
               mWheelSuspensionFrame();
               rotate([-90, 0, 0]) {
                    translate([0, 0, -property(suspension_arm_datasheet, "height")/2]) {
                         mWheelSuspensionArm();
                    }
               }
          }

     }
     rotate([90, 0, 0]) {
          translate([0, property(wheel_block_frame_datasheet, "wheel_axle_z_offset"), 0]) {
               duplicate([0, 0, 1]) {
                    for(angle = property(wheel_block_frame_datasheet, "support_angles")) {
                         rotate([0, 0, angle])
                              translate([property(wheel_block_frame_datasheet, "support_r_offset"),
                                         0, -property(wheel_block_frame_datasheet, "width")/2]) {
                              mM3x5mmThreadedInsert();
                         }
                    }
               }
          }
          translate([0, 0, -property(wheel_block_frame_datasheet, "width")/2]) {
               mWheelBlockFrame();
          }
     }
}

mLeftWheelBlock();
