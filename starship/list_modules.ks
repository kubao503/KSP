function GetPartModules
{
    parameter partTag.
    return ship:partstagged(partTag)[0]:modules.
}
print GetPartModules("fl_flap").
