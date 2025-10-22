// author: Jonas Boye & Chat-GPT
// License: MIT
#ifdef GL_ES
precision highp float;
#endif

// DO NOT redeclare: from, to, progress, resolution, uv

float random(vec2 p){
	return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 p){
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f*f*(3.0 - 2.0*f);
	return mix(
		mix(random(i), random(i + vec2(1.0,0.0)), f.x),
		mix(random(i + vec2(0.0,1.0)), random(i + vec2(1.0,1.0)), f.x),
		f.y
	);
}

float fbm(vec2 p){
	float v = 0.0;
	float a = 0.5;
	for (int i = 0; i < 6; i++){
		v += a * noise(p);
		p *= 2.0;
		a *= 0.5;
	}
	return v;
}

vec4 transition(vec2 uv){
	float brush = fbm(uv * vec2(15.0, 12.0));
	float offset = 0.25 * (brush - 0.5);

  float edge = progress - (uv.x - offset * 0.5);
	float mask = smoothstep(-0.015, 0.015, edge);

	// enforce validator rules
	if (progress <= 0.0) mask = 0.0;
	if (progress >= 1.0) mask = 1.0;

	return mix(
		getFromColor(uv),
		getToColor(uv),
		mask
	);
}
