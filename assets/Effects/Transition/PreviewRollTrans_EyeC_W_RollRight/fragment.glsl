#extension GL_OES_EGL_image_external : require

precision highp float;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform sampler2D u_textureFrame;
uniform vec2 u_FrameSize;
uniform float u_FrameOpacity;
uniform float fProgress;

uniform float u_Offset[3];
uniform float u_Scale;

varying vec2 v_texCoords;

void main(){

    vec2 v2CoordRotate = (v_texCoords - vec2(0.5)) * 2.5 + vec2(0.5);

    float fOffset = u_Offset[int(mod(floor((v2CoordRotate.y - 0.5) / u_Scale + 0.5) + 1.0, 3.0))];
    vec2 v2Center = vec2(0.5 - fOffset, 0.5);
    vec2 v2TxCoord = (v2CoordRotate - vec2(fOffset, 0.0) - v2Center) / u_Scale + v2Center;
    float fIndex = floor(v2TxCoord.x);
    vec2 v2TexLocal = fract(v2TxCoord + vec2(5.0));

    vec2 v2txCoordFrame = vec2(0.5);
    if(v2TexLocal.x < u_FrameSize.x)
        v2txCoordFrame.x = v2TexLocal.x / u_FrameSize.x * 0.5;
    else if(v2TexLocal.x > (1.0 - u_FrameSize.x))
        v2txCoordFrame.x = (v2TexLocal.x - 1.0 + u_FrameSize.x) / u_FrameSize.x * 0.5 + 0.5;

    if(v2TexLocal.y < u_FrameSize.y)
        v2txCoordFrame.y = v2TexLocal.y / u_FrameSize.y * 0.5;
    else if(v2TexLocal.y > (1.0 - u_FrameSize.y))
        v2txCoordFrame.y = (v2TexLocal.y - 1.0 + u_FrameSize.y) / u_FrameSize.y * 0.5 + 0.5;

	vec4 v4FrameColor = texture2D(u_textureFrame, v2txCoordFrame);

    if(fIndex > -2.0)
    	gl_FragColor = mix(texture2D(u_texture0, v2TexLocal), v4FrameColor, v4FrameColor.a * u_FrameOpacity);
   	else
    	gl_FragColor = mix(texture2D(u_texture1, v2TexLocal), v4FrameColor, v4FrameColor.a * u_FrameOpacity);
}