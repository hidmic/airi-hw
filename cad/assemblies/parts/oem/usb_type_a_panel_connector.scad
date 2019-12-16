include <generic/lib.scad>;


function vUSBTypeAPanelConnectorDatasheet() =
     [["conn_height", 16.8], ["cutout_length", 12.3], ["cutout_width", 26.5],
      ["flare_height", 4.5], ["flare_length", 18], ["flare_width", 30.31]];


module mUSBTypeAPanelConnector() {
     module mUSBTypeAFemaleConnector() {
          rotate([0, 0, 90]) {
               translate([-53.92913818, 0.57096958, 0.19999933]) {
                    import("stl/usb_type_a_female_connector.stl");
               }
          }
     }

     datasheet = vUSBTypeAPanelConnectorDatasheet();
     flare_height = property(datasheet, "flare_height");
     flare_length = property(datasheet, "flare_length");
     flare_width = property(datasheet, "flare_width");

     color("black") {
          render() {
               linear_extrude(height=flare_height) {
                    difference() {
                         square([flare_length, flare_width], center=true);
                         hull() projection() mUSBTypeAFemaleConnector();
                    }
               }
          }
     }
     color("silver") {
          conn_height = property(datasheet, "conn_height");
          translate([0, 0, flare_height-conn_height/2]) {
               render() mUSBTypeAFemaleConnector();
          }
     }
}


mUSBTypeAPanelConnector();
