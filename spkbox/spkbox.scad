r=7.5/2;
a=2.8;
f0=130;

thick=.5;
dx=15;
dy=15;
dz=20;
duct_rate=.5;

idx=dx-thick*2;
idy=dy-thick*2;
idz=dz-thick*2;
V=idx*idy*idz/1000;
rd=a/sqrt(1/duct_rate);
l=(30000*rd*rd*PI)/(f0*f0*V)-1.5*rd;
L=3.125*a;


echo(V);

difference(){
	translate([0,-thick/2*10,0])cube([dx*10,(dy-thick)*10,dz*10],center=true);
	union(){
		difference(){
			union(){
				cube([idx*10,idy*10,idz*10],center=true);
				translate([0,-idy*10/2, L*10/2])rotate([90,0,0]){
					cylinder(r=r*10,h=thick*10);
					for(i=[0:3])rotate([0,0,i*90+45])translate([42,0,0])cylinder(d=4.5,h=thick*10);
				}
			}
			translate([0,-idy*10/2-.01,-L*10/2])rotate([90,0,180])cylinder(r=(rd+thick)*10,h=l*10);
		}
		translate([0,-idy*10/2-thick*10,-L*10/2])rotate([90,0,180])cylinder(r=rd*10,h=(l+thick)*10);
	}
}

translate([0,dy*10,0])cube([dx*10,thick*10,dz*10],center=true);