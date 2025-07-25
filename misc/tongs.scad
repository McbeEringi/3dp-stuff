use <../lib/arc.scad>;
$fa=1;$fs=1;

width=10;
thick=3;
length=150;

dist=10;
theta=15;
h_thick=1;
inner_theta_p=.8;

tooth=5;
phi=45;
tooth_n=5;

module bone(t=thick){
	rotate([-90,0,0])scale([1,1,sign(t)])linear_extrude(abs(t)){
		translate([0,-width/2])square([length-width,width]);
		translate([length-width,0])circle(width/2);
	}
}

module half(){
	rotate([0,0,theta/2])translate([0,dist,0]){
		bone();
		intersection(){
			bone(-dist);
			translate([length-width,0,0])rotate([0,phi,0])for(i=[0:tooth_n-1])translate([-i*tooth,0,0])rotate([0,0,45])cube([tooth*sqrt(2)/2,tooth*sqrt(2)/2,100],center=true);
		}
		intersection(){
			bone(thick+tooth);
			translate([length/2,0,0])rotate([0,phi,0])for(i=[0:tooth_n-1])translate([-i*tooth,thick,0])rotate([0,0,45])cylinder(d=tooth/2,h=100,center=true);
		}
	}
}
module hinge(){
	translate([0,0,-width/2])linear_extrude(width){
		//rotate(90+theta/2)arc(dist+h_thick/2,h_thick,180-theta);
		translate([-sin(theta/2)*dist,-cos(theta/2)*(dist+h_thick/2),0])rotate(90){
			$fs=h_thick*.2;
			darc(dist*cos(theta/2)*2+h_thick,h_thick,(180-theta)*inner_theta_p);
			circle(d=h_thick);
			translate([dist*cos(theta/2)*2+h_thick,0])circle(d=h_thick);
		}
		rotate(90+theta/2)arc(dist+thick-h_thick/2,h_thick,180-theta);
	}
}


half();scale([1,-1,1])half();
hinge();