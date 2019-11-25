include <generic/lib.scad>;

use <parts/oem/100mm_rhino_rubber_wheel.scad>;

use <parts/wheel_suspension_frame.scad>;
use <parts/wheel_block_frame.scad>;

use <wheel_suspension_arm.scad>;

kWheelBlockFrameDatasheet = vWheelBlockFrameDatasheet();
BlockFrameDatasheet = vWheelBlockFrameDatasheet();

module mWheelBlock() {
     wheel_axle_z_offset = property(kWheelBlockFrameDatasheet, "wheel_axle_z_offset");
     translate([0, 0, wheel_axle_z_offset]) {
          duplicate([0, 1, 0]) {
               translate([0, kWheelCaseWidth/2 + kSuspensionArmHeight/2, 0]) {
                    mWheelSuspensionArm();
               }
          }
          translate([0, kWheelBlockCenterToEncoderDistance, 0]) {
               rotate([0, 90, 0]) mEncoder();
          }
          translate([0, -kWheelBlockCenterToClampDistance, 0]) {
               rotate([0, 0, -90]) mMountedRoundBeltPulley();
          }
          mRoundShaftL100();
          mWheel();
     }
     mWheelCase();

     duplicate([0, 1, 0]) {
          translate([27, -kWheelCaseWidth/2-kSuspensionArmHeight/2, kWheelAxleZOffset - 3]) {
               rotate([180, 5, 0]) mShockAbsorber();
          }
     }
}
