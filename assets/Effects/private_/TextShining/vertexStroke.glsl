
attribute vec2 a_position;
attribute vec2 a_Offset;
attribute vec2 a_texCoords;

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform float u_Thickness;

varying vec2 v_texCoords;

void main()
{
	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * vec4(a_position * u_Thickness + a_Offset, 0.0, 1.0);

	v_texCoords = a_texCoords;
}