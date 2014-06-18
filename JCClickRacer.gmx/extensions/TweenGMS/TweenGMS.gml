#define Ease
/*
    Ease(value1, value2, amount, ease);
*/

return script_execute(argument3, argument2, argument0, argument1 - argument0, 1);

#define TweenGMS_Init
/*
    TweenGMS_Init();
    GEX Init Function
*/

// Declare global variable for holding shared tweener instance
global.TGMS_SharedTweener = noone;

// Create Default Tween Template
global.TGMS_TweenDefault = ds_list_create();

var _tween = global.TGMS_TweenDefault;

ds_list_add(_tween, noone); // 0 instance
ds_list_add(_tween, 0); // 1 property
ds_list_add(_tween, 0); // 2 start
ds_list_add(_tween, 0); // 3 destination
ds_list_add(_tween, 0); // 4 duration
ds_list_add(_tween, 0); // 5 ease
ds_list_add(_tween, 0); // 6 play mode
ds_list_add(_tween, -1); // 7 simple tween key
ds_list_add(_tween, 0); // 8 change
ds_list_add(_tween, 0); // 9 time
ds_list_add(_tween, 1); // 10 time scale
ds_list_add(_tween, -1); // 11 state
ds_list_add(_tween, 0); // 12 group
ds_list_add(_tween, -1); // 13 on play
ds_list_add(_tween, -1); // 14 on finish
ds_list_add(_tween, -1); // 15 on stop
ds_list_add(_tween, -1); // 16 on pause
ds_list_add(_tween, -1); // 17 on resume
ds_list_add(_tween, -1); // 18 on loop
ds_list_add(_tween, -1); // 19 on repeat
ds_list_add(_tween, -1); // 20 on bounce
ds_list_add(_tween, false); // 21 use seconds?
ds_list_add(_tween, 1); // 22 direction

// Create Null Tween
global.TGMS_TweenNull = ds_list_create();
ds_list_copy(global.TGMS_TweenNull, global.TGMS_TweenDefault);

#define TweenGMS_Final
/*
    TweenGMS_Final()
    GEX Final Function
*/

// Destroy default tween template
ds_list_destroy(global.TGMS_TweenDefault);

// Destroy null tween
ds_list_destroy(global.TGMS_TweenNull);

#define SharedTweener
/*
    SharedTweener();
    Creates and/or Returns Shared Tweener Singleton
*/

if (global.TGMS_SharedTweener == noone)
{
    instance_create(-1000000, -1000000, shared_Tweener)
}

return (global.TGMS_SharedTweener);

#define SharedTweenerActivate
/*
    SharedTweenerActivate();
*/

if (global.TGMS_SharedTweener != noone)
{
    instance_activate_object(global.TGMS_SharedTweener);
}

#define TweenSystemGetTimeScale
/*
    TweenSystemGetTimeScale()
*/

return (SharedTweener()).timeScale;

#define TweenSystemSetTimeScale
/*
    TweenSystemSetTimeScale(scale)
*/

(SharedTweener()).timeScale = argument0;

#define TweenSystemGetUpdateInterval
/*
    TweenSystemGetUpdateInterval();
*/

return ((SharedTweener()).updateInterval);

#define TweenSystemSetUpdateInterval
/*
    TweenSystemSetUpdateInterval(steps);
*/

(SharedTweener()).updateInterval = argument0;

#define TweenSystemPause
/*
    TweenSystemPause();
*/

(SharedTweener()).isActive = false;

#define TweenSystemResume
/*
    TweenSystemResume();
*/

(SharedTweener()).isActive = true;

#define TweenSystemIsActive
/*
    TweenSystemIsActive();
    Returns boolean
*/

return ((SharedTweener()).isActive);

#define TweenSystemClearRoom
/*
    TweenSystemClearRoom(room);
    Clears persistent room's tween data
*/

var _sharedTweener = SharedTweener();
var _pRoomTweens = _sharedTweener.pRoomTweens;
var _pRoomDelays = _sharedTweener.pRoomDelays;
var _key = argument0;

if (ds_map_exists(_pRoomTweens, _key))
{
    var _queue = ds_map_find_value(_pRoomTweens, _key);
    
    repeat(ds_queue_size(_queue))
    {
        var _tween = ds_queue_dequeue(_queue);
        TweenDestroy(_tween);
    }
    
    ds_queue_destroy(_queue);
    ds_map_delete(_pRoomTweens, _key);
}

if (ds_map_exists(_pRoomDelays, _key))
{
    var _queue = ds_map_find_value(_pRoomDelays, _key);
    
    repeat(ds_queue_size(_queue))
    {
        var _tween = ds_queue_dequeue(_queue);
        TweenDestroy(_tween);
    }
    
    ds_queue_destroy(_queue);
    ds_map_delete(_pRoomDelays, _key);
}

#define TweenSystemClearAllRooms
/*
    TweenSystemClearAllRooms();
    Clears tween data from all persistent rooms
*/

var _sharedTweener = SharedTweener();
var _pRoomTweens = _sharedTweener.pRoomTweens;
var _pRoomDelays = _sharedTweener.pRoomDelays;

repeat(ds_map_size(_pRoomTweens))
{
    var _key = ds_map_find_first(_pRoomTweens);
    var _queue = ds_map_find_value(_pRoomTweens, _key);
    
    repeat(ds_queue_size(_queue))
    {
        var _tween = ds_queue_dequeue(_queue);
        TweenDestroy(_tween);
    }
    
    ds_queue_destroy(_queue);
    ds_map_delete(_pRoomTweens, _key);
}



repeat(ds_map_size(_pRoomDelays))
{
    var _key = ds_map_find_first(_pRoomDelays);
    var _queue = ds_map_find_value(_pRoomDelays, _key);
    
    repeat(ds_queue_size(_queue))
    {
        var _tween = ds_queue_dequeue(_queue);
        TweenDestroy(_tween);
    }
    
    ds_queue_destroy(_queue);
    ds_map_delete(_pRoomDelays, _key);
}

#define TweenCreate
/*
    TweenCreate(instance, use_seconds);
*/

// Cache shared tweener
var _sharedTweener = SharedTweener();

// Create data structure to hold tween data
var _tween = ds_list_create(); 

// Copy default tween data
ds_list_copy(_tween, global.TGMS_TweenDefault);

// Set tweened instance
ds_list_replace(_tween, 0, argument[0]);

// Assign default time scale
ds_list_replace(_tween, 10, _sharedTweener.tweenDefaultTimeScale);

// Add tween to system tween list
ds_list_add(_sharedTweener.tweens, _tween);

// Set delta flag
if (argument_count == 1)
{
    ds_list_replace(_tween, 21, false);
}
else
if (argument_count == 2)
{
    ds_list_replace(_tween, 21, argument[1]);
}
else
{
   show_error("Wrong number of arguments supplied", false); 
}

// Return tween handle
return _tween;



#define TweenDeltaCreate
/*
    TweenDeltaCreate(instance);
*/

//  Create data structure to hold tween data
var _tween = ds_list_create(); 

//  Copy default tween data
ds_list_copy(_tween, global.TGMS_TweenDefault);

//  Set tweened instance
ds_list_replace(_tween, 0, argument0);

// Assign default time scale
ds_list_replace(_tween, 10, _sharedTweener.tweenDefaultTimeScale);

//  Set delta boolean
ds_list_replace(_tween, 21, true);

//  Place tween into automated tween list
ds_list_add(SharedTweener().tweens, _tween);

//  Return tween handle
return _tween;

#define TweenNull
/*
    TweenNull();
*/

return global.TGMS_TweenNull;

#define TweenDestroy
/*
    TweenDestroy(tween);
*/

//  Mark tween for destruction
ds_list_replace(argument0, 0, noone);
ds_list_replace(argument0, 11, -2);

return global.TGMS_TweenNull;

#define TweenDestroyAll
/*
    TweenDestroyAll();
*/

var _sharedTweener = SharedTweener();
var _tweens = _sharedTweener.tweens;

var _index = ds_list_size(_tweens);
while(_index--)
{    
    TweenDestroy(ds_list_find_value(_tweens, _index));
}

#define TweenDestroyGroup
/*
    TweenDestroyGroup(group);
*/

var _sharedTweener = SharedTweener();
var _tweens = _sharedTweener.tweens;

var _index = ds_list_size(_tweens);
while(_index--)
{    
    var _tween = ds_list_find_value(_tweens, _index);
    
    if (TweenGetGroup(_tween) == argument0)
        TweenDestroy(_tween);
}


#define TweenPlayOnce
/*
    TweenPlayOnce(tween, property, start, destination, duration, ease);
*/

var _tween = argument0;

if (ds_list_find_value(_tween, 11) != -2)
{
    ds_list_replace(_tween, 1, argument1); // set property
    ds_list_replace(_tween, 2, argument2); // Set start
    ds_list_replace(_tween, 3, argument3); // Set destination
    ds_list_replace(_tween, 4, argument4); // Set duration
    ds_list_replace(_tween, 5, argument5); // Set easing algorithm
    ds_list_replace(_tween, 6, TWEEN_PLAY_ONCE); // Set TWEEN_PLAY mode
    ds_list_replace(_tween, 8, argument3 - argument2); // Set calculated change (destination - start)
    ds_list_replace(_tween, 9, 0); // Set timer value to 0
    ds_list_replace(_tween, 10, abs(ds_list_find_value(_tween, 10)));
    ds_list_replace(_tween, 11, 1); // Set tween state to active
    ds_list_replace(_tween, 22, 1); // Set direction as forward
    with(ds_list_find_value(_tween, 0)) script_execute(argument1, argument2); // Set tweened variable to start value
    ExecuteTweenEvent(ds_list_find_value(_tween, 13));
}

#define TweenPlayLoop
/*
    TweenPlayLoop(tween, property, start, destination, duration, ease);
*/

TweenPlayOnce(argument0, argument1, argument2, argument3, argument4, argument5);
ds_list_replace(argument0, 6, TWEEN_PLAY_LOOP);

#define TweenPlayRepeat
/*
    TweenPlayRepeat(tween, property, start, destination, duration, ease);
*/

TweenPlayOnce(argument0, argument1, argument2, argument3, argument4, argument5);
ds_list_replace(argument0, 6, TWEEN_PLAY_REPEAT);

#define TweenPlayBounce
/*
    TweenPlayBounce(tween, property, start, destination, duration, ease);
*/

TweenPlayOnce(argument0, argument1, argument2, argument3, argument4, argument5);
ds_list_replace(argument0, 6, TWEEN_PLAY_BOUNCE);

#define TweenPlayPatrol
/*
    TweenPlayPatrol(tween, property, start, destination, duration, ease);
*/

TweenPlayOnce(argument0, argument1, argument2, argument3, argument4, argument5);
ds_list_replace(argument0, 6, TWEEN_PLAY_PATROL);

#define TweenPlayOnceDelay
/*
    TweenPlayOnceDelay(tween, property, start, destination, duration, ease);
*/

var _delay = ds_list_create();

ds_list_add(_delay, argument0); // tween
ds_list_add(_delay, argument1); // property
ds_list_add(_delay, argument2); // start
ds_list_add(_delay, argument3); // destination
ds_list_add(_delay, argument4); // duration
ds_list_add(_delay, argument5); // ease
ds_list_add(_delay, argument6); // delay
ds_list_add(_delay, TWEEN_PLAY_ONCE); // play mode
ds_list_add(_delay, ds_list_find_value(argument0, 21)); // isDelta
ds_list_add(_delay, 1); // state (stopped = -1, paused = 0, playing = 1)
ds_list_add(_delay, -1); // used for holding second delay for simple tweens
ds_list_add((SharedTweener()).delayedTweens, _delay);

return _delay;

#define TweenPlayLoopDelay
/*
    TweenPlayRepeatDelay(tween, property, start, destination, duration, ease, delay);
*/

var _delay = TweenPlayOnceDelay(argument0, argument1, argument2, argument3, argument4, argument5, argument6);
ds_list_replace(_delay, 7, TWEEN_PLAY_LOOP);
return _delay;


#define TweenPlayRepeatDelay
/*
    TweenPlayRepeatDelay(tween, property, start, destination, duration, ease, delay);
*/

var _delay = TweenPlayOnceDelay(argument0, argument1, argument2, argument3, argument4, argument5, argument6);
ds_list_replace(_delay, 7, TWEEN_PLAY_REPEAT);
return _delay;


#define TweenPlayBounceDelay
/*
    TweenPlayBounceDelay(tween, property, start, destination, duration, ease, delay);
*/

var _delay = TweenPlayOnceDelay(argument0, argument1, argument2, argument3, argument4, argument5, argument6);
ds_list_replace(_delay, 7, TWEEN_PLAY_BOUNCE);
return _delay;


#define TweenPlayPatrolDelay
/*
    TweenPlayBounceDelay(tween, tween, start, destination, duration, ease, delay);
*/

var _delay = TweenPlayOnceDelay(argument0, argument1, argument2, argument3, argument4, argument5, argument6);
ds_list_replace(_delay, 7, TWEEN_PLAY_PATROL);
return _delay;


#define TweenStop
/* 
    TweenStop(tween);
*/

if (ds_list_find_value(argument0, 11) != -2)
{
    ds_list_replace(argument0, 11, -1);
    ExecuteTweenEvent(ds_list_find_value(argument0, 15));
}

#define TweenStopAll
/*
    TweenStopAll();
*/

var _sharedTweener = SharedTweener();
var _tweens = _sharedTweener.tweens;

for (var i = 0, _maxIndex = ds_list_size(_tweens); i < _maxIndex; i++)
{
    TweenStop(ds_list_find_value(_tweens, i));
}


#define TweenStopGroup
/*
    TweenStopGroup(group);
*/

var _sharedTweener = SharedTweener();
var _tweens = _sharedTweener.tweens;

for (var i = 0, _maxIndex = ds_list_size(_tweens); i < _maxIndex; i++)
{
    var _tween = ds_list_find_value(_tweens, i);
    
    if (ds_list_find_value(_tween, 12) == argument0)
        TweenStop(_tween);
}


#define TweenPause
/*
    TweenPause(tween);
*/

if (ds_list_find_value(argument0, 11) == 1)
{
    ds_list_replace(argument0, 11, 0);
    ExecuteTweenEvent(ds_list_find_value(argument0, 16));
}

#define TweenPauseAll
/*
    TweenPauseAll();
*/

var _sharedTweener = SharedTweener();
var _tweens = _sharedTweener.tweens;

for (var i = 0, _maxIndex = ds_list_size(_tweens); i < _maxIndex; i++)
{
    TweenPause(ds_list_find_value(_tweens, i));
}


#define TweenPauseGroup
/*
    TweenPauseGroup(group);
*/

var _sharedTweener = SharedTweener();
var _tweens = _sharedTweener.tweens;

for (var i = 0, _maxIndex = ds_list_size(_tweens); i < _maxIndex; i++)
{
    var _tween = ds_list_find_value(_tweens, i);
    
    if (ds_list_find_value(_tween, 12) == argument0)
        TweenPause(_tween);
}


#define TweenResume
/*
    TweenResume(tween);
*/

if (ds_list_find_value(argument0, 11) == 0)
{
    ds_list_replace(argument0, 11, 1);
    ExecuteTweenEvent(ds_list_find_value(argument0, 17));
}

#define TweenResumeAll
/*
    TweenResumeAll();
*/

var _sharedTweener = SharedTweener();
var _tweens = _sharedTweener.tweens;

for (var i = 0, _maxIndex = ds_list_size(_tweens); i < _maxIndex; i++)
{
    TweenResume(ds_list_find_value(_tweens, i));
}


#define TweenResumeGroup
/*
    TweenResumeGroup(group);
*/

var _sharedTweener = SharedTweener();
var _tweens = _sharedTweener.tweens;

for (var i = 0, _maxIndex = ds_list_size(_tweens); i < _maxIndex; i++)
{
    var _tween = ds_list_find_value(_tweens, i);
    
    if (ds_list_find_value(_tween, 12) == argument0)
    {
        TweenResume(_tween);
    }
}


#define TweenReverse
/*
    TweenReverse(tween);
*/

ds_list_replace(argument0, 22, -ds_list_find_value(argument0, 22));
ds_list_replace(argument0, 10, -ds_list_find_value(argument0, 10));

#define TweenReverseAll
/*
    TweenReverseAll();
*/

var _sharedTweener = SharedTweener();
var _tweens = _sharedTweener.tweens;

for (var i = 0, _maxIndex = ds_list_size(_tweens); i < _maxIndex; i++)
{
    TweenReverse(ds_list_find_value(_tweens, i));
}

#define TweenReverseGroup
/*
    TweenReverseGroup(group);
*/

var _sharedTweener = SharedTweener();
var _tweens = _sharedTweener.tweens;

for (var i = 0, _maxIndex = ds_list_size(_tweens); i < _maxIndex; i++)
{
    _tween = ds_list_find_value(_tweens, i);
    
    if (ds_list_find_value(_tween, 12) == argument0)
    {
        TweenReverse(_tween);
    }
}


#define TweenSimpleUseDelta
/*
    TweenSimpleUseDelta(bool)
*/

(SharedTweener()).useSimpleDeltaTweens = argument0;

#define TweenSimpleMove
/*
    TweenSimpleMove(xStart, yStart, xDest, yDest, duration, ease);
*/

var _key = (id + 100000000);

if (ds_map_exists((SharedTweener()).simpleTweens, _key) == false)
{
    ds_map_add((SharedTweener()).simpleTweens, _key, id);

        TGMS_simple_x = TweenCreate(id);
        TGMS_simple_y = TweenCreate(id);
    
    ds_list_replace(TGMS_simple_x, 7, _key);
}

TweenUseDelta(TGMS_simple_x, SharedTweener().useSimpleDeltaTweens);
TweenUseDelta(TGMS_simple_y, SharedTweener().useSimpleDeltaTweens);

TweenPlayOnce(TGMS_simple_x, x__, argument0, argument2, argument4, argument5);
TweenPlayOnce(TGMS_simple_y, y__, argument1, argument3, argument4, argument5);

#define TweenSimpleMoveInt
/*
    TweenSimpleMoveRound(xStart, yStart, xDest, yDest, duration, ease);
*/

var _key = id + 100000000;

if (ds_map_exists((SharedTweener()).simpleTweens, _key) == false)
{
    ds_map_add((SharedTweener()).simpleTweens, _key, id);
    
    TGMS_simple_x = TweenCreate(id);
    TGMS_simple_y = TweenCreate(id);
    
    ds_list_replace(TGMS_simple_x, 7, _key);
}

TweenUseDelta(TGMS_simple_x, SharedTweener().useSimpleDeltaTweens);
TweenUseDelta(TGMS_simple_y, SharedTweener().useSimpleDeltaTweens);

TweenPlayOnce(TGMS_simple_x, x__int, argument0, argument2, argument4, argument5);
TweenPlayOnce(TGMS_simple_y, y__int, argument1, argument3, argument4, argument5);

#define TweenSimpleFade
/*
    TweenSimpleFade(alpha1, alpha2, duration, ease);
*/

var _key = id + 200000000;

if (ds_map_exists((SharedTweener()).simpleTweens, _key) == false)
{
    ds_map_add((SharedTweener()).simpleTweens, _key, id);
    
    if ((SharedTweener()).useSimpleDeltaTweens)
    {
        TGMS_simple_fade = TweenCreate(id, true);
    }
    else
    {
        TGMS_simple_fade = TweenCreate(id, false);
    }
    
    ds_list_replace(TGMS_simple_fade, 7, _key);
}

if (TweenIsDelta(TGMS_simple_fade) != SharedTweener().useSimpleDeltaTweens)
{
    TweenUseDelta(TGMS_simple_fade, !(TweenIsDelta(TGMS_simple_fade)));
}

TweenPlayOnce(TGMS_simple_fade, image_alpha__, argument0, argument1, argument2, argument3);

#define TweenSimpleScale
/*
    TweenSimpleScale(xScale1, yScale1, xScale2, yScale2, duration, ease);
*/

var _key = id + 300000000;

if (ds_map_exists((SharedTweener()).simpleTweens, _key) == false)
{
    ds_map_add((SharedTweener()).simpleTweens, _key, id);
    
    TGMS_simple_xscale = TweenCreate(id);
    TGMS_simple_yscale = TweenCreate(id);
    
    ds_list_replace(TGMS_simple_xscale, 7, _key);
}

TweenUseDelta(TGMS_simple_xscale, SharedTweener().useSimpleDeltaTweens);
TweenUseDelta(TGMS_simple_yscale, SharedTweener().useSimpleDeltaTweens);

TweenPlayOnce(TGMS_simple_xscale , image_xscale__, argument0, argument2, argument4, argument5);
TweenPlayOnce(TGMS_simple_yscale , image_yscale__, argument1, argument3, argument4, argument5);

#define TweenSimpleTurn
/*
    TweenSimpleTurn(direction1, direction2, duration, ease);
*/

var _key = id + 400000000;;

if (ds_map_exists((SharedTweener()).simpleTweens, _key) == false)
{
    ds_map_add((SharedTweener()).simpleTweens, _key, id);
    
    TGMS_simple_turn = TweenCreate(id);
    
    ds_list_replace(TGMS_simple_turn, 7, _key);
}

TweenUseDelta(TGMS_simple_turn, SharedTweener().useSimpleDeltaTweens);
TweenPlayOnce(TGMS_simple_turn, direction__, argument0, argument1, argument2, argument3);


#define TweenSimpleRotate
/*
    TweenSimpleRotate(angle1, angle2, duration, ease);
*/

var _key = id + 500000000;

if (ds_map_exists((SharedTweener()).simpleTweens, _key) == false)
{
    ds_map_add((SharedTweener()).simpleTweens, _key, id);
    
    TGMS_simple_rotate = TweenCreate(id);

    ds_list_replace(TGMS_simple_rotate, 7, _key);
}

TweenUseDelta(TGMS_simple_rotate, SharedTweener().useSimpleDeltaTweens);
TweenPlayOnce(TGMS_simple_rotate, image_angle__, argument0, argument1, argument2, argument3);

#define TweenSimpleImageCycle
/*
    TweenSimpleImageCycle(alpha1, alpha2, duration, ease);
*/

var _key = id + 600000000;;

if (ds_map_exists((SharedTweener()).simpleTweens, _key) == false)
{
    ds_map_add((SharedTweener()).simpleTweens, _key, id);
    
    TGMS_simple_image_cycle = TweenCreate(id);

    ds_list_replace(TGMS_simple_image_cycle, 7, _key);
}

TweenUseDelta(TGMS_simple_image_cycle, SharedTweener().useSimpleDeltaTweens);
TweenPlayOnce(TGMS_simple_image_cycle, image_index__, argument0, argument1, argument2, argument3);

#define TweenSimpleSpeedRamp
/*
    TweenSimpleSpeedRamp(speed1, speed2, duration, ease);
*/

var _key = id + 700000000;;

if (ds_map_exists((SharedTweener()).simpleTweens, _key) == false)
{
    ds_map_add((SharedTweener()).simpleTweens, _key, id);
    
    TGMS_simple_speed_ramp = TweenCreate(id);
    
    ds_list_replace(TGMS_simple_speed_ramp, 7, _key);
}

TweenUseDelta(TGMS_simple_speed_ramp, SharedTweener().useSimpleDeltaTweens);
TweenPlayOnce(TGMS_simple_speed_ramp, speed__, argument0, argument1, argument2, argument3);

#define TweenSimpleHVSpeedRamp
/*
    TweenSimpleHVSpeedRamp(hspeed1, vspeed1, hspeed2, vspeed2, duration, ease);
*/

var _key = id + 800000000;

if (ds_map_exists((SharedTweener()).simpleTweens, _key) == false)
{
    ds_map_add((SharedTweener()).simpleTweens, _key, id);
    
    TGMS_simple_hspeed_ramp = TweenCreate(id);
    TGMS_simple_vspeed_ramp = TweenCreate(id);
    
    ds_list_replace(TGMS_simple_hspeed_ramp, 7, _key);
}

TweenUseDelta(TGMS_simple_hspeed_ramp, SharedTweener().useSimpleDeltaTweens);
TweenUseDelta(TGMS_simple_vspeed_ramp, SharedTweener().useSimpleDeltaTweens);
TweenPlayOnce(TGMS_simple_hspeed_ramp, hspeed__, argument0, argument2, argument4, argument5);
TweenPlayOnce(TGMS_simple_vspeed_ramp, vspeed__, argument1, argument3, argument4, argument5);

#define TweenSimpleMoveDelay
/*
    TweenSimpleMoveDelay(xStart, yStart, xDest, yDest, duration, ease, delay);
*/

var _key = id + 100000000;

if (ds_map_exists((SharedTweener()).simpleTweens, _key) == false)
{
    ds_map_add((SharedTweener()).simpleTweens, _key, id);
    
    TGMS_simple_x = TweenCreate(id);
    TGMS_simple_y = TweenCreate(id);
    
    ds_list_replace(TGMS_simple_x, 7, _key);
}


TweenUseDelta(TGMS_simple_x, SharedTweener().useSimpleDeltaTweens);
TweenUseDelta(TGMS_simple_y, SharedTweener().useSimpleDeltaTweens);

var _delay1 = TweenPlayOnceDelay(TGMS_simple_x, x__, argument0, argument2, argument4, argument5, argument6);
var _delay2 = TweenPlayOnceDelay(TGMS_simple_y, y__, argument1, argument3, argument4, argument5, argument6);

ds_list_replace(_delay1, 10, _delay2);

return _delay1;

#define TweenSimpleMoveIntDelay
/*
    TweenSimpleMoveRoundDelay(xStart, yStart, xDest, yDest, duration, ease, delay);
*/

var _key = id + 100000000;

if (ds_map_exists((SharedTweener()).simpleTweens, _key) == false)
{
    ds_map_add((SharedTweener()).simpleTweens, _key, id);
    
    TGMS_simple_x = TweenCreate(id);
    TGMS_simple_y = TweenCreate(id);
    
    ds_list_replace(TGMS_simple_x, 7, _key);
}

TweenUseDelta(TGMS_simple_x, SharedTweener().useSimpleDeltaTweens);
TweenUseDelta(TGMS_simple_y, SharedTweener().useSimpleDeltaTweens);

var _delay1 = TweenPlayOnceDelay(TGMS_simple_x, x__int, argument0, argument2, argument4, argument5, argument6);
var _delay2 = TweenPlayOnceDelay(TGMS_simple_y, y__int, argument1, argument3, argument4, argument5, argument6);

ds_list_replace(_delay1, 10, _delay2);

return _delay1;

#define TweenSimpleFadeDelay
/*
    TweenSimpleFadeDelay(alphaStart, alphaEnd, duration, ease, delay);
*/

var _key = id + 200000000;

if (ds_map_exists((SharedTweener()).simpleTweens, _key) == false)
{
    ds_map_add((SharedTweener()).simpleTweens, _key, id);
    
    TGMS_simple_fade = TweenCreate(id);
    
    ds_list_replace(TGMS_simple_fade, 7, _key);
}

TweenUseDelta(TGMS_simple_fade, SharedTweener().useSimpleDeltaTweens);

return TweenPlayOnceDelay(TGMS_simple_fade, image_alpha__, argument0, argument1, argument2, argument3, argument4);

#define TweenSimpleScaleDelay
/*
    TweenSimpleScaleDelay(xStart, yStart, xDest, yDest, duration, ease, delay);
*/

var _key = id + 300000000;

if (ds_map_exists((SharedTweener()).simpleTweens, _key) == false)
{
    ds_map_add((SharedTweener()).simpleTweens, _key, id);
    
    TGMS_simple_xscale = TweenCreate(id);
    TGMS_simple_yscale = TweenCreate(id);

    ds_list_replace(TGMS_simple_xscale, 7, _key);
}

TweenUseDelta(TGMS_simple_xscale, SharedTweener().useSimpleDeltaTweens);
TweenUseDelta(TGMS_simple_yscale, SharedTweener().useSimpleDeltaTweens);

var _delay1 = TweenPlayOnceDelay(TGMS_simple_xscale , image_xscale__, argument0, argument2, argument4, argument5, argument6);
var _delay2 = TweenPlayOnceDelay(TGMS_simple_yscale , image_yscale__, argument1, argument3, argument4, argument5, argument6);

ds_list_replace(_delay1, 10, _delay2);

return _delay1;

#define TweenSimpleTurnDelay
/*
    TweenSimpleTurnDelay(direction_start, direction_end, duration, ease, delay);
*/

var _key = id + 400000000;

if (ds_map_exists((SharedTweener()).simpleTweens, _key) == false)
{
    ds_map_add((SharedTweener()).simpleTweens, _key, id);
    
    TGMS_simple_turn = TweenCreate(id);
    
    ds_list_replace(TGMS_simple_turn, 7, _key);
}

TweenUseDelta(TGMS_simple_turn, SharedTweener().useSimpleDeltaTweens);

return TweenPlayOnceDelay(TGMS_simple_turn, direction__, argument0, argument1, argument2, argument3, argument4);

#define TweenSimpleRotateDelay
/*
    TweenSimpleRotateDelay(angle_start, angle_end, duration, ease, delay);
*/

var _key = id + 500000000;

if (ds_map_exists((SharedTweener()).simpleTweens, _key) == false)
{
    ds_map_add((SharedTweener()).simpleTweens, _key, id);
    
    TGMS_simple_rotate = TweenCreate(id);
    
    ds_list_replace(TGMS_simple_rotate, 7, _key);
}

TweenUseDelta(TGMS_simple_rotate, SharedTweener().useSimpleDeltaTweens);

return TweenPlayOnceDelay(TGMS_simple_rotate, image_angle__, argument0, argument1, argument2, argument3, argument4);

#define TweenSimpleImageCycleDelay
/*
    TweenSimpleImageCycleDelay(alphaStart, alphaEnd, duration, ease, delay);
*/

var _key = id + 600000000;

if (ds_map_exists((SharedTweener()).simpleTweens, _key) == false)
{
    ds_map_add((SharedTweener()).simpleTweens, _key, id);
    
    TGMS_simple_image_cycle = TweenCreate(id);
    
    ds_list_replace(TGMS_simple_image_cycle, 7, _key);
}

TweenUseDelta(TGMS_simple_image_cycle, SharedTweener().useSimpleDeltaTweens);

return TweenPlayOnceDelay(TGMS_simple_image_cycle, image_index__, argument0, argument1, argument2, argument3, argument4);

#define TweenSimpleSpeedRampDelay
/*
    TweenSimpleSpeedRampDelay(speed1, speed2, duration, ease, delay);
*/

var _key = id + 700000000;

if (ds_map_exists((SharedTweener()).simpleTweens, _key) == false)
{
    ds_map_add((SharedTweener()).simpleTweens, _key, id);
    
    TGMS_simple_speed_ramp = TweenCreate(id);
    
    ds_list_replace(TGMS_simple_speed_ramp, 7, _key);
}

TweenUseDelta(TGMS_simple_speed_ramp, SharedTweener().useSimpleDeltaTweens);

return TweenPlayOnceDelay(TGMS_simple_speed_ramp, speed__, argument0, argument1, argument2, argument3, argument4);

#define TweenSimpleHVSpeedRampDelay
/*
    TweenSimpleHVSpeedRampDelay(hspeed1, vspeed1, hspeed2, vspeed2, duration, ease, delay);
*/

var _key = id + 800000000;

if (ds_map_exists((SharedTweener()).simpleTweens, _key) == false)
{
    ds_map_add((SharedTweener()).simpleTweens, _key, id);
    
    TGMS_simple_hspeed_ramp = TweenCreate(id);
    TGMS_simple_vspeed_ramp = TweenCreate(id);
    
    ds_list_replace(TGMS_simple_hspeed_ramp, 7, _key);
}

TweenUseDelta(TGMS_simple_hspeed_ramp, SharedTweener().useSimpleDeltaTweens);
TweenUseDelta(TGMS_simple_vspeed_ramp, SharedTweener().useSimpleDeltaTweens);

var _delay1 = TweenPlayOnceDelay(TGMS_simple_hspeed_ramp, hspeed__, argument0, argument2, argument4, argument5, argument6);
var _delay2 = TweenPlayOnceDelay(TGMS_simple_vspeed_ramp, vspeed__, argument1, argument3, argument4, argument5, argument6);

ds_list_replace(_delay1, 10, _delay2);

return _delay1;

#define TweenDelayNull
/*
    TweenDelayNull()
*/

return -1;

#define TweenDelayCancel
/*
    TweenDelayCancel(delay_handle);
*/

var _sharedTweener = SharedTweener();

if (ds_list_find_index(_sharedTweener.delayedTweens, argument0) != -1)
{
    ds_priority_add(_sharedTweener.delayCleaner, argument0, argument0);
    
    var _delay2 = ds_list_find_value(argument0, 10);
    
    if (_delay2 != -1)
    {
        ds_priority_add(_sharedTweener.delayCleaner, _delay2, _delay2);
    }
}

#define TweenDelayPause
/*
    TweenDelayPause(delay_handle);
*/

if (ds_list_find_index((SharedTweener()).delayedTweens, argument0) != -1)
{
    if (ds_list_find_value(argument0, 9) != -1)
    {
        ds_list_replace(argument0, 9, 0);
        
        if (ds_list_find_value(argument0, 10) != -1)
        {
            ds_list_replace(ds_list_find_value(argument0, 10), 9, 0);
        }
    }
}

    

#define TweenDelayResume
/*
    TweenDelayResume(delay_handle)
*/

if (ds_list_find_index((SharedTweener().delayedTweens), argument0) != -1)
{
    if (ds_list_find_value(argument0, 9) != -1)
    {
        ds_list_replace(argument0, 9, 1);
        
        if (ds_list_find_value(argument0, 10) != -1)
        {
            ds_list_replace(ds_list_find_value(argument0, 10), 9, 1);
        }
    }
}

#define TweenStepNext
/*
    TweenStepNext(tween)
*/

var _tween = argument0;
var _instance = ds_list_find_value(_tween, 0); //  Cache Tweened Instance       

if ( (instance_exists(_instance)) && (ds_list_find_value(_tween, 11) != -1) )
{ 
    // Update tween time
    if (ds_list_find_value(_tween, 21))
    {
        // Adjust time by tween's time scale multiplied by system scaled delta time
        var _time = ds_list_find_value(_tween, 9) + ds_list_find_value(_tween, 10) * SharedTweener().deltaTime;
    }
    else
    {
        // Adjust time by tween's time scale multiplied by system time scale
        var _time = ds_list_find_value(_tween, 9) + ds_list_find_value(_tween, 10) * SharedTweener().timeScale;
    }
    
    // Assign updated time to tween
    ds_list_replace(_tween, 9, _time);
    
    // Cache tween duration
    var _duration = ds_list_find_value(_tween, 4);
    
    // IF time between start and finish, update tweened property
    // ELSE the start or finish boundary has been reached
    if ((_time > 0) && (_time < _duration))
    {
        with(_instance) script_execute(ds_list_find_value(_tween, 1), script_execute(ds_list_find_value(_tween, 5), _time, ds_list_find_value(_tween, 2), ds_list_find_value(_tween, 8), _duration));
    }
    else 
    if (SharedTweener().timeScale != 0 && ds_list_find_value(_tween, 10) != 0)
    {       
        // Update tween properties based on playmode
        switch(ds_list_find_value(_tween, 6))
        {
        case TWEEN_PLAY_ONCE:
            // Set tween state as 'stopped'
            ds_list_replace(_tween, 11, -1); 
            
            if (_time > 0)
            {
                // Set tweened variable to destination
                with(_instance) script_execute(ds_list_find_value(_tween, 1), ds_list_find_value(_tween, 3));
            }
            else
            {
                // Set tweened variable to start position
                with(_instance) script_execute(ds_list_find_value(_tween, 1), ds_list_find_value(_tween, 2));
            }
            
            // Execute finish event
            ExecuteTweenEvent(ds_list_find_value(_tween, 14));
            break;
            
        case TWEEN_PLAY_LOOP:
            // IF tween's time is positive, jump to start
            // ELSE jump to the end
            if (_time > 0)
            {
                // Set time back to start
                ds_list_replace(_tween, 9, 0);
                
                // Set tweened variable to destination
                with(_instance) script_execute(ds_list_find_value(_tween, 1), ds_list_find_value(_tween, 3));
                
            }
            else 
            {
                // Set time to duration
                ds_list_replace(_tween, 9, TweenGetDuration(_tween));
                
                // Set tweened variable to start position
                with(_instance) script_execute(ds_list_find_value(_tween, 1), ds_list_find_value(_tween, 2));
            }
                
            // Execute loop event
            ExecuteTweenEvent(ds_list_find_value(_tween, 18));
            break;
            
        case TWEEN_PLAY_REPEAT:
            if (_time > 0)
            {
                // Set time back to start
                ds_list_replace(_tween, 9, 0);
                
                // Set tweened variable to destination
                with(_instance) script_execute(ds_list_find_value(_tween, 1), ds_list_find_value(_tween, 3));
                
                // Cache tween destination
                var _dest = TweenGetDestination(_tween);
                
                // Calculate new destination
                var _newDest = _dest + TweenGetChange(_tween);
                
                // Set start position to previous destination
                ds_list_replace(_tween, 2, _dest);
                
                // Set new destination
                TweenSetDestination(_tween, _newDest);
            }
            else
            {
                // Set time to duration
                ds_list_replace(_tween, 9, TweenGetDuration(_tween));
                
                // Set tweened variable to start position
                with(_instance) script_execute(ds_list_find_value(_tween, 1), ds_list_find_value(_tween, 2));
                
                // Cache start position
                var _start = TweenGetStart(_tween);
                
                // Calculate new starting position
                var _newStart = _start - TweenGetChange(_tween);
                
                // Assign new starting position
                ds_list_replace(_tween, 2, _newStart);
                
                // Set destination to previous start position
                TweenSetDestination(_tween, _start)
            }
            
            // Execute repeat event
            ExecuteTweenEvent(ds_list_find_value(_tween, 19));
            break;
            
        case TWEEN_PLAY_BOUNCE:
            // IF time larger than 0, bounce the tween back to start
            // ELSE have the tween finish
            if (_time > 0)
            {
                // Adjust for time "overflow"
                ds_list_replace(_tween, 9, _duration - (_time - _duration));
                
                // Set tweened variable to destination
                with(_instance) script_execute(ds_list_find_value(_tween, 1), ds_list_find_value(_tween, 3));
            
                // Reverse tween direction
                TweenReverse(_tween);
                
                // Execute bounce event
                ExecuteTweenEvent(ds_list_find_value(_tween, 20));
            }
            else
            {
                // Stop tween
                ds_list_replace(_tween, 11, -1); 
                
                // Set tweened variable to start
                with(_instance) script_execute(ds_list_find_value(_tween, 1), ds_list_find_value(_tween, 2)); 
                
                // Execute finish event
                ExecuteTweenEvent(ds_list_find_value(_tween, 14)); 
            }
            break;
            
        case TWEEN_PLAY_PATROL:
            // Adjust for time "overflow"
            if (_time > 0)
            {
                // Step back if needed
                ds_list_replace(_tween, 9, _duration - (_time - _duration));
                
                // Set tweened variable to destination
                with(_instance) script_execute(ds_list_find_value(_tween, 1), ds_list_find_value(_tween, 3));
                
            }
            else
            {
                // Step forward if needed
                ds_list_replace(_tween, 9, -_time);
                
                // Set tweened variable to start position
                with(_instance) script_execute(ds_list_find_value(_tween, 1), ds_list_find_value(_tween, 2));
            }
            
            // Reverse tween direction
            TweenReverse(_tween);
            
            // Execute bounce event
            ExecuteTweenEvent(ds_list_find_value(_tween, 20));
            break;
            
        default: 
            // Display warning message
            show_error("Invalid Tween Play Mode!", false);
            
            // Destroy tween so game can continue without further errors
            TweenDestroy(_tween);
        }
    }
}
                

#define TweenStepPrevious
/*
    TweenStepNext(tween)
*/

var _tween = argument0;
var _instance = ds_list_find_value(_tween, 0); //  Cache Tweened Instance       

if ( (instance_exists(_instance)) && (ds_list_find_value(_tween, 11) != -1) )
{ 
    // Update tween time
    if (ds_list_find_value(_tween, 21))
    {
        // Adjust time by tween's time scale multiplied by system scaled delta time
        var _time = ds_list_find_value(_tween, 9) - ds_list_find_value(_tween, 10) * SharedTweener().deltaTime;
    }
    else
    {
        // Adjust time by tween's time scale multiplied by system time scale
        var _time = ds_list_find_value(_tween, 9) - ds_list_find_value(_tween, 10) * SharedTweener().timeScale;
    }
    
    // Assign updated time to tween
    ds_list_replace(_tween, 9, _time);
    
    // Cache tween duration
    var _duration = ds_list_find_value(_tween, 4);
    
    // IF time between start and finish, update tweened property
    // ELSE the start or finish boundary has been reached
    if ((_time > 0) && (_time < _duration))
    {
        with(_instance) script_execute(ds_list_find_value(_tween, 1), script_execute(ds_list_find_value(_tween, 5), _time, ds_list_find_value(_tween, 2), ds_list_find_value(_tween, 8), _duration));
    }
    else 
    if (SharedTweener().timeScale != 0 && ds_list_find_value(_tween, 10) != 0)
    {       
        // Update tween properties based on playmode
        switch(ds_list_find_value(_tween, 6))
        {
        case TWEEN_PLAY_ONCE:
            // Set tween state as 'stopped'
            ds_list_replace(_tween, 11, -1); 
            
            if (_time > 0)
            {
                // Set tweened variable to destination
                with(_instance) script_execute(ds_list_find_value(_tween, 1), ds_list_find_value(_tween, 3));
            }
            else
            {
                // Set tweened variable to start position
                with(_instance) script_execute(ds_list_find_value(_tween, 1), ds_list_find_value(_tween, 2));
            }
            
            // Execute finish event
            ExecuteTweenEvent(ds_list_find_value(_tween, 14));
            break;
            
        case TWEEN_PLAY_LOOP:
            // IF tween's time is positive, jump to start
            // ELSE jump to the end
            if (_time > 0)
            {
                // Set time back to start
                ds_list_replace(_tween, 9, 0);
                
                // Set tweened variable to destination
                with(_instance) script_execute(ds_list_find_value(_tween, 1), ds_list_find_value(_tween, 3));
                
            }
            else 
            {
                // Set time to duration
                ds_list_replace(_tween, 9, TweenGetDuration(_tween));
                
                // Set tweened variable to start position
                with(_instance) script_execute(ds_list_find_value(_tween, 1), ds_list_find_value(_tween, 2));
            }
                
            // Execute loop event
            ExecuteTweenEvent(ds_list_find_value(_tween, 18));
            break;
            
        case TWEEN_PLAY_REPEAT:
            if (_time > 0)
            {
                // Set time back to start
                ds_list_replace(_tween, 9, 0);
                
                // Set tweened variable to destination
                with(_instance) script_execute(ds_list_find_value(_tween, 1), ds_list_find_value(_tween, 3));
                
                // Cache tween destination
                var _dest = TweenGetDestination(_tween);
                
                // Calculate new destination
                var _newDest = _dest + TweenGetChange(_tween);
                
                // Set start position to previous destination
                ds_list_replace(_tween, 2, _dest);
                
                // Set new destination
                TweenSetDestination(_tween, _newDest);
            }
            else
            {
                // Set time to duration
                ds_list_replace(_tween, 9, TweenGetDuration(_tween));
                
                // Set tweened variable to start position
                with(_instance) script_execute(ds_list_find_value(_tween, 1), ds_list_find_value(_tween, 2));
                
                // Cache start position
                var _start = TweenGetStart(_tween);
                
                // Calculate new starting position
                var _newStart = _start - TweenGetChange(_tween);
                
                // Assign new starting position
                ds_list_replace(_tween, 2, _newStart);
                
                // Set destination to previous start position
                TweenSetDestination(_tween, _start)
            }
            
            // Execute repeat event
            ExecuteTweenEvent(ds_list_find_value(_tween, 19));
            break;
            
        case TWEEN_PLAY_BOUNCE:
            // IF time larger than 0, bounce the tween back to start
            // ELSE have the tween finish
            if (_time > 0)
            {
                // Adjust for time "overflow"
                ds_list_replace(_tween, 9, _duration - (_time - _duration));
                
                // Set tweened variable to destination
                with(_instance) script_execute(ds_list_find_value(_tween, 1), ds_list_find_value(_tween, 3));
            
                // Reverse tween direction
                TweenReverse(_tween);
                
                // Execute bounce event
                ExecuteTweenEvent(ds_list_find_value(_tween, 20));
            }
            else
            {
                // Stop tween
                ds_list_replace(_tween, 11, -1); 
                
                // Set tweened variable to start
                with(_instance) script_execute(ds_list_find_value(_tween, 1), ds_list_find_value(_tween, 2)); 
                
                // Execute finish event
                ExecuteTweenEvent(ds_list_find_value(_tween, 14)); 
            }
            break;
            
        case TWEEN_PLAY_PATROL:
            // Adjust for time "overflow"
            if (_time > 0)
            {
                // Step back if needed
                ds_list_replace(_tween, 9, _duration - (_time - _duration));
                
                // Set tweened variable to destination
                with(_instance) script_execute(ds_list_find_value(_tween, 1), ds_list_find_value(_tween, 3));
                
            }
            else
            {
                // Step forward if needed
                ds_list_replace(_tween, 9, -_time);
                
                // Set tweened variable to start position
                with(_instance) script_execute(ds_list_find_value(_tween, 1), ds_list_find_value(_tween, 2));
            }
            
            // Reverse tween direction
            TweenReverse(_tween);
            
            // Execute bounce event
            ExecuteTweenEvent(ds_list_find_value(_tween, 20));
            break;
            
        default: 
            // Display warning message
            show_error("Invalid Tween Play Mode!", false);
            
            // Destroy tween so game can continue without further errors
            TweenDestroy(_tween);
        }
    }
}
                

#define TweenGetInstance
/*
    TweenGetInstance(tween);
*/

return ds_list_find_value(argument0, 0);

#define TweenGetProperty
/*
    TweenGetVariableReference(tween);
*/

return ds_list_find_value(argument0, 1);

#define TweenGetStart
/*
    TweenGetStart(tween)
*/

return ds_list_find_value(argument0, 2);

#define TweenGetDestination
/*
    TweenGetDestination(tween);
*/

return ds_list_find_value(argument0, 3);

#define TweenGetDuration
/*
    TweenGetDuration(tween);
*/

return ds_list_find_value(argument0, 4);

#define TweenGetEase
/*
    TweenGetEase(tween);
*/

return ds_list_find_value(argument0, 5);

#define TweenGetPlayMode
/*
    TweenGetBound(tween);
*/

return ds_list_find_value(argument0, 6);

#define TweenGetChange
/*
    TweenGetChange(tween);
*/

return ds_list_find_value(argument0, 8);

#define TweenGetTime
/*
    TweenGetTime(tween);
*/

return ds_list_find_value(argument0, 9);

#define TweenGetTimeScale
/*
    TweenGetTimeScale(tween);
*/

return ds_list_find_value(argument0, 10) * ds_list_find_value(argument0, 22);



#define TweenGetState
/*
    TweenGetState(tween);
*/

return ds_list_find_value(argument0, 11);

#define TweenGetGroup
/*
    TweenGetGroup(tween);
*/

return ds_list_find_value(argument0, 12);

#define TweenSetInstance
/*
    TweenSetInstance(tween, instance);
*/

if (ds_list_find_value(argument0, 0) != noone)
{
    ds_list_replace(argument0, 0, argument1);
}

#define TweenSetProperty
/*
    TweenSetProperty(tween, property);
*/

ds_list_replace(argument0, 1, argument1);

#define TweenSetStart
/*
    TweenSetStart(tween, start)
*/

//  Set New Start Position
ds_list_replace(argument0, 2, argument1);

//  Calculate New Change
ds_list_replace(argument0, 8, ds_list_find_value(argument0, 3) - ds_list_find_value(argument0, 2));


#define TweenSetDestination
/*
    TweenSetDestination(tween, destination);
*/

// Set New Destination
ds_list_replace(argument0, 3, argument1);

// Set New Calculated Change
ds_list_replace(argument0, 8, ds_list_find_value(argument0, 3) - ds_list_find_value(argument0, 2));

#define TweenSetDuration
/*
    TweenSetDuration(tween, duration);
*/

ds_list_replace(argument0, 4, argument1);

#define TweenSetEase
/*
    TweenSetEase(tween, ease);
*/

ds_list_replace(argument0, 5, argument1);

#define TweenSetPlayMode
/*
    TweenSetPlayMode(tween, TWEEN_PLAY_CONSTANT);
*/

// needs to be changed to take constant

ds_list_replace(argument0, 6, argument1);

#define TweenSetTimeScale
/*
    TweenSetTimeScale(tween, scale);
*/

ds_list_replace(argument0, 10, argument1 * ds_list_find_value(argument0, 22));


#define TweenSetTimeScaleAll
/*
    TweenSetTimeScaleAll(scale)
*/

var _sharedTweener = SharedTweener();
var _tweens = _sharedTweener.tweens;

for (var i = 0, _maxIndex = ds_list_size(_tweens); i < _maxIndex; i++)
{
    TweenSetTimeScale(ds_list_find_value(_tweens, i), argument0);
}


#define TweenSetTimeScaleGroup
/*
    TweenSetSpeedGroup(group, scale)
*/

var _sharedTweener = SharedTweener();
var _tweens = _sharedTweener.tweens;

for (var i = 0, _maxIndex = ds_list_size(_tweens); i < _maxIndex; i++)
{
    var _tween = ds_list_find_value(_tweens, i);
    
    if (ds_list_find_value(_tween, 12) == argument0)
    {
        TweenSetTimeScale(_tween, argument1);
    }
}


#define TweenSetTime
/*
    TweenSetSpeed(tween, time);
*/

// Assign new time value
ds_list_replace(argument0, 9, argument1);

// Calculate new position for updated time
with(ds_list_find_value(argument0, 0))
{
    if (TweenGetDuration(argument0) > 0)
    {
        with (ds_list_find_value(argument0, 0)) script_execute(ds_list_find_value(argument0, 1), script_execute(ds_list_find_value(argument0, 5), argument1, ds_list_find_value(argument0, 2), ds_list_find_value(argument0, 8), ds_list_find_value(argument0, 4)));
    }
}


#define TweenSetGroup
/*
    TweenSetGroup(tween, group);
*/

ds_list_replace(argument0, 12, argument1);

#define TweenUseDelta
/*
    TweenUseDelta(tween, bool)
*/

ds_list_replace(argument0, 21, argument1);



#define TweenIsActive
/*
    TweenIsActive(tween);
*/

return (ds_list_find_value(argument0, 11) == 1);


#define TweenIsStopped
/*
    TweenIsStopped(tween);
*/

return (ds_list_find_value(argument0, 11) == -1);

#define TweenIsPaused
/*
    TweenIsActive(tween);
*/

return (ds_list_find_value(argument0, 11) == 0);

#define TweenIsDelta
/*
    TweenIsDelta(tween);
*/

return ds_list_find_value(argument0, 21);


#define ExecuteTweenEvent
/*
    ExecuteTweenEvent(event);
*/

if (argument0 == -1)
{
    exit;
}

var _cleanQueue = -1;
var _size = ds_list_size(argument0);

for (var i = 0; i < _size; i++)
{
    // Cache callback
    var _cb = ds_list_find_value(argument0, i); 
    
    // Cache Caller
    var _caller = ds_list_find_value(_cb, 0);

    if (instance_exists(_caller))
    {
        switch(ds_list_size(_cb))
        {
        case 2: with(_caller) script_execute(ds_list_find_value(_cb, 1)); break;
        case 3: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2)); break;
        case 4: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3)); break;
        case 5: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4)); break;
        case 6: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4), ds_list_find_value(_cb, 5)); break;
        case 7: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4), ds_list_find_value(_cb, 5), ds_list_find_value(_cb, 6)); break;
        case 8: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4), ds_list_find_value(_cb, 5), ds_list_find_value(_cb, 6), ds_list_find_value(_cb, 7)); break;
        case 9: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4), ds_list_find_value(_cb, 5), ds_list_find_value(_cb, 6), ds_list_find_value(_cb, 7), ds_list_find_value(_cb, 8)); break;
        case 10: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4), ds_list_find_value(_cb, 5), ds_list_find_value(_cb, 6), ds_list_find_value(_cb, 7), ds_list_find_value(_cb, 8), ds_list_find_value(_cb, 9)); break;
        case 11: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4), ds_list_find_value(_cb, 5), ds_list_find_value(_cb, 6), ds_list_find_value(_cb, 7), ds_list_find_value(_cb, 8), ds_list_find_value(_cb, 9), ds_list_find_value(_cb, 10)); break;
        case 12: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4), ds_list_find_value(_cb, 5), ds_list_find_value(_cb, 6), ds_list_find_value(_cb, 7), ds_list_find_value(_cb, 8), ds_list_find_value(_cb, 9), ds_list_find_value(_cb, 10), ds_list_find_value(_cb, 11)); break;
        case 13: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4), ds_list_find_value(_cb, 5), ds_list_find_value(_cb, 6), ds_list_find_value(_cb, 7), ds_list_find_value(_cb, 8), ds_list_find_value(_cb, 9), ds_list_find_value(_cb, 10), ds_list_find_value(_cb, 11), ds_list_find_value(_cb, 12)); break;
        case 14: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4), ds_list_find_value(_cb, 5), ds_list_find_value(_cb, 6), ds_list_find_value(_cb, 7), ds_list_find_value(_cb, 8), ds_list_find_value(_cb, 9), ds_list_find_value(_cb, 10), ds_list_find_value(_cb, 11), ds_list_find_value(_cb, 12), ds_list_find_value(_cb, 13)); break;
        case 15: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4), ds_list_find_value(_cb, 5), ds_list_find_value(_cb, 6), ds_list_find_value(_cb, 7), ds_list_find_value(_cb, 8), ds_list_find_value(_cb, 9), ds_list_find_value(_cb, 10), ds_list_find_value(_cb, 11), ds_list_find_value(_cb, 12), ds_list_find_value(_cb, 13), ds_list_find_value(_cb, 14)); break;
        }
    }
    else
    {
        instance_activate_object(_caller)
        
        if (instance_exists(_caller))
        {   
            switch(ds_list_size(_cb))
            {
            case 2: with(_caller) script_execute(ds_list_find_value(_cb, 1)); break;
            case 3: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2)); break;
            case 4: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3)); break;
            case 5: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4)); break;
            case 6: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4), ds_list_find_value(_cb, 5)); break;
            case 7: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4), ds_list_find_value(_cb, 5), ds_list_find_value(_cb, 6)); break;
            case 8: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4), ds_list_find_value(_cb, 5), ds_list_find_value(_cb, 6), ds_list_find_value(_cb, 7)); break;
            case 9: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4), ds_list_find_value(_cb, 5), ds_list_find_value(_cb, 6), ds_list_find_value(_cb, 7), ds_list_find_value(_cb, 8)); break;
            case 10: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4), ds_list_find_value(_cb, 5), ds_list_find_value(_cb, 6), ds_list_find_value(_cb, 7), ds_list_find_value(_cb, 8), ds_list_find_value(_cb, 9)); break;
            case 11: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4), ds_list_find_value(_cb, 5), ds_list_find_value(_cb, 6), ds_list_find_value(_cb, 7), ds_list_find_value(_cb, 8), ds_list_find_value(_cb, 9), ds_list_find_value(_cb, 10)); break;
            case 12: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4), ds_list_find_value(_cb, 5), ds_list_find_value(_cb, 6), ds_list_find_value(_cb, 7), ds_list_find_value(_cb, 8), ds_list_find_value(_cb, 9), ds_list_find_value(_cb, 10), ds_list_find_value(_cb, 11)); break;
            case 13: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4), ds_list_find_value(_cb, 5), ds_list_find_value(_cb, 6), ds_list_find_value(_cb, 7), ds_list_find_value(_cb, 8), ds_list_find_value(_cb, 9), ds_list_find_value(_cb, 10), ds_list_find_value(_cb, 11), ds_list_find_value(_cb, 12)); break;
            case 14: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4), ds_list_find_value(_cb, 5), ds_list_find_value(_cb, 6), ds_list_find_value(_cb, 7), ds_list_find_value(_cb, 8), ds_list_find_value(_cb, 9), ds_list_find_value(_cb, 10), ds_list_find_value(_cb, 11), ds_list_find_value(_cb, 12), ds_list_find_value(_cb, 13)); break;
            case 15: with(_caller) script_execute(ds_list_find_value(_cb, 1), ds_list_find_value(_cb, 2), ds_list_find_value(_cb, 3), ds_list_find_value(_cb, 4), ds_list_find_value(_cb, 5), ds_list_find_value(_cb, 6), ds_list_find_value(_cb, 7), ds_list_find_value(_cb, 8), ds_list_find_value(_cb, 9), ds_list_find_value(_cb, 10), ds_list_find_value(_cb, 11), ds_list_find_value(_cb, 12), ds_list_find_value(_cb, 13), ds_list_find_value(_cb, 14)); break;
            }
            
            instance_deactivate_object(_caller);
        }
        else
        {
            // Initialize clean queue is not already
            if (_cleanQueue == -1)
            {
                _cleanQueue = ds_queue_create();
            }
            
            // Add callback to cleaning queue
            ds_queue_enqueue(_cleanQueue, _cb);
        }
    }
}

// IF the cleaning queue is initialized
if (_cleanQueue != -1)
{
    // Remove all callbacks added to the queue
    repeat(ds_queue_size(_cleanQueue))
    {
        // Cache callback
        _cb = ds_queue_dequeue(_cleanQueue);
        
        // Remove callback from event
        ds_list_delete(argument0, ds_list_find_index(argument0, _cb)); 
        
        // Destroy callback
        ds_list_destroy(_cb);
    }
    
    // Destroy clean queue
    ds_queue_destroy(_cleanQueue);
}

#define TweenOnPlayAdd
/*
    TweenOnPlayAdd(tween, caller, script, arg0, arg1, ...)
    Returns: callback handle
*/

var _event = ds_list_find_value(argument[0], 13);
var _callback = ds_list_create();

// Initialize event if it is not already
if (_event == -1)
{
    _event = ds_list_create();
    ds_list_replace(argument[0], 13, _event);
}

// Assign caller to callback
ds_list_add(_callback, argument[1]);

// Assign script to callback
ds_list_add(_callback, argument[2]);

// Assign arguments to callback
for(var i = 3; i < argument_count; i++)
{
    ds_list_add(_callback, argument[i]);   
}

// Add callback to the event
ds_list_add(_event, _callback); 

return _callback;

#define TweenOnFinishAdd
/*
    TweenOnFinishAdd(tween, caller, script, arg0, arg1, ...)
    Returns: callback handle
*/

var _event = ds_list_find_value(argument[0], 14);
var _callback = ds_list_create();

// Initialize event if it is not already
if (_event == -1)
{
    _event = ds_list_create();
    ds_list_replace(argument[0], 14, _event);
}

// Assign caller to callback
ds_list_add(_callback, argument[1]);

// Assign script to callback
ds_list_add(_callback, argument[2]);

// Assign arguments to callback
for(var i = 3; i < argument_count; i++)
{
    ds_list_add(_callback, argument[i]);   
}

// Add callback to the event
ds_list_add(_event, _callback); 

return _callback;

#define TweenOnStopAdd
/*
    TweenOnStopAdd(tween, caller, script, arg0, arg1, ...)
    Returns: callback handle
*/

var _event = ds_list_find_value(argument[0], 15);
var _callback = ds_list_create();

// Initialize event if it is not already
if (_event == -1)
{
    _event = ds_list_create();
    ds_list_replace(argument[0], 15, _event);
}

// Assign caller to callback
ds_list_add(_callback, argument[1]);

// Assign script to callback
ds_list_add(_callback, argument[2]);

// Assign arguments to callback
for(var i = 3; i < argument_count; i++)
{
    ds_list_add(_callback, argument[i]);   
}

// Add callback to the event
ds_list_add(_event, _callback); 

return _callback;

#define TweenOnPauseAdd
/*
    TweenOnPauseAdd(tween, caller, script, arg0, arg1, ...)
    Returns: callback handle
*/

var _event = ds_list_find_value(argument[0], 16);
var _callback = ds_list_create();

// Initialize event if it is not already
if (_event == -1)
{
    _event = ds_list_create();
    ds_list_replace(argument[0], 16, _event);
}

// Assign caller to callback
ds_list_add(_callback, argument[1]);

// Assign script to callback
ds_list_add(_callback, argument[2]);

// Assign arguments to callback
for(var i = 3; i < argument_count; i++)
{
    ds_list_add(_callback, argument[i]);   
}

// Add callback to the event
ds_list_add(_event, _callback); 

return _callback;

#define TweenOnResumeAdd
/*
    TweenOnResumeAdd(tween, caller, script, arg0, arg1, ...)
    Returns: callback handle
*/

var _event = ds_list_find_value(argument[0], 17);
var _callback = ds_list_create();

// Initialize event if it is not already
if (_event == -1)
{
    _event = ds_list_create();
    ds_list_replace(argument[0], 17, _event);
}

// Assign caller to callback
ds_list_add(_callback, argument[1]);

// Assign script to callback
ds_list_add(_callback, argument[2]);

// Assign arguments to callback
for(var i = 3; i < argument_count; i++)
{
    ds_list_add(_callback, argument[i]);   
}

// Add callback to the event
ds_list_add(_event, _callback); 

return _callback;

#define TweenOnLoopAdd
/*
    TweenOnLoopAdd(tween, caller, script, arg0, arg1, ...)
    Returns: callback handle
*/

var _event = ds_list_find_value(argument[0], 18);
var _callback = ds_list_create();

// Initialize event if it is not already
if (_event == -1)
{
    _event = ds_list_create();
    ds_list_replace(argument[0], 18, _event);
}

// Assign caller to callback
ds_list_add(_callback, argument[1]);

// Assign script to callback
ds_list_add(_callback, argument[2]);

// Assign arguments to callback
for(var i = 3; i < argument_count; i++)
{
    ds_list_add(_callback, argument[i]);   
}

// Add callback to the event
ds_list_add(_event, _callback); 

return _callback;

#define TweenOnRepeatAdd
/*
    TweenOnRepeatAdd(tween, caller, script, arg0, arg1)
    Returns: callback handle
*/

var _event = ds_list_find_value(argument[0], 19);
var _callback = ds_list_create();

// Initialize event if it is not already
if (_event == -1)
{
    _event = ds_list_create();
    ds_list_replace(argument[0], 19, _event);
}

// Assign caller to callback
ds_list_add(_callback, argument[1]);

// Assign script to callback
ds_list_add(_callback, argument[2]);

// Assign arguments to callback
for(var i = 3; i < argument_count; i++)
{
    ds_list_add(_callback, argument[i]);   
}

// Add callback to the event
ds_list_add(_event, _callback); 

return _callback;

#define TweenOnBounceAdd
/*
    TweenOnBounceAdd(tween, caller, script, arg0, arg1)
    Return: callback handle
*/

var _event = ds_list_find_value(argument[0], 20);
var _callback = ds_list_create();

// Initialize event if it is not already
if (_event == -1)
{
    _event = ds_list_create();
    ds_list_replace(argument[0], 20, _event);
}

// Assign caller to callback
ds_list_add(_callback, argument[1]);

// Assign script to callback
ds_list_add(_callback, argument[2]);

// Assign arguments to callback
for(var i = 3; i < argument_count; i++)
{
    ds_list_add(_callback, argument[i]);   
}

// Add callback to the event
ds_list_add(_event, _callback); 

return _callback;

#define TweenOnPlayRemove
/*
    TweenOnPlayRemove(tween, callback)
*/

var _event = ds_list_find_value(argument0, 13);
var _callback = argument1;

if (_event != -1)
{
    var _callbackIndex = ds_list_find_index(_event, _callback);
    
    if (_callbackIndex != -1)
    {
        ds_list_delete(_event, _callbackIndex); // remove callback from event
        ds_list_destroy(_callback); // destroy callback
        return true;
    }
}

return false;




#define TweenOnFinishRemove
/*
    TweenOnFinishRemove(tween, callback)
*/

var _event = ds_list_find_value(argument0, 14);
var _callback = argument1;

if (_event != -1)
{
    var _callbackIndex = ds_list_find_index(_event, _callback);
    
    if (_callbackIndex != -1)
    {
        ds_list_delete(_event, _callbackIndex); // remove callback from event
        ds_list_destroy(_callback); // destroy callback
        return true;
    }
}

return false;

#define TweenOnStopRemove
/*
    TweenOnStopRemove(tween, callback)
*/

var _event = ds_list_find_value(argument0, 15);
var _callback = argument1;

if (_event != -1)
{
    var _callbackIndex = ds_list_find_index(_event, _callback);
    
    if (_callbackIndex != -1)
    {
        ds_list_delete(_event, _callbackIndex); // remove callback from event
        ds_list_destroy(_callback); // destroy callback
        return true;
    }
}

return false;

#define TweenOnPauseRemove
/*
    TweenOnPauseRemove(tween, callback)
*/

var _event = ds_list_find_value(argument0, 16);
var _callback = argument1;

if (_event != -1)
{
    var _callbackIndex = ds_list_find_index(_event, _callback);
    
    if (_callbackIndex != -1)
    {
        ds_list_delete(_event, _callbackIndex); // remove callback from event
        ds_list_destroy(_callback); // destroy callback
        return true;
    }
}

return false;

#define TweenOnResumeRemove
/*
    TweenOnResumeRemove(tween, callback)
*/

var _event = ds_list_find_value(argument0, 17);
var _callback = argument1;

if (_event != -1)
{
    var _callbackIndex = ds_list_find_index(_event, _callback);
    
    if (_callbackIndex != -1)
    {
        ds_list_delete(_event, _callbackIndex); // remove callback from event
        ds_list_destroy(_callback); // destroy callback
        return true;
    }
}

return false;

#define TweenOnLoopRemove
/*
    TweenOnLoopRemove(tween, callback)
*/

var _event = ds_list_find_value(argument0, 18);
var _callback = argument1;

if (_event != -1)
{
    var _callbackIndex = ds_list_find_index(_event, _callback);
    
    if (_callbackIndex != -1)
    {
        ds_list_delete(_event, _callbackIndex); // remove callback from event
        ds_list_destroy(_callback); // destroy callback
        return true;
    }
}

return false;

#define TweenOnRepeatRemove
/*
    TweenOnRepeatRemove(tween, callback)
*/

var _event = ds_list_find_value(argument0, 19);
var _callback = argument1;

if (_event != -1)
{
    var _callbackIndex = ds_list_find_index(_event, _callback);
    
    if (_callbackIndex != -1)
    {
        ds_list_delete(_event, _callbackIndex); // remove callback from event
        ds_list_destroy(_callback); // destroy callback
        return true;
    }
}

return false;

#define TweenOnBounceRemove
/*
    TweenOnBounceRemove(tween, callback)
*/

var _event = ds_list_find_value(argument0, 20);
var _callback = argument1;

if (_event != -1)
{
    var _callbackIndex = ds_list_find_index(_event, _callback);
    
    if (_callbackIndex != -1)
    {
        ds_list_delete(_event, _callbackIndex); // remove callback from event
        ds_list_destroy(_callback); // destroy callback
        return true;
    }
}

return false;

#define TweenOnPlayRemoveAll
/*
    TweenOnPlayRemoveAll(tween);
*/

var _event = ds_list_find_value(argument0, 13);

if (_event != -1)
{
    repeat(ds_list_size(_event))
    {
        var _callback = ds_list_find_value(_event, 0); // fetch callback
        ds_list_destroy(_callback); // destroy callback
        ds_list_delete(_event, 0); // remove callback from event
    }
}

#define TweenOnFinishRemoveAll
/*
    TweenOnFinishRemoveAll(tween);
*/

var _event = ds_list_find_value(argument0, 14);

if (_event != -1)
{
    repeat(ds_list_size(_event))
    {
        var _callback = ds_list_find_value(_event, 0); // fetch callback
        ds_list_destroy(_callback); // destroy callback
        ds_list_delete(_event, 0); // remove callback from event
    }
}

#define TweenOnStopRemoveAll
/*
    TweenOnStopRemoveAll(tween);
*/

var _event = ds_list_find_value(argument0, 15);

if (_event != -1)
{
    repeat(ds_list_size(_event))
    {
        var _callback = ds_list_find_value(_event, 0); // fetch callback
        ds_list_destroy(_callback); // destroy callback
        ds_list_delete(_event, 0); // remove callback from event
    }
}

#define TweenOnPauseRemoveAll
/*
    TweenOnPauseRemoveAll(tween);
*/

var _event = ds_list_find_value(argument0, 16);

if (_event != -1)
{
    repeat(ds_list_size(_event))
    {
        var _callback = ds_list_find_value(_event, 0); // fetch callback
        ds_list_destroy(_callback); // destroy callback
        ds_list_delete(_event, 0); // remove callback from event
    }
}

#define TweenOnResumeRemoveAll
/*
    TweenOnResumeRemoveAll(tween);
*/

var _event = ds_list_find_value(argument0, 17);

if (_event != -1)
{
    repeat(ds_list_size(_event))
    {
        var _callback = ds_list_find_value(_event, 0); // fetch callback
        ds_list_destroy(_callback); // destroy callback
        ds_list_delete(_event, 0); // remove callback from event
    }
}

#define TweenOnLoopRemoveAll
/*
    TweenOnLoopRemoveAll(tween);
*/

var _event = ds_list_find_value(argument0, 18);

if (_event != -1)
{
    repeat(ds_list_size(_event))
    {
        var _callback = ds_list_find_value(_event, 0); // fetch callback
        ds_list_destroy(_callback); // destroy callback
        ds_list_delete(_event, 0); // remove callback from event
    }
}

#define TweenOnRepeatRemoveAll
/*
    TweenOnRepeatRemoveAll(tween);
*/

var _event = ds_list_find_value(argument0, 19);

if (_event != -1)
{
    repeat(ds_list_size(_event))
    {
        var _callback = ds_list_find_value(_event, 0); // fetch callback
        ds_list_destroy(_callback); // destroy callback
        ds_list_delete(_event, 0); // remove callback from event
    }
}

#define TweenOnBounceRemoveAll
/*
    TweenOnBounceRemoveAll(tween);
*/

var _event = ds_list_find_value(argument0, 20);

if (_event != -1)
{
    repeat(ds_list_size(_event))
    {
        var _callback = ds_list_find_value(_event, 0); // fetch callback
        ds_list_destroy(_callback); // destroy callback
        ds_list_delete(_event, 0); // remove callback from event
    }
}

#define TweenDefaultSetTimeScale
/*
    TweenDefaultSetTimeScale(scale)
*/

(SharedTweener()).tweenDefaultTimeScale = clamp(argument0, 0, 10000);

#define TweenDefaultGetTimeScale
/*
    TweenDefaultGetTimeScale()
*/

return (SharedTweener()).tweenDefaultTimeScale;

