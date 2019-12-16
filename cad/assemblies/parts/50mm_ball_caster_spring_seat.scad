include <generic/lib.scad>;

use <oem/f2276_sae1070_spring.scad>;
use <oem/m3x5mm_threaded_insert.scad>;
use <oem/m3_nut.scad>;


function v50mmBallCasterSpringSeatDatasheet() =
     let(nut_datasheet = vM3NutDatasheet(),
         spring_datasheet=vF2276SAE1070SpringDatasheet(),
         nut_m_max=property(nut_datasheet, "m_max"),
         threaded_insert_datasheet=vM3x5mmThreadedInsertDatasheet(),
         threaded_insert_length=property(threaded_insert_datasheet, "length"),
         spring_outer_diameter=property(spring_datasheet, "outer_diameter"),
         spring_inner_diameter=property(spring_datasheet, "inner_diameter"),
         spring_wire_diameter=property(spring_datasheet, "wire_diameter"),
         spring_pitch=property(spring_datasheet, "pitch"), base_thickness=2)
     [["base_thickness", base_thickness],
      ["inner_diameter", spring_inner_diameter],
      ["outer_diameter", spring_outer_diameter + 2 * spring_wire_diameter],
      ["height", base_thickness + max(threaded_insert_length + nut_m_max, spring_pitch)]];


module m50mmBallCasterSpringSeat() {
     datasheet = v50mmBallCasterSpringSeatDatasheet();
     base_thickness = property(datasheet, "base_thickness");
     outer_diameter = property(datasheet, "outer_diameter");
     inner_diameter = property(datasheet, "inner_diameter");
     height = property(datasheet, "height");

     color($default_color) {
          render() {
               difference() {
                    union() {
                         cylinder(d=outer_diameter, h=base_thickness);
                         cylinder(d=inner_diameter, h=height);
                    }
                    let(hole_diameter=property(vM3x5mmThreadedInsertDatasheet(), "nominal_diameter")) {
                         translate([0, 0, -kEpsilon]) {
                              cylinder(d=hole_diameter, h=height + 2 * kEpsilon);
                         }
                    }
               }
          }
     }
}


m50mmBallCasterSpringSeat();
