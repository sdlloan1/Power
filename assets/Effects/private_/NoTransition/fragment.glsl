#extension GL_OES_EGL_image_external : require
precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform float fProgress;

void main(){
	vec4 fadeOutColor = texture2D(u_texture0, v_texCoords);
	vec4 fadeInColor = texture2D(u_texture1, v_texCoords);
	gl_FragColor = (fProgress < 0.5) ? fadeOutColor : fadeInColor;
}
