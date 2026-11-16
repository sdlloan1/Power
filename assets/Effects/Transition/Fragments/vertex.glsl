attribute vec4 a_position;
attribute vec2 a_texCoords;
uniform float u_Flip;
uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
varying vec2 v_texCoords;
void main()
{
	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * (a_position * vec4(1.0, u_Flip, 1.0, 1.0));
	v_texCoords = a_texCoords;
}