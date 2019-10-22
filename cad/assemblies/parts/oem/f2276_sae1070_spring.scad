include <generic/lib.scad>;

use <generic/third_party/springs.scad>

function vF2276SAE1070SpringDatasheet() =
     [["outer_diameter", 18.1], ["n_windings", 8], ["wire_diameter", 1], ["free_length", 43]];

kF2276SAE1070SpringLength = property(vF2276SAE1070SpringDatasheet(), "free_length");

module mF2276SAE1070Spring(length=kF2276SAE1070SpringLength) {
     assert(length > 0);
     assert(length <= kF2276SAE1070SpringLength);

     datasheet = vF2276SAE1070SpringDatasheet();
     n_windings = property(datasheet, "n_windings");
     outer_radius = property(datasheet, "outer_diameter") / 2;
     wire_radius = property(datasheet, "wire_diameter") / 2;

     spring(Windings=n_windings, R=outer_radius, r=wire_radius, h=length, slices=50);
}

mF2276SAE1070Spring();
