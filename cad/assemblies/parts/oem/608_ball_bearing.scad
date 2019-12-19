include <generic/lib.scad>;

function v608BallBearingDatasheet() =
     [["height", 7],
      ["inner_diameter", 8],
      ["outer_diameter", 22],
      ["outer_ring_diameter", 19.1]];


module m608BallBearing() {
     color("silver") {
          rotate([90, 0, 0]) {
               import_mesh("stl/608.stl", convexity=10);
          }
     }
}

m608BallBearing();
