
uniform sampler2D u_textureSrc;

precision mediump float;

uniform float u_HueOffset;

varying vec2 v_texCoords;

vec4 hcl_To_RGB(float fHue, float fChroma, float fLuminance)
{
	if(fChroma < 0.001)
    	return vec4(fLuminance, fLuminance, fLuminance, 1.0);

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

    float fm = fLuminance - dot(v4RGB, vec4(0.299, 0.587, 0.114, 0.0));
    v4RGB += vec4(fm, fm, fm, 0.0);
    v4RGB = max(vec4(0.0, 0.0, 0.0, 0.0), min(vec4(1.0, 1.0, 1.0, 1.0), v4RGB));

	return v4RGB;
}

void main(void)
{
    vec4 v4Src = texture2D(u_textureSrc, v_texCoords);

    float fLuminance = dot(v4Src, vec4(0.299, 0.587, 0.114, 0.0));

    float fMax = max(max(v4Src.r, v4Src.g), v4Src.b);
    float fMin = min(min(v4Src.r, v4Src.g), v4Src.b);
    float fChroma = fMax - fMin;
    if(fChroma < 0.001)
        fChroma = 0.0;

    float fHue = -1.0;
    if(fChroma != 0.0)
    {
        if(fMax == v4Src.r){
            fHue = ((v4Src.g - v4Src.b) / fChroma);
            if(fHue < 0.0)
                fHue += 6.0;
        }
        else if(fMax == v4Src.g)
            fHue = ((v4Src.b - v4Src.r) / fChroma) + 2.0;
        else
            fHue = ((v4Src.r - v4Src.g) / fChroma) + 4.0;
    }

    gl_FragColor = vec4(hcl_To_RGB(mod(fHue + u_HueOffset, 6.0), fChroma, fLuminance).rgb, v4Src.a);
}
