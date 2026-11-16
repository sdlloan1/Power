attribute vec4 a_position;
attribute vec2 a_texCoords;
uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;

uniform vec2 u_texRatio;
uniform vec2 u_texCenter;

varying vec2 v_texCoords;
void main()
{
	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * a_position;
	v_texCoords = (a_texCoords - u_texCenter) * u_texRatio + u_texCenter;
}