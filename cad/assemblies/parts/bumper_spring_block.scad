include <generic/lib.scad>;

use <oem/f066_sae1070_spring.scad>;
use <oem/kw10_micro_switch.scad>;
use <oem/m3_phillips_screw.scad>;
use <oem/m3_washer.scad>;

use <chassis_base.scad>;


function vBumperSpringBlockDatasheet() =
     let(washer_datasheet=vM3WasherDatasheet(),
         chassis_datasheet=vChassisBaseDatasheet(),
         spring_datasheet=vF066SAE1070SpringDatasheet(),
         switch_datasheet=vKW10Z1PMicroSwitchDatasheet(),
         chassis_outer_diameter=property(chassis_datasheet, "outer_diameter"),
         chassis_fillet_radius=property(chassis_datasheet, "fillet_radius"),
         thickness=property(chassis_datasheet, "thickness"), angular_offset=70,
         front_block_height=property(spring_datasheet, "outer_diameter") + thickness,
         front_block_width=property(switch_datasheet, "width") + 8,
         front_block_depth=(property(switch_datasheet, "height") + 5 +
                            property(switch_datasheet, "terminal_length")),
         front_spring_protrusion=(property(switch_datasheet, "height") -
                                  property(switch_datasheet, "mounting_hole_offset") -
                                  property(switch_datasheet, "mounting_hole_diameter")/2 -
                                  thickness),
         spring_gap_width=property(switch_datasheet, "lever_height") + 3,
         spring_length=property(spring_datasheet, "free_length") - 5,
         rear_block_height=front_block_height + property(switch_datasheet, "depth") + chassis_fillet_radius,
         rear_block_depth=spring_length - front_spring_protrusion - spring_gap_width + thickness,
         rear_block_width=(front_block_width + chassis_outer_diameter/2 * (sin(
              acos(cos(angular_offset) - (rear_block_depth + spring_gap_width) / (chassis_outer_diameter/2))
         ) - sin(angular_offset))))
     [["front_block_height", front_block_height], ["front_block_depth", front_block_depth],
      ["front_block_width", front_block_width], ["rear_block_depth", rear_block_depth],
      ["rear_block_width", rear_block_width], ["rear_block_height", rear_block_height],
      ["angular_offset", angular_offset], ["thickness", thickness],
      ["front_spring_protrusion", front_spring_protrusion],
      ["spring_gap_width", spring_gap_width], ["spring_length", spring_length],
      ["washer_gap_width", 2 * property(washer_datasheet, "thickness")],
      ["switch_x_offset", property(switch_datasheet, "height")/2 - 2 * kEpsilon],
      ["switch_y_offset", -property(switch_datasheet, "width")/2 + front_block_width],
      ["switch_z_offset", front_block_height + property(switch_datasheet, "depth")/2],
      ["spring_x_offset", front_spring_protrusion],
      ["spring_y_offset", -property(switch_datasheet, "width")/2 + front_block_width],
      ["spring_z_offset", thickness + property(spring_datasheet, "outer_diameter")/2],
      ["fastening_hole_diameter", property(vM3PhillipsScrewDatasheet(), "nominal_diameter")],
      ["x_offset", chassis_outer_diameter/2 * cos(angular_offset)],
      ["y_offset", -chassis_outer_diameter/2 * sin(angular_offset)]];


module mBumperSpringBlock() {
     datasheet = vBumperSpringBlockDatasheet();
     front_block_height = property(datasheet, "front_block_height");
     rear_block_height = property(datasheet, "rear_block_height");
     front_block_depth = property(datasheet, "front_block_depth");
     rear_block_depth = property(datasheet, "rear_block_depth");
     front_block_width = property(datasheet, "front_block_width");
     rear_block_width = property(datasheet, "rear_block_width");
     front_spring_protrusion = property(datasheet, "front_spring_protrusion");
     thickness = property(datasheet, "thickness");
     angular_offset = property(datasheet, "angular_offset");
     spring_length = property(datasheet, "spring_length");
     spring_gap_width = property(datasheet, "spring_gap_width");
     washer_gap_width = property(datasheet, "washer_gap_width");

     x_offset = property(datasheet, "x_offset");
     y_offset = property(datasheet, "y_offset");

     chassis_datasheet = vChassisBaseDatasheet();
     chassis_fillet_radius = property(chassis_datasheet, "fillet_radius");

     translate([-x_offset, -y_offset, -chassis_fillet_radius])
     mChassisVolumeConstrain() {
          translate([x_offset, y_offset, chassis_fillet_radius]) {
               difference() {
                    union() {
                         cube([front_block_depth, front_block_width, front_block_height]);
                         translate([-rear_block_depth-spring_gap_width, front_block_width-rear_block_width, -chassis_fillet_radius]) {
                              cube([rear_block_depth, rear_block_width, rear_block_height]);
                         }
                    }
                    let (switch_datasheet=vKW10Z1PMicroSwitchDatasheet(),
                         switch_width=property(switch_datasheet, "width"),
                         switch_depth=property(switch_datasheet, "depth"),
                         switch_height=property(switch_datasheet, "height"),
                         switch_terminal_length=property(switch_datasheet, "terminal_length"),
                         switch_mounting_hole_offset=property(switch_datasheet, "mounting_hole_offset"),
                         switch_mounting_hole_diameter=property(switch_datasheet, "mounting_hole_diameter"),
                         switch_mounting_hole_distance=property(switch_datasheet, "mounting_hole_distance")) {
                         translate([switch_height - switch_mounting_hole_offset,
                                    -switch_width/2 + front_block_width, -kEpsilon]) {
                              duplicate([0, 1, 0]) {
                                   translate([0, switch_mounting_hole_distance/2, 0]) {
                                        cylinder(d=switch_mounting_hole_diameter, h=rear_block_height + 2 * kEpsilon);
                                   }
                              }
                         }
                         let(spring_datasheet=vF066SAE1070SpringDatasheet(),
                             spring_outer_diameter=property(spring_datasheet, "outer_diameter"),
                             fastening_hole_diameter=property(datasheet, "fastening_hole_diameter")) {
                              translate([0, -switch_width/2 + front_block_width, thickness + spring_outer_diameter/2]) {
                                   translate([front_spring_protrusion, 0, 0]) {
                                        rotate([0, -90, 0]) {
                                             cylinder(d=spring_outer_diameter + kEpsilon, h=spring_length);
                                             translate([0, -spring_outer_diameter/2, 0]) {
                                                  cube([rear_block_height, spring_outer_diameter, spring_length]);
                                             }
                                        }
                                   }
                                   translate([-rear_block_depth-spring_gap_width-kEpsilon, 0, 0]) {
                                        rotate([0, 90, 0]) {
                                             cylinder(d=fastening_hole_diameter, h=thickness + 2 * kEpsilon);
                                             mirror([1, 0, 0]) {
                                                  translate([0, -fastening_hole_diameter/2, 0]) {
                                                       cube([rear_block_height, fastening_hole_diameter, thickness + 2 * kEpsilon]);
                                                  }
                                             }
                                        }
                                   }
                                   let(washer_datasheet=vM3WasherDatasheet(),
                                       washer_outer_diameter=property(washer_datasheet, "outer_diameter")) {
                                        translate([-rear_block_depth-spring_gap_width+thickness, 0, 0]) {
                                             rotate([0, 90, 0]) {
                                                  cylinder(d=washer_outer_diameter, h=washer_gap_width);
                                                  mirror([1, 0, 0]) {
                                                       translate([0, -washer_outer_diameter/2, 0]) {
                                                            cube([rear_block_height, washer_outer_diameter, washer_gap_width]);
                                                       }
                                                  }
                                             }
                                        }
                                   }
                              }
                              translate([-rear_block_depth-spring_gap_width-kEpsilon, front_block_width + kEpsilon, front_block_height]) {
                                   mirror([0, 1, 0]) {
                                        cube([rear_block_depth + 2 * kEpsilon,
                                              switch_width/2 + spring_outer_diameter/2 + kEpsilon,
                                              rear_block_height - front_block_height + kEpsilon]);
                                   }
                              }
                         }
                    }
               }
          }
     }
}


module mBumperSpringFrontBlock() {
     datasheet = vBumperSpringBlockDatasheet();
     difference() {
          mBumperSpringBlock();
          translate([-property(datasheet, "rear_block_depth")/2-
                     property(datasheet, "spring_gap_width"), -kEpsilon, 0]) {
               cube([property(datasheet, "rear_block_depth") + 2 * kEpsilon,
                     (property(datasheet, "rear_block_width") + kEpsilon) * 2,
                     (property(datasheet, "rear_block_height") + kEpsilon) * 2], center=true);
          }
     }
}

module mBumperSpringRearBlock() {
     datasheet = vBumperSpringBlockDatasheet();
     difference() {
          mBumperSpringBlock();
          translate([-kEpsilon, -kEpsilon, -kEpsilon]) {
               cube([property(datasheet, "front_block_depth") + 2 * kEpsilon,
                     property(datasheet, "front_block_width") + 2 * kEpsilon,
                     property(datasheet, "front_block_height") + 2 * kEpsilon]);
          }
     }
}

mBumperSpringFrontBlock();
mBumperSpringRearBlock();

