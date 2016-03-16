/* 
 * TerritorialBuilding
 * 
 * Author: ANybakk
 */

#include "Entity.as"



namespace TerritorialBuilding {



  const string NAME = "TerritorialBuilding";
  
  
  
  shared class Data {
    
    //Options
    
    u8                    oBesiegedAlertTimeout       = 3;                      //Timeout for besieged alert, in seconds.
    u8                    oOverwhelmedTakeOverTime    = 10;                     //The time necessary for takeover, in seconds. Negative to disable.
    f32                   oTerritoryRadius            = 150.0f;                 //A territorial radius (range of takeover).
    
    //EventData (do-once)
    
    Entity::EventData     eBlobWasOverwhelmed;
    
    //EventData (do-while)
    
    Entity::EventData     eBlobIsBesieged;
    
    //Internals
    
  }
  
  
  
  namespace Blob {
  
  
  
    /**
     * Stores a data object
     * 
     * @param   this    a blob pointer.
     * @param   data     a data pointer.
     */
    void storeData(CBlob@ this, Data@ data = null) {

      if(data is null) {
      
        @data = Data();
        
      }
      
      this.set(NAME + "::Data", @data);
      
    }
    
    
    
    /**
     * Retrieves a data object.
     * 
     * @param   this    a blob pointer.
     * @return  data     a pointer to the data (null if none was found).
     */
    Data@ retrieveData(CBlob@ this) {
    
      Data@ data;
      
      this.get(NAME + "::Data", @data);
      
      return data;
      
    }
    
    
    
    /**
     * Checks for overlapping blobs and performs necessary actions
     * 
     * @param   this        blob reference.
     */
    void checkOverlapping(CBlob@ this) {

      //Create a blob array
      CBlob@[] overlappingBlobs;
      
      //Check if any overlapping blobs
      if(this.getOverlapping(@overlappingBlobs)) {
  
        //Retrieve data
        Data@ data = TerritorialBuilding::Blob::retrieveData(this);
        
        //Obtain owner team number
        u8 ownerTeamNumber = this.getTeamNum();
        
        //Create a blob handle
        CBlob@ overlappingBlob;
        
        //Create a overlapping team number variable
        uint overlappingTeamNumber = 0;
        
        //Create a friendly count variable
        uint friendlyCount = 0;
        
        //Create an array of unfriendly count variables (up to 10 teams)
        uint[] unfriendlyCount = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
        
        //Iterate through overlapping blobs
        for(uint i=0; i<overlappingBlobs.length; i++) {
        
          //Keep a reference to this blob
          @overlappingBlob = overlappingBlobs[i];
          
          //Check if overlapping is player or humanoid, and not dead
          if((overlappingBlob.hasTag("player") || overlappingBlob.hasTag("isHumanoid")) && (!overlappingBlob.hasTag("dead") || !overlappingBlob.hasTag("CreatureBlob::isDead"))) {
          
            //Keep overlapping team number
            overlappingTeamNumber = overlappingBlob.getTeamNum();
            
            //Check if spawn site has no owner, overlapping is player and not dead
            if(ownerTeamNumber > 10) {
            
              //Change ownership straight away
              changeOwnership(this, overlappingTeamNumber);
              
              //Unset besieged
              data.eBlobIsBesieged.iTime = -1;
              
              //Unset overwhelmed
              data.eBlobWasOverwhelmed.iTime = -1;
              
              //Register friendly
              friendlyCount++;
              
            }
            
            //Otherwise, check if player and same team
            else if(overlappingTeamNumber == ownerTeamNumber) {
            
              //Register friendly
              friendlyCount++;
              
            }
            
            //Otherwise, check if different team, and valid team
            else if(overlappingTeamNumber != ownerTeamNumber && overlappingTeamNumber >= 0 && overlappingTeamNumber <= 10) {
              
              //Set besieged
              data.eBlobIsBesieged.iTime = getGameTime();
              
              //Register unfriendly
              unfriendlyCount[overlappingTeamNumber]++;
              
            }
            
          }
          
        }
        
        //Check if takeover is enabled
        if(data.oOverwhelmedTakeOverTime >= 0) {
        
          //Create unfriendly total count variable
          uint unfriendlyCountTotal = 0;
          
          //Iterate through all unfriendly
          for(uint i=0; i<unfriendlyCount.length; i++) {
          
            //Add to total
            unfriendlyCountTotal += unfriendlyCount[i];
            
          }
          
          //Check if more unfriendly than friendly
          if(unfriendlyCountTotal > friendlyCount) {
          
            //Check if not already overwhelmed
            if(data.eBlobWasOverwhelmed.iTime < 0) {
            
              //Set overwhelmed
              data.eBlobWasOverwhelmed.iTime = getGameTime();
              
            }
            
            //Otherwise (still overwhelmed)
            else {
                
              //Determine for how long this has been overwhelmed
              u32 overwhelmedForTime = getGameTime() - data.eBlobWasOverwhelmed.iTime;
              
              //If surpass or equal to takeover time
              if(overwhelmedForTime >= data.oOverwhelmedTakeOverTime * getTicksASecond()) {
              
                //Create highest count variable
                uint highestCount = 0;
                
                //Create most numerous team variable
                uint mostNumerousTeam = 0;
                
                //Iterate through all unfriendly again to determine which team won
                for(uint i=0; i<unfriendlyCount.length; i++) {
                
                  //Check if higher than previously highest
                  if(unfriendlyCount[i] > highestCount) {
                  
                    highestCount = unfriendlyCount[i];
                    mostNumerousTeam = i;
                    
                  }
                  
                }
                
                //Change ownership
                changeOwnership(this, mostNumerousTeam);
                
              }
              
            }
            
          }
          
          //Otherwise (not overwhelmed)
          else {
          
            //Unset overwhelmed
            data.eBlobWasOverwhelmed.iTime = -1;
            
          }
          
        }
        
      }
      
    }



    /**
     * Changes ownership of this building and nearby structures
     * 
     * @param   this        blob reference.
     * @param   teamNumber  the new team owner
     */
    void changeOwnership(CBlob@ this, const u8 teamNumber) {

      //Check if server
      if(getNet().isServer()) {
  
        //Retrieve data
        Data@ data = TerritorialBuilding::Blob::retrieveData(this);
      
        //Obtain a map reference
        CMap@ map = this.getMap();
        
        //Create an array of blob references
        CBlob@[] nearbyBlobs;
        
        //Obtain blob references within a radius
        if(map.getBlobsInRadius(this.getPosition(), data.oTerritoryRadius, @nearbyBlobs)) {
        
          //Create a blob handle
          CBlob@ nearbyBlob;
        
          //Iterate through nearby blobs
          for(uint i=0; i<nearbyBlobs.length; i++) {
          
            //Keep a reference to blob
            @nearbyBlob = nearbyBlobs[i];
            
            //Check if blob's owner is not same as new owner and is either a door, a building or a ladder
            if(nearbyBlob.getTeamNum() != teamNumber && (nearbyBlob.hasTag("door") || nearbyBlob.hasTag("building") || nearbyBlob.getName() == "ladder")) {
            
              //Set ownership on blob
              nearbyBlob.server_setTeamNum(teamNumber);
              
            }
            
          }
          
        }
        
      }
      
      //Set ownership of spawn site
      this.server_setTeamNum(teamNumber);
      
    }
    
    
    
  }
  
  
  
  namespace Sprite {
  }
  
  
  
  namespace Shape {
  }
  
  
  
  namespace Movement {
  }
  
  
  
  namespace Brain {
  }
  
  
  
  namespace Attachment {
  }
  
  
  
  namespace Inventory {
  }
  
  
  
}