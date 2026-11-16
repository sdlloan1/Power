
uniform sampler2D u_textureMaskSrc;

precision highp float;

uniform int u_Type;
uniform int u_Mode;
uniform int u_Inverse;
uniform vec2 u_FeatherRange;
uniform vec2 u_Aliasing;

varying vec2 v_texCoords;

void main(){

    if(u_Type == 0) // Line
    {
        if(u_Inverse == 0)
            gl_FragColor = vec4(max((0.5 - v_texCoords.y) / u_FeatherRange.y, 0.0));
        else
            gl_FragColor = vec4(max((v_texCoords.y - 0.5) / u_FeatherRange.y, 0.0));
    }
    else if(u_Type == 1) // Parallel
    {
        if(u_Inverse == 0)
            gl_FragColor = vec4(max((0.5 - (abs(0.5 - v_texCoords.y) * 100.0)) / u_FeatherRange.y, 0.0));
        else
        {
            float fVal = max(0.495 - v_texCoords.y, v_texCoords.y - 0.505);
            gl_FragColor = vec4(max((fVal * 100.0) / u_FeatherRange.y, 0.0));
        }
    }
    else if(u_Type == 2) // Box
    {
        vec2 v2TxCoord = (v_texCoords - vec2(0.5)) * 15.0 + vec2(0.5);

        float fAlpha = 0.0;
        if(u_Inverse == 0)
        {
            float fAlphaX = 0.0;
            float fAlphaY = 0.0;

            if((v2TxCoord.x >= 0.0) && (v2TxCoord.x <= 1.0))
            {
                if((v2TxCoord.y >= 0.0) && (v2TxCoord.y <= 1.0))
                {
                    fAlphaX = min(v2TxCoord.x, 1.0 - v2TxCoord.x) / u_FeatherRange.x;
                    fAlphaY = min(v2TxCoord.y, 1.0 - v2TxCoord.y) / u_FeatherRange.y;
                }
            }

            fAlpha = min(fAlphaX, fAlphaY);
        }
        else
        {
            float fAlphaY = 0.0;
            if(v2TxCoord.y < 0.0)
                fAlphaY = -v2TxCoord.y / u_FeatherRange.y;
            else if(v2TxCoord.y > 1.0)
                fAlphaY = (v2TxCoord.y - 1.0) / u_FeatherRange.y;

            float fAlphaX = 0.0;
            if(v2TxCoord.x < 0.0)
                fAlphaX = -v2TxCoord.x / u_FeatherRange.x;
            else if(v2TxCoord.x > 1.0)
                fAlphaX = (v2TxCoord.x - 1.0) / u_FeatherRange.x;

            fAlpha = max(fAlphaX, fAlphaY);
        }

        gl_FragColor = vec4(fAlpha);
    }
    else if(u_Type == 3) // Circle
    {
        vec2 v2TxCoord = (v_texCoords - vec2(0.5)) * 15.0 + vec2(0.5);
        float fVal = ((v2TxCoord.x - 0.5) * (v2TxCoord.x - 0.5) + (v2TxCoord.y - 0.5) * (v2TxCoord.y - 0.5)) * 4.0;

        if(u_Inverse == 0)
        {
            gl_FragColor = vec4((0.97 - fVal) / u_FeatherRange.x);
        }
        else
        {
            gl_FragColor = vec4((fVal - 0.97) / u_FeatherRange.x);
        }
    }
    else if(u_Type == 4) // Image
    {
        vec4 v4Src = texture2D(u_textureMaskSrc, v_texCoords);

        float alpha;

        if (u_Mode == 0) {
            alpha = v4Src.a;
        } else {
            alpha = dot(v4Src, vec4(0.299, 0.587, 0.114, 0.0));
        }

        if(u_Inverse == 0) {
            gl_FragColor = vec4(alpha);
        } else {
            gl_FragColor = vec4(1.0-alpha);
        }
    }
}
