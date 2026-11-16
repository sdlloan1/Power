attribute vec4 a_position;
attribute vec2 a_texCoords;
attribute float a_Threshold;

uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;

varying vec2 v_texCoords;
varying float v_Threshold;

void main()
{
	gl_Position = u_PMatrix * u_VMatrix * a_position;
	v_texCoords = a_texCoords;
	v_Threshold = a_Threshold;
}