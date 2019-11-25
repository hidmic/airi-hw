
function vPCM060808BushingDatasheet() =
     [["height", 8], ["outer_diameter", 8], ["inner_diameter", 6]];

module mPCM060808Bushing() {
     rotate([0, -90, 0]) {
          import("stl/PCM_060808_E.stl");
     }
}
