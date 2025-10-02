include <../lib/fn.scad>;
$fa=1;$fs=1;

rot=smoothstep(0,.5,$t)*-180;
print=smoothstep(.5,.9,$t);

d=50;n=5;
roller_arc_ratio=.55;
//roller_r_min=1.8;
//roller_r_max=(1-sin(90-180/n*roller_arc_ratio))*d/2+roller_r_min;
roller_r_max=6.5/2;
roller_r_min=roller_r_max-(1-sin(90-180/n*roller_arc_ratio))*d/2;
roller_h=sin(180/n*roller_arc_ratio)*d;
roller_shaft_r=.8/2;

echo("min",roller_r_min);

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

//motor();

module ngon(n=3,ri=1){
	r=ri/cos(180/n);
	polygon([
		for(i=[0:n-1])let(t=i/n*360)[cos(t)*r,sin(t)*r]
	]);
}
module r2d(dr=0,dh=0,shaft=roller_shaft_r){
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
module roller(dr=0){
	translate([0,0,mix(0,roller_h/2,print)])
	rotate([mix(90,0,print),0,0])
	rotate_extrude()r2d(dr);
}

module plate(){intersection(){
	difference(){
		circle(d=d-2);
		for(i=[1:n]){
			rotate(360*i/n)translate([d/2-roller_r_max,0])r2d2(3,.5);
		}
	}
	rotate(180/n)ngon(n,d/2-roller_r_max-roller_shaft_r);
}}



rotate([0,0,rot]){

// wheel plate
translate([mix(0,d/2,print),mix(0,-d/2,print),mix(roller_r_max-roller_r_min,0,print)])linear_extrude(roller_r_min*2)plate();
translate([mix(0,d/2*3,print),mix(0,-d/2,print),mix(-roller_r_max-roller_r_min,0,print)])linear_extrude(roller_r_min*2)rotate(180/n)plate();


// sub wheel
for(i=[1:n]){
	rotate(mix(360*i/n,0,print))translate([
		mix(d/2-roller_r_max,(i-.5)*roller_r_max*3,print),
	mix(0,roller_r_max*1,print),
	mix(roller_r_max,0,print)
	]){roller();%roller(1);}
	rotate(mix(360*(i+.5)/n,0,print))translate([
		mix(d/2-roller_r_max,(i-.5)*roller_r_max*3,print),
		mix(0,roller_r_max*4,print),
		mix(-roller_r_max,0,print)
	]){roller();%roller(1);}
}

}