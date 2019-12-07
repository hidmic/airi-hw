include <generic/lib.scad>;

use <chassis_base.scad>;
use <bumper_base.scad>;

use <chassis_base_cover.scad>;

use <bumper_spring_block.partB.scad>;
use <wheel_block_frame.scad>;

kChassisBaseDatasheet = vChassisBaseDatasheet();
kBumperBaseDatasheet = vBumperBaseDatasheet();
kWheelBlockFrameDatasheet = vWheelBlockFrameDatasheet();

function vBaseChassisDatasheet() =
     let(inner_diameter=property(kChassisBaseDatasheet, "inner_diameter"),
         wheel_diameter=property(kWheelBlockFrameDatasheet, "wheel_diameter"),
         wheel_axle_z_offset=property(kWheelBlockFrameDatasheet, "wheel_axle_z_offset"))
     [["height", property(kChassisBaseDatasheet, "base_height")],
      ["outer_diameter", property(kChassisBaseDatasheet, "outer_diameter")],
      ["inner_diameter", inner_diameter],
      ["thickness", property(kChassisBaseDatasheet, "thickness")],
      ["fillet_radius", property(kChassisBaseDatasheet, "fillet_radius")],
      ["wheel_slot_length", 2 * sqrt(pow(wheel_diameter/2 + 8, 2) - pow(wheel_axle_z_offset, 2))],
      ["wheel_slot_width", property(kWheelBlockFrameDatasheet, "wheel_width") + 8],
      ["wheel_base", 265], ["nerve_angles", [80:20:280]], ["nerve_height", 50], ["nerve_length", 20]];

module mBaseChassis() {
     datasheet = vBaseChassisDatasheet();
     height = property(datasheet, "height");
     thickness = property(datasheet, "thickness");
     inner_diameter = property(datasheet, "inner_diameter");
     outer_diameter = property(datasheet, "outer_diameter");
     fillet_radius = property(datasheet, "fillet_radius");

     nerve_angles = property(datasheet, "nerve_angles");
     nerve_height = property(datasheet, "nerve_height");
     nerve_length = property(datasheet, "nerve_length");

     chassis_cover_datasheet = vChassisBaseCoverDatasheet();
     cover_support_diameter = property(chassis_cover_datasheet, "support_diameter");
     cover_support_angles = concat(property(chassis_cover_datasheet, "support_angles"),
                                   property(chassis_cover_datasheet, "bay_support_angles"));

     cover_support_screw_datasheet = vChassisCoverSupportScrewDatasheet();
     cover_support_screw_diameter = property(cover_support_screw_datasheet, "nominal_diameter");

     render() {
          difference() {
               mChassisShell();
               translate([0, 0, height]) {
                    mChassisBBox();
               }
               mBumperBaseComplement();
               duplicate([0, 1, 0]) {
                    translate([0, property(datasheet, "wheel_base")/2, 0]) {
                         cube([property(datasheet, "wheel_slot_length"),
                               property(datasheet, "wheel_slot_width"),
                               2 * thickness + 2 * kEpsilon], center=true);
                    }
               }
          }
          mChassisVolumeConstrain() {
               linear_extrude(height=height) {
                    duplicate([0, 1, 0]) {
                         mBumperLockXSection();
                    }
                    /* for(angle = cover_support_angles) { */
                    /*      rotate(angle) { */
                    /*           translate([inner_diameter/2, 0]) { */
                    /*                curved_support_xsection( */
                    /*                     support_radius=cover_support_diameter/2, */
                    /*                     fillet_radius=fillet_radius, */
                    /*                     hole_radius=cover_support_screw_diameter/2, */
                    /*                     wall_outer_radius=outer_diameter/2, */
                    /*                     wall_inner_radius=inner_diameter/2); */
                    /*           } */
                    /*      } */
                    /* } */
               }
               duplicate([0, 1, 0]) {
                    let(angular_width=property(kBumperBaseDatasheet, "angular_width")) {
                         translate([outer_diameter/2 * cos(angular_width/2),
                                    -outer_diameter/2 * sin(angular_width/2),
                                    thickness]) {
                              mBumperSpringBlock_PartB();
                         }
                    }
               }
          }
          /* translate([0, 0, thickness]) { */
          /*      for(angle = nerve_angles) { */
          /*           rotate([0, 0, angle]) { */
          /*                exp_corner_nerve(height=nerve_height, radius=nerve_length, */
          /*                                 angles=[-180 * thickness/(PI * outer_diameter/2), */
          /*                                          180 * thickness/(PI * outer_diameter/2)], */
          /*                                 corner_radius=-inner_diameter/2); */
          /*           } */
          /*      } */
          /* } */
     }
}

mBaseChassis();
