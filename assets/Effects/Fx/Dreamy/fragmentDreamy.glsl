
uniform sampler2D u_texture0; 
uniform sampler2D u_textureBlur;

precision mediump float;
varying vec2 v_texCoords;

void main(){
    vec4 v4BlurTex = texture2D(u_textureBlur, v_texCoords);
    vec4 v4OrgTex = texture2D(u_texture0, v_texCoords);
    vec4 v4Result = vec4(1.0) - ((vec4(1.0) - v4OrgTex) * (vec4(1.0) - v4BlurTex));

	gl_FragColor = vec4(v4Result.rgb, v4OrgTex.a);
}