include <generic/lib.scad>;

function v5mmFlatTopLEDDatasheet() =
     [["diameter", 5], ["height", 5.3]];

module m5mmFlatTopLED() {
     translate([-7.3102541, -3.0, -22.9 -17.9 + 7.6]) {
          color("lightblue") import_mesh("stl/LED_5mm.stl");
     }
}

m5mmFlatTopLED();
