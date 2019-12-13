include <generic/lib.scad>;

use <generic/ball_caster_yoke.scad>;

use <oem/m3_hex_standoff.scad>;

use <50mm_ball_caster_support.scad>;
use <50mm_ball_caster_yoke.scad>;
use <chassis_base.scad>;


function v50mmBallCasterBaseDatasheet() =
     let(chassis_datasheet = vChassisBaseDatasheet(),
         caster_support_datasheet = v50mmBallCasterSupportDatasheet(),
         chassis_thickness = property(chassis_datasheet, "thickness"),
         chassis_z_offset = property(chassis_datasheet, "z_offset"),
         main_diameter = property(caster_support_datasheet, "main_diameter"),
         ball_z_offset = property(caster_support_datasheet, "ball_z_offset"),
         ball_diameter = property(caster_support_datasheet, "ball_diameter"),
         base_thickness = property(caster_support_datasheet, "base_thickness"),
         standoff_length = property(vM3x30mmHexThreadedStandoffDatasheet(), "length"),
         hole_diameter = property(vM3x30mmHexThreadedStandoffDatasheet(), "hole_diameter"),
         support_z_offset = ball_z_offset + ball_diameter/2 - chassis_z_offset - chassis_thickness,
         standoff_z_offset = support_z_offset - base_thickness/2 - standoff_length/2)
     concat(
          pvBallCasterYokeDatasheet(main_diameter=property(caster_support_datasheet, "main_diameter"),
                                    base_thickness=property(caster_support_datasheet, "base_thickness"),
                                    mount_offset=property(caster_support_datasheet, "mount_offset"),
                                    mount_diameter=property(caster_support_datasheet, "mount_diameter"),
                                    mount_height=standoff_z_offset -  base_thickness),
          [["support_z_offset", support_z_offset], ["support_opening_diameter", main_diameter + 1],
           ["standoff_z_offset", standoff_z_offset], ["standoff_length", standoff_length],
           ["mount_hole_diameter", hole_diameter]]
     );


module m50mmBallCasterBase() {
     datasheet = v50mmBallCasterBaseDatasheet();
     main_diameter = property(datasheet, "main_diameter");
     base_thickness = property(datasheet, "base_thickness");
     mount_offset = property(datasheet, "mount_offset");
     mount_height = property(datasheet, "mount_height");
     mount_hole_diameter = property(datasheet, "mount_hole_diameter");

     support_opening_diameter = property(datasheet, "support_opening_diameter");

     difference() {
          pmBallCasterYoke(datasheet);
          translate([0, 0, -kEpsilon]) {
               duplicate([0, 1, 0]) {
                    translate([0, mount_offset, 0]) {
                         translate([0, 0, mount_height]) {
                              linear_extrude(height=base_thickness + 2 * kEpsilon) {
                                   offset(delta=kEpsilon) {
                                        hull() projection() mM3x30mmHexStandoff();
                                   }
                              }
                         }
                         let(hole_diameter=mount_hole_diameter) {
                              cylinder(h=mount_height + base_thickness + 2 * kEpsilon, d=hole_diameter);
                         }
                    }
               }
               cylinder(d=support_opening_diameter, h=base_thickness + 2 * kEpsilon);
          }
     }
     difference() {
          cylinder(d=support_opening_diameter + 2 * base_thickness, h=base_thickness);
          translate([0, 0, -kEpsilon]) {
               cylinder(d=support_opening_diameter, h=base_thickness + 2 * kEpsilon);
          }
     }
}

m50mmBallCasterBase();
