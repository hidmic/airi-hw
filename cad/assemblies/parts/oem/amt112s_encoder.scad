include <generic/lib.scad>;

function vAMT112SEncoderDatasheet() =
     [["height", 10.34], ["width", 28.58], ["length", 37.25],
      ["axle_to_top_offset", 15.33], ["mounting_diameter", 25.4],
      ["mounting_angles", [-135, -45, 45, 135]],
      ["mounting_hole_diameter", 2]];


module mAMT112SEncoder() {
     datasheet = vAMT112SEncoderDatasheet();
     width = property(datasheet, "width");
     length = property(datasheet, "length");
     axle_to_top_offset = property(datasheet, "axle_to_top_offset");
     rotate([0, 0, 180]) {
          translate([-width/2, 0, -(length - axle_to_top_offset)]) {
               rotate([90, 0, 0]) import("stl/CUI_AMT112S-4096-8000-S.STL");
          }
     }
}


mAMT112SEncoder();
