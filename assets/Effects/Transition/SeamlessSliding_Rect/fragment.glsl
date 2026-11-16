#extension GL_OES_EGL_image_external : require
precision highp float;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;

uniform float fProgress;
uniform vec2 u_AspectRatio;
uniform vec4 u_GridInfo[4];

uniform int u_SampleCount[4];
uniform vec2 u_Distance[40];

uniform float u_MixRate[4];
uniform vec2 u_CentralScale;
uniform vec2 u_Center;

varying vec2 v_texCoords;

void main(){

    vec2 v2TxCoord = v_texCoords * u_AspectRatio;

    vec2 v2Diff = abs(v_texCoords - vec2(0.5)) * 2.0;
    float fDiff = max(v2Diff.x, v2Diff.y);

    int GridIndex;
    if(fDiff < u_GridInfo[0].w)
    {
        GridIndex = int(u_GridInfo[0].z + 0.1);
    }
    else if(fDiff < u_GridInfo[1].w)
    {
        GridIndex = int(u_GridInfo[1].z + 0.1);
    }
    else if(fDiff < u_GridInfo[2].w)
    {
        GridIndex = int(u_GridInfo[2].z + 0.1);
    }
    else
    {
        GridIndex = int(u_GridInfo[3].z + 0.1);
    }

    vec2 v2TxCoordOffset;
    vec4 v4Result0 = vec4(0.0);
    vec4 v4Result1 = vec4(0.0);

    int timeIndex = int(u_GridInfo[GridIndex].z + 0.1);
    int nCount = u_SampleCount[timeIndex];
    int nBaseIndex = timeIndex * 10;
    {
        for(int index = 0 ; index < nCount ; ++index)
        {
            v2TxCoordOffset = v2TxCoord - u_GridInfo[GridIndex].xy * u_Distance[nBaseIndex + index].x;
            v4Result0 += texture2D(u_texture0, (v2TxCoordOffset / u_AspectRatio - vec2(0.5))/ u_GridInfo[GridIndex].w + vec2(0.5)) * u_Distance[nBaseIndex + index].y;
        }
    }

    {
        for(int index = 0 ; index < nCount ; ++index)
        {
            v2TxCoordOffset = v2TxCoord - u_GridInfo[GridIndex].xy * u_Distance[nBaseIndex + index].x;
            v4Result1 += texture2D(u_texture1, (v2TxCoordOffset / u_AspectRatio - vec2(0.5))/ u_GridInfo[GridIndex].w + vec2(0.5)) * u_Distance[nBaseIndex + index].y;
        }
    }

    gl_FragColor = mix(v4Result0, v4Result1, u_MixRate[timeIndex]);
}