
function vRPLidarA1M8R1Datasheet() =
     [["working_width", 6], ["range", 6000]];


module mRPLidarA1M8R1() {
     translate([-35.14, 35, 0]) {
          rotate([90, 0, 0]) import("stl/RPLIDAR-A1M8-R1.stl");
     }
}
