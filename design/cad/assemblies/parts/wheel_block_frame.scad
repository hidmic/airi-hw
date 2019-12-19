include <generic/lib.scad>;

use <oem/100mm_rhino_rubber_wheel.scad>;
use <oem/m3x5mm_threaded_insert.scad>;
use <oem/m3_phillips_screw.scad>;

use <chassis_base.scad>
use <wheel_suspension_frame_base.scad>;

kChassisBaseDatasheet = vChassisBaseDatasheet();
kWheelSuspensionFrameBaseDatasheet = vWheelSuspensionFrameBaseDatasheet();
k100mmRhinoRubberWheelDatasheet = v100mmRhinoRubberWheelDatasheet();
kM3x5mmThreadedInsertDatasheet = vM3x5mmThreadedInsertDatasheet();


function vWheelBlockFrameDatasheet() =
     let (chassis_datasheet=vChassisBaseDatasheet(),
          wheel_suspension_frame_datasheet=vWheelSuspensionFrameBaseDatasheet(),
          outer_radius=property(wheel_suspension_frame_datasheet, "outer_radius"),
          main_radius=property(wheel_suspension_frame_datasheet, "main_radius"),
          thickness=property(wheel_suspension_frame_datasheet, "thickness"),
          wheel_datasheet=v100mmRhinoRubberWheelDatasheet(),
          wheel_width=property(wheel_datasheet, "width"), width=wheel_width + 10,
          toe_width=15, inner_radius=outer_radius - thickness)
     [["outer_radius", outer_radius], ["inner_radius", inner_radius], ["thickness", thickness],
      ["width", width], ["toe_width", toe_width], ["wheel_width", wheel_width],
      ["fastening_hole_diameter", property(vM3PhillipsScrewDatasheet(), "nominal_diameter")],
      ["fastening_x_offset", [inner_radius - toe_width/2, -inner_radius + toe_width/2]],
      ["fastening_y_offset", [width/2 - width/5, -width/2 + width/5]],
      ["wheel_diameter", property(wheel_datasheet, "diameter")],
      ["wheel_axle_z_offset", (property(wheel_datasheet, "diameter") / 2 -
                               property(chassis_datasheet, "z_offset") -
                               property(chassis_datasheet, "thickness"))],
      ["support_angles", property(wheel_suspension_frame_datasheet, "support_angles")],
      ["support_diameter", 2 * ((outer_radius + inner_radius)/2 - main_radius)],
      ["support_r_offset", main_radius]];


module mWheelBlockFrame() {
     datasheet = vWheelBlockFrameDatasheet();
     frame_width = property(datasheet, "width");
     frame_toe_width = property(datasheet, "toe_width");
     frame_fastening_hole_diameter = property(datasheet, "fastening_hole_diameter");
     frame_thickness = property(datasheet, "thickness");
     frame_outer_radius = property(datasheet, "outer_radius");
     frame_inner_radius = property(datasheet, "inner_radius");
     wheel_axle_z_offset = property(datasheet, "wheel_axle_z_offset");

     frame_support_angles = property(datasheet, "support_angles");
     frame_support_diameter = property(datasheet, "support_diameter");

     color($default_color) {
          linear_extrude(height=frame_width) {
               translate([0, wheel_axle_z_offset]) {
                    ring(inner_radius=frame_inner_radius, outer_radius=frame_outer_radius, angles=[0, 180]);
                    for(angle=frame_support_angles) {
                         rotate([0, 0, angle]) {
                              threaded_insert_minor_diameter =
                                   property(kM3x5mmThreadedInsertDatasheet, "minor_diameter");
                              translate([frame_outer_radius, 0]) {
                                   curved_support_xsection(support_radius=frame_support_diameter/2,
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
                              square([frame_toe_width/2 - frame_fastening_hole_diameter/2, frame_thickness]);
                              translate([frame_toe_width/2 + frame_fastening_hole_diameter/2, 0]) {
                                   square([frame_toe_width/2 - frame_fastening_hole_diameter/2, frame_thickness]);
                              }
                         }
                         square([frame_thickness, wheel_axle_z_offset]);
                    }
               }
          }
          duplicate([1, 0, 0]) {
               translate([-frame_outer_radius + frame_thickness + frame_toe_width/2, 0, 0]) {
                    difference() {
                         translate([-frame_fastening_hole_diameter/2, 0, 0]) {
                              cube([frame_fastening_hole_diameter, frame_thickness, frame_width / 5]);
                         }
                         translate([0, -kEpsilon, frame_width / 5]) {
                              rotate([-90, 0, 0]) cylinder(d=frame_fastening_hole_diameter, h=frame_thickness + 2 * kEpsilon);
                         }
                    }
               }
          }
     }
}


mWheelBlockFrame();
