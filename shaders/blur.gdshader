shader_type canvas_item;

uniform float blur_amount : hint_range(0, 32);

void fragment() {
    vec2 size = 1.0 / vec2(textureSize(TEXTURE, 0));
    vec4 color = vec4(0.0);
    float total = 0.0;
    for (float x = -blur_amount; x <= blur_amount; x++) {
        for (float y = -blur_amount; y <= blur_amount; y++) {
            vec2 offset = vec2(x, y) * size;
            color += texture(TEXTURE, UV + offset);
            total += 1.0;
        }
    }
    COLOR = color / total;
}
