#extension GL_OES_EGL_image_external : require

precision mediump float;

varying vec2 v_texCoords;
varying vec2 v_maskCoords;

uniform sampler2D u_texture0;
uniform sampler2D u_texture1;
uniform sampler2D u_textureMask;

uniform int u_Type;
uniform float u_TxOpacity;

void main(){

    if(u_Type == 0)
    {
        vec4 v4Src = texture2D(u_texture0, v_texCoords);
        vec4 v4Mask = texture2D(u_textureMask, v_maskCoords);
        gl_FragColor = vec4(v4Src.rgb, v4Mask.a * u_TxOpacity);
    }
    else if(u_Type == 1)
    {
        vec4 v4Src = texture2D(u_texture1, v_texCoords);
        vec4 v4Mask = texture2D(u_textureMask, v_maskCoords);
        gl_FragColor = vec4(v4Src.rgb, v4Mask.a * u_TxOpacity);
    }
    else if(u_Type == 2)
    {
        gl_FragColor = texture2D(u_textureMask, v_maskCoords);
    }
}