
function vRPLidarA1M8R1Datasheet() =
     [["working_width", 6], ["range", 6000],
      ["support_locations", [[-42, 20], [-42, -20], [28, 28], [28, -28]]]];


module mRPLidarA1M8R1() {
     rotate([0, 0, 180]) {
          translate([-35.14, 35, 0]) {
               rotate([90, 0, 0]) import("stl/RPLIDAR-A1M8-R1.stl");
          }
     }
}
