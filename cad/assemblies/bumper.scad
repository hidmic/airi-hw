include <generic/lib.scad>;

use <parts/hcs04_sonar_bracket.scad>;

use <parts/chassis_base.scad>;

use <parts/bumper_base.scad>;
use <parts/bumper.partA.scad>;
use <parts/bumper.partB.scad>;

function vBumperDatasheet() = vBumperBaseDatasheet();

module mBumper() {
     mBumper_PartA();
     mBumper_PartB();

     bumper_height = property(vBumperDatasheet(), "height");
     sonar_mounting_angles = property(vBumperDatasheet(), "sonar_mounting_angles");
     sonar_distance_to_wall = property(vHCS04SonarBracketDatasheet(), "distance_to_wall");
     sonar_mounting_polar_angle = property(vHCS04SonarBracketDatasheet(), "mounting_polar_angle");
     chassis_outer_diameter = property(vChassisBaseDatasheet(), "outer_diameter");
     chassis_fillet_radius = property(vChassisBaseDatasheet(), "fillet_radius");

     for (angle = sonar_mounting_angles) {
          rotate([0, 0, angle]) {
               translate([chassis_outer_diameter/2 - sonar_distance_to_wall, 0,
                          -sonar_distance_to_wall * sin(90 - sonar_mounting_polar_angle) +
                          bumper_height/2])  {
                    rotate([0, sonar_mounting_polar_angle, 0]) {
                         mHCS04SonarBracket();
                    }
               }
          }
     }
}

mBumper();
