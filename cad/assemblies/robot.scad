include <generic/lib.scad>;

use <parts/oem/12v5a4h_battery.scad>;
use <parts/oem/rplidar_a1m8_r1.scad>;
use <parts/oem/jetson_nano.scad>;
use <parts/oem/stm32_disco.scad>;
use <parts/oem/gt2_pulley.scad>;
use <parts/oem/gt2_belt.scad>;

use <parts/base_chassis.scad>;

use <motor_block.scad>;
use <left_wheel_block.scad>;
use <right_wheel_block.scad>;
use <rear_ball_caster.scad>;
use <front_ball_caster.scad>;


module mRobot() {
     chassis_datasheet = vBaseChassisDatasheet();

     mBaseChassis();

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
              motor_block_x_offset=sqrt(pow(motor_z_offset - wheel_axle_z_offset, 2)
                                        + pow(belt_side_length, 2)) - motor_x_offset,
              pulley_angle=asin((motor_z_offset - wheel_axle_z_offset)/belt_side_length)) {
               translate([0, property(chassis_datasheet, "wheel_base")/2, 0]) {
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
              motor_block_x_offset=sqrt(pow(motor_z_offset - wheel_axle_z_offset, 2)
                                        + pow(belt_side_length, 2)) - motor_x_offset,
              pulley_angle=asin((motor_z_offset - wheel_axle_z_offset)/belt_side_length)) {
               translate([0, -property(chassis_datasheet, "wheel_base")/2, 0]) {
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
          let (battery_datasheet=v12v5a4hBatteryDatasheet()) {
               //translate([-property(battery_datasheet, "width"), 0, 0])
               // rotate([0, 0, -20])
               // translate([-property(battery_datasheet, "length")/2 - 30, 20, 0])
               /* translate([-65, 0, 0]) */
//               rotate([0, 90, 0])
               // rotate([0, 0, 90])//               translate([-property(battery_datasheet, "width")-8, 0, 0])
               duplicate([0, 1, 0])
                    translate([-property(battery_datasheet, "width")/2 - 75,
                               property(battery_datasheet, "length")/2 + 35, 0]) {
                    rotate([0, 0, -90]) m12v5a4hBattery();
                    }
          }
          translate([property(chassis_datasheet, "front_caster_x_offset"), 0, 0]) {
               mFrontBallCaster();
          }
          translate([property(chassis_datasheet, "rear_caster_x_offset"), 0, 0]) {
               rotate([0, 0, 90]) mRearBallCaster();
          }
     }



     translate([0, 0, property(vMotorBlockDatasheet(), "pillar_height")]) {
          translate([0, 0, 8]) {
          rotate([0, 0, 180]) mRPLidarA1M8R1();
          translate([90, 0, 0])
               rotate([0, 0, -90]) mJetsonNano();
          }
          mirror([0, 0, 1]) translate([-20, 0, 5]) mSTM32Disco();
     }
}

mRobot();
