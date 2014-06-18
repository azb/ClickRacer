//argument0 = duration
//argument1 = delay

tween_xscale = TweenCreate(id);
tween_yscale = TweenCreate(id);
tween_image_alpha = TweenCreate(id);

TweenPlayOnceDelay(tween_xscale, xscale__, image_xscale, 10, argument0, EaseInCubic,argument1);
TweenPlayOnceDelay(tween_yscale, yscale__, image_yscale, 10, argument0, EaseInCubic,argument1);
TweenPlayOnceDelay(tween_image_alpha, image_alpha__, image_alpha, 0, argument0, EaseLinear,argument1);
