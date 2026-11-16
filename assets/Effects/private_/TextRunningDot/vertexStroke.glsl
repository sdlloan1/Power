
attribute vec2 a_position;
attribute vec3 a_transform;
attribute vec2 a_texCoords;

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform float u_Thickness;
uniform float u_Progress;

varying vec2 v_texCoords;
varying float v_Fade;

void main()
{
    vec2 v2Pos = a_position * u_Thickness;

	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * vec4(v2Pos + a_transform.xy, 0.0, 1.0);

	v_texCoords = a_texCoords;

	v_Fade = 1.0 -  mod(a_transform.z + u_Progress, 1.0);
}