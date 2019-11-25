include <generic/lib.scad>;

use <parts/oem/688_ball_bearing.scad>;
use <parts/oem/m2_nut.scad>;
use <parts/oem/m3x5mm_threaded_insert.scad>;

use <parts/wheel_suspension_link.scad>;
use <parts/wheel_suspension_axle_joint.scad>;
use <parts/wheel_suspension_arm.partA.scad>;
use <parts/wheel_suspension_arm.partB.scad>;

function vWheelSuspensionArmDatasheet() =
     let(height_partA=property(vWheelSuspensionArm_PartA_Datasheet(), "height"),
         height_partB=property(vWheelSuspensionArm_PartB_Datasheet(), "height"))
     [["height", height_partA + height_partB]];

module mWheelSuspensionArm() {
     mWheelSuspensionArm_PartA();
     translate([0, 0, property(vWheelSuspensionLinkDatasheet(), "thickness") +
                property(vWheelSuspensionAxleJointDatasheet(), "height") / 2]) {
          rotate([0, 90, 0]) m688BallBearing();
     }
     translate([0, 0, property(vWheelSuspensionArm_PartA_Datasheet(), "height")]) {
          mWheelSuspensionArm_PartB();
     }
}

mWheelSuspensionArm();
