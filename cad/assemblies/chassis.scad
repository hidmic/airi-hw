include <generic/lib.scad>;

use <parts/base_chassis.scad>;
use <parts/base_chassis.partA.scad>;
use <parts/base_chassis.partB.scad>;

use <bumper.scad>;

function vChassisDatasheet() =
     vBaseChassisDatasheet();

module mChassis() {
     mBaseChassis_PartA();
     mBaseChassis_PartB();

     mBumper();
}

mChassis();
