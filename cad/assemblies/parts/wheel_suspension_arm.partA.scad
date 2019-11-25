include <generic/lib.scad>;

use <wheel_suspension_axle_joint.scad>;
use <wheel_suspension_pivot_joint.scad>;
use <wheel_suspension_link.scad>;

kWheelSuspensionLinkDatasheet = vWheelSuspensionLinkDatasheet();
kWheelSuspensionAxleJointDatasheet = vWheelSuspensionAxleJointDatasheet();

function vWheelSuspensionArm_PartA_Datasheet() =
     let(link_thickness=property(kWheelSuspensionLinkDatasheet, "thickness"),
         joint_height=property(kWheelSuspensionAxleJointDatasheet, "height"))
     [["height", link_thickness + joint_height]];

module mWheelSuspensionArm_PartA() {
     mWheelSuspensionLink();
     translate([0, 0, property(kWheelSuspensionLinkDatasheet, "thickness")]) {
          mWheelSuspensionAxleJoint();
          translate([property(vWheelSuspensionLinkDatasheet(), "length"), 0, 0]) {
               mWheelSuspensionPivotJoint();
          }
     }
}

mWheelSuspensionArm_PartA();
