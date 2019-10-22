include <lib.scad>;

use <ball_caster_yoke.scad>;

function pvBallCasterSupportDatasheet(ball_diameter, ball_protrusion, ball_gap,
                                      wall_gap, wall_thickness, base_thickness,
                                      mount_offset, mount_diameter) =
     assert(ball_diameter > 0)
     assert(ball_protrusion > 0)
     assert(ball_diameter > ball_protrusion)
     assert(ball_gap > 0)
     assert(wall_gap > 0)
     assert(ball_diameter > 2 * wall_gap)
     assert(wall_thickness > 0)
     assert(base_thickness > 0)
     assert(mount_offset > ball_diameter/2)
     assert(mount_diameter > 0)
     [["ball_diameter", ball_diameter], ["ball_protrusion", ball_protrusion], ["ball_gap", ball_gap],
      ["wall_gap", wall_gap], ["wall_thickness", wall_thickness], ["base_thickness", base_thickness],
      ["mount_offset", mount_offset], ["mount_diameter", mount_diameter],
      ["ball_z_offset", base_thickness + ball_gap + ball_diameter / 2],
      ["main_height", base_thickness + ball_gap + ball_diameter - ball_protrusion],
      ["main_diameter", ball_diameter + 2 * wall_thickness]];

module pmBallCasterSupport(datasheet) {
     base_thickness = property(datasheet, "base_thickness");
     main_height = property(datasheet, "main_height");
     main_diameter = property(datasheet, "main_diameter");
     mount_offset = property(datasheet, "mount_offset");
     mount_diameter = property(datasheet, "mount_diameter");
     ball_diameter = property(datasheet, "ball_diameter");
     ball_protrusion = property(datasheet, "ball_protrusion");
     ball_gap = property(datasheet, "ball_gap");
     ball_z_offset = property(datasheet, "ball_z_offset");
     wall_gap = property(datasheet, "wall_gap");
     wall_thickness = property(datasheet, "wall_thickness");

     pmBallCasterYoke(datasheet);
     rotate([0, 0, 90]) {
          translate([0, 0, base_thickness]) {
               difference() {
                    cylinder(h=main_height - base_thickness, d=main_diameter);
                    translate([0, 0, ball_z_offset - base_thickness]) sphere(d=ball_diameter);
                    translate([-main_diameter / 2 - kEpsilon, -wall_gap / 2, 0]) {
                         cube([main_diameter + 2 * kEpsilon, wall_gap, main_height - base_thickness + kEpsilon]);
                    }
                    translate([-main_diameter/2 - kEpsilon, 0, main_height - base_thickness - wall_gap/2]) {
                         rotate([0, 90, 0]) cylinder(h=main_diameter + 2 * kEpsilon, d=2 * wall_gap, $fn=6);
                    }
                    cylinder(h=ball_diameter/4 + ball_gap, d=ball_diameter * sqrt(3)/2);
               }
          }
     }
}

pmBallCasterSupport(
     datasheet=pvBallCasterSupportDatasheet(
          ball_diameter=10, ball_protrusion=3, ball_gap=2,
          wall_gap=3, wall_thickness=2, base_thickness=2,
          mount_offset=10, mount_diameter=4
     )
);
