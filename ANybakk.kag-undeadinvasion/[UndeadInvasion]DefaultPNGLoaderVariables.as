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
    const int COLOR_TILE_IRON             = 0xff6c776e; //ARGB(255, 108, 119, 110)
    const int COLOR_TILE_COAL             = 0xff000000; //ARGB(255,   0,   0,   0)
    
    //Blob map colors
    const int COLOR_MAUSOLEUM             = 0xffff007d; //ARGB(255, 255,   0, 125)
    const int COLOR_SURVIVOR_CAMP         = 0xffd3f9c1; //ARGB(255, 211, 249, 193) (same as WAR hall)
    const int COLOR_BED                   = 0xff5a73a5; //ARGB(255,  90, 115, 165)
    
    //Sector map colors
    const int COLOR_SECTOR_NOBUILD_START  = 0xffff00ff; //ARGB(255, 255,   0, 255)
    const int COLOR_SECTOR_NOBUILD_END    = 0xff00ffff; //ARGB(255,   0, 255, 255)
    
  }
  
}