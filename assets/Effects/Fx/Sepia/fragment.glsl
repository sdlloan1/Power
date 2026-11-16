#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;
varying vec2 v_texCoords;

uniform vec4 u_FgndColor;
uniform int u_Degree;
int maxDegree = 255;

void main() {
	vec4 f4IntensityConvert = vec4(0.257, 0.504, 0.098, 0.0);

	vec4 f4Pixel = texture2D(u_texture0, v_texCoords);

	float fIntensity = dot(f4Pixel, f4IntensityConvert);
	vec4 f4Film = ( u_FgndColor + fIntensity ) / 2.0;

	float weight = float(u_Degree)/float(maxDegree);
	vec4 f4Result = f4Pixel + ( f4Film - f4Pixel ) * weight;

	gl_FragColor = vec4(f4Result.rgb, f4Pixel.a);
}