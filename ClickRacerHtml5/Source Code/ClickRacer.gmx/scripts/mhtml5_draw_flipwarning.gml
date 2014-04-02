// draw the warning for flipping the phone back to the right orientation
// argument0 - expected game orientation Landscape (0) or Portrait (1)
draw_set_color(c_dkgray);
draw_rectangle(0,0,display_get_gui_width(),display_get_gui_height(),0);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
if (argument0==0) {
draw_text(display_get_gui_width()/2,64,"Please return to landscape#mode to play the game");
} else {
draw_text(display_get_gui_width()/2,64,"Please return to portrait#mode to play the game");
}
draw_set_halign(fa_left);
draw_set_valign(fa_top);
