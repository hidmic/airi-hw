include <generic/lib.scad>;

use <oem/100mm_rhino_rubber_wheel.scad>;
use <oem/m3x5mm_threaded_insert.scad>;

use <chassis.scad>
use <wheel_suspension_frame_base.scad>;

kChassisDatasheet = vChassisDatasheet();
kWheelSuspensionFrameBaseDatasheet = vWheelSuspensionFrameBaseDatasheet();

k100mmRhinoRubberWheelDatasheet = v100mmRhinoRubberWheelDatasheet();
kM3x5mmThreadedInsertDatasheet = vM3x5mmThreadedInsertDatasheet();


function vWheelBlockFrameDatasheet() =
     let (outer_radius=property(kWheelSuspensionFrameBaseDatasheet, "outer_radius"),
          thickness=property(kWheelSuspensionFrameBaseDatasheet, "thickness"))
     [["outer_radius", outer_radius], ["inner_radius", outer_radius - thickness],
      ["thickness", thickness], ["width", 40], ["toe_width", 15], ["toe_hole_diameter", 3],
      ["wheel_axle_z_offset", (property(k100mmRhinoRubberWheelDatasheet, "diameter") / 2 -
                               property(kChassisDatasheet, "z_offset") -
                               property(kChassisDatasheet, "thickness"))]];

module mWheelBlockFrame() {
     datasheet = vWheelBlockFrameDatasheet();
     frame_width = property(datasheet, "width");
     frame_toe_width = property(datasheet, "toe_width");
     frame_toe_hole_diameter = property(datasheet, "toe_hole_diameter");
     frame_thickness = property(datasheet, "thickness");
     frame_outer_radius = property(datasheet, "outer_radius");
     frame_inner_radius = property(datasheet, "inner_radius");
     wheel_axle_z_offset = property(datasheet, "wheel_axle_z_offset");

     threaded_insert_minor_diameter = property(kM3x5mmThreadedInsertDatasheet, "minor_diameter");

     rotate([0, 0, 0]) {
          linear_extrude(height=frame_width) {
               translate([0, wheel_axle_z_offset]) {
                    ring(inner_radius=frame_inner_radius, outer_radius=frame_outer_radius, angles=[0, 180]);
                    for(angle=property(kWheelSuspensionFrameBaseDatasheet, "support_angles")) {
                         rotate([0, 0, angle]) {
                              translate([frame_outer_radius, 0]) {
                                   curved_support_xsection(support_radius=threaded_insert_minor_diameter,
                                                           hole_radius=threaded_insert_minor_diameter / 2,
                                                           fillet_radius=threaded_insert_minor_diameter / 4,
                                                           wall_inner_radius=frame_inner_radius,
                                                           wall_outer_radius=frame_outer_radius);
                              }
                         }
                    }
               }
               duplicate([1, 0, 0]) {
                    translate([-frame_outer_radius, 0]) {
                         translate([frame_thickness, 0]) {
                              square([frame_toe_width/2 - frame_toe_hole_diameter/2, frame_thickness]);
                              translate([frame_toe_width/2 + frame_toe_hole_diameter/2, 0]) {
                                   square([frame_toe_width/2 - frame_toe_hole_diameter/2, frame_thickness]);
                              }
                         }
                         square([frame_thickness, wheel_axle_z_offset]);
                    }
               }
          }
          duplicate([1, 0, 0]) {
               translate([-frame_outer_radius + frame_thickness + frame_toe_width/2, 0, 0]) {
                    difference() {
                         translate([- frame_toe_hole_diameter/2, 0, 0]) {
                              cube([frame_toe_hole_diameter, frame_thickness, frame_width / 5]);
                         }
                         translate([0, -kEpsilon, frame_width / 5]) {
                              rotate([-90, 0, 0]) cylinder(d=frame_toe_hole_diameter, h=frame_thickness + 2 * kEpsilon);
                         }
                    }
               }
          }
     }
}


mWheelBlockFrame();
