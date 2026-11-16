attribute vec4 a_position;
attribute vec2 a_texCoords;
attribute vec2 a_texDisCoords;

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;

varying vec2 v_texDisCoords;
varying vec2 v_texCoords;

void main()
{
	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * a_position;
	v_texCoords = a_texCoords;
	v_texDisCoords = a_texDisCoords;
}