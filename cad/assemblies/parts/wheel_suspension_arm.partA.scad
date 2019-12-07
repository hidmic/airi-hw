include <generic/lib.scad>;

use <wheel_suspension_axle_joint.scad>;
use <wheel_suspension_pivot_joint.scad>;
use <wheel_suspension_link.scad>;

kWheelSuspensionLinkDatasheet = vWheelSuspensionLinkDatasheet();
kWheelSuspensionAxleJointDatasheet = vWheelSuspensionAxleJointDatasheet();

function vWheelSuspensionArm_PartA_Datasheet() =
     let(link_thickness=property(kWheelSuspensionLinkDatasheet, "thickness"),
         joint_height=property(kWheelSuspensionAxleJointDatasheet, "height"),
         encoder_fastening_angles=property(
              kWheelSuspensionAxleJointDatasheet, "encoder_fastening_angles"),
         encoder_fastening_diameter=property(
              kWheelSuspensionAxleJointDatasheet, "encoder_fastening_diameter"))
     [["length", property(kWheelSuspensionLinkDatasheet, "length")],
      ["height", link_thickness + joint_height],
      ["encoder_fastening_angles", encoder_fastening_angles],
      ["encoder_fastening_diameter", encoder_fastening_diameter]];

module mWheelSuspensionArm_PartA() {
     mWheelSuspensionLink();
     translate([0, 0, property(kWheelSuspensionLinkDatasheet, "thickness")]) {
          mWheelSuspensionAxleJoint();
          translate([property(kWheelSuspensionLinkDatasheet, "length"), 0, 0]) {
               mWheelSuspensionPivotJoint();
          }
     }
}

mWheelSuspensionArm_PartA();
