include <generic/lib.scad>;

use <oem/70mm_shock_absorber.scad>;

use <wheel_suspension_axle_joint.scad>;
use <wheel_suspension_pivot_joint.scad>;

kWheelSuspensionAxleJointDatasheet = vWheelSuspensionAxleJointDatasheet();
kWheelSuspensionPivotJointDatasheet = vWheelSuspensionPivotJointDatasheet();

function vWheelSuspensionLinkDatasheet() =
     [["thickness", 3], ["width", 12], ["length", 60], ["fillet_radius", 5]];


module mWheelSuspensionLink() {
     datasheet = vWheelSuspensionLinkDatasheet();
     link_length = property(datasheet, "length");
     link_width = property(datasheet, "width");

     color($default_color) {
          linear_extrude(height=property(datasheet, "thickness")) {
               difference() {
                    fillet(r=property(datasheet, "fillet_radius")) {
                         translate([link_length/2, 0]) {
                              square([link_length, link_width], center=true);
                         }
                         circle(d=property(kWheelSuspensionAxleJointDatasheet, "outer_diameter"));
                         translate([link_length, 0]) {
                              circle(d=property(kWheelSuspensionPivotJointDatasheet, "outer_diameter"));
                         }
                    }
                    circle(d=(property(kWheelSuspensionAxleJointDatasheet, "inner_diameter") +
                              property(kWheelSuspensionAxleJointDatasheet, "axle_diameter")) / 2);
                    difference() {
                         hull_complement() mWheelSuspensionAxleJointXSection();
                         circle(d=property(kWheelSuspensionAxleJointDatasheet, "inner_diameter"));
                    }
                    translate([link_length, 0]) {
                         circle(d=(property(kWheelSuspensionPivotJointDatasheet, "inner_diameter") +
                                   property(kWheelSuspensionPivotJointDatasheet, "axle_diameter")) / 2);
                         difference() {
                              hull_complement() mWheelSuspensionPivotJointXSection();
                              circle(d=property(kWheelSuspensionPivotJointDatasheet, "inner_diameter"));
                         }
                    }
                    let (hole_diameter=property(v70mmShockAbsorberDatasheet(), "hole_diameter"),
                         axle_joint_diameter=property(kWheelSuspensionAxleJointDatasheet, "outer_diameter"),
                         pivot_joint_diameter=property(kWheelSuspensionPivotJointDatasheet, "outer_diameter"),
                         start_x = axle_joint_diameter / 2 + 2 * hole_diameter,
                         end_x = link_length - pivot_joint_diameter / 2 - 2 * hole_diameter) {
                         for (x = steps(start_x, end_x, 5)) {
                              translate([x, 0, 0]) circle(d=hole_diameter);
                         }
                    }
               }
          }
     }
}

mWheelSuspensionLink();
