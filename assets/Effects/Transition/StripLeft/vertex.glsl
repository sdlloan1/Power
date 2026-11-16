
attribute vec4 a_position;
attribute vec2 a_texCoords;

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform mat4 u_RevYMatrix;

varying vec2 v_texCoords;

void main()
{
	gl_Position = u_PMatrix * u_VMatrix * u_RevYMatrix * u_MMatrix * a_position;
	v_texCoords = a_texCoords;
}
