include <generic/lib.scad>;

use <generic/joint.scad>;

use <oem/688_ball_bearing.scad>;
use <oem/amt112s_encoder.scad>;
use <oem/m3x5mm_threaded_insert.scad>;
use <oem/m2_nut.scad>;

k688BallBearingDatasheet = v688BallBearingDatasheet();
kAMT112SEncoderDatasheet = vAMT112SEncoderDatasheet();
kM3x5mmThreadedInsertDatasheet = vM3x5mmThreadedInsertDatasheet();

function vWheelSuspensionAxleJointDatasheet() =
     let(outer_diameter=32, inner_diameter=property(k688BallBearingDatasheet, "outer_diameter"),
         encoder_fastening_angles=property(kAMT112SEncoderDatasheet, "mounting_angles"),
         encoder_fastening_diameter=property(kAMT112SEncoderDatasheet, "mounting_diameter"),
         encoder_fastening_hole_diameter=property(kAMT112SEncoderDatasheet, "mounting_hole_diameter"),
         joint_fastening_angles=[0, 90, 180, 270], joint_fastening_diameter=(outer_diameter + inner_diameter) / 2,
         joint_fastening_hole_diameter=property(kM3x5mmThreadedInsertDatasheet, "nominal_diameter"))
     concat(
          pvJointDatasheet(outer_diameter=outer_diameter, inner_diameter=inner_diameter,
                           height=property(k688BallBearingDatasheet, "height") + 1,
                           axle_diameter=property(k688BallBearingDatasheet, "inner_diameter"),
                           fastening_angles=[encoder_fastening_angles, joint_fastening_angles],
                           fastening_diameters=[encoder_fastening_diameter, joint_fastening_diameter],
                           fastening_hole_diameters=[encoder_fastening_hole_diameter, joint_fastening_hole_diameter]),
          [["encoder_fastening_angles", encoder_fastening_angles],
           ["encoder_fastening_diameter", encoder_fastening_diameter],
           ["encoder_fastening_hole_diameter", encoder_fastening_hole_diameter],
           ["joint_fastening_angles", joint_fastening_angles],
           ["joint_fastening_diameter", joint_fastening_diameter],
           ["joint_fastening_hole_diameter", joint_fastening_hole_diameter]]
     );


module mWheelSuspensionAxleJointXSection() {
     pmJointXSection(vWheelSuspensionAxleJointDatasheet());
}

module mWheelSuspensionAxleJoint() {
     datasheet = vWheelSuspensionAxleJointDatasheet();
     color($default_color) {
          render() {
               difference() {
                    pmJoint(datasheet);
                    let(encoder_fastening_angles=property(datasheet, "encoder_fastening_angles"),
                        encoder_fastening_diameter=property(datasheet, "encoder_fastening_diameter"),
                        nut_bore_z_offset=property(datasheet, "height")) {
                         for (i = [0:len(encoder_fastening_angles)-1]) {
                              rotate([0, 0, encoder_fastening_angles[i]]) {
                                   translate([encoder_fastening_diameter/2, 0, nut_bore_z_offset]) {
                                        mM2NutBore();
                                   }
                              }
                         }
                    }
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
}

mWheelSuspensionAxleJoint();
