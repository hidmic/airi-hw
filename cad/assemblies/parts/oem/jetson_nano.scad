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

kControllerWidth = 66;
kControllerLength = 97;
kControllerThickness = 1.6;

module mController() {
     translate([-kControllerWidth/2, -kControllerLength/2])
     difference() {
          linear_extrude(height=kControllerThickness, center=true) {
               square([kControllerWidth, kControllerLength]);
          }
          linear_extrude(height=1.1 * kControllerThickness, center=true) {
               for(x = [6.33, 66 - 6.33]) {
                    for(y = [97 - 3.34 - 2.54, 97 - 3.34]) {
                         translate([x, y]) {
                              circle(d=1.5, $fn = 64);
                         }
                    }
               }
               for(x = [6.33, 6.33 + 2.54, 66 - 6.33 - 2.54, 66 - 6.33]) {
                    for(y = [0:2.54:60.96]) {
                         translate([x, y + 2.22]) {
                              circle(d=1.5, $fn=64);
                         }
                    }
               }
          }
     }
}
