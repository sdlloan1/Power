#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;
uniform int u_Level;

varying vec2 v_texCoords;

void main()
{
    if((u_Level < 2) || (u_Level > 64))
    	gl_FragColor = texture2D(u_texture0, v_texCoords);
    else
    {
        vec4 v4Src = texture2D(u_texture0, v_texCoords);
        float fAlpha = v4Src.a;
        v4Src *= 255.0;
        int nR = int(v4Src.r) * u_Level / 256 * 256 / (u_Level - 1);
        int nG = int(v4Src.g) * u_Level / 256 * 256 / (u_Level - 1);
        int nB = int(v4Src.b) * u_Level / 256 * 256 / (u_Level - 1);

        gl_FragColor = vec4(float(nR) / 255.0, float(nG) / 255.0, float(nB) / 255.0, fAlpha);
    }
}