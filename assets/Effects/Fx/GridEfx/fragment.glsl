#ifdef INPUT_IS_OES_TEXTURE
#extension GL_OES_EGL_image_external : require
uniform samplerExternalOES u_texture0;
#else
uniform sampler2D u_texture0;
#endif

precision mediump float;
uniform vec4 u_GridColor;
uniform float u_DisX;
uniform float u_DisY;
uniform float u_GridWidth;
uniform float u_GridHeight;

varying vec2 v_texCoords;

void main(){

    float fPosX = v_texCoords.x / u_DisX;
    float fPosY = v_texCoords.y / u_DisY;

    if(((ceil(fPosX) - fPosX) < u_GridWidth) || ((ceil(fPosY) - fPosY) < u_GridHeight))
        gl_FragColor = vec4(u_GridColor.rgb, texture2D(u_texture0, v_texCoords).a);
    else
        gl_FragColor = texture2D(u_texture0, v_texCoords);
}
