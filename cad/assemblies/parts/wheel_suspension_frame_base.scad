include <generic/lib.scad>;

use <oem/70mm_shock_absorber.scad>;

use <wheel_suspension_link.scad>;
use <wheel_suspension_pivot_joint.scad>;

use <oem/m3x5mm_threaded_insert.scad>;

kM3x5mmThreadedInsertDatasheet = vM3x5mmThreadedInsertDatasheet();
kWheelSuspensionPivotJointDatasheet = vWheelSuspensionPivotJointDatasheet();
kWheelSuspensionLinkDatasheet = vWheelSuspensionLinkDatasheet();

function vWheelSuspensionFrameBaseDatasheet() =
     let(pivot_radius=property(kWheelSuspensionLinkDatasheet, "length"),
         outer_radius=pivot_radius + property(kWheelSuspensionPivotJointDatasheet, "outer_diameter")/2,
         width=10, thickness=2, main_radius=outer_radius - width/2 - thickness, inner_radius=main_radius - width/2,
         support_hole_diameter=property(kM3x5mmThreadedInsertDatasheet, "nominal_diameter") + 4 * kEpsilon)
     [["main_radius", main_radius], ["outer_radius", outer_radius], ["inner_radius", inner_radius],
      ["pivot_radius", pivot_radius], ["width", width], ["thickness", thickness], ["fillet_radius", 3],
      ["angular_length", 135], ["support_angles", [30, 120]], ["support_hole_angular_delta", 5],
      ["support_hole_diameter", support_hole_diameter], ["shock_support_hole_angles", [20:10:130]]];


module mWheelSuspensionFrameBase() {
     datasheet = vWheelSuspensionFrameBaseDatasheet();
     frame_width = property(datasheet, "width");
     frame_thickness = property(datasheet, "thickness");

     pivot_radius = property(datasheet, "pivot_radius");
     inner_radius = property(datasheet, "inner_radius");
     outer_radius = property(datasheet, "outer_radius");
     main_radius = property(datasheet, "main_radius");
     angular_length = property(datasheet, "angular_length");

     linear_extrude(height=property(datasheet, "thickness")) {
          difference() {
               fillet(r=property(datasheet, "fillet_radius")) {
               //union() {
                    rounded_ring(inner_radius=inner_radius, outer_radius=outer_radius, angles=[0, angular_length]);
                    let(pivot_joint_outer_diameter=property(kWheelSuspensionPivotJointDatasheet, "outer_diameter")) {
                         translate([pivot_radius, 0, 0]) circle(d=pivot_joint_outer_diameter);
                    }
               }
               translate([pivot_radius, 0]) {
                    circle(d=property(datasheet, "support_hole_diameter"));
               }
               rotate([0, 0, angular_length]) {
                    translate([main_radius, 0]) {
                         circle(d=property(datasheet, "support_hole_diameter"));
                    }
               }
               let(support_angles = property(datasheet, "support_angles"),
                   support_hole_diameter = property(datasheet, "support_hole_diameter"),
                   support_hole_angular_delta = property(datasheet, "support_hole_angular_delta")) {
                    for (angle = support_angles) {
                         rounded_ring(inner_radius=main_radius - support_hole_diameter / 2,
                                      outer_radius=main_radius + support_hole_diameter / 2,
                                      angles=[angle - support_hole_angular_delta/2, angle + support_hole_angular_delta/2]);
                    }
               }
               let (shock_support_hole_angles = property(datasheet, "shock_support_hole_angles"),
                    shock_support_hole_diameter = property(v70mmShockAbsorberDatasheet(), "support_hole_diameter")) {
                    for (angle = shock_support_hole_angles) {
                         rotate(angle) {
                              translate([main_radius, 0]) {
                                   circle(d=shock_support_hole_diameter);
                              }
                         }
                    }
               }
          }
     }
}

mWheelSuspensionFrameBase();
