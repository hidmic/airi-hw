include <generic/lib.scad>;

use <generic/third_party/springs.scad>

function vF066SAE1070SpringDatasheet() =
     let(outer_diameter=6.5, wire_diameter=1, n_windings=10,
         inner_diameter=outer_diameter - 2 * wire_diameter,
         free_length=16)
     [["outer_diameter", outer_diameter], ["inner_diameter", inner_diameter],
      ["n_windings", n_windings], ["wire_diameter", wire_diameter],
      ["free_length", free_length], ["pitch", free_length/n_windings]];

kF066SAE1070SpringLength = property(vF066SAE1070SpringDatasheet(), "free_length");

module mF066SAE1070Spring(length=kF066SAE1070SpringLength) {
     assert(length > 0);
     assert(length <= kF066SAE1070SpringLength);

     datasheet = vF066SAE1070SpringDatasheet();
     n_windings = property(datasheet, "n_windings");
     main_radius = (property(datasheet, "outer_diameter") +
                    property(datasheet, "inner_diameter")) / 4;
     wire_radius = property(datasheet, "wire_diameter") / 2;

     if (!$simple) {
          color("silver") {
               translate([0, 0, wire_radius]) {
                    spring(Windings=n_windings, R=main_radius, r=wire_radius,
                           h=length - 2 * wire_radius, slices=30);
               }
          }
     }
}

mF066SAE1070Spring();
