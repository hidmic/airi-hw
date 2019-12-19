include <generic/lib.scad>;

function vSPDTSlideSwitchDatasheet() =
     [];

module mSPDTSlideSwitch() {
     color("dimgray") {
          translate([0, -1.6, 2.1]) {
               rotate([90, 0, 0]) {
                    import_mesh("stl/spdt_slide_switch.stl");
               }
          }
     }
}

mSPDTSlideSwitch();
