include <generic/lib.scad>;

use <generic/standoffs.scad>;

function vM3x30mmHexThreadedStandoffDatasheet() =
     pvMetricHexStandoffDatasheet(hole_diameter=3, thread_pitch=0.5, length=30, width=5.5);

module mM3x30mmHexThreadedStandoff() {
     color("darkgoldenrod") pmMetricHexStandoff(datasheet=vM3x30mmHexThreadedStandoffDatasheet());
}

function vM3x30mmHexStandoffDatasheet() =
     pvMetricHexStandoffDatasheet(hole_diameter=3, length=30, width=5.5);

module mM3x30mmHexStandoff() {
     color("darkgoldenrod") pmMetricHexStandoff(datasheet=vM3x30mmHexStandoffDatasheet());
}


function vM3x40mmHexThreadedStandoffDatasheet() =
     pvMetricHexStandoffDatasheet(hole_diameter=3, thread_pitch=0.5, length=40, width=5.5);

module mM3x40mmHexThreadedStandoff() {
     color("darkgoldenrod") pmMetricHexStandoff(datasheet=vM3x40mmHexThreadedStandoffDatasheet());
}

function vM3x40mmHexStandoffDatasheet() =
     pvMetricHexStandoffDatasheet(hole_diameter=3, length=40, width=5.5);

module mM3x40mmHexStandoff() {
     color("darkgoldenrod") pmMetricHexStandoff(datasheet=vM3x40mmHexStandoffDatasheet());
}


function vM3x15mmHexThreadedStandoffDatasheet() =
     pvMetricHexStandoffDatasheet(hole_diameter=3, thread_pitch=0.5, length=15, width=5.5);

module mM3x15mmHexThreadedStandoff() {
     color("darkgoldenrod") pmMetricHexStandoff(datasheet=vM3x15mmHexThreadedStandoffDatasheet());
}

function vM3x15mmHexStandoffDatasheet() =
     pvMetricHexStandoffDatasheet(hole_diameter=3, length=15, width=5.5);

module mM3x15mmHexStandoff() {
     color("darkgoldenrod") pmMetricHexStandoff(datasheet=vM3x15mmHexStandoffDatasheet());
}

function vM3x10mmHexThreadedStandoffDatasheet() =
     pvMetricHexStandoffDatasheet(hole_diameter=3, thread_pitch=0.5, length=10, width=5.5);

module mM3x10mmHexThreadedStandoff() {
     color("darkgoldenrod") pmMetricHexStandoff(datasheet=vM3x10mmHexThreadedStandoffDatasheet());
}

function vM3x10mmHexStandoffDatasheet() =
     pvMetricHexStandoffDatasheet(hole_diameter=3, length=10, width=5.5);

module mM3x10mmHexStandoff() {
     color("darkgoldenrod") pmMetricHexStandoff(datasheet=vM3x10mmHexStandoffDatasheet());
}

