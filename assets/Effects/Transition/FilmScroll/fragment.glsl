precision mediump float;
varying vec2 v_texCoords;
uniform sampler2D u_texture0;
uniform sampler2D u_texture1;

uniform sampler2D filmMask;
uniform float fProgress;
uniform int mode;

void main(){
    vec2 uv1;
    vec2 uv2;
    const float filmXRatio = 0.01764291;
    const float filmYRatio = 0.15647059;

    if (mode == 0) {
        uv1.x = v_texCoords.x + fProgress;
        uv1.y = v_texCoords.y;
        uv2.x = uv1.x - 1.0;
        uv2.y = v_texCoords.y;
        if (v_texCoords.x < 1.0 - fProgress) {
            if (v_texCoords.x < filmXRatio ||
                v_texCoords.x > abs(1.0-filmXRatio) ||
                v_texCoords.y < filmYRatio ||
                v_texCoords.y > abs(1.0-filmYRatio))
                gl_FragColor = texture2D(filmMask, uv1);
            else
                gl_FragColor = texture2D(u_texture0, uv1);
        }
        else {
            if (v_texCoords.x < filmXRatio ||
                v_texCoords.x > abs(1.0-filmXRatio) ||
                v_texCoords.y < filmYRatio ||
                v_texCoords.y > abs(1.0-filmYRatio))
                gl_FragColor = texture2D(filmMask, uv2);
            else
                gl_FragColor = texture2D(u_texture1, uv2);
        }
    }
    else {
        uv1.x = v_texCoords.x - fProgress;
        uv1.y = v_texCoords.y;
        uv2.x = uv1.x + 1.0;
        uv2.y = v_texCoords.y;
        if (v_texCoords.x > fProgress) {
            if (v_texCoords.x < filmXRatio ||
                v_texCoords.x > abs(1.0-filmXRatio) ||
                v_texCoords.y < filmYRatio ||
                v_texCoords.y > abs(1.0-filmYRatio))
                gl_FragColor = texture2D(filmMask, uv1);
            else
                gl_FragColor = texture2D(u_texture0, uv1);
        }
        else {
            if (v_texCoords.x < filmXRatio ||
                v_texCoords.x > abs(1.0-filmXRatio) ||
                v_texCoords.y < filmYRatio ||
                v_texCoords.y > abs(1.0-filmYRatio))
                gl_FragColor = texture2D(filmMask, uv2);
            else
                gl_FragColor = texture2D(u_texture1, uv2);
        }
    }
}
