
function v70mmShockAbsorberDatasheet() =
     [["length", 68], ["diameter", 17], ["hole_diameter", 2.5]];

module m70mmShockAbsorber() {
     color("crimson") {
          render() {
               translate([0.0, 0.07597303, -33.29282761]) {
                    import("stl/shock_absorber_1_10_70.stl");
               }
          }
     }
}

m70mmShockAbsorber();
