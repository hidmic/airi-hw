include <generic/lib.scad>;

function v8mmClampingHubDatasheet() =
     [["height", 8], ["mount_locations", [[8, 8], [8, -8], [-8, 8], [-8, -8]]]];

module m8mmClampingHub() {
     color("silver") {
          translate([0.5, 0, 3.3303027798233593])
          rotate([0, -180, 90])
          translate([26.56210756, 12.11835694, -22.16415906])
          import_mesh("stl/1301-0016-0008.stl");
     }
}

m8mmClampingHub();
