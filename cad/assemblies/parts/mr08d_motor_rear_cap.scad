include <generic/lib.scad>;

use <generic/motor_cap.scad>;

use <oem/m2_nut.scad>;
use <oem/m2_phillips_screw.scad>;
use <oem/mr08d_024022_motor.scad>;

// use <oem/35x1_5mm_oring.scad>;

function vMR08DMotorRearCapDatasheet() =
     let(motor_datasheet=vMR08D024022MotorDatasheet(),
         inner_diameter=property(motor_datasheet, "bottom_diameter"), height=6,
         wall_thickness=1, seat_diameter=inner_diameter - 4 * wall_thickness)
     pvMotorCapDatasheet(inner_diameter=inner_diameter, seat_diameter=seat_diameter,
                         wall_thickness=wall_thickness, height=height,
                         motor_datasheet=motor_datasheet,
                         fastening_screw_datasheet=vM2PhillipsScrewDatasheet(),
                         fastening_nut_datasheet=vM2NutDatasheet());

module mMR08DMotorRearCapNut() {
     mM2Nut();
}

module mMR08DMotorRearCapScrew() {
     mM2x10mmPhillipsScrew();
}


module mMR08DMotorRearCap() {
     color($default_color) pmMotorCap(vMR08DMotorRearCapDatasheet());
}

mMR08DMotorRearCap();
