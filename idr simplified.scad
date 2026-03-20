// Industrial room (CFD-ready) - mesh-friendly edition
// Based on your earlier script; only geometry detail changed to improve mesh quality.
// Units: meters
$fn = 48; // facets for rounded geometry

// ---------- ROOM DIMENSIONS (meters) ----------
room_x = 30;   // length (x)
room_y = 15;   // width  (y)
room_z = 10;   // height (z)
wall_thickness = 0.25;

// ---------- PIPE / FEATURE SIZING (increase these to avoid tiny features) ----------
min_feature = 0.06;     // absolute smallest feature (~6 cm) - prevents tiny slivers
thin_pipe_od = 0.18;    // previously ~0.12 => increased to 0.18 m
cross_pipe_od = 0.14;   // previously 0.05 => increased to 0.14 m
vertical_riser_od = 0.14; // previously 0.09 => increased
branch_pipe_od = 0.10;  // small branch pipes slightly larger than before
vent_pipe_od   = 0.12;  // vent/long pipe
support_size   = 0.28;  // increase minimal support thickness

// ---------- REACTOR / TANK SIZING (unchanged conceptually) ----------
module vertical_reactor(radius=1.2, height=6, head="dome") {
    union() {
        translate([0,0,0]) cylinder(h=height, r=radius, center=false);
        if (head == "dome") {
            translate([0,0,height]) sphere(r=radius);
        } else {
            translate([0,0,height]) cylinder(h=0.25, r=radius, center=false);
        }
    }
}

module horizontal_reactor(radius=1.2, length=8, head="flat") {
    union() {
        // center the horizontal reactor so placements are intuitive
        translate([0,0,0]) rotate([0,90,0]) cylinder(h=length, r=radius, center=false);
        if (head == "dome") {
            // approximate hemispherical endcaps
            translate([0,0,0]) rotate([0,90,0]) sphere(r=radius);
            translate([length,0,0]) rotate([0,90,0]) sphere(r=radius);
        } else {
            translate([0,0,0]) rotate([0,90,0]) cylinder(h=0.2, r=radius);
            translate([length,0,0]) rotate([0,90,0]) cylinder(h=0.2, r=radius);
        }
    }
}

module tank(radius=1, height=4) {
    union() {
        cylinder(h=height, r=radius, center=false);
        translate([0,0,height]) cylinder(h=0.2, r=radius, center=false);
    }
}

// ---------- pipe using multmatrix rotation (keeps arbitrary orientation possible) ----------
function norm(v) = sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
function rot_to_matrix(v) =
    let(len = norm(v),
        ux = v[0]/len, uy = v[1]/len, uz = v[2]/len,
        // choose tangent vector a
        a = (abs(uz) < 0.999) ? [ -uy, ux, 0 ] : [1,0,0],
        av = let(n=norm(a)) (n>0 ? [a[0]/n,a[1]/n,a[2]/n] : [1,0,0]),
        vx = av[0], vy = av[1], vz = av[2],
        // w = v cross a
        wx = uy*vz - uz*vy,
        wy = uz*vx - ux*vz,
        wz = ux*vy - uy*vx,
        wn = norm([wx,wy,wz]),
        wxn = wn>0 ? wx/wn : 0,
        wyn = wn>0 ? wy/wn : 0,
        wzn = wn>0 ? wz/wn : 0
    )
    [
      [ ux, vx, wxn, 0 ],
      [ uy, vy, wyn, 0 ],
      [ uz, vz, wzn, 0 ],
      [  0,  0,   0, 1 ]
    ];

module pipe(start=[0,0,0], end=[1,0,0], od = thin_pipe_od) {
    v = [end[0]-start[0], end[1]-start[1], end[2]-start[2]];
    len = norm(v);
    if (len > 1e-6) {
        translate(start)
            multmatrix(m = rot_to_matrix(v))
                translate([0,0,0])
                    cylinder(h = len, r = od/2, center=false);
    }
}

// ---------- BUILD THE EQUIPMENT LAYOUT (same concept, thicker pipes) ----------
module equipment_layout() {
    // vertical reactors grid
    x0 = 6; y0 = 4;
    gapx = 6; gapy = 4;
    for (i=[0:3]) {
        for (j=[0:1]) {
            tx = x0 + i*gapx;
            ty = y0 + j*gapy;
            translate([tx, ty, 0])
                vertical_reactor(radius = (i%2==0?1.9:1.6), height = 6, head=( (i+j)%3==0 ? "dome":"flat"));
        }
    }

    // cluster of storage tanks
    translate([5, 12.3, 0]) tank(radius=1.4, height=4);
    translate([8, 12.3, 0]) tank(radius=1.4, height=4);
    translate([11, 12.3, 0]) tank(radius=1.4, height=4);

    // horizontal reactors
    translate([15, 12, 1.0]) horizontal_reactor(radius=1.4, length=10, head="flat");
    

    // pump skid and control block (make a bit thicker)
    translate([3.5, 1.5, 0]) cube([2.2,1.4,1.0]);
    translate([14, 2, 0]) cube([2,1.2,1.0]);

    // main pipe rack along Y direction - thicker pipes (previously 0.12 OD)
    for (k=[0:5]) {
        px = 4 + k*1.6;
        translate([px, 0.5, 2.2])
            rotate([90,0,0]) cylinder(h=room_y-1.0, r=thin_pipe_od/2, center=false);
    }

    // cross-connect pipes between columns (now thicker)
    for (k=[0:4]) {
        py = 3 + k*2.2;
        translate([2, py, 3.0])
            rotate([0,90,0]) cylinder(h=room_x-4, r=cross_pipe_od/2, center=false);
    }

    // vertical risers near reactors - thicker
    for (i=[0:3]) {
        tx = x0 + i*gapx;
        translate([tx, y0-1.0, 0]) cylinder(h=room_z, r=vertical_riser_od/2);
    }

    // small branch pipes near horizontal reactors (short runs) - slightly larger
    for (i=[0:3]) {
        translate([16 + i*1.5, 6, 3.0])
            rotate([90,0,0]) cylinder(h=4, r=branch_pipe_od/2);
    }

    // long vent pipe toward ceiling - thicker
    translate([22, 2, 0]) cylinder(h=room_z, r=vent_pipe_od/2);

    // supports: make them thicker and fewer to avoid tiny supports
    for (i=[0:4]) {
        translate([2+i*6, 2, 0]) cube([support_size, support_size, 0.8]);
    }
}

// ---------- FINAL FLUID DOMAIN: ROOM MINUS EQUIPMENT ----------
difference() {
    // outer room solid (we will subtract equipment to produce fluid domain)
    translate([0,0,0]) cube([room_x, room_y, room_z]);

    // subtract the equipment (creates cutouts inside the room)
    translate([0,0,0]) equipment_layout();

    // leak hole in left wall (make hole a bit larger than tiny)
    // place it at x=0 wall, center height and mid-width
    translate([-0.01, room_y/2, room_z/2]) rotate([0,90,0]) cylinder(h=0.8, r=max(min_feature/2, 0.06), center=true);
}