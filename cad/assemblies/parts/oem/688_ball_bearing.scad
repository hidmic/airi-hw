

function v688BallBearingDatasheet() =
     [["height", 5],
      ["inner_diameter", 8],
      ["outer_diameter", 16],
      ["outer_ring_diameter", 14.2]];


module m688BallBearing() {
     rotate([90, 0, 0]) import("stl/688-2z.stl", convexity=10);
}

m688BallBearing();
