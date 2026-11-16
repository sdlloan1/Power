attribute vec4 a_position;
attribute vec2 a_texCoords;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform float u_OffsetX;
uniform float u_OffsetY;
varying vec2 v_texCoords;

void main()
{
	gl_Position = u_PMatrix * u_VMatrix * (a_position + vec4(u_OffsetX, u_OffsetY, 0.0, 0.0));
	v_texCoords = a_texCoords;
}