$fs=.5;
$fa=2;
d=0.2;

a=2.54;
w=5.8+d;
h=12.8+d;
depth=6.5;
pinh=0.75;
hgap=a*3-w;
vgap=a*6-h;

linear_extrude(depth){
	difference(){
		union(){
			translate([-w/2,-vgap/2])square([w,vgap]);
			translate([-hgap-w/2,-(h/2)])square([hgap,h]);
			translate([w/2,-(h/2)])square([hgap,h]);
		}
		for(i=[0:3])translate([(1<i?-1:1)*w/2,(i%2?-1:1)*vgap/2])circle(d=.8);
	}
}

translate([20,0,0])difference(){
	union(){
		translate([0,0,6])union(){
			cube([18,6,12],center=true);
			cube([6,18,12],center=true);
		}
		cylinder(d=15);
	}
	translate([0,0,-.01])cylinder(d=2+d,h=1.01);
	translate([0,0,54])sphere(r=50);
}

translate([0,20,0])cylinder(d=2,h=1+pinh-d);