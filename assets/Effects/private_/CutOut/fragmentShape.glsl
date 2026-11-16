
uniform sampler2D u_textureMaskSrc;

precision highp float;

uniform int u_Inverse;

varying vec2 v_texCoords;

void main(){
    vec4 v4Src = texture2D(u_textureMaskSrc, v_texCoords);

    if(u_Inverse == 0)
    {
        gl_FragColor = vec4(dot(v4Src, vec4(0.299, 0.587, 0.114, 0.0)));
    }
    else
    {
        gl_FragColor = vec4(1.0-dot(v4Src, vec4(0.299, 0.587, 0.114, 0.0)));
    }
}
