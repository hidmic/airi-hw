
function vRPLidarA1M8R1Datasheet() =
     [["working_width", 6], ["range", 6000], ["laser_top_offset", 9], ["main_diameter", 70],
      ["connector_y_offset", 30], ["connector_width", 6], ["connector_length", 20],
      ["support_locations", [[-42, 20], [-42, -20], [28, 28], [28, -28]]]];


module mRPLidarA1M8R1() {
     color("dimgray") {
          translate([-13, 0, 25])
          rotate([90, 0, 180])
          translate([77.3244, -744.642, -132.9176])
          render() import("stl/RPLIDAR-A1M8-R1.stl");
     }
}

mRPLidarA1M8R1();
