attribute vec4 a_pos;

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;

varying vec2 v_texCoords;

void main()
{
	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * vec4(a_pos.xy, 0.0, 1.0);
	v_texCoords = a_pos.zw;
}