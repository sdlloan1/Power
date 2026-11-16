
uniform sampler2D u_texture0;

precision mediump float;

varying vec2 v_texCoords;

void main()
{
    vec4 v4Pixel = 2.2222222 * texture2D(u_texture0, v_texCoords);
    v4Pixel *= (vec4(1.0) + (1.5625 * v4Pixel));
    v4Pixel -= vec4(5.0);
    v4Pixel = max(v4Pixel, vec4(0.0));
    v4Pixel /= (vec4(10.0) + v4Pixel);

	gl_FragColor = vec4(v4Pixel.rgb, 1.0);
}