include <generic/lib.scad>;

function vM3x5mmThreadedInsertDatasheet() =
     let(major_diameter=5.31)
     [["major_diameter", major_diameter],
      ["minor_diameter", major_diameter - 0.5],
      ["nominal_diameter", 3], ["length", 5]];

module mM3x5mmThreadedInsertTaperCone() {
     datasheet = vM3x5mmThreadedInsertDatasheet();
     translate([0, 0, -property(datasheet, "length")])
     cylinder(d1=property(datasheet, "minor_diameter"),
              d2=property(datasheet, "major_diameter"),
              h=property(datasheet, "length") + kEpsilon);
}

module mM3x5mmThreadedInsert() {
     color("darkgoldenrod") render() import("stl/m3x5mm_threaded_insert.stl");
}

mM3x5mmThreadedInsert();
