
uniform sampler2D u_txBrush;

precision mediump float;

uniform vec3 u_color_LT;
uniform vec3 u_color_RT;
uniform vec3 u_color_LB;
uniform vec3 u_color_RB;

varying vec2 v_texCoords;
varying vec2 v_colorRatio;

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
    vec3 v3ColorY1 = mix(u_color_LT, u_color_LB, v_colorRatio.y);
    vec3 v3ColorY2 = mix(u_color_RT, u_color_RB, v_colorRatio.y);
    vec3 v3Color = mix(v3ColorY1, v3ColorY2, v_colorRatio.x);
    float fMax = max(max(v3Color.r, v3Color.g), v3Color.b);
    float fMin = min(min(v3Color.r, v3Color.g), v3Color.b);
    float fDstChroma = fMax - fMin;

    float fDstHue = 0.0;
    if(fDstChroma > 0.001)
    {
        if(fMax == v3Color.r){
            fDstHue = ((v3Color.g - v3Color.b) / fDstChroma);
            if(fDstHue < 0.0)
                fDstHue += 6.0;
        }
        else if(fMax == v3Color.g)
            fDstHue = ((v3Color.b - v3Color.r) / fDstChroma) + 2.0;
        else
            fDstHue = ((v3Color.r - v3Color.g) / fDstChroma) + 4.0;
    }

    vec4 v4Src = texture2D(u_txBrush, v_texCoords);

    float fLuminanceBrush = dot(v4Src, vec4(0.299, 0.587, 0.114, 0.0));

    fMax = max(max(v4Src.r, v4Src.g), v4Src.b);
    fMin = min(min(v4Src.r, v4Src.g), v4Src.b);
    float fChromaBrush = fMax - fMin;

    gl_FragColor = hcl_To_RGB(fDstHue, fChromaBrush * fDstChroma, fLuminanceBrush);
}