attribute vec4 a_position;
attribute vec2 a_texCoords;
uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;

uniform int u_MaskRotate;
uniform vec2 u_MaskScale;

varying vec2 v_texCoords;
varying vec2 v_maskCoords;

void main()
{
	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * a_position;
	v_texCoords = a_texCoords;

    vec2 v2Coord = (a_texCoords - vec2(0.5)) * u_MaskScale;

    if(u_MaskRotate > 0)
        v2Coord = vec2(v2Coord.y, -v2Coord.x);

    v_maskCoords = v2Coord + vec2(0.5);

}