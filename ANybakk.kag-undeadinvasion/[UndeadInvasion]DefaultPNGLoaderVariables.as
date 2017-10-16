/*
 * UndeadInvasion DefaultPNGLoader variables
 * 
 * This script contains any variables associated with the PNG map loader. To 
 * override these variables, make a new mod where you override this file. By 
 * doing it this way, tweaking these variables won't require having to deal 
 * with code.
 * 
 * Author: ANybakk
 */

namespace UndeadInvasion {

  namespace DefaultPNGLoaderVariables {
  
    //Tile map colors
    const SColor COLOR_TILE_IRON      (255, 108, 119, 110);
    const SColor COLOR_TILE_COAL      (255,   0,   0,   0);
    
    //Blob map colors
    const SColor COLOR_MAUSOLEUM      (255, 255,   0, 125); //#ff007d
    const SColor COLOR_SURVIVOR_CAMP  (255, 211, 249, 193); //#d3f9c1 (same as WAR hall)
    const SColor COLOR_BED            (255,  90, 115, 165);
    
    //Sector map colors
    const SColor COLOR_SECTOR_NOBUILD_START (255, 255,   0, 255); //#ff00ff
    const SColor COLOR_SECTOR_NOBUILD_END   (255,   0, 255, 255); //#00ffff
    
  }
  
}