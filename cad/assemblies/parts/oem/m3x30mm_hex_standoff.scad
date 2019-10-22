include <generic/lib.scad>;

use <generic/standoffs.scad>;

function vM3x30mmHexThreadedStandoffDatasheet() =
     pvMetricHexStandoffDatasheet(hole_diameter=3, thread_pitch=0.5, length=30, width=5.5);

module mM3x30mmHexThreadedStandoff() {
     pmMetricHexStandoff(datasheet=vM3x30mmHexThreadedStandoffDatasheet());
}

function vM3x30mmHexStandoffDatasheet() =
     pvMetricHexStandoffDatasheet(length=30, width=5.5);

module mM3x30mmHexStandoff() {
     pmMetricHexStandoff(datasheet=vM3x30mmHexStandoffDatasheet());
}
