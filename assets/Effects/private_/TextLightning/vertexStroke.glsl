
attribute vec4 a_position;
attribute vec4 a_Offset;
attribute vec2 a_texCoords;
attribute float a_Progress;

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform float u_Thickness;
uniform float u_Progress;

varying vec2 v_texCoords;
varying float v_Fade;

void main()
{
    vec4 v4Pos = a_position * a_Offset.z * u_Thickness;

	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * vec4(v4Pos.xy + a_Offset.xy, 0.0, 1.0);

	v_texCoords = a_texCoords + vec2(a_Offset.w, 0.0);
	v_Fade = clamp(1.0 - (u_Progress - a_Progress) * 1.5, 0.0, 1.0);
}