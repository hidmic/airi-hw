include <generic/lib.scad>;

use <parts/hcs04_sonar_bracket.scad>;

use <parts/chassis_base.scad>;

use <parts/bumper_base.scad>;
use <parts/bumper.partA.scad>;
use <parts/bumper.partB.scad>;

function vBumperDatasheet() = vBumperBaseDatasheet();

module mBumper() {
     datasheet = vBumperDatasheet();
     bumper_height = property(datasheet, "height");
     bumper_z_offset = property(datasheet, "z_offset");
     sonar_mounting_angles = property(datasheet, "sonar_mounting_angles");
     sonar_mounting_radius = property(datasheet, "sonar_mounting_radius");
     sonar_mounting_z_offset = property(datasheet, "sonar_mounting_z_offset");

     sonar_mounting_polar_angle = property(vHCS04SonarBracketDatasheet(), "mounting_polar_angle");

     translate([0, 0, bumper_z_offset]) {
          mBumper_PartA();
          for (angle = sonar_mounting_angles) {
               rotate([0, 0, angle]) {
                    translate([sonar_mounting_radius, 0, sonar_mounting_z_offset])  {
                         rotate([0, sonar_mounting_polar_angle, 0]) {
                              mHCS04SonarBracket();
                         }
                    }
               }
          }
          mBumper_PartB();
     }
}

mBumper();

use <parts/oem/micro_switch_spdt.scad>;

mMicroSwitchSPDT();
