
precision mediump float;

uniform sampler2D u_texture0;

uniform vec3 u_DstHCL;

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
    vec4 v4Src = texture2D(u_texture0, v_texCoords);

    float fLuminanceSrc = dot(v4Src, vec4(0.299, 0.587, 0.114, 0.0));

    float fMax = max(max(v4Src.r, v4Src.g), v4Src.b);
    float fMin = min(min(v4Src.r, v4Src.g), v4Src.b);
    float fChromaSrc = fMax - fMin;

    if(fChromaSrc > 0.001)
    {
        float fHueSrc;
        if(fMax == v4Src.r)
            fHueSrc = mod(((v4Src.g - v4Src.b) / fChromaSrc) + 6.0, 6.0);
        else if(fMax == v4Src.g)
            fHueSrc = ((v4Src.b - v4Src.r) / fChromaSrc) + 2.0;
        else
            fHueSrc = ((v4Src.r - v4Src.g) / fChromaSrc) + 4.0;

        if(u_DstHCL.g < 0.001)
            gl_FragColor = vec4(fLuminanceSrc * u_DstHCL.b);
        else
            gl_FragColor = hcl_To_RGB(mod(fHueSrc + u_DstHCL.r + 5.5, 6.0), fChromaSrc, fLuminanceSrc * u_DstHCL.b);
    }
    else
        gl_FragColor = v4Src;
}