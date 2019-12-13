include <generic/lib.scad>;

use <parts/oem/12v5a4h_battery.scad>;
use <parts/oem/rplidar_a1m8_r1.scad>;
use <parts/oem/jetson_nano.scad>;
use <parts/oem/stm32_disco.scad>;
use <parts/oem/gt2_pulley.scad>;
use <parts/oem/gt2_belt.scad>;
use <parts/oem/gy521_imu.scad>;
use <parts/oem/ky033_ir_sensor.scad>;
use <parts/oem/m3_hex_standoff.scad>;

use <parts/board_support.scad>;

use <chassis.scad>;
use <motor_block.scad>;
use <left_wheel_block.scad>;
use <right_wheel_block.scad>;
use <rear_ball_caster.scad>;
use <front_ball_caster.scad>;


module mRobot() {
     chassis_datasheet = vChassisDatasheet();
     wheel_base = property(chassis_datasheet, "wheel_base");

     motor_block_datasheet = vMotorBlockDatasheet();
     motor_z_offset = property(motor_block_datasheet, "motor_z_offset");
     motor_x_offset = property(motor_block_datasheet, "motor_x_offset");
     motor_shaft_y_offset = property(motor_block_datasheet, "shaft_y_offset");

     pulley_datasheet = vGT2Pulley20T8mmBore6mmWideDatasheet();
     pulley_length = property(pulley_datasheet, "body_length");
     pulley_base_length = property(pulley_datasheet, "base_length");
     pulley_tooth_length = property(pulley_datasheet, "tooth_length");

     translate([0, 0, property(chassis_datasheet, "thickness")]) {
          let(belt_datasheet=vGT2Belt280mmLong6mmWideDatasheet(),
              belt_side_length=property(belt_datasheet, "side_length"),
              wheel_block_datasheet=vLeftWheelBlockDatasheet(),
              wheel_axle_y_offset=property(wheel_block_datasheet, "wheel_axle_y_offset"),
              wheel_axle_z_offset=property(wheel_block_datasheet, "wheel_axle_z_offset"),
              motor_block_x_offset=property(chassis_datasheet, "left_motor_block_x_offset"),
              pulley_angle=asin((motor_z_offset - wheel_axle_z_offset)/belt_side_length)) {
               translate([0, wheel_base/2, 0]) {
                    translate([0, wheel_axle_y_offset + pulley_length, wheel_axle_z_offset]) {
                         rotate([pulley_angle, 0, -90]) {
                              translate([pulley_base_length + pulley_tooth_length/2, 0, 0]) {
                                   rotate([90, 0, 90]) {
                                        translate([belt_side_length/2, 0, 0]) mGT2Belt280mmLong6mmWide();
                                   }
                              }
                              mGT2Pulley20T8mmBore6mmWide();
                         }
                    }
                    mLeftWheelBlock();
               }
               translate([motor_block_x_offset, 0, 0]) {
                    translate([motor_x_offset, motor_shaft_y_offset - pulley_length, motor_z_offset]) {
                         rotate([-pulley_angle, 0, 90]) mGT2Pulley20T8mmBore6mmWide();
                    }
                    mirror([0, 1, 0]) mMotorBlock();
               }
          }

          let(belt_datasheet=vGT2Belt122mmLong6mmWideDatasheet(),
              belt_side_length=property(belt_datasheet, "side_length"),
              wheel_block_datasheet=vRightWheelBlockDatasheet(),
              wheel_axle_y_offset=property(wheel_block_datasheet, "wheel_axle_y_offset"),
              wheel_axle_z_offset=property(wheel_block_datasheet, "wheel_axle_z_offset"),
              motor_block_x_offset=property(chassis_datasheet, "right_motor_block_x_offset"),
              pulley_angle=asin((motor_z_offset - wheel_axle_z_offset)/belt_side_length)) {
               translate([0, -wheel_base/2, 0]) {
                    translate([0, wheel_axle_y_offset - pulley_length, wheel_axle_z_offset]) {
                         rotate([-pulley_angle, 0, 90]) {
                              translate([pulley_base_length + pulley_tooth_length/2, 0, 0]) {
                                   rotate([90, 0, -90]) {
                                        translate([belt_side_length/2, 0, 0]) mGT2Belt122mmLong6mmWide();
                                   }
                              }
                              mGT2Pulley20T8mmBore6mmWide();
                         }
                    }
                    mRightWheelBlock();
               }
               translate([motor_block_x_offset, 0, 0]) {
                    translate([motor_x_offset, -motor_shaft_y_offset + pulley_length, motor_z_offset]) {
                         rotate([pulley_angle, 0, -90]) mGT2Pulley20T8mmBore6mmWide();
                    }
                    mMotorBlock();
               }
          }

          duplicate([0, 1, 0]) {
               translate([property(chassis_datasheet, "battery_x_offset"),
                          property(chassis_datasheet, "battery_y_offset"), 0]) {
                    m12v5a4hBattery();
               }
          }

          translate([property(chassis_datasheet, "front_caster_x_offset"), 0, 0]) {
               mFrontBallCaster();
          }
          translate([property(chassis_datasheet, "rear_caster_x_offset"), 0, 0]) {
               rotate([0, 0, 90]) mRearBallCaster();
          }

          mBoardSupport();
          let(board_support_datasheet=vBoardSupportDatasheet()) {
               translate([0, 0, (property(board_support_datasheet, "z_offset") +
                                 property(board_support_datasheet, "height"))]) {
                    translate([property(board_support_datasheet, "lidar_x_offset"),
                               property(board_support_datasheet, "lidar_y_offset"), 0]) {
                         mRPLidarA1M8R1();
                    }
                    translate([property(board_support_datasheet, "computer_x_offset"),
                               property(board_support_datasheet, "computer_y_offset"), 0]) {
                         for (location = property(vJetsonNanoDatasheet(), "support_locations")) {
                              translate(location) mM3x10mmHexThreadedStandoff();
                         }
                         translate([0, 0, property(vM3x10mmHexThreadedStandoffDatasheet(), "length")]) {
                              mJetsonNano();
                         }
                    }
                    mirror([0, 0, 1]) translate([-20, 0, 5]) mSTM32Disco();
               }
          }
          rotate([0, 0, 90]) mGY521IMU();
          for (angle = property(chassis_datasheet, "ir_sensor_angles")) {
               translate([property(chassis_datasheet, "ir_sensor_x_offset"), 0, 0]) {
                    rotate([0, 0, angle]) {
                         translate([property(chassis_datasheet, "ir_sensor_r_offset"), 0, 0]) {
                              rotate([0, 0, -90]) mKY033IRSensor();
                         }
                    }
               }
          }
     }

     mChassis();

     
}

mRobot();
