
uniform sampler2D u_texture0; 
uniform sampler2D u_textureGlow;

precision mediump float;
uniform float fLevel;
varying vec2 v_texCoords;

void main(){
    vec4 v4Src = texture2D(u_texture0, v_texCoords);
	gl_FragColor = vec4((texture2D(u_textureGlow, v_texCoords) + (fLevel * v4Src)).rgb, v4Src.a);
}