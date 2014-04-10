// set the size of the screen to match the device while keeping the aspect ratio of the first view
// argument0 - Preferred orientation of game: landscape (0) or portrait (1)
// argument1 - Force portrait game to full screen width - No (0) Yes (1) 
// Choosing 1 for argument1 may result in some of your game being cut off. Only use "1" if you
// are sure that the game height will fit onto the screen of the device.
// It is only necessary to change this in portrait mode, it has no effect in landscape mode so 
// leave it as is.
if (desktest==0) {
if (os_type==os_windows||os_type==os_macosx) {
if (os_type==os_winphone||os_type==os_win8native) {
var bw,bh,w,h;
bw=browser_width;
bh=browser_height;
if (argument1==1) {
w=bw;
h=round((w/view_wview[0])*view_hview[0]);
} else {
if (argument0==0) {
w=bw;
h=round((w/view_wview[0])*view_hview[0]);
} else {
h=bh;
w=round((h/view_hview[0])*view_wview[0]);
}
}
window_set_size(w,h);
display_set_gui_size(w,h);
view_wport[0]=w;
view_hport[0]=h;
}
} else {
var bw,bh,w,h;
bw=browser_width;
bh=browser_height;
if (argument1==1) {
w=bw;
h=round((w/view_wview[0])*view_hview[0]);
} else {
if (argument0==0) {
w=bw;
h=round((w/view_wview[0])*view_hview[0]);
} else {
h=bh;
w=round((h/view_hview[0])*view_wview[0]);
}
}
window_set_size(w,h);
display_set_gui_size(w,h);
view_wport[0]=w;
view_hport[0]=h;
}
} else {
var bw,bh,w,h;
bw=browser_width;
bh=browser_height;
if (argument1==1) {
w=bw;
h=round((w/view_wview[0])*view_hview[0]);
} else {
if (argument0==0) {
w=bw;
h=round((w/view_wview[0])*view_hview[0]);
} else {
h=bh;
w=round((h/view_hview[0])*view_wview[0]);
}
}
window_set_size(w,h);
display_set_gui_size(w,h);
view_wport[0]=w;
view_hport[0]=h;
}
