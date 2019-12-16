$fn = 32;
$default_color = [0.203125, 0.203125, 0.203125];

kEpsilon = 1e-1;

function property(table, key) = table[search([key], table)[0]][1];

module hull_complement() {
     difference() {
          hull() {
               children();
          }
          children();
     }
}

module sector(radius, angles, fn = $fn) {
     r = radius / cos(180 / fn);
     step = -360 / fn;

     points = concat([[0, 0]],
                     [for(a = [angles[0] : step : angles[1] - 360])
                               [r * cos(a), r * sin(a)]
                          ],
                     [[r * cos(angles[1]), r * sin(angles[1])]]
          );

     difference() {
          circle(radius, $fn = fn);
          polygon(points);
     }
}

module ring(inner_radius, outer_radius, angles = [0, 360], fn = $fn) {
     difference() {
          sector(radius=outer_radius, angles=angles, fn=fn);
          sector(radius=inner_radius, angles=angles+[-kEpsilon, kEpsilon], fn=fn);
     }
}

module rounded_ring(inner_radius, outer_radius, angles = [0, 360], fn = $fn) {
     step_angle = 360 / fn;
     ring_width = outer_radius - inner_radius;
     ring_mean_radius = (outer_radius + inner_radius) / 2;
     for (theta = angles) {
          theta_d = theta / step_angle;
          theta_frac = (theta_d - floor(theta_d) - 0.5) * step_angle;
          rho = ring_mean_radius * cos(step_angle/2) / cos(theta_frac);
          rotate(theta)
          translate([rho, 0])
          circle(d=ring_width);
     }
     ring(inner_radius=inner_radius,
          outer_radius=outer_radius,
          angles=angles, fn=fn);
}

module fillet(r) {
     difference() {
          difference() {
               offset(r=-r - kEpsilon / 100) {
                    offset(delta=r) {
                         children();
                    }
               }
               offset(r=r) {
                    offset(delta=-r) {
                         children();
                    }
               }
          }
          children();
     }
     offset(r=r) {
          offset(delta=-r) {
               children();
          }
     }
}

module bench_fillet(r, order=1000) {
     difference() {
          fillet(r) {
               translate([-order/2-kEpsilon, 0]) {
                    square([order, order], center=true);
               }
               children();
          }
          translate([-order/2-kEpsilon, 0]) {
               square([order+kEpsilon, order+kEpsilon], center=true);
          }
     }
}

module curved_bench_fillet(r, bench_radius, order=1000, internal=true) {
     difference() {
          fillet(r) {
               if (internal) {
                    translate([bench_radius, 0]) {
                         ring(inner_radius=bench_radius + kEpsilon, outer_radius=bench_radius * order);
                    }
               } else {
                    translate([-bench_radius, 0]) circle(r=bench_radius - kEpsilon);
               }
               children();
          }
          if (internal) {
               translate([bench_radius, 0]) {
                    ring(inner_radius=bench_radius, outer_radius=bench_radius * order + kEpsilon);
               }
          } else {
               translate([-bench_radius, 0]) circle(r=bench_radius);
          }
     }
}


module window(side, position=[0, 0, 0], order=1000) {
    difference() {
        children();
        translate(position)  {
            difference() {
                square(order, center=true);
                square(side, center=true);
            }
        }
    }
}


module rounded_cylinder(diameter, height, fillet_radius, center) {
     translate([0, 0, ! center ? height/2 : 0]) {
          minkowski() {
               cylinder(d=(diameter - 2 * fillet_radius),
                        h=(height - 2 * fillet_radius),
                        center=true);
               sphere(r=fillet_radius);
          }
     }
}

module curved_support_xsection(support_radius, fillet_radius,
                               wall_inner_radius, wall_outer_radius,
                               hole_radius = 0, internal=true) {
     assert(support_radius > 0);
     assert(fillet_radius > 0);
     assert(wall_inner_radius > 0);
     assert(support_radius >= fillet_radius);
     assert(wall_outer_radius > wall_inner_radius);
     assert(support_radius > hole_radius);
     support_angular_width = (4 * support_radius / wall_outer_radius) * 180 / PI;
     wall_thickness = wall_outer_radius - wall_inner_radius;
     rotate([0, 0, internal ? 180 : 0]) {
          difference() {
               window(6*support_radius, order=30*support_radius) {
                    curved_bench_fillet(fillet_radius, bench_radius=wall_inner_radius, internal=internal) {
                         hull() {
                              translate([support_radius + wall_thickness/2, 0]) {
                                   circle(r=support_radius);
                              }
                              rotate([0, 0, ! internal ? 180 : 0])
                              translate([wall_inner_radius + wall_thickness/2, 0]) {
                                   ring(inner_radius=wall_inner_radius,
                                        outer_radius=wall_outer_radius,
                                        angles=[180 - support_angular_width/2,
                                                180 + support_angular_width/2]);
                              }
                         }
                         rotate([0, 0, ! internal ? 180 : 0])
                         translate([wall_inner_radius + wall_thickness/2, 0]) {
                              ring(inner_radius=wall_inner_radius,
                                   outer_radius=wall_outer_radius,
                                   angles=[180 - support_angular_width,
                                           180 + support_angular_width]);
                         }
                    }
               }
               if (hole_radius > 0) {
                    translate([support_radius + wall_thickness/2, 0]) {
                         circle(r=hole_radius);
                    }
               }
          }
     }
}

module outline(delta) {
     assert(delta != 0);
     if (delta > 0) {
          difference() {
               offset(delta=delta) {
                    children();
               }
               children();
          }
     } else {
          intersection() {
               difference() {
                    children();
                    offset(delta=delta) {
                         children();
                    }
               }
               children();
          }
     }
}

module outline_extrude(height, thickness, keep) {
     assert(thickness > 0);
     assert(height > thickness);

     linear_extrude(height=height - thickness) {
          difference() {
               outline(delta=thickness) {
                    children();
               }
          }
     }
     linear_extrude(height=thickness) {
          children(keep);
     }
}

module duplicate(v) {
     children();
     mirror(v) children();
}

function steps(start, end, n) = [start:(end - start)/(n - 1):end];

function sigmoid(x) = 1.0 / (1.0 + exp(-x));

module sigmoid_profile(length, width, order=10, fn = $fn) {
     step = length / fn;
     points = concat(
          [[0, 0]],
          [for (x = [step:step:length-step]) [x, width * sigmoid(2 * order * ((x / length) - 0.5))]],
          [[length, width], [0, width]]

     );
     polygon(points=points);
}

module exp_nerve_xsection(height, length, decay_rate = 5, fn = $fn) {
     step = length / fn;
     points = concat(
          [[0, 0]],
          [for (x = [0:step:length-step]) [x, height * exp(-x/decay_rate)]],
          [[length, 0]]
          );
     polygon(points=points);
}

module exp_nerve(height, length, thickness, decay_rate = 3, fn = $fn) {
     rotate([90, 0, 0])
     linear_extrude(height=thickness, center=true) {
          exp_nerve_xsection(height, length, decay_rate, fn);
     }
}

module exp_corner_nerve(height, radius, angles, corner_radius = 0, decay_rate = 3, fn = $fn) {
     difference() {
          rotate_extrude() {
               if (corner_radius > 0) {
                    translate([corner_radius, 0, 0])
                    exp_nerve_xsection(height=height, length=radius, decay_rate=decay_rate, fn=fn);
               } else {
                    translate([-corner_radius, 0, 0])
                    mirror([1, 0, 0])
                    exp_nerve_xsection(height=height, length=radius, decay_rate=decay_rate, fn=fn);
               }
          }
          linear_extrude(height=2 * height, center=true) {
               sector(radius=radius + abs(corner_radius), angles=[angles[1], angles[0] + 360], fn=fn);
          }
     }
}

function slice(v, i) = [for (j = i) v[j]];

function all(v) = len(v) == 0 ? true : ( len(v) == 1 || ! v[0] ? v[0] : all(slice(v, [1:len(v)-1])));

module square_frame(length, width, link_width) {
     difference() {
          square([length, width], center=true);
          duplicate([1, 0, 0]) {
               let(corner_angle=atan(length/width), triangle_base_x_offset=length/2 - link_width,
                   triangle_base_y_offset=width/2 - link_width * width / length - link_width/2 / sin(corner_angle),
                   triangle_tip_x_offset=link_width/2 / cos(corner_angle)) {
                    polygon([[triangle_base_x_offset, triangle_base_y_offset],
                             [triangle_base_x_offset, -triangle_base_y_offset],
                             [triangle_tip_x_offset, 0]]);
               }
          }
          duplicate([0, 1, 0]) {
               let(corner_angle=atan(width/length), triangle_base_y_offset=width/2 - link_width,
                   triangle_base_x_offset=length/2 - link_width * length / width - link_width/2 / sin(corner_angle),
                   triangle_tip_y_offset=link_width/2 / cos(corner_angle)) {
                    polygon([[triangle_base_x_offset, triangle_base_y_offset],
                             [-triangle_base_x_offset, triangle_base_y_offset],
                             [0, triangle_tip_y_offset]]);
               }
          }
     }
}

module wifi_logo(size, waves=3) {
     for (i = [1:waves]) {
          rounded_ring(outer_radius=(2 * i + 1) * size, inner_radius=2 * i * size, angles=[-45, 45]);
     }
     circle(r=size);
}


