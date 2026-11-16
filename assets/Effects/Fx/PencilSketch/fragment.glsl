
uniform sampler2D u_textureHSL;
uniform sampler2D u_textureIntermediate;
uniform sampler2D u_textureSketch;

precision mediump float;

uniform float u_GreyScaleConv;
uniform float u_EdgeDegree;
uniform float u_EdgeIntensity;
uniform vec2 u_TexelSize;

varying vec2 v_texCoords;
varying vec2 v_texSketchCoords;

void main()
{
    float fLT = texture2D(u_textureIntermediate, v_texCoords - u_TexelSize).r;
    float fRT = texture2D(u_textureIntermediate, v_texCoords + vec2(u_TexelSize.x, -u_TexelSize.y)).r;
    float fLB = texture2D(u_textureIntermediate, v_texCoords + vec2(-u_TexelSize.x, u_TexelSize.y)).r;
    float fRB = texture2D(u_textureIntermediate, v_texCoords + u_TexelSize).r;

    float fL = texture2D(u_textureIntermediate, v_texCoords + vec2(-u_TexelSize.x, 0.0)).r;
    float fT = texture2D(u_textureIntermediate, v_texCoords + vec2(0.0, -u_TexelSize.y)).r;
    float fR = texture2D(u_textureIntermediate, v_texCoords + vec2(u_TexelSize.x, 0.0)).r;
    float fB = texture2D(u_textureIntermediate, v_texCoords + vec2(0.0, u_TexelSize.y)).r;

    float fVertical = fLT + fT + fRT - fLB - fB - fRB;
    float fHorizontal = fLT + fL + fLB - fRT - fR - fRB;

    float fEdgeVal = 0.0;
    if((fVertical * fVertical + fHorizontal * fHorizontal) * 255.0 > u_EdgeDegree)
        fEdgeVal = u_EdgeIntensity;

    vec4 v4Sketch = texture2D(u_textureSketch, v_texSketchCoords);
    float fIntensity = texture2D(u_textureIntermediate, v_texCoords).r - fEdgeVal;
    fIntensity = min(1.0, max(0.0, ((fIntensity - 0.5) * 1.3) + 0.5));
    fIntensity = min(1.0, max(0.0, fIntensity + v4Sketch.a));

// Re-construct RGB with new L
    vec4 v4OrgHSL = texture2D(u_textureHSL, v_texCoords);
    v4OrgHSL.r *= 6.0;

    float fC = (1.0 - abs(fIntensity * 2.0 - 1.0)) * v4OrgHSL.g;
    float fX = fC * (1.0 - abs(mod(v4OrgHSL.r, 2.0) - 1.0));
    float m = fIntensity - (fC * 0.5);

    vec4 v4Res;
    if(v4OrgHSL.r < 1.0)
    	v4Res = vec4(vec3(fC, fX, 0.0) + m, 1.0);
    else if(v4OrgHSL.r < 2.0)
    	v4Res = vec4(vec3(fX, fC, 0.0) + m, 1.0);
    else if(v4OrgHSL.r < 3.0)
    	v4Res = vec4(vec3(0.0, fC, fX) + m, 1.0);
    else if(v4OrgHSL.r < 4.0)
    	v4Res = vec4(vec3(0.0, fX, fC) + m, 1.0);
    else if(v4OrgHSL.r < 5.0)
    	v4Res = vec4(vec3(fX, 0.0, fC) + m, 1.0);
    else
    	v4Res = vec4(vec3(fC, 0.0, fX) + m, 1.0);

    if(v4OrgHSL.b <= 0.1255)
        v4Res = (vec4(v4OrgHSL.b, v4OrgHSL.b, v4OrgHSL.b, v4OrgHSL.b) * (0.1255 - v4OrgHSL.b) + v4Res * v4OrgHSL.b) / 0.1255;

    if(u_GreyScaleConv > 0.5)
    {
        float fGrey = dot(v4Res, vec4(0.257, 0.504, 0.098, 0.0)) + 0.062745;
    	gl_FragColor = vec4(fGrey, fGrey, fGrey, v4OrgHSL.a);
    }
    else
    	gl_FragColor = vec4(v4Res.rgb, v4OrgHSL.a);
}