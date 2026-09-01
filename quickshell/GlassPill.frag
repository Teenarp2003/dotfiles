#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float srcWidth;
    float srcHeight;
    float radius;
} ubuf;

float sdRoundBox(vec2 p, vec2 b, float r) {
    vec2 q = abs(p) - b + vec2(r);
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r;
}

void main() {
    vec2 size = vec2(max(ubuf.srcWidth, 1.0), max(ubuf.srcHeight, 1.0));
    vec2 uv = qt_TexCoord0 * size;
    vec2 halfSize = size * 0.5;
    float r = min(ubuf.radius, min(halfSize.x, halfSize.y));
    vec2 p = uv - halfSize;
    float d = sdRoundBox(p, halfSize, r);
    float mask = 1.0 - smoothstep(-1.15, 1.15, d);
    if (mask <= 0.001)
        discard;

    vec2 b = max(halfSize - vec2(r), vec2(0.0));
    vec2 q = abs(p) - b;
    vec2 nxy;
    if (q.x > 0.0 && q.y > 0.0)
        nxy = normalize(q * sign(p));
    else if (q.x > q.y)
        nxy = vec2(sign(p.x), 0.0);
    else
        nxy = vec2(0.0, sign(p.y));

    float inward = max(-d, 0.0);
    float t = clamp(inward / max(r, 1.0), 0.0, 1.0);
    float z = sqrt(max(0.0, 1.0 - pow(1.0 - t, 2.0)));
    vec3 N = normalize(vec3(nxy * (1.0 - t) * 1.2, max(z, 0.14)));
    vec3 L = normalize(vec3(-0.28, -0.78, 0.58));
    vec3 H = normalize(L + vec3(0.0, 0.0, 1.0));
    float spec = pow(max(dot(N, H), 0.0), 84.0);
    float glint = pow(max(dot(N, normalize(vec3(0.55, -0.62, 0.42))), 0.0), 22.0);
    float fres = pow(1.0 - clamp(N.z, 0.0, 1.0), 1.85);
    float ao = smoothstep(-0.2, 0.85, nxy.y) * (1.0 - t);

    float hi = (spec * 0.55 + glint * 0.18 + fres * 0.20) * mask * ubuf.qt_Opacity;
    float lo = ao * 0.28 * mask * ubuf.qt_Opacity;
    vec3 col = vec3(1.0) * hi;
    col += vec3(0.0) * lo;
    fragColor = vec4(col, max(hi, lo));
}
