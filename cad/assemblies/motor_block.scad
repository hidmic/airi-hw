include <generic/lib.scad>;

use <parts/oem/m2_nut.scad>;
use <parts/oem/mr08d_024022_motor.scad>;

use <parts/mr08d_motor_base_support.scad>;

use <motor_bracket.scad>;

function vMotorBlockDatasheet() =
     [];

module mMotorBlock() {
     datasheet = vMotorBlockDatasheet();
     motor_z_offset = property(vMR08DMotorBaseSupportDatasheet(), "motor_z_offset");

     translate([50, 0, motor_z_offset])
     rotate([90, 0, -90])
     mMotorBracket();

     rotate([-90, 0, -90])
     mMR08DMotorBaseSupport();
}

mMotorBlock();

