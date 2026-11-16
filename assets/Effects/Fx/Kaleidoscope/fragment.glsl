#ifndef HAS_OFFSCREEN_TEXTURE
	#ifdef INPUT_IS_OES_TEXTURE
	#extension GL_OES_EGL_image_external : require
		uniform samplerExternalOES u_texture0;
	#else
		uniform sampler2D u_texture0;
	#endif
#else
uniform sampler2D u_texture0;
#endif

precision highp float;
varying vec2 v_texCoords;

uniform float u_resizeY;
uniform float u_resizeX;

uniform float u_angle;
uniform float u_offsetX;
uniform float u_offsetY;
uniform int u_segment;

const float PI = 3.141592658;

void main(void){
	vec2 pos = (v_texCoords - 0.5);
  
	pos.x /= u_resizeX;
	pos.y /= u_resizeY;

	float rad = length(pos);
	float angle = atan(pos.y, pos.x) + (u_angle) * PI / 180.0;
	  
	angle = mod(angle, PI * 2.0);
  
	float fArcWidth = PI / float(u_segment);
	float fMulti = ceil(angle / fArcWidth) - 1.0;
	
	angle = angle - fArcWidth * fMulti;
	
	if(mod(fMulti, 2.0) == 1.0) {
		angle = abs(angle - PI / float(u_segment));
	}
  
	float x = cos(angle) * rad * u_resizeX;
	float y = sin(angle) * rad * u_resizeY;
	
	vec2 result = vec2(x + u_offsetX/100.0, y + u_offsetY/100.0);
	result.x = mod(result.x, 1.0);
	result.y = mod(result.y, 1.0);

	gl_FragColor = texture2D(u_texture0, result);
}