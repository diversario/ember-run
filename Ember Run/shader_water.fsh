//void main( void )
//{
//    float time = u_time * .5;
//    vec2 sp = gl_FragCoord.xy / size.xy;
//    vec2 p = sp * 6.0 - 20.0;
//    vec2 i = p;
//    float c = 1.0;
//    float inten = .05;
//    
//    for (int n = 0; n < 5; n++)
//    {
//        float t = time * (1.0 - (3.5 / float(n+1)));
//        i = p + vec2(cos(t - i.x) + sin(t + i.y), sin(t - i.y) + cos(t + i.x));
//        c += 1.0/length(vec2(p.x / (sin(i.x+t)/inten),p.y / (cos(i.y+t)/inten)));
//    }
//    
//    c /= float(5);
//    c = 1.55-sqrt(c);
//    vec3 colour = vec3(pow(abs(c), 15.0));
//    
//    gl_FragColor = vec4(clamp(colour + vec3(0.0, 0.17, 0.3), 0.0, .5), 0.3);
//}
//
//void main (void) {
//    vec2 st = gl_FragCoord.xy/size.xy;
//    float aspect = size.x/size.y;
//    st.x *= aspect;
//    
//    vec3 color = vec3(0.0);
//    color = vec3(st.x, st.y, (1.0+sin(u_time))*0.5);
//    
//    //if ( u_sprite_size != vec2(0.0) ) {
//    float imgAspect = u_sprite_size.x/u_sprite_size.y;
//    vec4 img = texture2D(u_texture, st*vec2(1.,imgAspect));
//    // color = img.rgb;
//    color = mix(color,img.rgb,img.a);
//    
//    float offset = smoothstep(0.0, 1.0, sin(st.y) * cos(u_time)) / 50.0;
//    color.r = texture2D(u_tex0, vec2(st.x + offset, st.y)).r;
//    
//    offset = smoothstep(0.0, 1.0, cos(st.y) * sin(u_time)) / 50.0;
//    color.g = texture2D(u_tex0, vec2(st.x + offset, st.y)).g;
//    
//    offset = smoothstep(0.0, 1.0, cos(st.y) + sin(u_time)) / 50.0;
//    color.b = texture2D(u_tex0, vec2(st.x + offset, st.y)).b;
//    //}
//    
//    gl_FragColor = vec4(color,1.0);
//}

//void main(void) {
//    vec2 st = gl_FragCoord.xy/size.xy;
//    float aspect = size.x/size.y;
//    //st.x *= aspect;
//    
//    vec3 color = vec3(0.0);
//    color = vec3(st.x, st.y, (1.0+sin(u_time))*0.5);
//    
//    //if ( u_sprite_size != vec2(0.0) ) {
//    float imgAspect = size.x/size.y;
//    vec4 img = texture2D(u_texture, st * vec2(1.0, aspect));
//    
//    color = mix(color,img.rgb,img.a);
//    
//    float offset = smoothstep(0.0, 1.0, sin(st.y) * cos(u_time)) / 50.0;
//    color.r = texture2D(u_texture, vec2(st.x + offset, st.y)).r;
//    //color = vec3(1.0);
//    gl_FragColor = vec4(color,1.0);
//}
//

// expo out
// t == 1.0 ? t : 1.0 - pow(2.0, -10.0 * t);

void main (void) {
    vec2 tc = v_tex_coord;
    vec3 color = vec3(0.0);
    
    float y = smoothstep(0.0, 0.5, tc.y);
    float x = smoothstep(0.0, 0.5, tc.x);
    
    float offset_y = y/800.0;
    float offset_x = x/200.0;
    
    color.r = texture2D(u_texture, vec2(v_tex_coord.x + offset_x, v_tex_coord.y + offset_y)).r;
    color.g = texture2D(u_texture, vec2(v_tex_coord.x - offset_x, v_tex_coord.y - offset_y)).g;
    color.b = texture2D(u_texture, vec2(v_tex_coord.x + offset_x, v_tex_coord.y - offset_y)).b;
    
    //color.r += sin(test / 1000.0);
    
    gl_FragColor = vec4(color,1.0);
}

// uniform split
//void main(void) {
//    vec2 st = v_tex_coord;
//
//    vec3 color = vec3(0.0);
//
//    vec4 img = texture2D(u_texture, v_tex_coord);
//
//    color = mix(color,img.rgb,img.a);
//
//    float offset = smoothstep(0.0, 1.0, sin(st.y) * cos(u_time)) / 50.0;
//    color.r = texture2D(u_texture, vec2(v_tex_coord.x + offset, v_tex_coord.y)).r;
//    
//    offset = smoothstep(0.0, 1.0, cos(st.y) * sin(u_time)) / 50.0;
//    color.g = texture2D(u_texture, vec2(v_tex_coord.x - offset, v_tex_coord.y)).g;
//    
//    offset = smoothstep(0.0, 1.0, pow(sin(st.y) * cos(u_time), 5.0)) / 50.0;
//    color.b = texture2D(u_texture, vec2(v_tex_coord.x + offset, v_tex_coord.y)).b;
//    
//    gl_FragColor = vec4(color,1.0);
//}
