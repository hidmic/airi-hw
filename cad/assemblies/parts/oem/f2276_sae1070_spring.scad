include <generic/lib.scad>;

use <generic/third_party/springs.scad>

function vF2276SAE1070SpringDatasheet() =
     let(wire_diameter=1, outer_diameter=18.1, n_windings=8,
         inner_diameter=outer_diameter - 2 * wire_diameter,
         free_length=43)
     [["outer_diameter", outer_diameter],
      ["inner_diameter", inner_diameter],
      ["wire_diameter", wire_diameter],
      ["pitch", free_length/n_windings],
      ["n_windings", n_windings],
      ["free_length", free_length]];

kF2276SAE1070SpringLength = property(vF2276SAE1070SpringDatasheet(), "free_length");

module mF2276SAE1070Spring(length=kF2276SAE1070SpringLength) {
     assert(length > 0);
     assert(length <= kF2276SAE1070SpringLength);

     datasheet = vF2276SAE1070SpringDatasheet();
     n_windings = property(datasheet, "n_windings");
     main_radius = (property(datasheet, "outer_diameter") +
                    property(datasheet, "inner_diameter")) / 4;
     wire_radius = property(datasheet, "wire_diameter") / 2;

     translate([0, 0, wire_radius]) {
          spring(Windings=n_windings, R=main_radius, r=wire_radius, h=length - 2 * wire_radius, slices=50);
     }
}

mF2276SAE1070Spring();
