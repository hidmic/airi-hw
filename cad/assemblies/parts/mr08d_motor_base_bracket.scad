include <generic/lib.scad>;

use <oem/mr08d_024022_motor.scad>;
use <oem/m3x5mm_threaded_insert.scad>;

use <generic/motor_cap.scad>;
use <mr08d_motor_front_cap.scad>;
use <mr08d_motor_rear_cap.scad>;

function vMR08DMotorBaseBracketDatasheet() =
     let(motor_datasheet=vMR08D024022MotorDatasheet(),
         rear_cap_datasheet=vMR08DMotorRearCapDatasheet(),
         front_cap_datasheet=vMR08DMotorFrontCapDatasheet(),
         inner_length=property(motor_datasheet, "length"),
         wall_thickness=property(rear_cap_datasheet, "wall_thickness"),
         outer_length=inner_length + 4 * wall_thickness, base_thickness=2,
         front_cap_z_offset=(base_thickness +
                             property(front_cap_datasheet, "wall_thickness") +
                             (property(rear_cap_datasheet, "outer_diameter") -
                              property(front_cap_datasheet, "outer_diameter"))/2),
         rear_cap_z_offset=base_thickness + wall_thickness,
         hole_to_hole_y_distance=(property(rear_cap_datasheet, "outer_diameter") + 2 * wall_thickness +
                                  property(rear_cap_datasheet, "height") / 2 + 2 * wall_thickness),
         rear_cap_support_datasheet=pvMotorCapBaseSupportDatasheet(
              rear_cap_datasheet, hole_to_hole_distance=hole_to_hole_y_distance
         ),
         front_cap_support_datasheet=pvMotorCapBaseSupportDatasheet(
              front_cap_datasheet, hole_to_hole_distance=hole_to_hole_y_distance,
              height=property(rear_cap_support_datasheet, "height") + rear_cap_z_offset - front_cap_z_offset
         ))
     [["base_thickness", base_thickness], ["outer_length", outer_length], ["inner_length", inner_length],
      ["main_width", property(rear_cap_support_datasheet, "width")],
      ["outer_width", property(rear_cap_support_datasheet, "outer_width")],
      ["hole_to_hole_y_distance", hole_to_hole_y_distance], ["link_width", 4],
      ["hole_to_hole_x_distance", (outer_length - property(rear_cap_support_datasheet, "depth")/2 -
                                   property(front_cap_support_datasheet, "depth")/2)],
      ["motor_z_offset", base_thickness + property(rear_cap_datasheet, "outer_diameter")/2],
      ["front_cap_datasheet", front_cap_datasheet],
      ["front_cap_support_datasheet", front_cap_support_datasheet],
      ["front_cap_x_offset", (outer_length - property(front_cap_support_datasheet, "depth"))/2],
      ["front_cap_z_offset", front_cap_z_offset],
      ["rear_cap_datasheet", rear_cap_datasheet],
      ["rear_cap_support_datasheet", rear_cap_support_datasheet],
      ["rear_cap_x_offset", (-outer_length + property(rear_cap_support_datasheet, "depth"))/2],
      ["rear_cap_z_offset", rear_cap_z_offset],
      ["fastening_screw_datasheet", property(rear_cap_datasheet, "fastening_screw_datasheet")]];

module mMR08DMotorBracketFrontCap() {
     mMR08DMotorFrontCap();
}

module mMR08DMotorBracketFrontCapNut() {
     mMR08DMotorFrontCapNut();
}

module mMR08DMotorBracketRearCap() {
     mMR08DMotorRearCap();
}

module mMR08DMotorBracketRearCapNut() {
     mMR08DMotorRearCapNut();
}

module mMR08DMotorBracketThreadInsert() {
     translate([0, 0, -property(vM3x5mmThreadedInsertDatasheet(), "length")]) {
          mM3x5mmThreadedInsert();
     }
}

module mMR08DMotorBaseBracket() {
     datasheet = vMR08DMotorBaseBracketDatasheet();
     main_width = property(datasheet, "main_width");
     outer_length = property(datasheet, "outer_length");
     link_width = property(datasheet, "link_width");
     base_thickness = property(datasheet, "base_thickness");
     hole_to_hole_y_distance = property(datasheet, "hole_to_hole_y_distance");
     front_cap_support_datasheet = property(datasheet, "front_cap_support_datasheet");
     rear_cap_support_datasheet = property(datasheet, "rear_cap_support_datasheet");

     linear_extrude(height=base_thickness) {
          square_frame(outer_length, main_width, link_width);
     }

     let(x_offset=property(datasheet, "rear_cap_x_offset"),
         z_offset=property(datasheet, "rear_cap_z_offset"),
         height=property(rear_cap_support_datasheet, "height"),
         wall_thickness=property(rear_cap_support_datasheet, "wall_thickness")) {
          translate([x_offset, 0, 0]) {
               linear_extrude(height=z_offset - wall_thickness) {
                    projection() pmMotorCapBaseSupport(rear_cap_support_datasheet);
               }
               translate([0, 0, z_offset - wall_thickness]) {
                    difference() {
                         pmMotorCapBaseSupport(rear_cap_support_datasheet);
                         duplicate([0, 1, 0]) {
                              translate([0, hole_to_hole_y_distance/2, height]) {
                                   mM3x5mmThreadedInsertTaperCone();
                              }
                         }
                    }
               }
          }
     }

     let(x_offset=property(datasheet, "front_cap_x_offset"),
         z_offset=property(datasheet, "front_cap_z_offset"),
         height=property(front_cap_support_datasheet, "height"),
         wall_thickness=property(front_cap_support_datasheet, "wall_thickness")) {
          translate([x_offset, 0, 0]) {
               linear_extrude(height=z_offset - wall_thickness) {
                    projection() pmMotorCapBaseSupport(front_cap_support_datasheet);
               }
               translate([0, 0, z_offset - wall_thickness]) {
                    difference() {
                         pmMotorCapBaseSupport(front_cap_support_datasheet);
                         duplicate([0, 1, 0]) {
                              translate([0, hole_to_hole_y_distance/2, height]) {
                                   mM3x5mmThreadedInsertTaperCone();
                              }
                         }
                    }
               }
          }
     }
}


mMR08DMotorBaseBracket();
