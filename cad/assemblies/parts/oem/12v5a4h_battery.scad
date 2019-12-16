
function v12v5a4hBatteryDatasheet() =
     [["length", 90], ["width", 70],
      ["height", 101], ["max_height", 107]];


module m12v5a4hBattery() {
     color("dimgray") {
          render() {
               rotate([90, 0, 0]) {
                    import("stl/Battery12V_5A.stl");
               }
          }
     }
}


m12v5a4hBattery();
