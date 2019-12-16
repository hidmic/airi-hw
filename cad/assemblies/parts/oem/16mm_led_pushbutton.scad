
function v16mmLEDPushbuttonDatasheet() = [["cutout_diameter", 16]];


module m16mmLEDPushbutton() {
     color("silver") {
          render() {
               rotate([0, 0, -90]) {
                    import("stl/16mm_led_pushbutton.stl");
               }
          }
     }
}
