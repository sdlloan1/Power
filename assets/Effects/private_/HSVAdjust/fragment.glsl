#ifdef INPUT_IS_OES_TEXTURE 
#extension GL_OES_EGL_image_external : require 
uniform samplerExternalOES u_texture0; 
#else 
uniform sampler2D u_texture0; 
#endif

uniform sampler2D u_MappingTexture;

precision mediump float;

varying highp vec2 v_texCoords;

vec3 RGB2HSV(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = c.g < c.b ? vec4(c.bg, K.wz) : vec4(c.gb, K.xy);
    vec4 q = c.r < p.x ? vec4(p.xyw, c.r) : vec4(c.r, p.yzx);

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;

    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 HSV2RGB(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);

    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float hueWeight(float H)
{
    if(H < (30.0/360.0))
        return mix(0.0,   0.125, (H - (0.0/360.0)  ) / (30.0/360.0));
    else if (H < (60.0/360.0))
        return mix(0.125, 0.25,  (H - (30.0/360.0) ) / (30.0/360.0));
    else if (H < (120.0/360.0))
        return mix(0.25,  0.375, (H - (60.0/360.0) ) / (60.0/360.0));
    else if (H < (180.0/360.0))
        return mix(0.375, 0.5,   (H - (120.0/360.0) ) / (60.0/360.0));
    else if (H < (240.0/360.0))
        return mix(0.5,   0.625, (H - (180.0/360.0)) / (60.0/360.0));
    else if (H < (285.0/360.0))
        return mix(0.625, 0.75,  (H - (240.0/360.0)) / (45.0/360.0));
    else if (H < (300.0/360.0))
        return mix(0.75,  0.875, (H - (285.0/360.0)) / (15.0/360.0));
    else
        return mix(0.875, 1.0,   (H - (300.0/360.0)) / (60.0/360.0));
}

void main()
{
    vec4 textureColor = texture2D(u_texture0, v_texCoords);
    vec3 HSV = RGB2HSV(textureColor.rgb);
    vec4 HMapping, SMapping, VMapping;

    HMapping = texture2D(u_MappingTexture, vec2(HSV.x, 0.0));
    float weight = hueWeight(HSV.x);
    SMapping = texture2D(u_MappingTexture, vec2(HSV.y, weight));
    VMapping = texture2D(u_MappingTexture, vec2(HSV.z, weight));

    if (HSV.y > 0.0)
    {
        float H, S, V;
        H = mod((HSV.x + HMapping.z) - 0.5, 1.0);
        S = SMapping.y;
        V = VMapping.x;

        float DeltaV = V - HSV.z;
        if (HSV.y < 0.025)
            V = clamp(HSV.z + (DeltaV * HSV.y), 0.0, 1.0);
        else
        {
           if (DeltaV < 0.0)
               V = clamp(HSV.z - (pow(abs(DeltaV), 1.0/HSV.y)), 0.0, 1.0);
           else
               V = clamp(HSV.z + (pow(abs(DeltaV), 1.0/HSV.y)), 0.0, 1.0);
        }

        gl_FragColor = vec4(HSV2RGB(vec3(H, S, V)), textureColor.a);
    }
    else
        gl_FragColor = vec4(textureColor.rgb, textureColor.a);
}
