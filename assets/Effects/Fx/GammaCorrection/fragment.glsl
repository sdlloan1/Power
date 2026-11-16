#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif 

precision mediump float;
uniform float u_Level;

varying vec2 v_texCoords;

vec4 v4ConvertY = vec4(0.299, 0.587, 0.114, 0.0);
void main()
{
	vec4 v4Src = texture2D(u_texture0, v_texCoords);
	float fY = dot(v4Src, v4ConvertY);
	float fCb = (v4Src.b - fY) * 0.564;
	float fCr = (v4Src.r - fY) * 0.713;

    float NewY = pow(fY, u_Level);

    float rR = NewY + (fCr * 1.402);
    float rG = NewY + fCb * -0.344 + fCr * -0.714;
    float rB = NewY + fCb * 1.772;
	gl_FragColor = vec4(rR, rG, rB, v4Src.a);
}