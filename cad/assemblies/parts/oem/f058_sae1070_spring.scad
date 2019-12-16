include <generic/lib.scad>;

use <generic/third_party/springs.scad>

function vF058SAE1070SpringDatasheet() =
     let(outer_diameter=4.5, wire_diameter=0.5, n_windings=35.5,
         inner_diameter=outer_diameter - 2 * wire_diameter,
         free_length=65)
     [["outer_diameter", outer_diameter], ["inner_diameter", inner_diameter],
      ["n_windings", n_windings], ["wire_diameter", wire_diameter],
      ["free_length", free_length], ["pitch", free_length/n_windings]];

kF058SAE1070SpringLength = property(vF058SAE1070SpringDatasheet(), "free_length");

module mF058SAE1070Spring(length=kF058SAE1070SpringLength) {
     assert(length > 0);
     assert(length <= kF058SAE1070SpringLength);

     datasheet = vF058SAE1070SpringDatasheet();
     // 'generic/third_party/springs.scad' no maneja vueltas fraccionarias
     n_windings = round(property(datasheet, "n_windings"));
     main_radius = (property(datasheet, "outer_diameter") +
                    property(datasheet, "inner_diameter")) / 4;
     wire_radius = property(datasheet, "wire_diameter") / 2;

     color("silver") {
          render() {
               translate([0, 0, wire_radius]) {
                    spring(Windings=n_windings, R=main_radius, r=wire_radius,
                           h=length - 2 * wire_radius, slices=30);
               }
          }
     }
}

mF058SAE1070Spring();
