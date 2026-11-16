attribute vec4 a_position;
attribute vec2 a_texCoords;
uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform float u_fMaskRatioX;
uniform float u_fMaskRatioY;
varying vec2 v_texCoords;
varying vec2 v_maskCoords;

void main()
{
	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * a_position;
	v_texCoords = a_texCoords;
	v_maskCoords = (a_texCoords - vec2(0.5, 0.5)) * vec2(u_fMaskRatioX, u_fMaskRatioY) + vec2(0.5, 0.5);
}