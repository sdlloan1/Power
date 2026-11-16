attribute vec3 a_position;

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform mat4 u_RevMatrix;

varying vec4 v_Color;

void main()
{
	gl_Position = u_PMatrix * u_VMatrix * u_RevMatrix * u_MMatrix * vec4(a_position, 1.0);
	float RB = (a_position.y + 1.0) * 0.5;
	v_Color = vec4(RB, 1.0, RB, 1.0);
}