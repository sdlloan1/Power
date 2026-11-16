
attribute vec4 a_position;
attribute vec4 a_Offset;
attribute vec2 a_texCoords;

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform float u_Thickness;
uniform float u_ProgressOffset;
uniform vec2 u_HueRange;

varying vec2 v_texCoords;
varying vec4 v_Colors;

void main()
{
    vec4 v4Pos = a_position * a_Offset.z * u_Thickness;

	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * vec4(v4Pos.xy + a_Offset.xy, 0.0, 1.0);

    float fHue;
    float fProgress = mod(a_Offset.w * 2.0 + u_ProgressOffset, 1.0);
    if(fProgress < 0.5)
        fHue = fProgress * 2.0 * (u_HueRange.y - u_HueRange.x) + u_HueRange.x;
    else
        fHue = (fProgress - 0.5) * 2.0 * (u_HueRange.x - u_HueRange.y) + u_HueRange.y;

    float fChroma = 0.9;
    float fX = fChroma * (1.0 - abs(mod(fHue, 2.0) - 1.0));

    vec4 v4RGB;
	if(fHue < 1.0)
	    v4RGB = vec4(fChroma, fX, 0.0, 1.0);
	else if(fHue < 2.0)
	    v4RGB = vec4(fX, fChroma, 0.0, 1.0);
	else if(fHue < 3.0)
	    v4RGB = vec4(0.0, fChroma, fX, 1.0);
	else if(fHue < 4.0)
	    v4RGB = vec4(0.0, fX, fChroma, 1.0);
	else if(fHue < 5.0)
	    v4RGB = vec4(fX, 0.0, fChroma, 1.0);
	else
	    v4RGB = vec4(fChroma, 0.0, fX, 1.0);

//    float fm = fLuminance - dot(v4RGB, vec4(0.299, 0.587, 0.114, 0.0));
    float fm = 0.5 - dot(v4RGB, vec4(0.299, 0.587, 0.114, 0.0));
    v4RGB += vec4(fm, fm, fm, 0.0);
    v4RGB = clamp(v4RGB, 0.0, 1.0);

	v_Colors = v4RGB;

	v_texCoords = a_texCoords;
}