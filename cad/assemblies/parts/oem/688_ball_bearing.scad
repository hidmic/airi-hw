include <generic/lib.scad>;

function v688BallBearingDatasheet() =
     [["height", 5],
      ["inner_diameter", 8],
      ["outer_diameter", 16],
      ["outer_ring_diameter", 14.2]];


module m688BallBearing() {
     color("silver") {
          rotate([90, 0, 0]) {
               import_mesh("stl/688-2z.stl");
          }
     }
}

m688BallBearing();
