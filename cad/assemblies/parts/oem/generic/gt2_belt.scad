include <lib.scad>;

use <third_party/timing_belts.scad>;


function pvGT2BeltDatasheet(diameter, width, length) =
     [["diameter", diameter], ["width", width], ["length", length],
      ["side_length", length/2 - diameter * PI / 2]];


module pmGT2Belt(datasheet) {
     width = property(datasheet, "width");
     diameter = property(datasheet, "diameter");
     side_length = property(datasheet, "side_length");

     duplicate([0, 1, 0]) {
          translate([-side_length/2, -diameter/2, 0]) {
               belt_len(vGT2_2Profile(), width, side_length);
          }
     }
     duplicate([1, 0, 0]) {
          translate([side_length/2, -diameter/2, 0]) {
               belt_angle(vGT2_2Profile(), diameter/2, width, 180);
          }
     }
}

pmGT2Belt(pvGT2BeltDatasheet(diameter=12.22, width=6, length=122));
