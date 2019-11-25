include <generic/lib.scad>;

function vM3x8mmCountersunkScrew() =
     [["head_diameter", 6], ["nominal_diameter", 3], ["head_height", 1.7], ["length", 8]];

module mM3x8mmCountersunkScrewBore() {
     datasheet = vM3x8mmCountersunkScrew();
     translate([0, 0, -property(datasheet, "head_height")])
     cylinder(d1=property(datasheet, "nominal_diameter"),
              d2=property(datasheet, "head_diameter"),
              h=property(datasheet, "head_height") + kEpsilon);
}
