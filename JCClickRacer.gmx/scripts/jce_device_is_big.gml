///jce_device_is_big : bool

//Returns whether the device is large
//(You can also just check the screen height for a specific cut-off dimension)

ret = false;

switch (os_device)
{
    case device_ios_ipad: ret = true; break;
    case device_ios_ipad_retina: ret = true; break;
    default: ret = false;
}

switch (os_type)
{
    case os_windows: ret = true; break;
    case os_macosx: ret = true; break;
    case os_linux: ret = true; break;
}
 
return ret;
