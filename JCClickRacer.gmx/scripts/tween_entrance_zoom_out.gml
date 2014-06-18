//argument0 = duration
//argument1 = delay

tween_xscale = TweenCreate(id);
tween_yscale = TweenCreate(id);
tween_image_alpha = TweenCreate(id);

TweenPlayOnceDelay(tween_xscale, xscale__, 10, image_xscale, argument0, EaseOutCubic,argument1);
TweenPlayOnceDelay(tween_yscale, yscale__, 10, image_yscale, argument0, EaseOutCubic,argument1);
TweenPlayOnceDelay(tween_image_alpha, image_alpha__, 0, image_alpha, argument0, EaseOutCubic,argument1);
