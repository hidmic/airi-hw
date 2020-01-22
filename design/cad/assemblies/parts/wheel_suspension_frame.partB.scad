include <generic/lib.scad>;

use <oem/70mm_shock_absorber.scad>;

use <wheel_suspension_frame_base.scad>;
use <wheel_suspension_pivot_joint.scad>;

use <wheel_suspension_frame.partA.scad>;

kWheelSuspensionFrame_PartA_Datasheet = vWheelSuspensionFrame_PartA_Datasheet();

function vWheelSuspensionFrame_PartB_Datasheet() =
     let(female_snap_fit_major_diameter=property(kWheelSuspensionFrame_PartA_Datasheet, "female_snap_fit_major_diameter"),
         female_snap_fit_thickness=property(kWheelSuspensionFrame_PartA_Datasheet, "female_snap_fit_thickness"),
         female_snap_fit_height=property(kWheelSuspensionFrame_PartA_Datasheet, "female_snap_fit_height"))
     concat(
          vWheelSuspensionFrameBaseDatasheet(),
          [["male_snap_fit_diameter", female_snap_fit_major_diameter - 2 * female_snap_fit_thickness], ["male_snap_fit_height", female_snap_fit_height]]
     );

module mWheelSuspensionFrame_PartB() {
     datasheet = vWheelSuspensionFrame_PartB_Datasheet();

     male_snap_fit_diameter = property(datasheet, "male_snap_fit_diameter");
     male_snap_fit_height = property(datasheet, "male_snap_fit_height");

     base_thickness = property(datasheet, "thickness");
     base_main_radius = property(datasheet, "main_radius");
     base_pivot_radius = property(datasheet, "pivot_radius");
     base_angular_length = property(datasheet, "angular_length");
     base_support_hole_diameter = property(datasheet, "support_hole_diameter");

     module male_snap_fit() {
          linear_extrude(height=male_snap_fit_height) {
               ring(outer_radius=male_snap_fit_diameter/2,
                    inner_radius=base_support_hole_diameter/2);
          }
     }

     color($default_color) {
          mirror([0, 1, 0]) {
               mWheelSuspensionFrameBase();
               translate([0, 0, base_thickness]) {
                    translate([base_pivot_radius, 0, 0]) {
                         male_snap_fit();
                    }
                    rotate([0, 0, base_angular_length]) {
                         translate([base_main_radius, 0, 0]) {
                              male_snap_fit();
                         }
                    }
               }
          }
     }
}

mWheelSuspensionFrame_PartB();
