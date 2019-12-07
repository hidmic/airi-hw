include <generic/lib.scad>;

use <generic/third_party/springs.scad>

function vF174SAE1070SpringDatasheet() =
     let(outer_diameter=8.8, wire_diameter=2, inner_diameter=outer_diameter - 2 * wire_diameter,
         n_windings=5.5, free_length=15, pitch=free_length/n_windings)
     [["outer_diameter", outer_diameter], ["inner_diameter", inner_diameter],
      ["n_windings", n_windings], ["wire_diameter", wire_diameter],
      ["free_length",free_length], ["pitch", pitch]];

kF174SAE1070SpringLength = property(vF174SAE1070SpringDatasheet(), "free_length");

module mF174SAE1070Spring(length=kF174SAE1070SpringLength) {
     assert(length > 0);
     assert(length <= kF174SAE1070SpringLength);

     datasheet = vF174SAE1070SpringDatasheet();
     n_windings = property(datasheet, "n_windings");
     main_radius = (property(datasheet, "outer_diameter") +
                    property(datasheet, "inner_diameter")) / 4;
     wire_radius = property(datasheet, "wire_diameter") / 2;

     translate([0, 0, wire_radius]) {
          spring(Windings=n_windings, R=main_radius, r=wire_radius, h=length - 2 * wire_radius, slices=50);
     }
}

mF174SAE1070Spring();
