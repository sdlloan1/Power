
precision mediump float;

uniform sampler2D u_textureSrc;
uniform sampler2D u_textureBackdrop;

uniform float u_SrcOpacity;

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

void main()
{
	vec4 v4ColorSrc = texture2D(u_textureSrc, v_texCoords);
	vec4 v4ColorBackdrop = texture2D(u_textureBackdrop, v_texCoords);

	float fAlphaSrc = v4ColorSrc.a * u_SrcOpacity;
	float fAlphaBackdrop = v4ColorBackdrop.a;
	float fAlphaDst = fAlphaSrc + fAlphaBackdrop - (fAlphaSrc * fAlphaBackdrop);

    float fMax = max(max(v4ColorSrc.r, v4ColorSrc.g), v4ColorSrc.b);
    float fMin = min(min(v4ColorSrc.r, v4ColorSrc.g), v4ColorSrc.b);
    float fChromaSrc = fMax - fMin;
    float fHueSrc = 0.0;

    if(fChromaSrc > 0.001)
    {
        if(fMax == v4ColorSrc.r)
            fHueSrc = mod((((v4ColorSrc.g - v4ColorSrc.b) /  fChromaSrc) + 6.0), 6.0);
        else if(fMax == v4ColorSrc.g)
            fHueSrc = ((v4ColorSrc.b - v4ColorSrc.r) /  fChromaSrc) + 2.0;
        else
            fHueSrc = ((v4ColorSrc.r - v4ColorSrc.g) /  fChromaSrc) + 4.0;
    }

    float fLuminanceBackdrop = dot(v4ColorBackdrop, vec4(0.299, 0.587, 0.114, 0.0));

	vec4 v4ColorBlend = hcl_To_RGB(fHueSrc, fChromaSrc, fLuminanceBackdrop);

	float fParam1 = (1.0 - fAlphaSrc) * fAlphaBackdrop;
	float fParam2 = (1.0 - fAlphaBackdrop) * fAlphaSrc;
	float fParam3 = fAlphaSrc * fAlphaBackdrop;

	vec4 v4Result = (v4ColorBackdrop * fParam1 + v4ColorSrc * fParam2 + v4ColorBlend * fParam3) / fAlphaDst;

	gl_FragColor = vec4(v4Result.rgb, fAlphaDst);
}
