if step!=1.1
{
step = 1.1
speed = 0

lives--
if lives = 0
    {
    step = 2
    speed = 0
    if score > topscore
        {
        topscore = score
        newrecord = 1
        }
    }
else
    {
    alarm[0] = 30
    }
}
