include <generic/lib.scad>;

use <oem/m3x8mm_countersunk_screw.scad>;

use <wheel_suspension_axle_joint.scad>;
use <wheel_suspension_pivot_joint.scad>;
use <wheel_suspension_link.scad>;

kWheelSuspensionAxleJointDatasheet = vWheelSuspensionAxleJointDatasheet();
kWheelSuspensionPivotJointDatasheet = vWheelSuspensionPivotJointDatasheet();
kWheelSuspensionLinkDatasheet = vWheelSuspensionLinkDatasheet();

function vWheelSuspensionArm_PartB_Datasheet() =
     [["height", property(kWheelSuspensionLinkDatasheet, "thickness")]];

module mWheelSuspensionArm_PartB() {
     render() {
          difference() {
               mWheelSuspensionLink();
               let(link_thickness=property(kWheelSuspensionLinkDatasheet, "thickness"),
                   link_length=property(kWheelSuspensionLinkDatasheet, "length")) {
                    let(joint_fastening_diameter=property(kWheelSuspensionAxleJointDatasheet, "joint_fastening_diameter")) {
                         for (angle = property(kWheelSuspensionAxleJointDatasheet, "joint_fastening_angles")) {
                              rotate([0, 0, angle]) {
                                   translate([joint_fastening_diameter/2, 0, link_thickness]) {
                                        mM3CountersunkScrewBore();
                                   }
                              }
                         }
                    }
                    translate([link_length, 0, 0]) {
                         let(joint_fastening_diameter=property(kWheelSuspensionPivotJointDatasheet, "joint_fastening_diameter")) {
                              for (angle = property(kWheelSuspensionPivotJointDatasheet, "joint_fastening_angles")) {
                                   rotate([0, 0, angle]) {
                                        translate([joint_fastening_diameter/2, 0, link_thickness]) {
                                             mM3CountersunkScrewBore();
                                        }
                                   }
                              }
                         }
                    }
               }
          }
     }
}

mWheelSuspensionArm_PartB();
