include <generic/lib.scad>;

use <parts/oem/12v7ah_battery.scad>;

use <parts/base_chassis.scad>;

use <motor_block.scad>;
use <left_wheel_block.scad>;
use <right_wheel_block.scad>;
use <rear_ball_caster.scad>;


module mRobot() {
     chassis_datasheet = vBaseChassisDatasheet();
     mBaseChassis();
     translate([0, 0, property(chassis_datasheet, "thickness")]) {
          translate([0, property(chassis_datasheet, "wheel_base")/2, 0]) {
               mLeftWheelBlock();
          }
          translate([0, -property(chassis_datasheet, "wheel_base")/2, 0]) {
               mRightWheelBlock();
          }
          let (battery_datasheet=v12v7ahBatteryDatasheet()) {
               for (x = [0, -property(battery_datasheet, "width") - 10])
               translate([x - 10, 0, 0])
               translate([-property(battery_datasheet, "width")/2, 0, 0]) {
                    rotate([0, 0, 90]) {
                         translate([-property(battery_datasheet, "length")/2,
                                    -property(battery_datasheet, "width")/2, 0]) {
                              m12v7ahBattery();
                         }
                    }
               }
          }
     }
     //mRearBallCaster();
}

mRobot();
