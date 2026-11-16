#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;

uniform vec2 u_AspectRatio;
uniform float u_SpinAngle;
uniform float u_SpiralAngle;

varying vec2 v_texCoords;

void main() {

	vec2 v2CoordShift = (v_texCoords - vec2(0.5)) * u_AspectRatio;

	float fSpiralAngle = u_SpiralAngle * (sin(length(v2CoordShift) / length(u_AspectRatio) * 5.0 - 1.5707963268) + 1.0) * 0.5;

	vec2 v2Rotate = vec2(sin(u_SpinAngle + fSpiralAngle), cos(u_SpinAngle + fSpiralAngle));
	vec2 v2CoordRotate = vec2(v2CoordShift.x * v2Rotate.y - v2CoordShift.y * v2Rotate.x, v2CoordShift.x * v2Rotate.x + v2CoordShift.y * v2Rotate.y);
	vec2 v2Coord = v2CoordRotate / u_AspectRatio + vec2(0.5);

	gl_FragColor = texture2D(u_texture0, v2Coord);
}