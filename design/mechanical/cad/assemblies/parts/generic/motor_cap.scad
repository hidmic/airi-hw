include <lib.scad>;

use <../oem/generic/nuts.scad>;

function pvMotorCapDatasheet(inner_diameter, seat_diameter, height, wall_thickness,
                             motor_datasheet, fastening_screw_datasheet, fastening_nut_datasheet) =
     let (outer_diameter=inner_diameter + 2 * wall_thickness,
          fastening_block_diameter=property(fastening_nut_datasheet, "e_min") + 2 * wall_thickness,
          fastening_xy_offset=(outer_diameter - fastening_block_diameter - wall_thickness)/2)
     [["outer_diameter", outer_diameter], ["inner_diameter", inner_diameter], ["height", height],
      ["seat_diameter", seat_diameter], ["wall_thickness", wall_thickness], ["motor_datasheet", motor_datasheet],
      ["fastening_block_diameter", fastening_block_diameter],
      ["fastening_screw_datasheet", fastening_screw_datasheet],
      ["fastening_nut_datasheet", fastening_nut_datasheet],
      ["fastening_locations", [[fastening_xy_offset, fastening_xy_offset],
                               [fastening_xy_offset, -fastening_xy_offset]]]];


function pvMotorCapBaseSupportDatasheet(cap_datasheet, height=0, hole_to_hole_distance=0) =
     let(outer_diameter=property(cap_datasheet, "outer_diameter"),
         wall_thickness=property(cap_datasheet, "wall_thickness"),
         height=height == 0 ? outer_diameter/4 + wall_thickness : height,
         hole_to_hole_distance=hole_to_hole_distance == 0 ? (width + depth) : hole_to_hole_distance,
         depth=property(cap_datasheet, "height") + 2 * wall_thickness)
     [["width", outer_diameter + 2 * wall_thickness], ["depth", depth], ["height", height],
      ["outer_width", hole_to_hole_distance + depth * 3/2], ["wedge_height", depth/4],
      ["wedge_width", depth], ["wall_thickness", wall_thickness], ["cap_datasheet", cap_datasheet],
      ["hole_to_hole_distance", hole_to_hole_distance]];


module pmMotorCapBaseSupportWedgeXSection(datasheet) {
     height = property(datasheet, "wedge_height");
     width = property(datasheet, "wedge_width");
     polygon([[-width/2, 0], [0, height], [width/2, 0]]);
}


module pmMotorCapBaseSupport(datasheet) {
     height = property(datasheet, "height");
     width = property(datasheet, "width");
     depth = property(datasheet, "depth");
     wall_thickness = property(datasheet, "wall_thickness");
     hole_to_hole_distance = property(datasheet, "hole_to_hole_distance");

     cap_datasheet = property(datasheet, "cap_datasheet");
     cap_height = property(cap_datasheet, "height");
     cap_outer_diameter = property(cap_datasheet, "outer_diameter");
     cap_fastening_locations = property(cap_datasheet, "fastening_locations");
     cap_fastening_screw_datasheet = property(cap_datasheet, "fastening_screw_datasheet");
     cap_fastening_screw_diameter = property(cap_fastening_screw_datasheet, "nominal_diameter");

     linear_extrude(height=height) {
          duplicate([0, 1, 0]) {
               translate([-depth/2, cap_outer_diameter/2]) {
                    square([depth, wall_thickness]);
               }
          }
     }
     linear_extrude(height=wall_thickness) {
          square([depth, width], center=true);
     }
     translate([0, 0, wall_thickness]) {
          duplicate([1, 0, 0]) {
               translate([cap_height/2, 0, 0]) {
                    rotate([0, 90, 0]) {
                         linear_extrude(height=wall_thickness) {
                              translate([-cap_outer_diameter/2, 0, 0]) {
                                   difference() {
                                        projection() pmMotorCap(cap_datasheet);
                                        circle(d=cap_outer_diameter + kEpsilon);
                                        square([cap_outer_diameter - 2 * (height - wall_thickness),
                                                cap_outer_diameter + 2 * kEpsilon], center=true);
                                        square([cap_outer_diameter + 2 * kEpsilon,
                                                cap_outer_diameter/2], center=true);
                                        for (loc = cap_fastening_locations) {
                                             translate(loc) {
                                                  translate([-cap_outer_diameter/4, 0]) {
                                                       square([cap_outer_diameter/2, cap_fastening_screw_diameter], center=true);
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
     duplicate([0, 1, 0]) {
          translate([0, hole_to_hole_distance/2, 0]) {
               difference() {
                    translate([0, 0, height/2]) {
                         cube([depth, depth, height], center=true);
                    }
                    translate([0, 0, -kEpsilon]) {
                         cylinder(d=cap_fastening_screw_diameter, h=height + 2 * kEpsilon);
                    }
               }
               translate([-depth/2, -depth/2, 0]) {
                    mirror([0, 1, 0]) cube([depth, (hole_to_hole_distance - width - depth)/2, height]);
               }
               linear_extrude(height=height) {
                    translate([0, depth/2, 0]) {
                         pmMotorCapBaseSupportWedgeXSection(datasheet);
                    }
               }
          }
     }
}


module pmMotorCap(datasheet) {
     height = property(datasheet, "height");
     outer_diameter = property(datasheet, "outer_diameter");
     seat_diameter = property(datasheet, "seat_diameter");
     wall_thickness = property(datasheet, "wall_thickness");

     fastening_locations = property(datasheet, "fastening_locations");
     fastening_block_diameter = property(datasheet, "fastening_block_diameter");
     fastening_screw_datasheet = property(datasheet, "fastening_screw_datasheet");
     fastening_screw_diameter = property(fastening_screw_datasheet, "nominal_diameter");
     fastening_nut_datasheet = property(datasheet, "fastening_nut_datasheet");

     linear_extrude(height=height) {
          outline(delta=-wall_thickness) {
               translate([outer_diameter / 4, 0]) {
                    square([outer_diameter / 2, outer_diameter], center=true);
               }
               circle(d=outer_diameter);
          }
          outline(delta=-wall_thickness) {
               circle(d=outer_diameter);
          }
     }
     linear_extrude(height=wall_thickness) {
          difference() {
               union() {
                    translate([outer_diameter / 4, 0]) {
                         square([outer_diameter / 2, outer_diameter], center=true);
                    }
                    circle(d=outer_diameter);
               }
               circle(d=seat_diameter);

               for (loc = fastening_locations) {
                    translate(loc) {
                         circle(d=fastening_screw_diameter);
                    }
               }

               children();
          }
     }
     for (loc = fastening_locations) {
          translate(loc) {
               difference() {
                    cylinder(d=fastening_block_diameter, h=height);
                    translate([0, 0, -kEpsilon]) {
                         cylinder(h=fastening_block_diameter + 2 * kEpsilon,
                                  d=fastening_screw_diameter);
                    }
                    translate([0, 0, height + kEpsilon]) {
                         pmNutBore(fastening_nut_datasheet);
                    }
               }
          }
     }
}

