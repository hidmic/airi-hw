include <generic/lib.scad>;

function v16mmLEDPushbuttonDatasheet() = [["cutout_diameter", 16]];

module m16mmLEDPushbutton() {
     color("silver") {
          rotate([0, 0, -90]) {
               import_mesh("stl/16mm_led_pushbutton.stl");
          }
     }
}
