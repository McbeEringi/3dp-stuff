include <../lib/fn.scad>;
//$fa=1;$fs=1;

print=smoothstep(.1,.9,$t*2-.5);

d=50;n=5;
roller_arc_ratio=.55;
//roller_r_min=1.8;
//roller_r_max=(1-sin(90-180/n*roller_arc_ratio))*d/2+roller_r_min;
roller_r_max=6.5/2;
roller_h=sin(180/n*roller_arc_ratio)*d;
roller_shaft_r=.7/2;

echo("min",roller_r_max-(1-sin(90-180/n*roller_arc_ratio))*d/2);

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
//arc(25,1,60);

module r2d(dr=0,dh=0){
	intersection(){
		translate([roller_r_max-d/2,0])circle(d=d+dr*2);
		translate([roller_shaft_r,-roller_h/2-dh])square([roller_r_max-roller_shaft_r+dr*2,roller_h+dh*2]);
	}
}
module r2d2(dr=0,dh=0){
	intersection(){
		translate([ (roller_r_max-d/2),0])circle(d=d+dr*2);
		translate([-(roller_r_max-d/2),0])circle(d=d+dr*2);
		square([(roller_r_max+dr*2)*2,roller_h+dh*2],center=true);
	}
}
module roller(dr=0){
	translate([0,0,mix(0,roller_h/2,print)])
	rotate([mix(90,0,print),0,0])
	rotate_extrude()r2d(dr);
}
//roller();


difference(){
	circle(d=d);
	for(i=[1:n]){
		rotate(360*i/n)translate([d/2-roller_r_max,0])r2d2(2,.5);
	}
}

/*
for(i=[1:n]){
	translate([mix(0,(i-.5)*roller_r_max*3,print),0,0]){
		rotate(360*i/n)
		translate([mix(d/2-roller_r_max,0,print),0,0]){roller();%roller(1);}
		rotate(360*(i+.5)/n)
		translate([mix(d/2-roller_r_max,0,print),mix(0,roller_r_max*3,print),mix(roller_r_max*2,0,print)]){roller();%roller(1);}
	}
}
*/

