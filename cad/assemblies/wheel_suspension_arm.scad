include <generic/lib.scad>;

use <parts/oem/688_ball_bearing.scad>;
use <parts/oem/m2_nut.scad>;
use <parts/oem/m3x5mm_threaded_insert.scad>;
use <parts/oem/m3_countersunk_screw.scad>;

use <parts/wheel_suspension_link.scad>;
use <parts/wheel_suspension_axle_joint.scad>;
use <parts/wheel_suspension_pivot_joint.scad>;
use <parts/wheel_suspension_arm.partA.scad>;
use <parts/wheel_suspension_arm.partB.scad>;


function vWheelSuspensionArmDatasheet() =
     let(partA_datasheet=vWheelSuspensionArm_PartA_Datasheet(),
         partB_datasheet=vWheelSuspensionArm_PartB_Datasheet())
     [["length", property(partA_datasheet, "length")],
      ["height", property(partA_datasheet, "height") + property(partB_datasheet, "height")],
      ["encoder_fastening_angles", property(partA_datasheet, "encoder_fastening_angles")],
      ["encoder_fastening_diameter", property(partA_datasheet, "encoder_fastening_diameter")]];


module mWheelSuspensionArm() {
     datasheet = vWheelSuspensionArmDatasheet();
     link_datasheet = vWheelSuspensionLinkDatasheet();
     axle_joint_datasheet = vWheelSuspensionAxleJointDatasheet();
     pivot_joint_datasheet = vWheelSuspensionPivotJointDatasheet();

     arm_partA_datasheet = vWheelSuspensionArm_PartA_Datasheet();

     mWheelSuspensionArm_PartA();
     translate([0, 0, property(link_datasheet, "thickness") +
                property(axle_joint_datasheet, "height") / 2]) {
          rotate([0, 90, 0]) m688BallBearing();
     }

     translate([0, 0, property(arm_partA_datasheet, "height")]) {
          mWheelSuspensionArm_PartB();
     }

     for(angle = property(axle_joint_datasheet, "encoder_fastening_angles")) {
          rotate([0, 0, angle]) {
               translate([property(axle_joint_datasheet, "encoder_fastening_diameter")/2,
                          0, property(arm_partA_datasheet, "height")]) {
                    mirror([0, 0, 1]) mM2Nut();
               }
          }
     }


     for(angle = property(axle_joint_datasheet, "joint_fastening_angles")) {
          rotate([0, 0, angle]) {
               translate([property(axle_joint_datasheet, "joint_fastening_diameter")/2, 0, 0]) {
                    translate([0, 0, property(datasheet, "height")]) {
                         mirror([0, 0, 1]) mM3x8mmCountersunkScrew();
                    }
                    translate([0, 0, property(arm_partA_datasheet, "height")]) {
                         mirror([0, 0, 1]) mM3x5mmThreadedInsert();
                    }
               }

          }
     }

     translate([property(link_datasheet, "length"), 0, 0]) {
          for(angle = property(pivot_joint_datasheet, "joint_fastening_angles")) {
               rotate([0, 0, angle]) {
                    translate([property(pivot_joint_datasheet, "joint_fastening_diameter")/2, 0, 0]) {
                         translate([0, 0, property(datasheet, "height")]) {
                              mirror([0, 0, 1]) mM3x8mmCountersunkScrew();
                         }
                         translate([0, 0, property(arm_partA_datasheet, "height")]) {
                              mirror([0, 0, 1]) mM3x5mmThreadedInsert();
                         }
                    }
               }
          }
     }
}

mWheelSuspensionArm();
