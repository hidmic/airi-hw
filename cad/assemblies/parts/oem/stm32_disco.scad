include <generic/lib.scad>;

function vSTM32DiscoDatasheet() =
     [["length", 97], ["width", 66], ["thickness", 1.6], ["height", 5]];

module mSTM32Disco() {
     datasheet = vSTM32DiscoDatasheet();

     length = property(datasheet, "length");
     width = property(datasheet, "width");
     thickness = property(datasheet, "thickness");

     linear_extrude(height=thickness) {
          difference() {
               square([width, length], center=true);
               for(x = [-width/2 + 6.33, width/2 - 6.33]) {
                    for(y = [length/2 - 3.34 - 2.54, length/2 - 3.34]) {
                         translate([x, y]) {
                              circle(d=1.5, $fn=64);
                         }
                    }
               }
               for(x = [-width/2 + 6.33, -width/2 + 6.33 + 2.54, width/2 - 6.33 - 2.54, width/2 - 6.33]) {
                    for(y = [0:2.54:60.96]) {
                         translate([x, y + 2.22 - length/2]) {
                              circle(d=1.5, $fn=64);
                         }
                    }
               }

          }
     }
}

mSTM32Disco();
