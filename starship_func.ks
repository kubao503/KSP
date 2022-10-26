// Visualising vectors
function draw_arrows
{
    parameter vecotors_to_draw, clear is true.
    if clear {
        clearvecdraws().
    }
    for vector in vecotors_to_draw {
        vecdraw(v(0,0,0), vector, rgb(1,RANDOM(),0), "", 10, true, 0.02).
    }
}
