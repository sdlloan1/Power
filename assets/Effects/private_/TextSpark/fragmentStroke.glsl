
uniform sampler2D u_txBrush;

precision mediump float;

varying vec2 v_texCoords;
varying float v_sparkProgress;

void main(void)
{
    float fLight = clamp((v_sparkProgress - 0.8) * 5.0, 0.0, 1.0);
    fLight = 1.0 - fLight * fLight;
	gl_FragColor = texture2D(u_txBrush, v_texCoords) * fLight;
}