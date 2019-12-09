include <lib.scad>;

function pvBallCasterYokeDatasheet(main_diameter, base_thickness, mount_offset, mount_diameter, mount_height=0) =
     assert(main_diameter > 0)
     assert(base_thickness > 0)
     assert(mount_offset > 0)
     assert(mount_diameter > 0)
     [["main_diameter", main_diameter], ["base_thickness", base_thickness],
      ["mount_offset", mount_offset], ["mount_diameter", mount_diameter],
      ["mount_height", mount_height], ["main_height", mount_height + base_thickness]];

module pmBallCasterYoke(datasheet) {
     main_diameter = property(datasheet, "main_diameter");
     base_thickness = property(datasheet, "base_thickness");
     mount_offset = property(datasheet, "mount_offset");
     mount_diameter = property(datasheet, "mount_diameter");
     mount_height = property(datasheet, "mount_height");

     linear_extrude(height=base_thickness) {
          hull() {
               circle(d=main_diameter);
               duplicate([0, 1, 0]) {
                    translate([0, mount_offset, 0]) {
                         circle(d=mount_diameter);
                    }
               }
          }
     }
     if (mount_height > 0) {
          translate([0, 0, base_thickness]) {
               duplicate([0, 1, 0]) {
                    translate([0, mount_offset, 0]) {
                         cylinder(h=mount_height, d=mount_diameter);
                    }
               }
          }
     }
}

pmBallCasterYoke(
     datasheet=pvBallCasterYokeDatasheet(
          main_diameter=12, base_thickness=2, mount_offset=10, mount_diameter=4, mount_height=5
     )
);
