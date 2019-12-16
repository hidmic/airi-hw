
function v12v7ahBatteryDatasheet() =
     [["length", 150], ["width", 65],
      ["height", 90], ["max_height", 101]];


module m12v7ahBattery() {
     color("dimgray") {
          render() import("stl/Batterie.stl");
     }
}


m12v7ahBattery();
