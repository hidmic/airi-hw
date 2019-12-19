include <generic/lib.scad>;

function vJetsonNanoDatasheet() =
     let(length=100, width=81.021973, height=30.506195)
     [["length", length], ["width", width], ["height", height],
      ["support_locations", [[-length/2 + 4, width/2 - 4],
                             [length/2 - 10, width/2 - 4],
                             [-length/2 + 4, width/2 - 62],
                             [length/2 - 10, width/2 - 62]]]];

module mJetsonNano() {
     height = property(vJetsonNanoDatasheet(), "height");

     color("dimgray") {
          rotate([0, 0, -90])
          translate([0, 0, height/2 - 2.2])
          rotate([90, 0, 0])
          translate([-2.51098442, -41.02810287, 13.])
          import_mesh("stl/Jetson-Nano-DK.stl");
     }
}

mJetsonNano();
