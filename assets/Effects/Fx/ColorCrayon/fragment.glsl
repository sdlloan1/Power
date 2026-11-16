
uniform sampler2D u_texture0; 
precision mediump float;
varying vec2 v_texCoords;


void main(){
    vec4 v4Src = texture2D(u_texture0, v_texCoords);
    gl_FragColor = vec4(v4Src.rgb, 1.0);
}
