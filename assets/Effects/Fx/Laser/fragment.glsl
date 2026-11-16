#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;
uniform vec2 u_v2Center;
uniform float u_AspectRatio;
uniform float u_Radius;

varying vec2 v_texCoords;

void main()
{
    vec2 v2texCoordsAspect = (v_texCoords - u_v2Center) * vec2(u_AspectRatio, 1.0) + u_v2Center;
    float fDis = distance(v2texCoordsAspect, u_v2Center);

    if(fDis > u_Radius)
    {
        vec2 v2texCoordsNew = (v_texCoords - u_v2Center) * u_Radius / fDis + u_v2Center;
        gl_FragColor = texture2D(u_texture0, v2texCoordsNew);
    }
    else
    {
        gl_FragColor = texture2D(u_texture0, v_texCoords);
    }
}