// from glsl
clamp=function(x,a,b)min(max(x,a),b);
saturate=function(x)clamp(x,0,1);
mix=function(a,b,x)a*(1-x)+b*x;
smoothstep=function(a,b,x)let(x=saturate((x-a)/(b-a)))x*x*(3-2*x);

// rad deg conv
r2d=function(x)x/PI*180;
d2r=function(x)x*PI/180;
// rad fn
_sin=function(x)sin(r2d(x));
_cos=function(x)cos(r2d(x));
_tan=function(x)tan(r2d(x));
_atan=function(x)d2r(atan(x));

rot=function(p,t)let(s=_sin(t),c=_cos(t))[c*p.x-s*p.y,s*p.x+c*p.y];

module skew(xy=0,xz=0,yx=0,yz=0,zx=0,zy=0){
	matrix=[
		[1,tan(xy),tan(xz),0],
		[tan(yx),1,tan(yz),0],
		[tan(zx),tan(zy),1,0],
		[0,0,0,1]
	];
	multmatrix(matrix)
	children();
}