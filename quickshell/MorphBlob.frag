#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float srcWidth;
    float srcHeight;
    float pillR;
    float panelR;
    float blendK;
    vec4 fillColor;
    vec4 pillRect;
    vec4 panelRect;
} ubuf;

float sdRoundBox(vec2 p, vec2 b, float r) {
    vec2 q = abs(p) - b + vec2(r);
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r;
}

float smin(float a, float b, float k) {
    k = max(k, 0.001);
    float h = max(k - abs(a - b), 0.0) / k;
    return min(a, b) - h * h * k * 0.25;
}

void main() {
    vec2 uv = qt_TexCoord0 * vec2(ubuf.srcWidth, ubuf.srcHeight);

    vec2 pillHalf = ubuf.pillRect.zw * 0.5;
    vec2 pillC = ubuf.pillRect.xy + pillHalf;
    float dPill = sdRoundBox(uv - pillC, pillHalf, min(ubuf.pillR, min(pillHalf.x, pillHalf.y)));

    vec2 panelHalf = max(ubuf.panelRect.zw, vec2(1.0)) * 0.5;
    vec2 panelC = ubuf.panelRect.xy + panelHalf;
    float dPanel = sdRoundBox(uv - panelC, panelHalf, min(ubuf.panelR, min(panelHalf.x, panelHalf.y)));

    float d = smin(dPill, dPanel, ubuf.blendK);
    float alpha = 1.0 - smoothstep(-1.2, 1.2, d);
    fragColor = ubuf.fillColor * (alpha * ubuf.qt_Opacity);
}
