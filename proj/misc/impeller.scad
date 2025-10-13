include <lib/arc.scad>;
$fa=.5;
PI=3.1415;

cover=1;
b=1;// thicknss

ds=2.5;// shaft diamiter
hs=10;// shaft length

n=8;// num blade
at=30;// blade arc theta

th=20;// corn section height
ch=10;// cylinder section height
r2=15;// top radius
r1=40;// bottom radius

tw=0;// twist


bb=b/sin(atan((th+ch)/(r1*2*PI/360*tw)));// blade thickness
//darc(d=10,b=1,t=60);

difference(){
	union(){
		linear_extrude(b)circle(r1);// base
		translate([0,0,b]){
			intersection(){
				union(){// shape
					cylinder(h=ch,r=r1);
					translate([0,0,ch])cylinder(th,r1,r2);
				}
				union(){// blades
					linear_extrude(th+ch,twist=-tw)for(i=[1:n])rotate(i/n*360)difference(){
						darc(d=r1,b=bb,t=at);
						circle(r2);
					}
					linear_extrude(th+ch,twist=-tw)for(i=[1:n])rotate((i+.5)/n*360)difference(){
						darc(d=r1,b=bb,t=at);
						circle(r2+(r1-r2)/2);
					}
					if(cover)translate([0,0,ch-b])difference(){// cover
						cylinder(h=th+b,r=r1);
						cylinder(th+b,r1,r1-(r1-r2)/th*(th+b));
						cylinder(h=th+b,r=r2);
					}
				}
			}
			cylinder(th,r1,0);// inner
		}
	}
	cylinder(th-b,r1-b*2,0);// inner
}
difference(){// shaft
	cylinder(h=max(hs,th-b),r=4);
	cylinder(d=ds,h=hs,$fa=1,$fs=.5);
}