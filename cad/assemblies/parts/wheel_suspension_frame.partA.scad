include <generic/lib.scad>;

use <oem/70mm_shock_absorber.scad>;

use <wheel_suspension_frame_base.scad>;
use <wheel_suspension_pivot_joint.scad>;

use <../wheel_suspension_arm.scad>;

kWheelSuspensionArmDatasheet = vWheelSuspensionArmDatasheet();
kWheelSuspensionPivotJointDatasheet = vWheelSuspensionPivotJointDatasheet();

function vWheelSuspensionFrame_PartA_Datasheet() =
     let(joint_inner_diameter=property(vWheelSuspensionPivotJointDatasheet(), "inner_diameter"),
         suspension_arm_height=property(vWheelSuspensionArmDatasheet(), "height"))
     concat(
          vWheelSuspensionFrameBaseDatasheet(),
          [["female_snap_fit_thickness", 1], ["female_snap_fit_major_diameter", joint_inner_diameter],
           ["female_snap_fit_minor_diameter", joint_inner_diameter - 0.4], ["female_snap_fit_height", suspension_arm_height + 2],
           ["female_snap_fit_cut_angles", [45, -45]], ["female_snap_fit_cut_width", 1], ["female_snap_fit_cut_length", suspension_arm_height / 2 + 1]]
     );


module mWheelSuspensionFrame_PartA() {
     datasheet = vWheelSuspensionFrame_PartA_Datasheet();

     female_snap_fit_major_diameter = property(datasheet, "female_snap_fit_major_diameter");
     female_snap_fit_minor_diameter = property(datasheet, "female_snap_fit_minor_diameter");
     female_snap_fit_thickness = property(datasheet, "female_snap_fit_thickness");
     female_snap_fit_height = property(datasheet, "female_snap_fit_height");

     female_snap_fit_cut_length = property(datasheet, "female_snap_fit_cut_length");
     female_snap_fit_cut_width = property(datasheet, "female_snap_fit_cut_width");
     female_snap_fit_cut_angles = property(datasheet, "female_snap_fit_cut_angles");

     base_thickness = property(datasheet, "thickness");
     base_pivot_radius = property(datasheet, "pivot_radius");
     base_main_radius = property(datasheet, "main_radius");
     base_angular_length = property(datasheet, "angular_length");

     module female_snap_fit() {
          difference() {
               cylinder(d1=female_snap_fit_major_diameter,
                        d2=female_snap_fit_minor_diameter,
                        h=female_snap_fit_height);
               translate([0, 0, -kEpsilon]) {
                    cylinder(d1=female_snap_fit_major_diameter - female_snap_fit_thickness,
                             d2=female_snap_fit_minor_diameter - female_snap_fit_thickness,
                             h=female_snap_fit_height + 2 * kEpsilon);
               }
               for (angle = female_snap_fit_cut_angles) {
                    rotate([0, 0, angle]) {
                         translate([0, 0, female_snap_fit_height - female_snap_fit_cut_length / 2 + kEpsilon]) {
                              cube([female_snap_fit_cut_width,
                                    2 * female_snap_fit_major_diameter,
                                    female_snap_fit_cut_length], center=true);
                         }
                    }
               }
          }
     }

     color($default_color) {
          mWheelSuspensionFrameBase();
          translate([0, 0, base_thickness]) {
               translate([base_pivot_radius, 0, 0]) {
                    female_snap_fit();
               }
               rotate([0, 0, base_angular_length]) {
                    translate([base_main_radius, 0, 0]) {
                         female_snap_fit();
                    }
               }
          }
     }
}

mWheelSuspensionFrame_PartA();
