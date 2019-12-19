include <generic/lib.scad>;


function vM2CountersunkScrew() =
     [["head_diameter", 4], ["nominal_diameter", 2], ["head_height", 1.2]];

module mM2CountersunkScrewBore() {
     datasheet = vM2CountersunkScrew();
     translate([0, 0, -property(datasheet, "head_height")])
          cylinder(d1=property(datasheet, "nominal_diameter"),
                   d2=property(datasheet, "head_diameter"),
                   h=property(datasheet, "head_height") + kEpsilon);
}

module mM2x20mmCountersunkScrew() {
     color("silver") import_mesh("stl/m2x20mm_countersunk_screw.stl");
}

mM2x20mmCountersunkScrew();
