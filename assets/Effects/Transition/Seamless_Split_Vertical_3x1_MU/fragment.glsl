#extension GL_OES_EGL_image_external : require
precision highp float;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;

uniform float fProgress;
uniform vec2 u_AspectRatio;
uniform vec3 u_GridInfo[9];

uniform int u_SampleCount[3];
uniform vec2 u_Distance[60];

uniform float u_MixRate[3];
uniform vec2 u_CentralScale;
uniform vec2 u_Center;

varying vec2 v_texCoords;

void main(){

    vec2 v2TxCoord = v_texCoords * u_AspectRatio;

    vec2 v2Floor = floor(clamp(((v_texCoords - u_Center) * u_CentralScale) + u_Center, 0.0, 1.0) * 2.99999);
    int GridIndex = int(v2Floor.x + v2Floor.y * 3.0);

    vec2 v2TxCoordOffset;
    vec4 v4Result0 = vec4(0.0);
    vec4 v4Result1 = vec4(0.0);

    int timeIndex = int(u_GridInfo[GridIndex].z + 0.1);
    int nCount = u_SampleCount[timeIndex];
    int nBaseIndex = timeIndex * 20;
    {
        for(int index = 0 ; index < nCount ; ++index)
        {
            v2TxCoordOffset = v2TxCoord - u_GridInfo[GridIndex].xy * u_Distance[nBaseIndex + index].x;
            v4Result0 += texture2D(u_texture0, v2TxCoordOffset / u_AspectRatio) * u_Distance[nBaseIndex + index].y;
        }
    }

    {
        for(int index = 0 ; index < nCount ; ++index)
        {
            v2TxCoordOffset = v2TxCoord - u_GridInfo[GridIndex].xy * u_Distance[nBaseIndex + index].x;
            v4Result1 += texture2D(u_texture1, v2TxCoordOffset / u_AspectRatio) * u_Distance[nBaseIndex + index].y;
        }
    }

    gl_FragColor = mix(v4Result0, v4Result1, u_MixRate[timeIndex]);
}