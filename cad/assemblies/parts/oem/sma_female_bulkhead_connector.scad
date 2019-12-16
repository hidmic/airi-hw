
function vSMAFemaleBulkheadConnectorDatasheet() =
     [["thread_length", 11], ["thread_diameter", 6.4]];

module mSMAFemaleBulkheadConnectorCutuotSection() {
     difference() {
          circle(d=6.4);
          translate([0, -6.0, 0]) {
               square(6.4, center=true);
          }
     }
}

module mSMAFemaleBulkheadConnector() {
     color("darkgoldenrod") {
          rotate([0, 0, 90]) {
               translate ([0, 0, -12.5]) {
                    rotate([0, -90, 0]) {
                         scale([25.4, 25.4, 25.4]) {  // inch to mm
                              render() import("stl/sma_female_bulkhead_connector.stl");
                         }
                    }
               }
          }
     }
}


mSMAFemaleBulkheadConnector();
