/*
 * UndeadInvasion
 * 
 * Author: ANybakk
 */



namespace UndeadInvasion {



  /**
   * Returns an array of players belonging to a certain team
   */
  CPlayer@[] getPlayers(int teamNumber) {

    CPlayer@      player;
    CPlayer@[]    teamPlayers;
    
    for(int i=0; i<::getPlayersCount(); i++) {
    
      @player = getPlayer(i);
      
      if(player.getTeamNum() == teamNumber) {
      
        teamPlayers.push_back(player);
        
      }
      
    }
    
    return teamPlayers;
    
  }
  
  
  
  /**
   * Returns the number of players belonging to a certain team
   */
  int getPlayersCount(int teamNumber) {

    CPlayer@    player;
    int         playerCount = 0;
    
    for(int i=0; i<::getPlayersCount(); i++) {
    
      @player = getPlayer(i);
      
      if(player.getTeamNum() == teamNumber) {
      
        playerCount++;
        
      }
      
    }
    
    return playerCount;
    
  }
  
  
  
}