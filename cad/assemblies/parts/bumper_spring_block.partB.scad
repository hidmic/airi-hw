include <generic/lib.scad>;

use <chassis_base.scad>;
use <bumper_spring_block_base.scad>;

kChassisBaseDatasheet = vChassisBaseDatasheet();

function vBumperSpringBlock_PartB_Datasheet() =
     vBumperSpringBlockBaseDatasheet();


module mBumperSpringBlock_PartB() {
     datasheet = vBumperSpringBlock_PartB_Datasheet();
     height = property(datasheet, "height");
     depth = property(datasheet, "depth");
     spring_lock_size = property(datasheet, "spring_lock_size");

     chassis_outer_diameter = property(kChassisBaseDatasheet, "outer_diameter");

     module mBumperSpringBlock_PartB_XSection() {
          translate([-spring_lock_size, -spring_lock_size]) {
               difference() {
                    translate([spring_lock_size, spring_lock_size]) mBumperSpringBlockXSection();
                    square([depth, chassis_outer_diameter/2]);
               }
          }
     }

     render() {
          difference() {
               linear_extrude(height=height) {
                    mBumperSpringBlock_PartB_XSection();
               }
               mBumperSpringBlockSeatComplement();
          }
     }
}


mBumperSpringBlock_PartB();
