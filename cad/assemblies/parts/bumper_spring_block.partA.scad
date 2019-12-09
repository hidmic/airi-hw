include <generic/lib.scad>;

use <chassis_base.scad>;
use <bumper_spring_block_base.scad>;

kChassisBaseDatasheet = vChassisBaseDatasheet();

function vBumperSpringBlock_PartA_Datasheet() =
     vBumperSpringBlockBaseDatasheet();


module mBumperSpringBlock_PartA() {
     datasheet = vBumperSpringBlock_PartA_Datasheet();
     height = property(datasheet, "height");
     width = property(datasheet, "width");
     depth = property(datasheet, "depth");
     angular_offset = property(datasheet, "angular_offset");

     spring_outer_diameter = property(datasheet, "spring_outer_diameter");
     spring_lock_size = property(datasheet, "spring_lock_size");
     spring_seat_thickness = property(datasheet, "spring_seat_thickness");
     spring_slot_width = property(datasheet, "spring_slot_width");

     chassis_outer_diameter = property(kChassisBaseDatasheet, "outer_diameter");

     module mBumperSpringBlock_PartA_XSection() {
          translate([-spring_lock_size, -spring_lock_size]) {
               intersection() {
                    translate([spring_lock_size, spring_lock_size]) mBumperSpringBlockXSection();
                    square([depth, chassis_outer_diameter/2]);
               }
          }
     }

     render() {
          difference() {
               linear_extrude(height=height) {
                    mBumperSpringBlock_PartA_XSection();
               }
               mBumperSpringBlockSeatComplement();
          }
          linear_extrude(height=55) { // bumperHeight / 2
               difference() {
                    translate([-spring_lock_size, 0]) {
                         square([spring_seat_thickness + spring_slot_width, width/2 - spring_outer_diameter/2]);
                    }
                    translate([-chassis_outer_diameter/2 * cos(angular_offset), chassis_outer_diameter/2 * sin(angular_offset)]) {
                         ring(inner_radius=chassis_outer_diameter/2 - kEpsilon, outer_radius=chassis_outer_diameter);
                    }
               }
          }
     }
}


mBumperSpringBlock_PartA();
