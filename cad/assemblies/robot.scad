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
use <parts/oem/m3_phillips_screw.scad>;
use <parts/oem/m3_washer.scad>;
use <parts/oem/m3_nut.scad>;

use <parts/board_support.scad>;

use <chassis.scad>;
use <chassis_cover.scad>;
use <motor_block.scad>;
use <left_wheel_block.scad>;
use <right_wheel_block.scad>;
use <rear_ball_caster.scad>;
use <front_ball_caster.scad>;


SHOW_COVER=true;
SHOW_CHASSIS=true;
SHOW_DRIVETRAIN=true;
SHOW_ELECTRONICS=true;


module mRobot() {
     chassis_datasheet = vChassisDatasheet();
     wheel_base = property(chassis_datasheet, "wheel_base");
     chassis_thickness = property(chassis_datasheet, "thickness");
     motor_block_datasheet = vMotorBlockDatasheet();
     motor_z_offset = property(motor_block_datasheet, "motor_z_offset");
     motor_x_offset = property(motor_block_datasheet, "motor_x_offset");
     motor_shaft_y_offset = property(motor_block_datasheet, "shaft_y_offset");
     fastening_screw_x_offset = property(motor_block_datasheet, "fastening_screw_x_offset");
     fastening_screw_y_offset = property(motor_block_datasheet, "fastening_screw_y_offset");

     pulley_datasheet = vGT2Pulley20T8mmBore6mmWideDatasheet();
     pulley_length = property(pulley_datasheet, "body_length");
     pulley_base_length = property(pulley_datasheet, "base_length");
     pulley_tooth_length = property(pulley_datasheet, "tooth_length");

     translate([0, 0, property(chassis_datasheet, "z_offset")]) {
          translate([0, 0, chassis_thickness]) {
               if (SHOW_DRIVETRAIN) {
                    let(belt_datasheet=vGT2Belt122mmLong6mmWideDatasheet(),
                        belt_side_length=property(belt_datasheet, "side_length"),
                        wheel_block_datasheet=vLeftWheelBlockDatasheet(),
                        wheel_block_thickness=property(wheel_block_datasheet, "thickness"),
                        wheel_axle_y_offset=property(wheel_block_datasheet, "wheel_axle_y_offset"),
                        wheel_axle_z_offset=property(wheel_block_datasheet, "wheel_axle_z_offset"),
                        motor_block_x_offset=property(chassis_datasheet, "left_motor_block_x_offset"),
                        pulley_angle=asin((motor_z_offset - wheel_axle_z_offset)/belt_side_length)) {
                         translate([0, wheel_base/2, 0]) {
                              translate([0, wheel_axle_y_offset + pulley_length, wheel_axle_z_offset]) {
                                   rotate([pulley_angle, 0, -90]) {
                                        translate([pulley_base_length + pulley_tooth_length/2, 0, 0]) {
                                             rotate([90, 0, 90]) {
                                                  translate([belt_side_length/2, 0, 0]) mGT2Belt122mmLong6mmWide();
                                             }
                                        }
                                        mGT2Pulley20T8mmBore6mmWide();
                                   }
                              }
                              for (x_offset = property(wheel_block_datasheet, "fastening_x_offset")) {
                                   for (y_offset = property(wheel_block_datasheet, "fastening_y_offset")) {
                                        translate([x_offset, y_offset, 0]) {
                                             translate([0, 0, -chassis_thickness]) {
                                                  mirror([0, 0, 1]) mM3x12mmPhillipsScrew();
                                             }
                                             translate([0, 0, wheel_block_thickness]) {
                                                  mM3Washer();
                                                  translate([0, 0, property(vM3WasherDatasheet(), "thickness")]) {
                                                       mM3Nut();
                                                  }
                                             }
                                        }
                                   }
                              }
                              mLeftWheelBlock();
                         }
                         translate([motor_block_x_offset, 0, 0]) {
                              translate([motor_x_offset, motor_shaft_y_offset - pulley_length, motor_z_offset]) {
                                   rotate([-pulley_angle, 0, 90]) mGT2Pulley20T8mmBore6mmWide();
                              }
                              rotate([0, 0, -90]) {
                                   for (x_offset = fastening_screw_x_offset) {
                                        for (y_offset = fastening_screw_y_offset)  {
                                             translate([x_offset, y_offset, 0]) {
                                                  translate([0, 0, -chassis_thickness]) {
                                                       mirror([0, 0, 1]) mM3x12mmPhillipsScrew();
                                                  }
                                                  translate([0, 0, wheel_block_thickness]) {
                                                       mM3Washer();
                                                       translate([0, 0, property(vM3WasherDatasheet(), "thickness")]) {
                                                            mM3Nut();
                                                       }
                                                  }
                                             }
                                        }
                                   }
                              }
                              mMotorBlock();
                         }
                    }

                    let(belt_datasheet=vGT2Belt280mmLong6mmWideDatasheet(),
                        belt_side_length=property(belt_datasheet, "side_length"),
                        wheel_block_datasheet=vRightWheelBlockDatasheet(),
                        wheel_block_thickness=property(wheel_block_datasheet, "thickness"),
                        wheel_axle_y_offset=property(wheel_block_datasheet, "wheel_axle_y_offset"),
                        wheel_axle_z_offset=property(wheel_block_datasheet, "wheel_axle_z_offset"),
                        motor_block_x_offset=property(chassis_datasheet, "right_motor_block_x_offset"),
                        pulley_angle=asin((motor_z_offset - wheel_axle_z_offset)/belt_side_length)) {
                         translate([0, -wheel_base/2, 0]) {
                              translate([0, wheel_axle_y_offset - pulley_length, wheel_axle_z_offset]) {
                                   rotate([-pulley_angle, 0, 90]) {
                                        translate([pulley_base_length + pulley_tooth_length/2, 0, 0]) {
                                             rotate([90, 0, -90]) {
                                                  translate([belt_side_length/2, 0, 0]) mGT2Belt280mmLong6mmWide();
                                             }
                                        }
                                        mGT2Pulley20T8mmBore6mmWide();
                                   }
                              }
                              for (x_offset = property(wheel_block_datasheet, "fastening_x_offset")) {
                                   for (y_offset = property(wheel_block_datasheet, "fastening_y_offset")) {
                                        translate([x_offset, y_offset, 0]) {
                                             translate([0, 0, -chassis_thickness]) {
                                                  mirror([0, 0, 1]) mM3x12mmPhillipsScrew();
                                             }
                                             translate([0, 0, wheel_block_thickness]) {
                                                  mM3Washer();
                                                  translate([0, 0, property(vM3WasherDatasheet(), "thickness")]) {
                                                       mM3Nut();
                                                  }
                                             }
                                        }
                                   }
                              }
                              mRightWheelBlock();
                         }
                         translate([motor_block_x_offset, 0, 0]) {
                              translate([motor_x_offset, -motor_shaft_y_offset + pulley_length, motor_z_offset]) {
                                   rotate([pulley_angle, 0, -90]) mGT2Pulley20T8mmBore6mmWide();
                              }
                              rotate([0, 0, -90]) {
                                   for (x_offset = fastening_screw_x_offset) {
                                        for (y_offset = fastening_screw_y_offset)  {
                                             translate([x_offset, y_offset, 0]) {
                                                  translate([0, 0, -chassis_thickness]) {
                                                       mirror([0, 0, 1]) mM3x12mmPhillipsScrew();
                                                  }
                                                  translate([0, 0, wheel_block_thickness]) {
                                                       mM3Washer();
                                                       translate([0, 0, property(vM3WasherDatasheet(), "thickness")]) {
                                                            mM3Nut();
                                                       }
                                                  }
                                             }
                                        }
                                   }
                              }
                              mirror([0, 1, 0]) mMotorBlock();
                         }
                    }

                    translate([property(chassis_datasheet, "front_caster_x_offset"), 0, 0]) {
                         duplicate([0, 1, 0]) {
                              translate([0, property(vFrontBallCasterDatasheet(), "mount_offset"), -chassis_thickness]) {
                                   mirror([0, 0, 1]) mM3x12mmPhillipsScrew();
                              }
                         }
                         mFrontBallCaster();
                    }
                    translate([property(chassis_datasheet, "rear_caster_x_offset"), 0, 0]) {
                         rotate([0, 0, 90]) {
                              duplicate([0, 1, 0]) {
                                   translate([0, property(vRearBallCasterDatasheet(), "mount_offset"), -chassis_thickness]) {
                                        mirror([0, 0, 1]) mM3x12mmPhillipsScrew();
                                   }
                              }
                              mRearBallCaster();
                         }
                    }
               }

               if (SHOW_ELECTRONICS) {
                    duplicate([0, 1, 0]) {
                         translate([property(chassis_datasheet, "battery_x_offset"),
                                    property(chassis_datasheet, "battery_y_offset"), 0]) {
                              m12v5a4hBattery();
                         }
                    }

                    mBoardSupport();
                    let(board_support_datasheet=vBoardSupportDatasheet(),
                        board_support_z_offset=property(board_support_datasheet, "z_offset"),
                        board_support_height=property(board_support_datasheet, "height")) {
                         translate([0, 0, board_support_z_offset + board_support_height]) {
                              translate([property(board_support_datasheet, "lidar_x_offset"),
                                         property(board_support_datasheet, "lidar_y_offset"), 0]) {
                                   mRPLidarA1M8R1();
                                   for (location = property(vRPLidarA1M8R1Datasheet(), "support_locations")) {
                                        translate(location) {
                                             translate([0, 0, -board_support_height]) {
                                                  mirror([0, 0, 1]) mM3x12mmPhillipsScrew();
                                             }
                                        }
                                   }
                              }
                              translate([property(board_support_datasheet, "computer_x_offset"),
                                         property(board_support_datasheet, "computer_y_offset"), 0]) {
                                   for (location = property(vJetsonNanoDatasheet(), "support_locations")) {
                                        translate(location) {
                                             mM3x10mmHexThreadedStandoff();
                                             translate([0, 0, -board_support_height]) {
                                                  mirror([0, 0, 1]) mM3x12mmPhillipsScrew();
                                             }
                                        }
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
                                   let(ir_sensor_datasheet=vKY033IRSensorDatasheet()) {
                                        translate([property(chassis_datasheet, "ir_sensor_r_offset"), 0, 0]) {
                                             rotate([0, 0, -90]) {
                                                  translate([0, 0, property(ir_sensor_datasheet, "sensor_z_offset")]) {
                                                       mKY033IRSensor();
                                                  }
                                                  translate([0, -(property(ir_sensor_datasheet, "sensor_y_offset") -
                                                                  property(ir_sensor_datasheet, "hole_y_offset")), 0]) {
                                                       mM3x10mmHexStandoff();
                                                  }
                                             }
                                        }
                                   }
                              }
                         }
                    }
               }
          }

          if (SHOW_CHASSIS) {
               mChassis();
          }

          if (SHOW_COVER) {
               translate([0, 0, property(chassis_datasheet, "height")]) {
                    mChassisCover();
                    //mM8x50mmThreadedStud();
               }
          }
     }
}

mRobot();
