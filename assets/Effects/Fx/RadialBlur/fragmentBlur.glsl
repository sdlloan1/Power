uniform sampler2D u_texture0; 

precision mediump float;
varying vec2 v_texCoords;

uniform int nDegree;
const float fBase = 160.0;

void main(){
	// Return order -- float4(B, G, R, A)
	// f4.x = R , f4.y = G , f4.z = B , f4.w = A
    vec4 f4Result = texture2D(u_texture0, v_texCoords);
    float fAlpha = f4Result.a;
    vec2 f2Center = vec2(0.5, 0.5);

    float fScale;
    vec2 f2PosDiff;
    vec2 f2Sample;
    for ( int i = 1; i < 30 && i < nDegree; i++ )
    {
        fScale = fBase / ( fBase + float(i) );
        f2PosDiff = v_texCoords - f2Center;
        f2Sample = f2Center + f2PosDiff * fScale;
        f4Result += texture2D(u_texture0, f2Sample);
    }

    float fDegree = float(nDegree);
    f4Result /= max(fDegree, 1.0);

    gl_FragColor = vec4(f4Result.rgb, fAlpha);
}