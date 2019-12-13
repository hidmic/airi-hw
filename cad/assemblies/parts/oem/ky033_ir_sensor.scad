include <generic/lib.scad>;


function vKY033IRSensorDatasheet() =
     let(thickness=1.6, sensor_z_offset=11.5 - thickness)
     [["width", 14], ["length", 31.18],
      ["sensor_width", 5.5], ["sensor_length", 10],
      ["height", sensor_z_offset + 6.3 - thickness],
      ["sensor_z_offset", sensor_z_offset],
      ["sensor_y_offset", 10.5],
      ["thickness", thickness]];


module mKY033IRSensor() {
     translate([0, -property(vKY033IRSensorDatasheet(), "sensor_y_offset"), 0]) {
          scale(10) import("stl/ky033_ir_sensor.stl");
     }
}


mKY033IRSensor();
