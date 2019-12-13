include <generic/lib.scad>;

use <generic/motor_cap.scad>;

use <mr08d_motor_base_bracket.scad>;
use <wheel_block_frame.scad>;

function vMR08DMotorBaseSupportDatasheet() =
     let(wheel_block_frame_datasheet=vWheelBlockFrameDatasheet(),
         bracket_datasheet=vMR08DMotorBaseBracketDatasheet(),
         rear_cap_support_datasheet=property(bracket_datasheet, "rear_cap_support_datasheet"),
         bracket_outer_width=property(bracket_datasheet, "outer_width"),
         wedge_width=property(rear_cap_support_datasheet, "wedge_width"),
         wedge_height=property(rear_cap_support_datasheet, "wedge_height"),
         guide_length=bracket_outer_width * 0.8, min_thickness=2, guide_height=wedge_height + 1,
         guide_width=wedge_width + min_thickness, motor_z_offset=bracket_outer_width/2 + 1,
         pillar_to_pillar_distance=property(bracket_datasheet, "hole_to_hole_x_distance"),
         length=guide_length + guide_height)
     [["outer_width", pillar_to_pillar_distance + wedge_width + 2 * min_thickness],
      ["inner_width", pillar_to_pillar_distance - wedge_width], ["link_width", 5],
      ["length", length], ["pillar_to_pillar_distance", pillar_to_pillar_distance],
      ["pillar_height", bracket_outer_width + 2], ["pillar_width", wedge_width + min_thickness],
      ["pillar_depth", guide_height], ["motor_z_offset", motor_z_offset],
      ["guide_length", guide_length], ["guide_width", guide_width],
      ["guide_height", guide_height], ["min_thickness", min_thickness],
      ["pillar_hole_to_hole_distance", property(bracket_datasheet, "hole_to_hole_y_distance")],
      ["fastening_screw_datasheet", property(bracket_datasheet, "fastening_screw_datasheet")],
      ["fastening_screw_x_offset
", [(pillar_to_pillar_distance - wedge_width - guide_width)/2,
                                    -(pillar_to_pillar_distance - wedge_width - guide_width)/2]],
      ["fastening_screw_y_offset", [length/5, length * 4/5]]];


module mMR08DMotorBaseSupport() {
     datasheet = vMR08DMotorBaseSupportDatasheet();
     length = property(datasheet, "length");
     outer_width = property(datasheet, "outer_width");
     inner_width = property(datasheet, "inner_width");

     link_width = property(datasheet, "link_width");

     min_thickness = property(datasheet, "min_thickness");
     motor_z_offset = property(datasheet, "motor_z_offset");

     guide_length = property(datasheet, "guide_length");
     guide_height = property(datasheet, "guide_height");
     guide_width = property(datasheet, "guide_width");

     pillar_width = property(datasheet, "pillar_width");
     pillar_depth = property(datasheet, "pillar_depth");
     pillar_height = property(datasheet, "pillar_height");

     pillar_to_pillar_distance = property(datasheet, "pillar_to_pillar_distance");
     pillar_hole_to_hole_distance = property(datasheet, "pillar_hole_to_hole_distance");

     fastening_screw_datasheet = property(datasheet, "fastening_screw_datasheet");
     fastening_screw_diameter = property(fastening_screw_datasheet, "nominal_diameter");

     rotate([90, 0, 0]) {
          translate([0, 0, pillar_height/2]) {
               rotate([-90, 0, 0]) {
                    linear_extrude(height=min_thickness) {
                         difference() {
                              square_frame(pillar_to_pillar_distance + link_width, pillar_height, link_width);
                              duplicate([1, 0, 0]) {
                                   translate([pillar_to_pillar_distance/2, 0])
                                        square([link_width + kEpsilon, pillar_height + 2 * kEpsilon], center=true);
                              }
                         }
                    }
               }
          }
          duplicate([1, 0, 0]) {
               translate([pillar_to_pillar_distance/2, 0, 0]) {
                    translate([0, 0, pillar_height/2]) {
                         duplicate([0, 0, 1]) {
                              translate([0, 0, -pillar_height/2]) {
                                   translate([min_thickness/2 + guide_width/2, 0, guide_height]) {
                                        rotate([0, -90, 0]) {
                                             linear_extrude(height=min_thickness) {
                                                  polygon([[0, 0], [pillar_height/3, 0], [0, pillar_height/3]]);
                                             }
                                        }
                                   }
                                   let(bracket_datasheet=vMR08DMotorBaseBracketDatasheet()) {
                                        translate([0, pillar_depth, 0]) {
                                             rotate([-90, 0, 0]) {
                                                  linear_extrude(height=guide_length) {
                                                       translate([0, -kEpsilon - guide_height]) {
                                                            difference() {
                                                                 translate([-(guide_width - min_thickness)/2, kEpsilon]) {
                                                                      square([guide_width, guide_height]);
                                                                 }
                                                                 offset(delta=kEpsilon)
                                                                 translate([0, kEpsilon]) {
                                                                      pmMotorCapBaseSupportWedgeXSection(
                                                                           property(bracket_datasheet, "rear_cap_support_datasheet"));
                                                                 }
                                                            }
                                                       }
                                                  }
                                             }
                                        }
                                   }
                                   linear_extrude(height=min_thickness) {
                                        translate([-guide_width + min_thickness/2, length/2]) {
                                             difference() {
                                                  square([guide_width, length], center=true);
                                                  translate([0, length/5]) {
                                                       square([fastening_screw_diameter, length], center=true);
                                                       translate([0, -length/2]) circle(d=fastening_screw_diameter);
                                                  }
                                             }
                                        }
                                   }
                              }
                         }
                    }
                    translate([0, pillar_depth/2, 0]) {
                         difference() {
                              translate([min_thickness/2, 0, pillar_height/2]) {
                                   cube([pillar_width, pillar_depth, pillar_height], center=true);
                              }
                              translate([0, 0, motor_z_offset]) {
                                   duplicate([0, 0, 1]) {
                                        translate([0, 0, pillar_hole_to_hole_distance/2]) {
                                             rotate([90, 0,  0]) {
                                                  cylinder(d=fastening_screw_diameter,
                                                           h=pillar_depth + 2 * kEpsilon,
                                                           center=true);
                                             }
                                        }
                                   }
                              }
                         }
                    }
               }
          }
     }
}

mMR08DMotorBaseSupport();
