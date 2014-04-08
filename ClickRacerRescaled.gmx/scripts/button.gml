///button(spr,x,y,w,h,text,bpic,subimg,name)
//       0   1 2 3 4 5    6    7      8
//
//spr=button sprite//
//x,y=button position//
//w,h=button width/height//
//text=button text//
//bpic=button sub pic (ex; green check mark) use -1 for no picture//
//subimg=bpics image index//
//name//
//8 arguments//
down=0
draw_set_color(c_black)
draw_sprite_stretched_ext(argument0,0,argument1,argument2,argument3,argument4,c_white,1)
if mouse_x>argument1 if mouse_y>argument2 
if mouse_x<argument1+argument3 if mouse_y<argument2+argument4 
{if mouse_check_button_released(1) {down=1} else down=0
if mouse_check_button(1)
{draw_sprite_stretched_ext(argument0,2,argument1,argument2,argument3,argument4,c_white,1)}
else {draw_sprite_stretched_ext(argument0,1,argument1,argument2,argument3,argument4,c_white,1)}
draw_set_color(c_black)
draw_set_halign(fa_right) draw_set_valign(fa_top)
draw_text(room_width-4,0,argument8)
}
if argument6=-1
{}
else {draw_sprite(argument6,argument7,argument1+argument3/2,argument2+argument4/2)}

draw_set_halign(fa_center)
draw_set_valign(fa_center)
draw_text(argument1+argument3/2,argument2+argument4/2,argument5)

return down
