include <generic/lib.scad>;

use <oem/rplidar_a1m8_r1.scad>;
use <oem/jetson_nano.scad>;
use <oem/m3_phillips_screw.scad>;

use <../chassis.scad>;
use <../motor_block.scad>;
use <../controller.scad>;

function vBoardSupportDatasheet() =
     let(chassis_datasheet=vChassisDatasheet(),
         motor_block_datasheet=vMotorBlockDatasheet(),
         motor_block_screw_offset=property(motor_block_datasheet, "fastening_screw_x_offset")[0],
         x_max=(max(property(chassis_datasheet, "left_motor_block_x_offset"),
                    property(chassis_datasheet, "right_motor_block_x_offset")) +
                property(motor_block_datasheet, "length")),
         x_min=(property(chassis_datasheet, "battery_stop_x_offset") -
                property(chassis_datasheet, "battery_stop_side_length")/2))
     [["height", 8], ["width", property(motor_block_datasheet, "outer_width") + 12], ["length", x_max - x_min],
      ["x_offset", (x_max + x_min)/2], ["z_offset", property(motor_block_datasheet, "main_height")],
      ["lidar_x_offset", 0], ["lidar_y_offset", 0], ["computer_y_offset", -5],
      ["computer_x_offset", x_max - property(vJetsonNanoDatasheet(), "length")/2],
      ["controller_x_offset", 21 - property(vControllerDatasheet(), "length")/2],
      ["controller_y_offset", 0], []];

module mBoardSupport() {
     datasheet = vBoardSupportDatasheet();

     color("white", 0.3) {
          translate([0, 0, property(datasheet, "z_offset")]) {
               linear_extrude(height=property(datasheet, "height")) {
                    difference() {
                         translate([property(datasheet, "x_offset"), 0, 0]) {
                              square([property(datasheet, "length"), property(datasheet, "width")], center=true);
                         }
                         let(lidar_datasheet=vRPLidarA1M8R1Datasheet()) {
                              translate([property(datasheet, "lidar_x_offset"), property(datasheet, "lidar_y_offset")]) {
                                   for (location = property(lidar_datasheet, "support_locations")) {
                                        translate(location) {
                                             circle(d=property(vM3PhillipsScrewDatasheet(), "nominal_diameter"));
                                        }
                                   }
                                   translate([0, property(lidar_datasheet, "connector_y_offset") + property(datasheet, "width")/2]) {
                                        square([property(lidar_datasheet, "connector_length") + 4, property(datasheet, "width")], center=true);
                                   }
                              }
                         }
                         translate([property(datasheet, "computer_x_offset"), property(datasheet, "computer_y_offset")]) {
                              for (location = property(vJetsonNanoDatasheet(), "support_locations")) {
                                   translate(location) {
                                        circle(d=property(vM3PhillipsScrewDatasheet(), "nominal_diameter"));
                                   }
                              }
                         }
                         let(controller_datasheet=vControllerDatasheet()) {
                              translate([property(datasheet, "controller_x_offset"), property(datasheet, "controller_y_offset")]) {
                                   for (location = property(controller_datasheet, "support_locations")) {
                                        translate(location) {
                                             circle(d=property(vM3PhillipsScrewDatasheet(), "nominal_diameter"));
                                        }
                                   }
                                   mControllerConnectorCutout();
                              }
                         }
                         let (chassis_datasheet=vChassisDatasheet()) {
                              duplicate([0, 1, 0]) {
                                   translate([property(chassis_datasheet, "battery_stop_x_offset"),
                                              property(chassis_datasheet, "battery_stop_y_offset")]) {
                                        circle(d=property(chassis_datasheet, "batery_stop_hole_diameter"));
                                   }
                              }
                              let(motor_block_datasheet=vMotorBlockDatasheet(),
                                  fastening_screw_datasheet=property(motor_block_datasheet, "fastening_screw_datasheet"),
                                  fastening_screw_diameter=property(fastening_screw_datasheet, "nominal_diameter"),
                                  fastening_screw_x_offset=property(motor_block_datasheet, "fastening_screw_x_offset"),
                                  fastening_screw_y_offset=property(motor_block_datasheet, "fastening_screw_y_offset")) {
                                   for (block_x_offset = [property(chassis_datasheet, "left_motor_block_x_offset"),
                                                          property(chassis_datasheet, "right_motor_block_x_offset")]) {
                                        translate([block_x_offset, 0, 0]) {
                                             rotate([0, 0, -90]) {
                                                  for(x = fastening_screw_x_offset) {
                                                       for(y = fastening_screw_y_offset) {
                                                            translate([x, y, 0]) {
                                                                 circle(d=fastening_screw_diameter);
                                                            }
                                                       }
                                                  }
                                             }
                                        }
                                   }
                              }
                         }
                    }
               }
          }
     }
}


projection()
mBoardSupport();
