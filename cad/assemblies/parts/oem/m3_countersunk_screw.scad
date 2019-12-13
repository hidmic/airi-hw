include <generic/lib.scad>;

function vM3CountersunkScrew() =
     [["head_diameter", 6], ["nominal_diameter", 3], ["head_height", 1.7]];

module mM3CountersunkScrewBore() {
     datasheet = vM3CountersunkScrew();
     translate([0, 0, -property(datasheet, "head_height")])
     cylinder(d1=property(datasheet, "nominal_diameter"),
              d2=property(datasheet, "head_diameter"),
              h=property(datasheet, "head_height") + kEpsilon);
}

module mM3x8mmCountersunkScrew() {
     import("stl/m3x8mm_countersunk_screw.stl");
}

mM3x8mmCountersunkScrew();

