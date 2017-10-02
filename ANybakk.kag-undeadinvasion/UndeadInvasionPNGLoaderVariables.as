/*
 * UndeadInvasion PNGLoader variables
 * 
 * This script contains any variables associated with the PNG map loader. To 
 * override these variables, make a new mod where you override this file. By 
 * doing it this way, tweaking these variables won't require having to deal 
 * with code.
 * 
 * Author: ANybakk
 */

namespace UndeadInvasionPNGLoaderVariables {
  
  //Define undead spawn map color as RGB 255,0,125 (#ff007d)
  const SColor COLOR_MAUSOLEUM(255, 255,  0, 125);
  
  //Define survivor camp map color as RGB 211,249,193 (#d3f9c1) (same as WAR hall)
  const SColor COLOR_SURVIVOR_CAMP(255, 211, 249, 193);
  
  //Define bed map color as RGB 90,115,165
  const SColor COLOR_BED(255, 90, 115, 165);
  
  //Define no build sector start point as RGB 255,0,255 (#ff00ff)
  const SColor COLOR_SECTOR_NOBUILD_START(255, 255, 0, 255);
  
  //Define no build sector end point as RGB 0,255,255 (#00ffff)
  const SColor COLOR_SECTOR_NOBUILD_END(255, 0, 255, 255);
  
}