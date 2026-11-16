#extension GL_OES_EGL_image_external : require
precision highp float;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;

uniform float fProgress;
uniform int u_TxIndex;
uniform vec2 u_AspectRatio;
uniform vec2 u_Center;

uniform int u_SampleCount;
uniform vec2 u_AngleTable[20];

uniform float u_MixRate;

varying vec2 v_texCoords;

void main()
{
    vec2 v2TxCoord = (v_texCoords - u_Center) * u_AspectRatio;

    vec2 v2TxCoordRotate;
    vec4 v4Result0 = vec4(0.0);
    vec4 v4Result1 = vec4(0.0);

    {
        for(int index = 0 ; index < u_SampleCount ; ++index)
        {
            v2TxCoordRotate.x = v2TxCoord.x * cos(u_AngleTable[index].x) - v2TxCoord.y * sin(u_AngleTable[index].x);
            v2TxCoordRotate.y = v2TxCoord.x * sin(u_AngleTable[index].x) + v2TxCoord.y * cos(u_AngleTable[index].x);
            v4Result0 += texture2D(u_texture0, v2TxCoordRotate / u_AspectRatio + u_Center) * u_AngleTable[index].y;
        }
    }

    {
        for(int index = 0 ; index < u_SampleCount ; ++index)
        {
            v2TxCoordRotate.x = v2TxCoord.x * cos(u_AngleTable[index].x) - v2TxCoord.y * sin(u_AngleTable[index].x);
            v2TxCoordRotate.y = v2TxCoord.x * sin(u_AngleTable[index].x) + v2TxCoord.y * cos(u_AngleTable[index].x);
            v4Result1 += texture2D(u_texture1, v2TxCoordRotate / u_AspectRatio + u_Center) * u_AngleTable[index].y;
        }
    }

    gl_FragColor = mix(v4Result0, v4Result1, u_MixRate);
}