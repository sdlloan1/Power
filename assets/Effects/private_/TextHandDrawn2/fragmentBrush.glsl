
precision mediump float;

uniform sampler2D u_texture0;

uniform vec3 u_DstHCL1;
uniform vec3 u_DstHCL2;

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

    vec3 v3DstHCL;
    if(v_texCoords.x < 0.5)
        v3DstHCL = u_DstHCL1;
    else
        v3DstHCL = u_DstHCL2;

    if(v3DstHCL.g < 0.001)
	    gl_FragColor = hcl_To_RGB(v3DstHCL.r, 0.0, fLuminanceSrc * v3DstHCL.b);
	else
    	gl_FragColor = hcl_To_RGB(v3DstHCL.r, fChromaSrc, fLuminanceSrc * v3DstHCL.b);
}