
uniform sampler2D u_texture0; 
uniform sampler2D u_textureBloom;

precision mediump float;
varying vec2 v_texCoords;

void main(){
    vec4 v4Src = texture2D(u_texture0, v_texCoords);
    vec4 v4Res = v4Src + texture2D(u_textureBloom, v_texCoords);
	gl_FragColor = vec4(v4Res.rgb, v4Src.a);
}