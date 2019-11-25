include <generic/lib.scad>;

use <parts/wheel_suspension_frame.partA.scad>;
use <parts/wheel_suspension_frame.partB.scad>;

kWheelSuspensionFrame_PartA_Datasheet = vWheelSuspensionFrame_PartA_Datasheet();
kWheelSuspensionFrame_PartB_Datasheet = vWheelSuspensionFrame_PartB_Datasheet();

module mWheelSuspensionFrame() {
     let(z_offset=-(property(kWheelSuspensionFrame_PartA_Datasheet, "thickness") +
                    property(kWheelSuspensionFrame_PartA_Datasheet, "female_snap_fit_height")/2)) {
          rotate([90, 0, 0]) translate([0, 0, z_offset - 0.2]) mWheelSuspensionFrame_PartA();
     }
     let(z_offset=-(property(kWheelSuspensionFrame_PartB_Datasheet, "thickness") +
                    property(kWheelSuspensionFrame_PartB_Datasheet, "male_snap_fit_height")/2)) {
          rotate([-90, 0, 0]) translate([0, 0, z_offset - 0.2]) mWheelSuspensionFrame_PartB();
     }
}

mWheelSuspensionFrame();
