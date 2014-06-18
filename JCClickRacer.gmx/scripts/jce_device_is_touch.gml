///jce_device_is_touch() : bool

//Returns whether the device is a touch device
//Default is true

ret = true;
switch (os_type)
{
    case os_windows: ret = false; break;
    case os_linux: ret = false; break;
    case os_macosx: ret = false; break;
    case os_win8native: ret = win8_device_touchscreen_available(); break;
    
    case os_winphone: ret = true; break;
    case os_ios: ret = true; break;
    case os_android: ret = true; break;
    
    default: ret = true;
}
 
return ret;
