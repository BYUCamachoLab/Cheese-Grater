layer = 0.01;       // 10um scale for z direction
px = 0.0076;        // 7.6um scale for x and y directions



hchan = 5*layer;
wchan = 8*px;       // default x and y channel width
xychan = 8*px;      // default z channel width, should be even number, at least 8 for good flow
valve_xy = 6*px;    // side length of z channels out of valve bottom

distance_to_glass = 0.3;
h_bulk = distance_to_glass+0.5;

module centered_cube(x, y, z) {
     translate([-x/2, -y/2, 0]) cube([x, y, z]);
}

module flow_indicator(){
     // mark to tell which way flow should go
     mark_x = 400*px;
     mark_y = -350*px;
     mark_scale = 25*px;
     s_depth = h_bulk-0.1;
     translate([mark_x, mark_y, s_depth])
          cube([mark_scale, 7*mark_scale, 0.1]);
     translate([mark_x-2*mark_scale, mark_y+4*mark_scale, s_depth])
          cube([5*mark_scale, mark_scale, 0.1]);
     translate([mark_x-mark_scale, mark_y+5*mark_scale, s_depth])
          cube([3*mark_scale, mark_scale, 0.1]);
}

module bulk() {
     translate([1280*px, 800*px, 0]) {
          difference() {
               centered_cube(1200*px, 900*px, h_bulk);
               translate([0, 0, h_bulk-0.09]) {
                    for(i=[-4:4]) {
                         translate([i*port_to_port_x, port_loc_y, 0]) {
                              centered_cube(30*px, 30*px, 0.091);
                         }
                    }

                    mirror([0, 1, 0]) {
                         for(i=[-4:4]) {
                              translate([i*port_to_port_x, port_loc_y, 0]) {
                                   centered_cube(30*px, 30*px, 0.091);
                              }
                         }
                    }

                    for(i=[-0:0]) {
                         translate([port_loc_x, i*port_to_port_x, 0]) {
                              centered_cube(30*px, 30*px, 0.091);
                         }
                    }

                    mirror([1, 0, 0]) {
                         for(i=[-0:0]) {
                              translate([port_loc_x, i*port_to_port_x, 0]) {
                                   centered_cube(30*px, 30*px, 0.091);
                              }
                         }

                    }

               }
          }

          translate([0, 0, h_bulk-0.09]) {
               for(i=[-4:4]) {
                    translate([i*port_to_port_x, port_loc_y, 0]) {
                         centered_cube(26*px, 26*px, 0.10);
                    }
               }

               mirror([0, 1, 0]) {
                    for(i=[-4:4]) {
                         translate([i*port_to_port_x, port_loc_y, 0]) {
                              centered_cube(26*px, 26*px, 0.10);
                         }
                    }
               }

               for(i=[-0:0]) {
                    translate([port_loc_x, i*port_to_port_x, 0]) {
                         centered_cube(26*px, 26*px, 0.10);
                    }
               }

               mirror([1, 0, 0]) {
                    for(i=[-0:0]) {
                         translate([port_loc_x, i*port_to_port_x, 0]) {
                              centered_cube(26*px, 26*px, 0.10);
                         }
                    }

               }
          }
     }
}

h_alignment = 0.3;
module alignment() {
     translate([0, 350*px, 0])  centered_cube(142*px, 100*px, h_alignment);
     translate([0, -350*px, 0]) centered_cube(142*px, 100*px, h_alignment);
     translate([-500*px, 0, 0]) centered_cube(100*px, 142*px, h_alignment);
     translate([500*px, 0, 0])  centered_cube(100*px, 142*px, h_alignment);
}

module xchan(l, w=wchan, h=hchan) {
    color("lightblue")
    if (l < 0) {
        mirror([1,0,0])
            translate([0, -floor(w/px/2)*px, 0]) cube([-l, w, h]);
    }
    else {
        translate([0, -floor(w/px/2)*px, 0]) cube([l, w, h]);
    }
}

module ychan(l, w=wchan, h=hchan) {
    color("lightblue")
    if (l < 0) {
        mirror([0,-1,0])
            translate([-floor(w/px/2)*px, 0, 0]) cube([w, -l, h]);
    }
    else {
        translate([-floor(w/px/2)*px, 0, 0]) cube([w, l, h]);
    }
}

module zchan(l, xy=xychan) {
    color("lightblue")
    translate([-xy/2, -xy/2, 0]) {
        if (l < 0) {
            mirror([0,0,1])
                cube([xy, xy, -l]);
        }
        else {
            cube([xy, xy, l]);
        }
    }
}

module valve_core(d_valve=d_valve, h_fluid_valve=h_fluid_valve, h_air_valve=h_air_valve, t_memb_valve=t_memb_valve, sep=sep, l_chan_fluid=l_chan_fluid, l_chan_air=l_chan_air, orth=false) {
    color("white") cylinder(d=d_valve, h=h_fluid_valve, $fn=100);
    translate([0, 0, h_fluid_valve+t_memb_valve])
    color("dodgerblue") cylinder(d=d_valve, h=h_air_valve, $fn=100);

    zchan(l=-l_chan_fluid, xy=valve_xy);

     //     translate([sep+valve_xy,0,0])
    translate([d_valve/2-.5*valve_xy,0,0])
        zchan(l=-l_chan_fluid, xy=valve_xy);

    if (orth) {
        for(i=[0:1]) mirror([0,i,0])
            translate([0, d_valve/2-xychan/2, h_total_valve])
                zchan(l=l_chan_air);
    } else {
        for(i=[0:1]) mirror([i,0,0])
            translate([d_valve/2-xychan/2, 0, h_total_valve])
                zchan(l=l_chan_air);
    }
}

module valve_array() {
     for(i=[0:8]) {
          translate([(i-4)*port_to_port_x,0,0]) {
               valve_core(d_valve=d_valve_arr[i]);
          }
     }
}

// Interconnect port location parameters
port_to_port_x = 60*px;
port_loc_y = 190*px;
port_loc_x = 293*px;

// Length of y-channel above 1-way valves
outlet_ychan_len = 40*px;

module interconnects() {
     translate([-port_loc_x,-port_loc_y,l_chan_air-15*layer]) vert_connect_short();
     translate([port_loc_x,-port_loc_y,l_chan_air-15*layer])  vert_connect_short();
     translate([-290*px,0,23*layer+l_chan_air]) color("lightgreen") xchan(43*px, w=10*px, h=8*layer);
     translate([-233*px,0,23*layer+l_chan_air]) color("lightgreen") xchan(45*px, w=10*px, h=8*layer);
     translate([-172*px,0,23*layer+l_chan_air]) color("lightgreen") xchan(43*px, w=10*px, h=8*layer);
     translate([-111*px,0,23*layer+l_chan_air]) color("lightgreen") xchan(44*px, w=10*px, h=8*layer);
     translate([-53*px, 0,23*layer+l_chan_air]) color("lightgreen") xchan(45*px, w=10*px, h=8*layer);
     translate([8*px,   0,23*layer+l_chan_air]) color("lightgreen") xchan(43*px, w=10*px, h=8*layer);
     // translate([69*px,  0,23*layer+l_chan_air]) color("lightgreen") xchan(44*px, w=10*px, h=8*layer);
     translate([127*px, 0,23*layer+l_chan_air]) color("lightgreen") xchan(45*px, w=10*px, h=8*layer);
     translate([188*px, 0,23*layer+l_chan_air]) color("lightgreen") xchan(43*px, w=10*px, h=8*layer);
     translate([249*px, 0,23*layer+l_chan_air]) color("lightgreen") xchan(43*px, w=10*px, h=8*layer);

     for(i=[0:8]) { // 9 side connections
          translate([(i-4)*port_to_port_x,0,15*layer-l_chan_fluid]) {
               mirror([0,1,0]) translate ([0,0,0]) vert_connect();                             // center side connects
               translate ([0,0,0]) vert_connect();                                             // offset side connects
               translate([20*px,   -3*px, 0]) color("salmon") ychan(200*px, w=10*px, h=8*layer); // long salmon piece
               translate([10*px,  183*px, 0]) color("salmon") ychan( 14*px, w=10*px, h=8*layer); // short salmon piece
               translate([-2*px, -197*px, 0]) color("salmon") ychan(200*px, w=10*px, h=8*layer); // center salmon piece
          }
     }





}

interconnect_zchan_len = 1;
module vert_connect() {
     translate([0, port_loc_y, 0])
          zchan(l=interconnect_zchan_len, xy=14*px);
}

module vert_connect_short() {
     translate([0, port_loc_y, z_total])
          zchan(l=interconnect_zchan_len-z_total, xy=14*px);
}

module voids() {
     translate([1280*px, 800*px, distance_to_glass]) {
          translate([0,0,-z_minus]) valve_array();
          interconnects();
     }
}

eps = 0.0001;

d_valve = 40*px;
d_valve_arr = [30, 28, 26, 30, 28, 26, 30, 28, 26]*px;
h_fluid_valve = 2*layer;
h_air_valve = 4*layer;
t_memb_valve = 2*layer;

// want to make membrane thinner
// 550ms - 10um, 350 - 5um (later layer, 10um prints first)

sep = 6*px;
l_chan_fluid = 14*layer;
l_chan_air = 10*layer;
h_total_valve = h_fluid_valve + h_air_valve + t_memb_valve;

z_chan_bott = 15*layer;
z_chan_top = 15*layer;
z_plus = h_fluid_valve + t_memb_valve + h_air_valve + z_chan_top;
z_minus = -z_chan_bott;
z_total = abs(z_minus) + z_plus;


translate([1280*px, 800*px, h_bulk])
     alignment();

difference() {
     *bulk();
     voids();
}

color("blue") translate([0, 0, -2])
    import("171220_p4_interface.stl", convexity=3);
