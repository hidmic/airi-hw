include <generic/lib.scad>;

function vGY521IMUDatasheet() =
     [["width", 15.24], ["length", 25.4], ["thickness", 1.6]];


module mGY521IMU() {
     let(length=property(vGY521IMUDatasheet(), "length"),
         width=property(vGY521IMUDatasheet(), "width")) {
          translate([-length/2, -width/2, 0]) import("stl/GY521.stl");
     }
}

mGY521IMU();
