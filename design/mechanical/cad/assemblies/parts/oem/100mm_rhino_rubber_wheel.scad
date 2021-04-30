include <generic/lib.scad>;


function v100mmRhinoRubberWheelDatasheet() =
     [["diameter", 96], ["width", 32], ["inner_width", 8]];


module m100mmRhinoRubberWheel() {
     color([0.1, 0.1, 0.1]) {
          render() {
               let (width=property(v100mmRhinoRubberWheelDatasheet(), "width")) {
                    translate([0, width/2, 0]) {
                         rotate([-90, 0, 0]) import_mesh("stl/3601-0014-0096.stl");
                    }
               }
          }
     }
}

m100mmRhinoRubberWheel();