PI=3.1415;

cover=1;

ds=2.5;// shaft diamiter
at=60;// blade arc theta
n=6;// num blade
b=1;// thicknss
th=10;// corn section height
ch=5;// cylinder section height
r1=25;// bottom radius
r2=10;// top radius
tw=60;// twist
sbr=.5;// sub blade ratio

module arc(r,b,t){
	a=(r+b)*2;
	rot=function(t)[cos(t)*a,sin(t)*a];
	intersection(){
		difference(){circle(r+b);circle(r);}
		polygon([
			for(i=[0:floor(t/120)])rot(120*i),
			rot(t),[0,0]
		]);
	}
}

module darc(d,b,t){
	r=sqrt(d*d/(2*(1-cos(t))));
	translate([d,0])rotate((180-t)/2)translate([-r,0])arc(r,b,t);
}

bb=b/sin(atan((th+ch)/(r1*2*PI/360*tw)));// blade thickness

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
					linear_extrude(th+ch,twist=-tw)for(i=[1:n])rotate(i/n*360)darc(d=r1,b=bb,t=at);
					linear_extrude((th+ch)*sbr,twist=-tw*sbr)for(i=[1:n])rotate((i+.5)/n*360)darc(d=r1,b=bb,t=at);
					if(cover)translate([0,0,ch-b])difference(){// cover
						cylinder(h=th+b,r=r1);
						cylinder(th+b,r1,r1-(r1-r2)/th*(th+b));
					}
				}
			}
			cylinder(th,r1,0);// inner
		}
	}
	cylinder(d=ds,h=th+ch+b,$fa=1,$fs=.5);// shaft
}