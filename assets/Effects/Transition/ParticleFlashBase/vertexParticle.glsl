
attribute vec2 a_position;
attribute vec2 a_texCoords;

attribute vec4 a_posOffset; // xyz -- particle offset related to (0, 0, 0), w -- size verient
attribute vec4 a_motion; // xy -- rotate related to xz axis, zw -- xy motion
attribute float a_progressOffset; // Different fade in/out of different kinds of particles

uniform mat4 u_MMatrix;
uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;
uniform float u_Size;
uniform vec2 u_RotateWeight;
uniform float u_Progress;
uniform float u_ProgressOffset;
uniform float u_ParticleLife;
uniform float u_RotateZCorrection;

varying vec2 v_texCoords;
varying float v_Lightness;

void main()
{
    vec4 v4Pos = vec4(a_position * u_Size * a_posOffset.w, 0.0, 1.0);

    // a_motion - x: X_axis_rotate y: Z_axis_rotate z: X_axis_moving w: Y_axis_moving
    vec2 v2Rotate = (a_motion.xy * u_Progress + a_posOffset.xy) * u_RotateWeight;
    v2Rotate.y += u_RotateZCorrection;

    v4Pos.xy = vec2(v4Pos.x * cos(v2Rotate.y) - v4Pos.y * sin(v2Rotate.y), v4Pos.x * sin(v2Rotate.y) + v4Pos.y * cos(v2Rotate.y));
    v4Pos.yz = vec2(v4Pos.y * cos(v2Rotate.x) - v4Pos.z * sin(v2Rotate.x), v4Pos.y * sin(v2Rotate.x) + v4Pos.z * cos(v2Rotate.x));

    v4Pos = v4Pos + vec4(a_posOffset.x + a_motion.z * u_Progress, a_posOffset.y + a_motion.w * u_Progress, a_posOffset.z, 0.0);

	gl_Position = u_PMatrix * u_VMatrix * u_MMatrix * v4Pos;

	v_texCoords = a_texCoords;

    float fCurProgress  = clamp((u_Progress - (u_ProgressOffset * a_progressOffset)) / u_ParticleLife, 0.0, 1.0);
    v_Lightness = cos(fCurProgress * 6.2831853 - 3.14159265) * 0.5 + 0.5;
}