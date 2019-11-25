

function v608BallBearingDatasheet() =
     [["height", 7],
      ["inner_diameter", 8],
      ["outer_diameter", 22],
      ["outer_ring_diameter", 19.1]];


module m608BallBearing() {
     rotate([90, 0, 0]) import("stl/608.stl", convexity=10);
}

m608BallBearing();
