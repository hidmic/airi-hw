include <generic/lib.scad>;

use <10mm_ball_caster_base.scad>;
use <50mm_ball_caster_base.scad>;

use <chassis_base.scad>;
use <chassis_base_cover.scad>;
use <bumper_base.scad>;
use <bumper_spring_block.scad>;
use <wheel_block_frame.scad>;

kChassisBaseDatasheet = vChassisBaseDatasheet();
kBumperBaseDatasheet = vBumperBaseDatasheet();
kWheelBlockFrameDatasheet = vWheelBlockFrameDatasheet();

function vBaseChassisDatasheet() =
     let(outer_diameter=property(kChassisBaseDatasheet, "outer_diameter"),
         inner_diameter=property(kChassisBaseDatasheet, "inner_diameter"),
         wheel_diameter=property(kWheelBlockFrameDatasheet, "wheel_diameter"),
         wheel_axle_z_offset=property(kWheelBlockFrameDatasheet, "wheel_axle_z_offset"),
         front_caster_opening_diameter=property(v10mmBallCasterBaseDatasheet(), "support_opening_diameter"),
         rear_caster_opening_diameter=property(v50mmBallCasterBaseDatasheet(), "support_opening_diameter"))
     [["height", property(kChassisBaseDatasheet, "base_height")],
      ["outer_diameter", outer_diameter], ["inner_diameter", inner_diameter],
      ["thickness", property(kChassisBaseDatasheet, "thickness")],
      ["fillet_radius", property(kChassisBaseDatasheet, "fillet_radius")],
      ["wheel_slot_length", 2 * sqrt(pow(wheel_diameter/2 + 8, 2) - pow(wheel_axle_z_offset, 2))],
      ["wheel_slot_width", property(kWheelBlockFrameDatasheet, "wheel_width") + 8], ["wheel_base", 242],
      ["front_caster_x_offset", outer_diameter/2 - 2 * front_caster_opening_diameter],
      ["rear_caster_x_offset", -outer_diameter/2 + 1.2 * rear_caster_opening_diameter],
      ["support_pin_diameter", 4], ["support_pin_height", 4]];


module mBaseChassis() {
     datasheet = vBaseChassisDatasheet();
     height = property(datasheet, "height");
     thickness = property(datasheet, "thickness");
     inner_diameter = property(datasheet, "inner_diameter");
     outer_diameter = property(datasheet, "outer_diameter");
     fillet_radius = property(datasheet, "fillet_radius");

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
               translate([0, 0, -kEpsilon]) {
                    let(x_offset=property(datasheet, "front_caster_x_offset"),
                        opening_diameter=property(v10mmBallCasterBaseDatasheet(),
                                                  "support_opening_diameter")) {
                         translate([x_offset, 0, 0]) {
                              cylinder(d=opening_diameter, h=thickness + 2 * kEpsilon);
                         }
                    }
                    let(x_offset=property(datasheet, "rear_caster_x_offset"),
                        opening_diameter=property(v50mmBallCasterBaseDatasheet(),
                                                  "support_opening_diameter")) {
                         translate([x_offset, 0, 0]) {
                              cylinder(d=opening_diameter, h=thickness + 2 * kEpsilon);
                         }
                    }
               }
          }
          mChassisVolumeConstrain() {
               linear_extrude(height=height) {
                    duplicate([0, 1, 0]) {
                         mBumperLockXSection();
                    }
               }
          }
          /* mChassisVolumeConstrain() { */
          /*      for(angle = cover_support_angles) { */
          /*           linear_extrude(height=height) { */
          /*                rotate(angle) { */
          /*                     translate([(outer_diameter + inner_diameter)/4, 0]) { */
          /*                          curved_support_xsection( */
          /*                               support_radius=cover_support_diameter/2, */
          /*                               fillet_radius=fillet_radius, */
          /*                               hole_radius=cover_support_screw_diameter/2, */
          /*                               wall_outer_radius=outer_diameter/2, */
          /*                               wall_inner_radius=inner_diameter/2); */
          /*                     } */
          /*                } */
          /*           } */
          /*      } */
          /* } */
          difference() {
               let(block_x_offset=property(vBumperSpringBlockDatasheet(), "x_offset"),
                   block_y_offset=property(vBumperSpringBlockDatasheet(), "y_offset"),
                   bumper_height=property(vBumperBaseDatasheet(), "height")) {
                    duplicate([0, 1, 0]) {
                         translate([block_x_offset, block_y_offset, bumper_height/2 + fillet_radius]) {
                              duplicate([0, 0, 1]) {
                                   translate([0, 0, -bumper_height/2]) mBumperSpringRearBlock();
                              }
                         }
                    }
               }
               translate([0, 0, height]) {
                    mChassisBBox();
               }
          }
     }
}

mBaseChassis();
