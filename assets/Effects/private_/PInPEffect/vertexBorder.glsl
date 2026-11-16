
attribute vec4 a_position;
attribute vec2 a_texCoords;
attribute vec3 a_borderPos;

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform float u_BorderSize;

varying vec2 v_texCoords;
varying float v_borderVal;

void main()
{
    vec4 v4Pos = vec4(a_position.xy * u_BorderSize + a_borderPos.xy, 0.0, 1.0);

	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * v4Pos;

	v_texCoords = a_texCoords;
	v_borderVal = a_borderPos.z;
}