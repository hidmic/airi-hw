include <generic/lib.scad>;

use <generic/third_party/springs.scad>

function vF174SAE1070SpringDatasheet() =
     [["outer_diameter", 8.8], ["n_windings", 5.5], ["wire_diameter", 2], ["free_length", 15]];

kF174SAE1070SpringLength = property(vF174SAE1070SpringDatasheet(), "free_length");

module mF174SAE1070Spring(length=kF174SAE1070SpringLength) {
     assert(length > 0);
     assert(length <= kF174SAE1070SpringLength);

     datasheet = vF174SAE1070SpringDatasheet();
     n_windings = property(datasheet, "n_windings");
     outer_radius = property(datasheet, "outer_diameter") / 2;
     wire_radius = property(datasheet, "wire_diameter") / 2;

     spring(Windings=n_windings, R=outer_radius, r=wire_radius, h=length, slices=50);
}

mF174SAE1070Spring();
