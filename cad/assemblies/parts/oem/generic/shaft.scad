include <lib.scad>;

function pvShaftDatasheet(length, diameter) =
     [["length", length], ["diameter", diameter]];


module pmShaft(datasheet) {
     linear_extrude(height=property(datasheet, "length")) {
          scale(property(datasheet, "diameter")) {
               if ($children > 0) {
                    children();
               } else {
                    circle(d=1);
               }
          }
     }
}


datasheet = pvShaftDatasheet(length=10, diameter=10);
rotate([180, 0 ,0]) {
     pmShaft(datasheet);
}
pmShaft(datasheet) {
     circle(d=1, $fn=5);
}
