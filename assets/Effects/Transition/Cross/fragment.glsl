#extension GL_OES_EGL_image_external : require
precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform float fProgress;
uniform float u_Alpha;
uniform int u_TxIndex;

void main(){
    vec4 v4Result;
	if(u_TxIndex == 0)
	{
      	v4Result = texture2D(u_texture0, v_texCoords);
	}
	else
	{
       	v4Result = texture2D(u_texture1, v_texCoords);
    }
    
    gl_FragColor = vec4(v4Result.rgb, u_Alpha);
}