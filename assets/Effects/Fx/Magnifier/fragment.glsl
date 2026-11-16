#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;

uniform sampler2D u_txMask;
uniform vec2 u_Center;
uniform float u_AspectRatio;
uniform float u_FrameAspectRatioX;
uniform float u_FrameAspectRatioY;
uniform float u_Radius;
uniform int u_Type;

varying vec2 v_texCoords;
varying vec2 v_MagTxCords;

void main()
{
    vec4 v4Mask = texture2D(u_txMask, v_texCoords);
	vec4 v4Src = texture2D(u_texture0, v_texCoords);
	vec4 v4Magnify = texture2D(u_texture0, v_MagTxCords);

    if(u_Type == 0)
    {
        vec2 v2texCoordsAspect = (v_texCoords - u_Center) * vec2(u_AspectRatio * u_FrameAspectRatioX, u_FrameAspectRatioY) + u_Center;
        float fDis = distance(v2texCoordsAspect, u_Center);

        if(fDis > u_Radius)
            gl_FragColor = vec4((v4Mask + v4Src * (1.0 - v4Mask.a)).rgb, max(v4Src.a, v4Mask.a));
        else
            gl_FragColor = vec4((v4Mask + v4Magnify * (1.0 - v4Mask.a)).rgb, max(v4Magnify.a, v4Mask.a));
    }
    else
    {
        vec2 v2texCoordsAspect = (v_texCoords - u_Center) * vec2(u_AspectRatio * u_FrameAspectRatioX, u_FrameAspectRatioY) + u_Center;
        vec2 v2Dis = v2texCoordsAspect - u_Center;
        if((v2Dis.x > u_Radius) || (v2Dis.x < u_Radius * -1.0) || (v2Dis.y > u_Radius) || (v2Dis.y < u_Radius * -1.0))
            gl_FragColor = vec4((v4Mask + v4Src * (1.0 - v4Mask.a)).rgb, max(v4Src.a, v4Mask.a));
        else
            gl_FragColor = vec4((v4Mask + v4Magnify * (1.0 - v4Mask.a)).rgb, max(v4Magnify.a, v4Mask.a));
    }
}