attribute vec4 a_position;
attribute vec2 a_texCoords;
uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;

uniform float u_ViewRatio;

uniform float u_ScaleX;
uniform float u_ScaleY;
uniform float u_TransX;
uniform float u_TransY;
uniform float u_Rotate;

varying vec2 v_texCoords;
varying vec2 v_maskCoords;

void main()
{
	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * a_position;
	v_maskCoords = a_texCoords;
	v_texCoords = a_texCoords;

    v_texCoords.x = ((v_texCoords.x - 0.5) / u_ScaleX) + 0.5;
    v_texCoords.y = ((v_texCoords.y - 0.5) / u_ScaleY) + 0.5;

    if(u_Rotate != 0.0)
    {
        float fX = (v_texCoords.x - 0.5) * u_ViewRatio;
        float fY = 0.5 - v_texCoords.y;
        v_texCoords.x = 0.5 + (fX * cos(u_Rotate) - fY * sin(u_Rotate)) / u_ViewRatio;
        v_texCoords.y = 0.5 - fX * sin(u_Rotate) - fY * cos(u_Rotate);
    }

    v_texCoords.x = v_texCoords.x + u_TransX;
    v_texCoords.y = v_texCoords.y + u_TransY;
}