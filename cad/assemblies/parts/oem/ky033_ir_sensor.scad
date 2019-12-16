include <generic/lib.scad>;


function vKY033IRSensorDatasheet() =
     let(length=31.18, thickness=1.6, sensor_y_offset=10.5, sensor_z_offset=10)
     [["width", 14], ["length", length],
      ["sensor_width", 5.5], ["sensor_length", 10],
      ["height", sensor_z_offset + 6.3 - thickness],
      ["sensor_z_offset", sensor_z_offset],
      ["sensor_y_offset", sensor_y_offset],
      ["hole_y_offset", -length/2 + 7],
      ["hole_diameter", 3],
      ["thickness", thickness]];

echo(vKY033IRSensorDatasheet());

module mKY033IRSensor() {
     color("darkblue") {
          render() {
               translate([0, -property(vKY033IRSensorDatasheet(), "sensor_y_offset"), 0]) {
                    scale(10) import("stl/ky033_ir_sensor.stl");
               }
          }
     }
}

mKY033IRSensor();
