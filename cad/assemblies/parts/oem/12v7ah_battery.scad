include <generic/lib.scad>;

function v12v7ahBatteryDatasheet() =
     [["length", 150], ["width", 65],
      ["height", 90], ["max_height", 101]];


module m12v7ahBattery() {
     color("dimgray") {
          import_mesh("stl/Batterie.stl");
     }
}


m12v7ahBattery();
