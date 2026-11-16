#extension GL_OES_EGL_image_external : require
precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform float fProgress;
uniform int u_TxIndex;
uniform float u_Lighten;

void main(){
	if(u_TxIndex == 0)
	{
      	gl_FragColor = vec4((texture2D(u_texture0, v_texCoords) * u_Lighten).rgb, 1.0);
	}
	else
	{
       	gl_FragColor = vec4((texture2D(u_texture1, v_texCoords) * u_Lighten).rgb, 1.0);
    }
}