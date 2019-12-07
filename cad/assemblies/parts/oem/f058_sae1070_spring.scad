include <generic/lib.scad>;

use <generic/third_party/springs.scad>

function vF058SAE1070SpringDatasheet() =
     [["outer_diameter", 4.5], ["n_windings", 35.5], ["wire_diameter", 0.5], ["free_length", 65]];

kF058SAE1070SpringLength = property(vF058SAE1070SpringDatasheet(), "free_length");

module mF058SAE1070Spring(length=kF058SAE1070SpringLength) {
     assert(length > 0);
     assert(length <= kF058SAE1070SpringLength);

     datasheet = vF058SAE1070SpringDatasheet();
     n_windings = property(datasheet, "n_windings");
     outer_radius = property(datasheet, "outer_diameter") / 2;
     wire_radius = property(datasheet, "wire_diameter") / 2;

     spring(Windings=n_windings, R=outer_radius, r=wire_radius, h=length, slices=30);
}

mF058SAE1070Spring();
