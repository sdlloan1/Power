attribute vec4 a_position;
attribute vec2 a_texCoords;
uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;

uniform float u_CenterOffsetX;
uniform float u_CenterOffsetY1;
uniform float u_CenterOffsetY2;
uniform vec2 u_MaskScale;

varying vec2 v_texCoords;
varying vec2 v_MaskCoords1;
varying vec2 v_MaskCoords2;

void main()
{
	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * a_position;
	v_texCoords = a_texCoords;

    v_MaskCoords1 = ((a_texCoords - vec2(0.5, 0.5)) * u_MaskScale + vec2(0.5, 0.5)) + vec2(u_CenterOffsetX, u_CenterOffsetY1);
    v_MaskCoords2 = ((a_texCoords - vec2(0.5, 0.5)) * u_MaskScale + vec2(0.5, 0.5)) + vec2(u_CenterOffsetX, u_CenterOffsetY2);
}