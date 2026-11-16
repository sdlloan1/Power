#extension GL_OES_EGL_image_external : require

precision highp float;

uniform vec2 u_AspectRatio;
uniform float u_Rotate;
uniform float u_Height;
uniform vec2 u_Scale;
uniform vec2 u_Offset;
uniform int u_NoiseType;
uniform float u_Evolution;
uniform float u_HueOffset;
uniform float u_Opacity;
uniform float u_Brightness;
uniform float u_Contrast;

varying vec2 v_texCoords;

float random2(vec2 st, float evolution, float seed){
//    st = vec2( dot(st,vec2(127.1,311.7)), dot(st,vec2(269.5,183.3)) );

//    return -1.0 + 2.0 * fract( sin( dot(st.xy, vec2(12.9898,78.233)) + evolution) * (43758.5453123 + seed) );
    float sinDotValue = sin( dot(st.xy, vec2(12.9898,78.233)) );
    float randValue = fract( sinDotValue * (43758.5453123 + seed) );
    randValue = sin(evolution + randValue * 6.2831853) * 0.5 + 0.5;

    return randValue;

//    return fract( sin( dot(st.xy, vec2(12.9898,78.233))) * (43758.5453123 + seed) );
}

vec2 interpolate(int type, float a, float b, vec2 p) {
    // Interpolation Type: 1 - Basic/Hold, 2 - linear, 3 - Soft linear
    vec2 u = vec2(0.0, 0.0);

    if (type == 2)
        u = mix(vec2(a), vec2(b), p);
    else if (type == 3)
        u = smoothstep(vec2(a), vec2(b), p);
    //else if (type == 4)
    //    u = p * p * p * (p * (p * 6.0 - 15.0) + 10.0);

    return u;
}

//    #define T 0.7
//constant float4x4 CRM = float4x4(
//-T,       2.0 - T,    T - 2.0,        T,
//2.0 * T, T - 3.0,    3.0 - 2.0 * T, -T,
//-T,       0.0,        T,              0.0,
//0.0,     1.0,        0.0,            0.0);

// Catmul-Rom Spline Interpolation
vec2 interpolateCR(vec2 G1, vec2 G2, vec2 G3, vec2 G4, float t)
{
    float T = 0.7;
    vec2 A = G1 * -T + G2 * (2.0 - T) + G3 * (T - 2.0) + G4 * T;
    vec2 B = G1 * 2.0 * T + G2 * (T - 3.0) + G3 * (3.0 - 2.0 * T) + G4 * -T;
    vec2 C = G1 * -T + G2 * 0.0 + G3 * T + G4 * 0.0;
    vec2 D = G1 * 0.0 + G2 * 1.0 + G3 * 0.0 + G4 * 0.0;

    return t * (t * (t * A + B) + C) + D;
}

float noise(vec2 st, int noiseType, float evolution, float seed) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Noise type : 1 - Basic/Hold, 2 - linear, 3 - Soft linear
    if (noiseType != 4) {
        vec2 u = interpolate(noiseType, 0.0, 1.0, f);


        float b = random2(i + vec2(1.0, 0.0), evolution, seed );
        float c = random2(i + vec2(0.0, 1.0), evolution, seed );
        float d = random2(i + vec2(1.0, 1.0), evolution, seed );
        float a = random2(i + vec2(0.0, 0.0), evolution, seed );

        return mix( mix(a, b, u.x), mix(c, d, u.x), u.y);

        // Mix four corners percentages
        //                    return mix( mix( random2(i + vec2(0.0, 0.0), evolution, seed ),
        //                                     random2(i + vec2(1.0, 0.0), evolution, seed ), u.x),
        //                                mix( random2(i + vec2(0.0, 1.0), evolution, seed ),
        //                                     random2(i + vec2(1.0, 1.0), evolution, seed ), u.x), u.y);
    } else {
        // Noise type: 4 - spline
        //return pnoise(st);
        vec2 G00 = vec2( -1.0, random2(i + vec2(-1.0, -1.0), evolution, seed) );
        vec2 G01 = vec2(  0.0, random2(i + vec2( 0.0, -1.0), evolution, seed) );
        vec2 G02 = vec2(  1.0, random2(i + vec2( 1.0, -1.0), evolution, seed) );
        vec2 G03 = vec2(  2.0, random2(i + vec2( 2.0, -1.0), evolution, seed) );

        vec2 H0 = interpolateCR(G00, G01, G02, G03, f.x);

        vec2 G10 = vec2( -1.0, random2(i + vec2(-1.0, 0.0), evolution, seed) );
        vec2 G11 = vec2(  0.0, random2(i + vec2( 0.0, 0.0), evolution, seed) );
        vec2 G12 = vec2(  1.0, random2(i + vec2( 1.0, 0.0), evolution, seed) );
        vec2 G13 = vec2(  2.0, random2(i + vec2( 2.0, 0.0), evolution, seed) );

        vec2 H1 = interpolateCR(G10, G11, G12, G13, f.x);

        vec2 G20 = vec2( -1.0, random2(i + vec2(-1.0, 1.0), evolution, seed) );
        vec2 G21 = vec2(  0.0, random2(i + vec2( 0.0, 1.0), evolution, seed) );
        vec2 G22 = vec2(  1.0, random2(i + vec2( 1.0, 1.0), evolution, seed) );
        vec2 G23 = vec2(  2.0, random2(i + vec2( 2.0, 1.0), evolution, seed) );

        vec2 H2 = interpolateCR(G20, G21, G22, G23, f.x);

        vec2 G30 = vec2( -1.0, random2(i + vec2(-1.0, 2.0), evolution, seed) );
        vec2 G31 = vec2(  0.0, random2(i + vec2( 0.0, 2.0), evolution, seed) );
        vec2 G32 = vec2(  1.0, random2(i + vec2( 1.0, 2.0), evolution, seed) );
        vec2 G33 = vec2(  2.0, random2(i + vec2( 2.0, 2.0), evolution, seed) );

        vec2 H3 = interpolateCR(G30, G31, G32, G33, f.x);

        vec2 V0 = vec2(-1.0, H0.y);
        vec2 V1 = vec2( 0.0, H1.y);
        vec2 V2 = vec2( 1.0, H2.y);
        vec2 V3 = vec2( 2.0, H3.y);

        vec2 N = interpolateCR(V0, V1, V2, V3, f.y);
        return N.y;
    }
}

vec3 brightnessContrast(vec3 value, float brightness, float contrast)
{
    return (value - 0.5) * contrast + 0.5 + brightness;
}

vec3 RGB_To_hcl(vec3 rgb)
{
    float fLuminance = dot(rgb, vec3(0.299, 0.587, 0.114));

    float fMax = max(max(rgb.r, rgb.g), rgb.b);
    float fMin = min(min(rgb.r, rgb.g), rgb.b);
    float fChroma = fMax - fMin;
    if(fChroma < 0.001)
        fChroma = 0.0;

    float fHue = -1.0;
    if(fChroma != 0.0)
    {
        if(fMax == rgb.r){
            fHue = ((rgb.g - rgb.b) / fChroma);
            if(fHue < 0.0)
                fHue += 6.0;
        }
        else if(fMax == rgb.g)
            fHue = ((rgb.b - rgb.r) / fChroma) + 2.0;
        else
            fHue = ((rgb.r - rgb.g) / fChroma) + 4.0;
    }

    return vec3(fHue, fChroma, fLuminance);
}

vec4 hcl_To_RGB(float fHue, float fChroma, float fLuminance)
{
    if(fChroma < 0.001)
        return vec4(fLuminance, fLuminance, fLuminance, 1.0);

    float fX = fChroma * (1.0 - abs(mod(fHue, 2.0) - 1.0));

    vec4 v4RGB;
    if(fHue < 1.0)
        v4RGB = vec4(fChroma, fX, 0.0, 1.0);
    else if(fHue < 2.0)
        v4RGB = vec4(fX, fChroma, 0.0, 1.0);
    else if(fHue < 3.0)
        v4RGB = vec4(0.0, fChroma, fX, 1.0);
    else if(fHue < 4.0)
        v4RGB = vec4(0.0, fX, fChroma, 1.0);
    else if(fHue < 5.0)
        v4RGB = vec4(fX, 0.0, fChroma, 1.0);
    else
    v4RGB = vec4(fChroma, 0.0, fX, 1.0);

    float fm = fLuminance - dot(v4RGB, vec4(0.299, 0.587, 0.114, 0.0));
    v4RGB += vec4(fm, fm, fm, 0.0);
    v4RGB = max(vec4(0.0), min(vec4(1.0), v4RGB));

    return v4RGB;
}

void main(){

    vec2 st = (v_texCoords - vec2(0.5)) * u_AspectRatio;
    st = vec2(st.x * cos(u_Rotate) - st.y * sin(u_Rotate), st.x * sin(u_Rotate) + st.y * cos(u_Rotate));
    st -= u_Offset;
    st *= u_Height;
    st /= u_Scale;

    vec3 color = vec3( noise(st, u_NoiseType, u_Evolution, 500.0));
    color = brightnessContrast(color, u_Brightness, u_Contrast);

//    vec3 hcl = RGB_To_hcl(color * vec3(1.0, 0.0, 0.0));
//    color = hcl_To_RGB(mod(hcl.r + u_HueOffset, 6.0), hcl.g, hcl.b).rgb * u_Opacity;

    vec3 hcl = RGB_To_hcl(color);
//    color = hcl_To_RGB(mod(hcl.r + u_HueOffset + (1.0 - hcl.b) * 4.0, 6.0), hcl.g * (1.0 - hcl.b) * 0.0, hcl.b).rgb * u_Opacity;
//    color = hcl_To_RGB(mod(hcl.r + u_HueOffset + (1.0 - hcl.b) * 4.0, 6.0), hcl.g * (1.0 - hcl.b) * 0.0, hcl.b).rgb * u_Opacity;
    color = hcl_To_RGB(mod(u_HueOffset + (1.0 - hcl.b) * 4.0, 6.0), (1.0 - hcl.b), hcl.b).rgb * u_Opacity;

    gl_FragColor = vec4(color, 0.0);
}
