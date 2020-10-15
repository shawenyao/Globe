/* 
 * modified from https://gist.github.com/endel/dfe6bb2fbe679781948c
 * (originally modified from http://www.voidware.com/moon_phase.htm)
 */

function getMoonPhase(year, month, day)
{
    var c = e = jd = b = 0;

    if (month < 3) {
        year--;
        month += 12;
    }

    ++month;

    c = 365.25 * year;

    e = 30.6 * month;

    jd = c + e + day - 694039.09; //jd is total days elapsed

    jd /= 29.5305882; //divide by the moon cycle

    b = parseInt(jd); //int(jd) -> b, take integer part of jd

    jd -= b; //subtract integer part to leave fractional part of original jd

    b = Math.round(jd * 8); //scale fraction from 0-8 and round

    // 0 => New Moon (with a little Waxing Crescent Moon)
    // 1 => Waxing Crescent Moon
    // 2 => Quarter Moon
    // 3 => Waxing Gibbous Moon
    // 4 => Full Moon
    // 5 => Waning Gibbous Moon
    // 6 => Last Quarter Moon
    // 7 => Waning Crescent Moon
    // 8 => New Moon (with a little Waning Crescent Moon)
    
    return b;
}
