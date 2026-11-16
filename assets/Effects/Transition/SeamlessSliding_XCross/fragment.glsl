#extension GL_OES_EGL_image_external : require
precision highp float;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;

uniform float fProgress;
uniform vec2 u_AspectRatio;

uniform int u_SampleCount[4];
uniform vec2 u_Distance[40];

uniform float u_MixRate[4];
uniform vec3 u_RegionInfo[4];

varying vec2 v_texCoords;

void main(){

    vec2 v2TxCoord = (v_texCoords - vec2(0.5)) * u_AspectRatio;

    int nRegionIndex = 0;
    if(v_texCoords.x < v_texCoords.y)
        nRegionIndex = 2;

    if(v_texCoords.x > (1.0 - v_texCoords.y))
    nRegionIndex += 1;

    vec2 v2Direction = u_RegionInfo[nRegionIndex].xy;
    int nTimeIndex = int(u_RegionInfo[nRegionIndex].z + 0.1);
    int nBaseIndex = nTimeIndex * 10;
    int nCount = u_SampleCount[nTimeIndex];

    vec2 v2TxCoordOffset;
    vec4 v4Result0 = vec4(0.0);
    vec4 v4Result1 = vec4(0.0);

    {
        for(int index = 0 ; index < nCount ; ++index)
        {
            v2TxCoordOffset = v2TxCoord - v2Direction * u_Distance[nBaseIndex + index].x;
            v4Result0 += texture2D(u_texture0, v2TxCoordOffset / u_AspectRatio + vec2(0.5)) * u_Distance[nBaseIndex + index].y;
        }
    }

    {
        for(int index = 0 ; index < nCount ; ++index)
        {
            v2TxCoordOffset = v2TxCoord - v2Direction * u_Distance[nBaseIndex + index].x;
            v4Result1 += texture2D(u_texture1, v2TxCoordOffset / u_AspectRatio + vec2(0.5)) * u_Distance[nBaseIndex + index].y;
        }
    }

    gl_FragColor = mix(v4Result0, v4Result1, u_MixRate[nTimeIndex]);
}