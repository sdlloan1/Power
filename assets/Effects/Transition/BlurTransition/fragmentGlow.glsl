
uniform sampler2D u_texture0; 
uniform sampler2D u_textureGlow;

precision mediump float;
uniform float fLevel;
varying vec2 v_texCoords;

void main(){
	gl_FragColor = texture2D(u_texture0, v_texCoords) + (fLevel * texture2D(u_textureGlow, v_texCoords));
}