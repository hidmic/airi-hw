
function vM3PhillipsScrewDatasheet() =
     [["nominal_diameter", 3]];

module mM3x50mmAllenScrew() {
     color("silver") {
          rotate([0, 90, 0]) {
               translate([0, 0, 50]) {
                    render() import("stl/m3x50mm_allen_screw.stl");
               }
          }
     }
}

mM3x50mmAllenScrew();
