attribute vec4 a_position;
attribute vec2 a_texCoords;
uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform float u_Offset;
varying vec2 v_texCoords;

void main()
{
	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * (a_position + vec4(0.0, u_Offset, 0.0, 0.0));
	v_texCoords = a_texCoords;
}