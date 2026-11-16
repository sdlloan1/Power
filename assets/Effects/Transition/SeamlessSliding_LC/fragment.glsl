#extension GL_OES_EGL_image_external : require
precision highp float;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;

uniform float fProgress;
uniform int u_TxIndex;
uniform vec2 u_AspectRatio;
uniform vec2 u_Direction;

uniform int u_SampleCount;
uniform vec2 u_Distance[50];

uniform float u_MixRate;

varying vec2 v_texCoords;

void main(){

    vec2 v2TxCoord = v_texCoords * u_AspectRatio;

    vec2 v2TxCoordOffset;
    vec4 v4Result0 = vec4(0.0);
    vec4 v4Result1 = vec4(0.0);

    {
        for(int index = 0 ; index < u_SampleCount ; ++index)
        {
            v2TxCoordOffset = v2TxCoord - u_Direction * u_Distance[index].x;
            v4Result0 += texture2D(u_texture0, v2TxCoordOffset / u_AspectRatio) * u_Distance[index].y;
        }
    }

    {
        for(int index = 0 ; index < u_SampleCount ; ++index)
        {
            v2TxCoordOffset = v2TxCoord - u_Direction * u_Distance[index].x;
            v4Result1 += texture2D(u_texture1, v2TxCoordOffset / u_AspectRatio) * u_Distance[index].y;
        }
    }

    gl_FragColor = mix(v4Result0, v4Result1, u_MixRate);
}