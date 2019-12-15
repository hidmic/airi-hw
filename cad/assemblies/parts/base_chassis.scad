include <generic/lib.scad>;

use <oem/12v5a4h_battery.scad>;
use <oem/ky033_ir_sensor.scad>;
use <oem/gt2_belt.scad>;
use <oem/m3_hex_standoff.scad>;
use <oem/m3x5mm_threaded_insert.scad>;

use <10mm_ball_caster_base.scad>;
use <50mm_ball_caster_base.scad>;

use <chassis_base.scad>;
use <chassis_base_cover.scad>;
use <bumper_base.scad>;
use <bumper_spring_block.scad>;
use <wheel_block_frame.scad>;

use <../motor_block.scad>;
use <../left_wheel_block.scad>;
use <../right_wheel_block.scad>;


function vBaseChassisDatasheet() =
     let(chassis_datasheet=vChassisBaseDatasheet(),
         chassis_cover_datasheet = vChassisBaseCoverDatasheet(),
         height=property(chassis_datasheet, "base_height"),
         outer_diameter=property(chassis_datasheet, "outer_diameter"),
         inner_diameter=property(chassis_datasheet, "inner_diameter"),
         thickness=property(chassis_datasheet, "thickness"),
         fillet_radius=property(chassis_datasheet, "fillet_radius"),
         motor_block_datasheet=vMotorBlockDatasheet(),
         motor_z_offset = property(motor_block_datasheet, "motor_z_offset"),
         motor_x_offset = property(motor_block_datasheet, "motor_x_offset"),
         motor_shaft_y_offset = property(motor_block_datasheet, "shaft_y_offset"),
         left_wheel_block_datasheet=vLeftWheelBlockDatasheet(),
         left_wheel_axle_y_offset=property(left_wheel_block_datasheet, "wheel_axle_y_offset"),
         left_wheel_axle_z_offset=property(left_wheel_block_datasheet, "wheel_axle_z_offset"),
         left_belt_datasheet=vGT2Belt122mmLong6mmWideDatasheet(),
         left_belt_side_length=property(left_belt_datasheet, "side_length"),
         left_motor_block_x_offset=sqrt(pow(motor_z_offset - left_wheel_axle_z_offset, 2)
                                        + pow(left_belt_side_length, 2)) - motor_x_offset,
         right_wheel_block_datasheet=vRightWheelBlockDatasheet(),
         right_wheel_axle_y_offset=property(right_wheel_block_datasheet, "wheel_axle_y_offset"),
         right_wheel_axle_z_offset=property(right_wheel_block_datasheet, "wheel_axle_z_offset"),
         right_belt_datasheet=vGT2Belt280mmLong6mmWideDatasheet(),
         right_belt_side_length=property(right_belt_datasheet, "side_length"),
         right_motor_block_x_offset=sqrt(pow(motor_z_offset - right_wheel_axle_z_offset, 2)
                                         + pow(right_belt_side_length, 2)) - motor_x_offset,
         wheel_block_frame_datasheet=vWheelBlockFrameDatasheet(),
         wheel_diameter=property(wheel_block_frame_datasheet, "wheel_diameter"),
         wheel_width=property(wheel_block_frame_datasheet, "wheel_width"),
         wheel_block_outer_radius=property(wheel_block_frame_datasheet, "outer_radius"),
         wheel_axle_z_offset=property(wheel_block_frame_datasheet, "wheel_axle_z_offset"),
         front_caster_opening_diameter=property(v10mmBallCasterBaseDatasheet(), "support_opening_diameter"),
         rear_caster_opening_diameter=property(v50mmBallCasterBaseDatasheet(), "support_opening_diameter"),
         battery_datasheet=v12v5a4hBatteryDatasheet(), battery_width=property(battery_datasheet, "width"),
         battery_length=property(battery_datasheet, "length"), battery_stop_side_length=10,
         battery_x_offset=-battery_width/2 - wheel_block_outer_radius - 6,
         battery_y_offset=battery_length/2 + rear_caster_opening_diameter/2 + 6,
         ir_sensor_datasheet=vKY033IRSensorDatasheet(), spring_block_datasheet=vBumperSpringBlockDatasheet(),
         ir_sensor_x_offset=-(property(spring_block_datasheet, "spring_gap_width") + 1),
         ir_sensor_r_offset=(inner_diameter/2 - fillet_radius - property(ir_sensor_datasheet, "length")/2 +
                             property(ir_sensor_datasheet, "sensor_y_offset")))
     [["height", height], ["outer_diameter", outer_diameter], ["inner_diameter", inner_diameter],
      ["thickness", thickness], ["fillet_radius", fillet_radius], ["wheel_base", 242],
      ["wheel_slot_length", 2 * sqrt(pow(wheel_diameter/2 + 8, 2) - pow(wheel_axle_z_offset, 2))],
      ["wheel_slot_width", wheel_width + 8], ["support_pin_diameter", 4], ["support_pin_height", 4],
      ["cover_support_angles", concat(property(chassis_cover_datasheet, "support_angles"),
                                      property(chassis_cover_datasheet, "bay_support_angles"))],
      ["cover_support_r_offset", property(chassis_cover_datasheet, "support_r_offset")],
      ["cover_support_diameter", property(chassis_cover_datasheet, "support_diameter")],
      ["left_motor_block_x_offset", left_motor_block_x_offset],
      ["right_motor_block_x_offset", right_motor_block_x_offset],
      ["battery_x_offset", battery_x_offset], ["battery_y_offset", battery_y_offset],
      ["battery_stop_side_length", battery_stop_side_length],
      ["battery_stop_height", (property(motor_block_datasheet, "main_height") -
                               property(vM3x30mmHexThreadedStandoffDatasheet(), "length"))],
      ["battery_stop_x_offset", battery_x_offset + battery_width/2 + thickness + battery_stop_side_length/2],
      ["battery_stop_y_offset", property(motor_block_datasheet, "fastening_screw_x_offset")[0]],
      ["batery_stop_hole_diameter", property(vM3x5mmThreadedInsertDatasheet(), "nominal_diameter")],
      ["ir_sensor_x_offset", ir_sensor_x_offset], ["ir_sensor_r_offset", ir_sensor_r_offset], ["ir_sensor_angles", [-40, 40]],
      ["front_caster_x_offset", outer_diameter/2 - 2 * front_caster_opening_diameter],
      ["rear_caster_x_offset", -outer_diameter/2 + rear_caster_opening_diameter + 10],
      ["airway_width", 2], ["wall_airway_length", height * 0.70], ["wall_airway_z_offset", height * 0.25],
      ["wall_airway_angles", concat([for (a = [-160:2.5:-145]) a], [for (a = [145:2.5:160]) a],
                                    [for (a = [-175:2.5:-170]) a], [for (a = [170:2.5:175]) a])],
      ["bottom_airway_length", property(motor_block_datasheet, "outer_width")],
      ["bottom_airway_x_offset", [for (x = [-60:6:-14]) x]],
      ["front_airway_r_offset", [for (r = [12:6:30]) (inner_diameter/2 - r)]],
      ["front_airway_theta_offset", [-22.5, 22.5]], ["front_airway_angular_width", 25]];


module mBaseChassis() {
     datasheet = vBaseChassisDatasheet();
     height = property(datasheet, "height");
     thickness = property(datasheet, "thickness");
     inner_diameter = property(datasheet, "inner_diameter");
     outer_diameter = property(datasheet, "outer_diameter");
     fillet_radius = property(datasheet, "fillet_radius");

     airway_width = property(datasheet, "airway_width");
     wall_airway_angles = property(datasheet, "wall_airway_angles");
     wall_airway_length = property(datasheet, "wall_airway_length");
     wall_airway_z_offset = property(datasheet, "wall_airway_z_offset");
     bottom_airway_x_offset = property(datasheet, "bottom_airway_x_offset");
     bottom_airway_length = property(datasheet, "bottom_airway_length");
     front_airway_r_offset = property(datasheet, "front_airway_r_offset");
     front_airway_theta_offset = property(datasheet, "front_airway_theta_offset");
     front_airway_angular_width = property(datasheet, "front_airway_angular_width");

     render() {
          difference() {
               mChassisShell();
               for (angle = wall_airway_angles) {
                    rotate([0, 0, angle]) {
                         translate([(outer_diameter + inner_diameter)/4, 0, wall_airway_z_offset]) {
                              duplicate([0, 0, 1]) {
                                   translate([0, 0, wall_airway_length/2 - airway_width/2]) {
                                        rotate([0, 90, 0]) {
                                             cylinder(d=airway_width, h=2 * fillet_radius, center=true);
                                        }
                                   }
                              }
                              cube([2 * fillet_radius, airway_width, wall_airway_length - airway_width], center=true);
                         }
                    }
               }
               for (theta = front_airway_theta_offset) {
                    rotate([0, 0, theta]) {
                         for (r = front_airway_r_offset) {
                              linear_extrude(height=2 * (thickness + kEpsilon), center=true) {
                                   rounded_ring(outer_radius=r + airway_width/2, inner_radius=r - airway_width/2,
                                                angles=[-front_airway_angular_width/2, front_airway_angular_width/2]);
                              }
                         }
                    }
               }
               for (x = bottom_airway_x_offset) {
                    translate([x, 0, 0]) {
                         duplicate([0, 1, 0]) {
                              translate([0, bottom_airway_length/2 - airway_width/2, 0]) {
                                   cylinder(d=airway_width, h=2 * (thickness + kEpsilon), center=true);
                              }
                         }
                         cube([airway_width, bottom_airway_length - airway_width, 2 * (thickness + kEpsilon)], center=true);
                    }
               }
               translate([0, 0, height]) {
                    mChassisBBox();
               }
               mBumperBaseComplement();

               translate([0, 0, -kEpsilon]) {
                    let(ir_sensor_datasheet=vKY033IRSensorDatasheet()) {
                         translate([property(datasheet, "ir_sensor_x_offset"), 0, 0]) {
                              for (angle = property(datasheet, "ir_sensor_angles")) {
                                   rotate([0, 0, angle]) {
                                        translate([property(datasheet, "ir_sensor_r_offset"),
                                                   0, thickness/2 + kEpsilon]) {
                                             cube([property(ir_sensor_datasheet, "sensor_width"),
                                                   property(ir_sensor_datasheet, "sensor_length"),
                                                   thickness + 2 * kEpsilon], center=true);
                                        }
                                   }
                              }
                         }
                    }
                    duplicate([0, 1, 0]) {
                         let(wheel_block_frame_datasheet=vWheelBlockFrameDatasheet()) {
                              translate([0, property(datasheet, "wheel_base")/2, 0]) {
                                   translate([0, 0, thickness/2 + kEpsilon]) {
                                        cube([property(datasheet, "wheel_slot_length"),
                                              property(datasheet, "wheel_slot_width"),
                                              thickness + 2 * kEpsilon], center=true);
                                   }
                                   for(x = property(wheel_block_frame_datasheet, "fastening_x_offset")) {
                                        for(y = property(wheel_block_frame_datasheet, "fastening_y_offset")) {
                                             translate([x, y, 0]) {
                                                  cylinder(d=property(wheel_block_frame_datasheet, "fastening_hole_diameter"),
                                                           h=thickness + 2 * kEpsilon);
                                             }
                                        }
                                   }
                              }
                         }
                    }
                    let(motor_block_datasheet=vMotorBlockDatasheet(),
                        fastening_screw_datasheet=property(motor_block_datasheet, "fastening_screw_datasheet"),
                        fastening_screw_diameter=property(fastening_screw_datasheet, "nominal_diameter"),
                        fastening_screw_x_offset=property(motor_block_datasheet, "fastening_screw_x_offset"),
                        fastening_screw_y_offset=property(motor_block_datasheet, "fastening_screw_y_offset")) {
                         for (block_x_offset = [property(datasheet, "left_motor_block_x_offset"),
                                                property(datasheet, "right_motor_block_x_offset")]) {
                              translate([block_x_offset, 0, 0]) {
                                   rotate([0, 0, -90]) {
                                        for(x = fastening_screw_x_offset) {
                                             for(y = fastening_screw_y_offset) {
                                                  translate([x, y, 0]) {
                                                       cylinder(d=fastening_screw_diameter,
                                                                h=thickness + 2 * kEpsilon);
                                                  }
                                             }
                                        }
                                   }
                              }
                         }
                    }
                    let(caster_datasheet=v10mmBallCasterBaseDatasheet(),
                        mount_offset=property(caster_datasheet, "mount_offset"),
                        mount_hole_diameter=property(caster_datasheet, "mount_hole_diameter"),
                        opening_diameter=property(caster_datasheet, "support_opening_diameter")) {
                         translate([property(datasheet, "front_caster_x_offset"), 0, 0]) {
                              cylinder(d=opening_diameter, h=thickness + 2 * kEpsilon);
                              duplicate([0, 1, 0]) {
                                   translate([0, mount_offset, 0]) {
                                        cylinder(d=mount_hole_diameter, h=thickness + 2 * kEpsilon);
                                   }
                              }

                         }
                    }
                    let(caster_datasheet=v50mmBallCasterBaseDatasheet(),
                        mount_offset=property(caster_datasheet, "mount_offset"),
                        mount_hole_diameter=property(caster_datasheet, "mount_hole_diameter"),
                        opening_diameter=property(caster_datasheet, "support_opening_diameter")) {
                         translate([property(datasheet, "rear_caster_x_offset"), 0, 0]) {
                              cylinder(d=opening_diameter, h=thickness + 2 * kEpsilon);
                              duplicate([1, 0, 0]) {
                                   translate([mount_offset, 0, 0]) {
                                        cylinder(d=mount_hole_diameter, h=thickness + 2 * kEpsilon);
                                   }
                              }
                         }
                    }
                    duplicate([0, 1, 0]) {
                         translate([property(datasheet, "battery_stop_x_offset"),
                                    property(datasheet, "battery_stop_y_offset"),
                                    0]) {
                              cylinder(d=property(datasheet, "battery_stop_hole_diameter"), h=thickness + 2 * kEpsilon);
                         }
                    }
               }
          }
          mChassisVolumeConstrain() {
               linear_extrude(height=height) {
                    duplicate([0, 1, 0]) {
                         mBumperLockXSection();
                    }
               }
          }
          difference() {
               let(block_x_offset=property(vBumperSpringBlockDatasheet(), "x_offset"),
                   block_y_offset=property(vBumperSpringBlockDatasheet(), "y_offset"),
                   bumper_height=property(vBumperBaseDatasheet(), "height")) {
                    duplicate([0, 1, 0]) {
                         translate([block_x_offset, block_y_offset, bumper_height/2 + fillet_radius]) {
                              duplicate([0, 0, 1]) {
                                   translate([0, 0, -bumper_height/2]) mBumperSpringRearBlock();
                              }
                         }
                    }
               }
               translate([0, 0, height]) {
                    mChassisBBox();
               }
          }
          let(battery_datasheet=v12v5a4hBatteryDatasheet(),
              battery_length=property(battery_datasheet, "length"),
              battery_width=property(battery_datasheet, "width"),
              battery_height=property(battery_datasheet, "height"),
              stop_height=property(datasheet, "battery_stop_height")) {
               translate([0, 0, thickness]) {
                    duplicate([0, 1, 0]) {
                         translate([property(datasheet, "battery_x_offset"),
                                    property(datasheet, "battery_y_offset"), 0]) {
                              linear_extrude(height=stop_height) {
                                   translate([-battery_width/2, -battery_length/2]) {
                                        difference() {
                                             union() {
                                                  translate([-thickness, battery_length+thickness]) {
                                                       mirror([0, 1, 0]) square([battery_width/5, battery_length/5]);
                                                  }
                                                  translate([battery_width+thickness, -thickness]) {
                                                       mirror([1, 0, 0]) {
                                                            square([  + battery_width/5, battery_length/5]);
                                                       }
                                                  }
                                                  translate([-thickness, -thickness]) {
                                                       square([battery_width/5, battery_length/5]);
                                                  }
                                             }
                                             offset(delta=kEpsilon) {
                                                  square([battery_width, battery_length]);
                                             }
                                        }
                                   }
                              }
                         }
                         translate([property(datasheet, "battery_stop_x_offset"),
                                    property(datasheet, "battery_stop_y_offset"),
                                    0]) {
                              difference() {
                                   translate([0, 0, stop_height/2]) {
                                        cube([property(datasheet, "battery_stop_side_length"),
                                              property(datasheet, "battery_stop_side_length"),
                                              stop_height], center=true);
                                   }
                                   translate([0, 0, stop_height]) mM3x5mmThreadedInsertTaperCone();
                                   translate([0, 0, -kEpsilon]) {
                                        cylinder(d=property(datasheet, "battery_stop_hole_diameter"), h=stop_height + 2 * kEpsilon);
                                   }
                              }
                         }
                    }
               }
          }
     }
}

mBaseChassis();
