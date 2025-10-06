include <../lib/fn.scad>;
$fa=1;$fs=1;

d=50;n=5;
roller_arc_ratio=.55;
roller_r_max=10.5/2;
roller_shaft_r=1.75/2;// d=1.75mm filament
roller_shaft_r_asobi=.3;
plate2floor=1.2;
roller_gap_x=1.5;
roller_gap_y=.2;
shaft_snap_l=2;

hub_d_out=20;
hub_d_in=17;
hub_gap=.5;
hub_key=2;
hub_key_asobi=.2;
hub_spoke=1;


rot=smoothstep(0,.9,$t)*-360;
print=smoothstep(.3,.9,$t);

roller_r_min=roller_r_max-(1-sin(90-180/n*roller_arc_ratio))*d/2;
roller_h=sin(180/n*roller_arc_ratio)*d;
echo(min=roller_r_min);
//assert(roller_r_max*.55<=roller_r_min);

module shaft2d(){
	intersection(){
		circle(d=3,$fn=32);
		translate([.5,0])square([3,3],center=true);
	}
}
module motor(){
	linear_extrude(4)shaft2d();
	scale(-1){
		linear_extrude(1)circle(d=4);
		translate([0,0,1])linear_extrude(24.25)square([12,10],center=true);
	}
}

%motor();


module r2d(dr=0,dh=0,shaft=roller_shaft_r+roller_shaft_r_asobi){
	l=4;
	_d=d+dr*2;
	ta=asin((roller_h+dh*2)/_d);
	polygon([
		[shaft,sin(ta)*-_d/2],
		for(i=[-l:l])let(t=i/l*ta)[cos(t)*_d/2-d/2+roller_r_max,sin(t)*_d/2],
		[shaft,sin(ta)*_d/2]
	]);
}
module r2d2(dr=0,dh=0){r2d(dr,dh,-.01);scale(-1)r2d(dr,dh,0);}
module roller(){
	translate([0,0,mix(0,roller_h/2,print)])
	rotate([mix(90,0,print),0,0]){
		rotate_extrude()r2d();
		%rotate_extrude()r2d(1);
	}
}

module p2d(wire){intersection(){
	difference(){
		circle(r=d/2-plate2floor);
		for(i=[0:n-1]){
			rotate(360*(i+.5)/n)translate([d/2-roller_r_max,0])r2d2(roller_gap_x,roller_gap_y);
		}
	}
}}
module plate(key){
	difference(){
		union(){
			linear_extrude(roller_r_min+roller_shaft_r/sqrt(2))p2d(0);
			linear_extrude(roller_r_min+roller_r_max)circle(r=d/2-roller_r_max*2-roller_gap_x);
		}
		// hub key
		translate([0,0,-.01/2])linear_extrude(roller_r_min+roller_r_max+.01){
			circle(d=hub_d_out);
			rotate(180/n*key)translate([-(hub_d_out/2+hub_key/2),0])square(hub_key+hub_key_asobi*2,center=true);
		}
		// shaft
		translate([0,0,roller_r_min])for(i=[0:n-1])
			rotate(360*(i+.5)/n)translate([d/2-roller_r_max,0,0])
				rotate([90,0,0])cylinder(r=roller_shaft_r,h=roller_h+(roller_gap_y+shaft_snap_l)*2,center=true,$fn=16);
	}
}

module half(key){
	translate([0,0,mix(-roller_r_max,0,print)]){
		// plate
		translate([mix(0,d/2,print),mix(0,d/2+roller_r_max*2,print),mix(-roller_r_min,0,print)])plate(key);

		// roller
		for(i=[0:n-1]){
			i=i+.5;
			rotate(mix(360*i/n,0,print))translate([
				mix(d/2-roller_r_max,i*roller_r_max*3,print),
				mix(0,roller_r_max*1,print),
				0
			])roller();
		}

	}
}

module hub(){
	rotate([mix(0,180,print),0,0])translate([mix(0,-d/2,print),0,(roller_r_min+roller_r_max)*mix(-1,-2,print)]){
		linear_extrude((roller_r_min+roller_r_max)*2)difference(){
			union(){
				circle(d=hub_d_out);
				translate([-hub_d_out/2,0])square([hub_key*2,hub_key],center=true);
			}
			circle(d=hub_d_in);
			translate([hub_d_in/2-1,-hub_gap/2])square([2+(hub_d_out-hub_d_in)/2,hub_gap]);
		}
		translate([0,0,roller_r_min+roller_r_max])linear_extrude(roller_r_min+roller_r_max)difference(){
			union(){
				circle(3);
				for(i=[0:n-1])rotate(360*(i+.5)/n)translate([0,-hub_spoke/2])square([hub_d_in/2,hub_spoke]);
			}
			shaft2d();
			translate([0,-hub_gap/2])square([3,hub_gap]);
		}
	}
}


module main(){
	rotate(rot){
		half(0);
		translate([0,mix(0,d+roller_r_max*2,print),0])
			rotate([mix(180,0,print),0,mix(180/n,0,print)])half(1);
		hub();
	}
}

main();
