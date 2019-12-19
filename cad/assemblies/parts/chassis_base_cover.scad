include <generic/lib.scad>;

use <oem/16mm_led_pushbutton.scad>;
use <oem/m3_phillips_screw.scad>;
use <oem/m3x5mm_threaded_insert.scad>;
use <oem/m3_nut.scad>;

use <oem/rplidar_a1m8_r1.scad>;
use <oem/sma_female_bulkhead_connector.scad>;
use <oem/usb_type_a_panel_connector.scad>;

use <chassis_base.scad>;


function vChassisBaseCoverDatasheet() =
     let(chassis_datasheet=vChassisBaseDatasheet(),
         chassis_outer_diameter=property(chassis_datasheet, "outer_diameter"),
         chassis_inner_diameter=property(chassis_datasheet, "inner_diameter"),
         chassis_fillet_radius=property(chassis_datasheet, "fillet_radius"),
         min_thickness=property(chassis_datasheet, "thickness"),
         lidar_datasheet=vRPLidarA1M8R1Datasheet(),
         bay_height=property(lidar_datasheet, "working_width") + 2,
         height=(property(chassis_datasheet, "height") -
                 property(chassis_datasheet, "base_height") -
                 bay_height),
         support_diameter=10, wireway_width=20, wireway_conduit_width=25,
         outer_wireway_radius=chassis_outer_diameter/2 - support_diameter - chassis_fillet_radius,
         inner_wireway_radius=outer_wireway_radius - wireway_width,
         inner_diameter=property(lidar_datasheet, "main_diameter") + 2,
         sma_conn_datasheet=vSMAFemaleBulkheadConnectorDatasheet(),
         sma_conn_thread_length=property(sma_conn_datasheet, "thread_length"),
         sma_conn_locations=[let(wireway_conduit_angular_width=2 * asin(wireway_conduit_width / (2 * inner_wireway_radius)))
                             for(angle = [-135, 135]) let(corner_angle=angle - sign(angle) * wireway_conduit_angular_width/2)
                             [inner_wireway_radius * cos(corner_angle) - sign(cos(angle)) * sma_conn_thread_length,
                              inner_wireway_radius * sin(corner_angle), height/2]])
     [["height", height], ["bay_height", bay_height], ["panel_length", 40], ["panel_width", 80], ["panel_angular_offset", 0],
      ["panel_r_offset", -chassis_outer_diameter/4], ["outer_wireway_radius", outer_wireway_radius],
      ["inner_wireway_radius", inner_wireway_radius], ["inner_diameter", inner_diameter],
      ["wireway_conduit_angles", [-135, -45, 45, 135]],
      ["wireway_conduit_width", wireway_conduit_width], ["wireway_width", wireway_width],
      ["support_angles", [-165, -135, -105, -75, 75, 105, 135, 165]], ["bay_support_angles", [-90, 90, 180]],
      ["support_r_offset", chassis_inner_diameter/2 - support_diameter/2],
      ["support_diameter", support_diameter], ["fastening_angles", [0, 90, 180, 270]],
      ["fastening_r_offset", [inner_wireway_radius - support_diameter/2 - min_thickness,
                              inner_diameter/2 + min_thickness + support_diameter/2]],
      ["sma_conn_locations", sma_conn_locations],
      ["pole_block_diameter", 60], ["pole_block_taper_angle", 25],
      ["pole_socket_diameter",50], ["pole_socket_taper_angle", 25],
      ["pole_socket_depth", 20], ["min_thickness", min_thickness]];


function vChassisCoverSupportScrewDatasheet() = vM3PhillipsScrewDatasheet();
