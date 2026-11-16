
attribute vec2 a_position;
attribute vec4 a_transform;
attribute float a_light;
attribute vec2 a_texCoords;

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform float u_Thickness;

varying vec2 v_texCoords;
varying float v_Fade;

void main()
{
    vec2 v2Pos = a_position * a_transform.z * u_Thickness;
    vec2 v2PosRotate = vec2(v2Pos.x * cos(a_transform.w) - v2Pos.y * sin(a_transform.w), v2Pos.x * sin(a_transform.w) + v2Pos.y * cos(a_transform.w));

	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * vec4(v2PosRotate + a_transform.xy, 0.0, 1.0);

	v_texCoords = a_texCoords;

	v_Fade = a_light;
}