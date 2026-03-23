// --- CONFIGURATION (ripple) ---
const float DURATION = 0.15;
const float MAX_RADIUS = 0.026;
const float RING_THICKNESS = 0.02;
const float CURSOR_WIDTH_CHANGE_THRESHOLD = 0.5;
vec4 COLOR = vec4(0.35, 0.36, 0.44, 0.8);
const float BLUR = 3.5;
const float ANIMATION_START_OFFSET = 0.0;

float easeOutCirc(float t) {
    return sqrt(1.0 - pow(t - 1.0, 2.0));
}
float easeOutPulse(float t) {
    return t * (2.0 - t);
}

vec2 normalize(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    #if !defined(WEB)
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    #endif
    vec2 vu = normalize(fragCoord, 1.);
    vec2 offsetFactor = vec2(-.5, 0.5);
    vec4 currentCursor = vec4(normalize(iCurrentCursor.xy, 1.), normalize(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(normalize(iPreviousCursor.xy, 1.), normalize(iPreviousCursor.zw, 0.));
    vec2 centerCC = currentCursor.xy - (currentCursor.zw * offsetFactor);
    float cellWidth = max(currentCursor.z, previousCursor.z);
    float widthChange = abs(currentCursor.z - previousCursor.z);
    float widthThresholdNorm = cellWidth * CURSOR_WIDTH_CHANGE_THRESHOLD;
    float isModeChange = step(widthThresholdNorm, widthChange);
    float rippleProgress = (iTime - iTimeCursorChange) / DURATION + ANIMATION_START_OFFSET;
    float isAnimating = 1.0 - step(1.0, rippleProgress);
    if (isModeChange > 0.0 && isAnimating > 0.0) {
        float easedProgress = easeOutCirc(rippleProgress);
        float rippleRadius = easedProgress * MAX_RADIUS;
        float fade = 1.0 - easeOutPulse(rippleProgress);
        float dist = distance(vu, centerCC);
        float sdfRing = abs(dist - rippleRadius) - RING_THICKNESS * 0.5;
        float antiAliasSize = normalize(vec2(BLUR, BLUR), 0.0).x;
        float ripple = (1.0 - smoothstep(-antiAliasSize, antiAliasSize, sdfRing)) * fade;
        fragColor = mix(fragColor, COLOR, ripple * COLOR.a);
    }
}
