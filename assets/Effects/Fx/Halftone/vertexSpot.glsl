attribute vec2 a_position;
attribute vec2 a_texCoords;
attribute vec2 a_Center;

uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform float u_Flip;

varying vec2 v_texCoords;
varying vec2 v_Center;

void main()
{
	gl_Position = u_PMatrix * u_VMatrix * vec4(a_position.x, a_position.y * u_Flip , 0.0, 1.0);
	v_texCoords = a_texCoords;
	v_Center = a_Center;
}