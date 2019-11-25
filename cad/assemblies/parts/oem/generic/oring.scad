include <lib.scad>;

function pvORingDatasheet(main_diameter, cross_section_diameter) =
     [["main_diameter", main_diameter], ["cross_section_diameter", cross_section_diameter]];

module pmORing(datasheet) {
     rotate_extrude() {
          translate([property(datasheet, "main_diameter") / 2, 0]) {
               circle(d=property(datasheet, "cross_section_diameter"));
          }
     }
}

pmORing(pvORingDatasheet(main_diameter=20, cross_section_diameter=1));
