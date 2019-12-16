include <generic/lib.scad>;

function vPJ082BHConnectorDatasheet() =
     [["length", 13], ["width", 10], ["height", 10]];

module mPJ082BHConnector() {
     color("silver") {
          translate([-46.77696228, -20.51359606, -12.1999979 + 10]) {
               import("stl/pj-082bh.stl");
          }
     }
}


mPJ082BHConnector();
