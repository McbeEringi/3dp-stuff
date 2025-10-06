include <../lib/fn.scad>;
$fa=1;$fs=1;

d=50;n=5;
roller_arc_ratio=.52;
roller_r_max=10/2;
roller_shaft_r=1.75/2;// d=0.6mm Tin Copper Wire
roller_shaft_r_asobi=.2;
plate2floor=.5;


rot=smoothstep(0,.9,$t)*-360;
print=1;//smoothstep(.3,.9,$t);

roller_r_min=roller_r_max-(1-sin(90-180/n*roller_arc_ratio))*d/2;
roller_h=sin(180/n*roller_arc_ratio)*d;
echo(min=roller_r_min);
//assert(roller_r_max*.55<=roller_r_min);

module shaft(l=4){
	linear_extrude(l)intersection(){
		circle(d=3,$fn=32);
		translate([.5,0])square([3,3],center=true);
	}
}
module motor(){
	shaft();
	translate([0,0,-1])cylinder(d=4,h=1);
	translate([-6,-5,-25.25])cube([12,10,24.25]);
}

%motor();


module r2d(dr=0,dh=0,shaft=roller_shaft_r+roller_shaft_r_asobi){
	l=4;
	_d=d+dr;
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
			rotate(360*(i+.5)/n)translate([d/2-roller_r_max,0])r2d2(3,.5);
		}
	}
}}
module plate(){
	difference(){
		union(){
			linear_extrude(roller_r_min+roller_shaft_r/2)p2d(0);
			linear_extrude(roller_r_min+roller_r_max)circle(r=d/4);
		}
		linear_extrude(roller_r_min+roller_r_max)circle(r=d/6);
		translate([0,0,roller_r_min])for(i=[0:n-1])rotate(360*(i+.5)/n)translate([d/2-roller_r_max,0,0])rotate([90,0,0])cylinder(r=roller_shaft_r,h=d/2,center=true,$fn=16);
	}
}

module half(){
	translate([0,0,mix(-roller_r_max,0,print)]){
		// plate
		translate([mix(0,d/2,print),mix(0,d/2+roller_r_max*2,print),mix(-roller_r_min,0,print)])plate();

		//roller
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
module main(){
	rotate(rot){
		half();
		translate([0,mix(0,d+roller_r_max*2,print),0])rotate([mix(180,0,print),0,mix(180/n,0,print)])half();
	}
}

main();

translate([mix(0,-d/2,print),0,mix(-roller_r_min-roller_r_max,0,print)])linear_extrude((roller_r_min+roller_r_max)*2)difference(){
	circle(r=d/6);
	circle(r=d/6-5);
	translate([-1/2,0])square([1,d]);
}
