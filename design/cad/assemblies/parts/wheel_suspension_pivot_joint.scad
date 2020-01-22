include <generic/lib.scad>;

use <generic/joint.scad>;

use <oem/m3x5mm_threaded_insert.scad>;

use <wheel_suspension_axle_joint.scad>;


kWheelSuspensionAxleJointDatasheet = vWheelSuspensionAxleJointDatasheet();
kM3x5mmThreadedInsertDatasheet = vM3x5mmThreadedInsertDatasheet();

function vWheelSuspensionPivotJointDatasheet() =
     let(outer_diameter=22, axle_diameter=7,
         inner_diameter=axle_diameter - 2 * kEpsilon,
         joint_fastening_diameter=(outer_diameter + inner_diameter) / 2,
         joint_fastening_angles=property(kWheelSuspensionAxleJointDatasheet, "joint_fastening_angles"),
         joint_fastening_hole_diameter=property(kM3x5mmThreadedInsertDatasheet, "nominal_diameter"))
     concat(
          pvJointDatasheet(outer_diameter=outer_diameter, inner_diameter=axle_diameter + kEpsilon, axle_diameter=axle_diameter,
                           height=property(kWheelSuspensionAxleJointDatasheet, "height"),
                           fastening_angles=[joint_fastening_angles], fastening_diameters=[joint_fastening_diameter],
                           fastening_hole_diameters=[joint_fastening_hole_diameter]),
          [["joint_fastening_angles", joint_fastening_angles],
           ["joint_fastening_diameter", joint_fastening_diameter],
           ["joint_fastening_hole_diameter", joint_fastening_hole_diameter]]
     );

module mWheelSuspensionPivotJointXSection() {
     pmJointXSection(vWheelSuspensionPivotJointDatasheet());
}

module mWheelSuspensionPivotJoint() {
     datasheet = vWheelSuspensionPivotJointDatasheet();

     color($default_color) {
          difference() {
               pmJoint(datasheet);
               let(joint_fastening_angles=property(datasheet, "joint_fastening_angles"),
                   joint_fastening_diameter=property(datasheet, "joint_fastening_diameter"),
                   threaded_insert_z_offset=property(datasheet, "height")) {
                    for (i = [0:len(joint_fastening_angles)-1]) {
                         rotate([0, 0, joint_fastening_angles[i]]) {
                              translate([joint_fastening_diameter/2, 0, threaded_insert_z_offset]) {
                                   mM3x5mmThreadedInsertTaperCone();
                              }
                         }
                    }
               }
          }
     }
}

mWheelSuspensionPivotJoint();
