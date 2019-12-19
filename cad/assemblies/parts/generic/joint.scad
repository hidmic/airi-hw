include <lib.scad>;

function pvJointDatasheet(outer_diameter, inner_diameter, axle_diameter, height,
                          fastening_angles, fastening_diameters, fastening_hole_diameters) =
     assert(height > 0)
     assert(outer_diameter > 0)
     assert(axle_diameter > 0)
     assert(outer_diameter > inner_diameter)
     assert(axle_diameter < inner_diameter)
     assert(len(fastening_angles) == len(fastening_diameters))
     assert(len(fastening_angles) == len(fastening_hole_diameters))
     assert(all([for (d = fastening_diameters) d > inner_diameter]))
     assert(all([for (d = fastening_diameters) d < outer_diameter]))
     let(joint_width=(outer_diameter - inner_diameter) / 2)
     assert(all([for (d = fastening_hole_diameters) d < joint_width]))
     [["outer_diameter", outer_diameter], ["inner_diameter", inner_diameter],
      ["axle_diameter", axle_diameter], ["height", height],
      ["fastening_angles", fastening_angles], ["fastening_diameters", fastening_diameters],
      ["fastening_hole_diameters", fastening_hole_diameters]];

module pmJointXSection(datasheet) {
     difference() {
          circle(d=property(datasheet, "outer_diameter"));
          let (fastening_angles=property(datasheet, "fastening_angles"),
               fastening_diameters=property(datasheet, "fastening_diameters"),
               fastening_hole_diameters=property(datasheet, "fastening_hole_diameters")) {
               for (i=[0:len(fastening_angles)-1]) {
                    for (angle = fastening_angles[i]) {
                         rotate([0, 0, angle]) {
                              translate([fastening_diameters[i]/2, 0]) {
                                   circle(d=fastening_hole_diameters[i]);
                              }
                         }
                    }
               }
          }
          circle(d=property(datasheet, "inner_diameter"));
     }
}

module pmJoint(datasheet) {
     linear_extrude(height=property(datasheet, "height")) {
          difference() {
               pmJointXSection(datasheet);
          }
     }
}
