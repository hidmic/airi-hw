include <generic/lib.scad>;

function vJetsonNanoDatasheet() =
     [["length", 100], ["width", 81.021973], ["height", 30.506195]];

module mJetsonNano() {
     height = property(vJetsonNanoDatasheet(), "height");
     translate([0, 0, height/2 - 2.2])
     rotate([90, 0, 0])
     translate([-2.51098442, -41.02810287, 13.])
     import("stl/Jetson-Nano-DK.stl");
}

mJetsonNano();
