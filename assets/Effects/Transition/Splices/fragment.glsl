precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform sampler2D u_texture1;

uniform float fProgress;
uniform int mode;

void main(){
    vec2 uv1;
    vec2 uv2;
    vec2 uv3;
    vec2 uv4;
    if (mode == 1) {
        if(mod(floor(v_texCoords.y*50.0), 2.0) == 0.0) {
            uv1.x = v_texCoords.x + fProgress;
            uv1.y = v_texCoords.y;
            uv2.x = uv1.x - 1.0;
            uv2.y = v_texCoords.y;
            if (v_texCoords.x < 1.0 - fProgress)
            gl_FragColor = texture2D(u_texture0, uv1);
            else
            gl_FragColor = texture2D(u_texture1, uv2);
        }
        else {
            uv3.x = v_texCoords.x - fProgress;
            uv3.y = v_texCoords.y;
            uv4.x = uv3.x + 1.0;
            uv4.y = v_texCoords.y;
            if (v_texCoords.x > fProgress)
            gl_FragColor = texture2D(u_texture0, uv3);
            else
            gl_FragColor = texture2D(u_texture1, uv4);
        }
    }
    else {
        if(mod(floor(v_texCoords.x*50.0), 2.0) == 0.0) {
            uv1.y = v_texCoords.y + fProgress;
            uv1.x = v_texCoords.x;
            uv2.y = uv1.y - 1.0;
            uv2.x = v_texCoords.x;
            if (v_texCoords.y < 1.0 - fProgress)
            gl_FragColor = texture2D(u_texture0, uv1);
            else
            gl_FragColor = texture2D(u_texture1, uv2);
        }
        else {
            uv3.y = v_texCoords.y - fProgress;
            uv3.x = v_texCoords.x;
            uv4.y = uv3.y + 1.0;
            uv4.x = v_texCoords.x;
            if (v_texCoords.y > fProgress)
            gl_FragColor = texture2D(u_texture0, uv3);
            else
            gl_FragColor = texture2D(u_texture1, uv4);
        }
    }
}
