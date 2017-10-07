/* 
 * Producer blob
 * 
 * This is a type of blob that has a production menu available to the player. It can produce any type of blob in a very basic way.
 * 
 * Author: ANybakk
 */

#include "[UndeadInvasion]UtilityBlob.as";
#include "[UndeadInvasion]ProductionOptionCost.as";
#include "[UndeadInvasion]ProductionOption.as";



namespace UndeadInvasion {

  namespace ProducerBlob {
  
  
  
    /**
     * Initializes this entity
     */
    void onInit(CBlob@ this) {
      
      UndeadInvasion::UtilityBlob::onInit(this);
      
      setTags(this);
      setCommands(this);
      setHarvestMaterials(this);
      
      //Check if storage should be enabled
      if(ProducerVariables::hasMaterialStorage) {
      
        //Put inventory button to the right
        this.inventoryButtonPos = Vec2f(8, 0);
        
      }
      
      this.set_string("currentProductName", "");
      this.set_bool("producingRepeat", false);
      
    }
  
    
    
    /**
     * Sets various tags for this entity type. Inheriting types should call this.
     * 
     * @param   this            a blob reference.
     */
    void setTags(CBlob@ this) {
    
      this.Tag("isProducerBlob");
      
    }
  
    
    
    /**
     * Sets various commands for this entity type.
     * 
     * @param   this            a blob reference.
     */
    void setCommands(CBlob@ this) {
    
      this.addCommandID("userShowProduction");
      AddIconToken("$userShowProduction$", "InteractionIcons.png", Vec2f(32, 32), 15); //Icon number 16 (Hammer)
      
      this.addCommandID("userProduce");
      
      this.addCommandID("userStopProduce");
      AddIconToken("$userStopProduce$", "BuilderIcons.png", Vec2f(32, 32), 2); //Icon number 3 (Hammer stop sign)
      
      this.addCommandID("userRepeatProduce");
      AddIconToken("$userRepeatProduce$", "MenuItems.png", Vec2f(32, 32), 21); //Icon number 22 (Circular arrow)
      
    }
    
    
    
    /**
     * Sets what materials are returned when harvesting
     */
    void setHarvestMaterials(CBlob@ this) {
    
      //Replace with derivative of BlobBuildBlock
      //this.set("harvest", BlobBuildBlock().mHarvestMaterials);
      
    }
    
    
    
    /**
     * Tick event function
     */
    void onTick(CBlob@ this) {
    
      //Check if producing anything
      if(this.get_string("currentProductName") != "") {
      
        //Calculate time remaining
        u16 timeRemaining = this.get_u16("producingFinishTime") - getGameTime();
        
        //If reached or passed time to finish
        if(timeRemaining <= 0) {
        
          //Create blob
          CBlob@ producedBlob = server_CreateBlob(this.get_string("currentProductName"), this.getTeamNum(), this.getPosition());
          
          //Check if repeat is active
          if(this.get_bool("producingRepeat")) {
          
            //Determine production time
            u16 produceTime = this.get_u16("producingFinishTime") - this.get_u16("producingStartTime");
            
            //Store new start time, including correction
            this.set_u16("producingStartTime", getGameTime() + timeRemaining);
            
            //Store new finish time
            this.set_u16("producingFinishTime", getGameTime() + produceTime);
            
            //Create argument bit stream
            CBitStream repeatArgumentStream;
            
            //Write blob name to stream
            repeatArgumentStream.write_string(this.get_string("currentProductName"));
            
            //Send produce command
            this.SendCommandOnlyServer(this.getCommandID("userProduce"), repeatArgumentStream);
            
          }
          
          //Otherwise, if repeat is inactive
          else {
          
            //Reset product name
            this.set_string("currentProductName", "");
            
          }
          
        }
        
        //Otherwise (not finished)
        else {
        
          //TODO: Modify "locked" material quantity
          
        }
        
      }
      
    }
    
    
    
    /**
     * Command event function
     */
    void onCommand(CBlob@ this, u8 commandID, CBitStream @argumentStream) {
    
      //If show production
      if(commandID == this.getCommandID("userShowProduction")) {
      
        //Attempt to read user ID
        u16 userID;
        if(!argumentStream.saferead_netid(userID)) {
          return;
        }
        
        //Obtain reference to user blob
        CBlob@ userBlob = getBlobByNetworkID(userID);
        
        //Continue, if valid reference and is player
        if(userBlob !is null && userBlob.isMyPlayer()) {
        
          //Create a product grid menu
          CGridMenu@ productMenu = CreateGridMenu(
              userBlob.getScreenPos(),                  //pos2d
              this,                                     //blob
              ProducerVariables::PRODUCTION_MENU_SIZE, //slots
              "Materials"                               //
            );
          
          //Check if valid reference and there are productions options
          if(productMenu !is null && ProducerVariables::PRODUCTION_OPTIONS.length > 0) {
          
            //Create button reference handle
            CGridButton@ button;
            
            //Create a production option reference handle
            UndeadInvasion::ProductionOption@ productionOption;
            
            //Create hover text string
            string hoverText;
            
            //Iterate through production options
            for(int i=0; i<ProducerVariables::PRODUCTION_OPTIONS.length; i++) {
            
              //Keep reference
              @productionOption = ProducerVariables::PRODUCTION_OPTIONS[i];
              
              //Create argument bit stream
              CBitStream buttonArgumentStream;
              
              //Write blob name to stream
              buttonArgumentStream.write_string(productionOption.mName);
              
              //Write time to stream
              buttonArgumentStream.write_u16(productionOption.mTime * getTicksASecond());
              
              //Begin to build up hover text string
              hoverText = productionOption.mDecription + "\n\n";
            
              //Create a production option cost reference handle
              UndeadInvasion::ProductionOptionCost@ productionOptionCost;
              
              //Iterate through costs
              for(int j=0; j<productionOption.mCosts.length; j++) {
              
                //Keep reference
                @productionOptionCost = productionOption.mCosts[j];
                
                //Create a string token for cost text color depending on material requirements
                string costColor = "$RED$";
                
                //Check if storage should be enabled
                if(ProducerVariables::hasMaterialStorage) {
                
                  //Check if enough in material storage
                  if(this.getBlobCount(productionOptionCost.mName) >= productionOptionCost.mAmount) {
                  
                    //Change color string token
                    costColor = "$GREEN$";
                    
                  }
                  
                  //Write material blob name to stream
                  buttonArgumentStream.write_string(productionOptionCost.mName);
                  
                  //Write material blob amount to stream
                  buttonArgumentStream.write_u8(productionOptionCost.mAmount);
                  
                }
                
                //Append cost to hover text
                hoverText += " " + costColor + productionOptionCost.mAmount + costColor + " $" + productionOptionCost.mName + "$ " + costColor + productionOptionCost.mCaption + costColor;
                
              }
              
              //Add button
              @button = productMenu.AddButton(
                  "$" + productionOption.mName + "$",             //iconName
                  productionOption.mCaption,                      //caption
                  this.getCommandID("userProduce"),               //cmdID
                  //Vec2f(1.0f, 1.0f),                              //slotsDim (button size, overrides inventory size, but only if larger)
                  buttonArgumentStream                            //parameters
                );
              
              //Continue only if valid reference (to ensure there was enough space)
              if(button !is null) {
                
                //Set hover text
                button.hoverText = hoverText + " (" + productionOption.mTime + "s)\n";
                
                //Check if producing same product
                if(this.get_string("currentProductName") == productionOption.mName) {
                
                  //Set not clickable
                  //button.clickable = false;
                  
                  //Disable button (greyed out)
                  button.SetEnabled(false);
                  
                }
                
                button.selectOnClick = true;
                
              }
            
            }
            
            //Continue if tool menu is supposed to be enabled
            if(ProducerVariables::TOOL_MENU_ENABLED) {
            
              f32 toolMenuSize = 0.0f;
              
              if(ProducerVariables::TOOL_MENU_STOP_ENABLED) {
                toolMenuSize += 1.0f;
              }
              
              if(ProducerVariables::TOOL_MENU_REPEAT_ENABLED) {
                toolMenuSize += 1.0f;
              }
              
              //Determine where to position the tool menu
              Vec2f toolMenuPosition = productMenu.getUpperLeftPosition() + Vec2f(-32.0f, (toolMenuSize +1.0f) * 32 / 2);
              
              //Create menu
              CGridMenu@ toolMenu = CreateGridMenu(
                  toolMenuPosition,           //pos2d
                  this,                       //blob
                  Vec2f(1.0f, toolMenuSize),  //slots
                  ""                          //
                );
                
              //Continue if valid
              if(toolMenu !is null) {
              
                //Disable caption
                toolMenu.SetCaptionEnabled(false);
                
                //If stop tool should be enabled
                if(ProducerVariables::TOOL_MENU_STOP_ENABLED) {
                
                  //Create argument stream
                  CBitStream stopToolButtonArgumentStream;
                  
                  //Write name of current product
                  stopToolButtonArgumentStream.write_string(this.get_string("currentProductName"));
                  
                  //Add button
                  CGridButton@ stopToolButton = toolMenu.AddButton(
                      "$userStopProduce$",                            //iconName
                      "",                                             //caption
                      this.getCommandID("userStopProduce"),           //cmdID
                      //Vec2f(1.0f, 1.0f),                              //slotsDim (button size, overrides inventory size, but only if larger)
                      stopToolButtonArgumentStream                    //parameters
                    );
                  
                  //Continue if button added
                  if(stopToolButton !is null) {
                  
                    //Set hover text
                    stopToolButton.SetHoverText("Stop producing\n");
                    
                  }
                  
                }
                
                //If repeat tool should be enabled
                if(ProducerVariables::TOOL_MENU_REPEAT_ENABLED) {
                
                  //Create argument stream
                  CBitStream repeatToolButtonArgumentStream;
                  
                  //Write name of current product
                  repeatToolButtonArgumentStream.write_string(this.get_string("currentProductName"));
                  
                  //Add button
                  CGridButton@ repeatToolButton = toolMenu.AddButton(
                      "$userRepeatProduce$",                            //iconName
                      "",                                             //caption
                      this.getCommandID("userRepeatProduce"),           //cmdID
                      //Vec2f(1.0f, 1.0f),                              //slotsDim (button size, overrides inventory size, but only if larger)
                      repeatToolButtonArgumentStream                    //parameters
                    );
                  
                  //Continue if button added
                  if(repeatToolButton !is null) {
                  
                    //Set hover text
                    repeatToolButton.SetHoverText("Repeat\n");
                    
                    //Check if already repeat active
                    if(this.get_bool("producingRepeat")) {
                    
                      //Set button selected
                      repeatToolButton.SetSelected(1);
                      
                    }
                    
                  }
                  
                }
                
              }
              
            }
            
          }
          
        }
        
      }
      
      //If produce
      else if(commandID == this.getCommandID("userProduce")) {
      
        //Attempt to read blob name
        string productName;
        if(!argumentStream.saferead_string(productName)) {
          return;
        }
      
        //Attempt to read production time (default to next tick if missing)
        u16 produceTime;
        if(!argumentStream.saferead_u16(produceTime)) {
          produceTime = 1;
        }
        
        //Continue if not already producing same product
        if(productName != this.get_string("currentProductName")) {
        
          //Store new product name
          this.set_string("currentProductName", productName);
          
          //Store new start time
          this.set_u16("producingStartTime", getGameTime());
          
          //Store new finish time
          this.set_u16("producingFinishTime", getGameTime() + produceTime);
          
          //Create material name string
          string materialName;
          
          //Create material amount varialble
          u8 materialAmount;
          
          //Repeat while there are more
          while(argumentStream.saferead_string(productName)) {
          
            argumentStream.saferead_u8(materialAmount);
          
            //TODO: Lock materials
            //Move from this.inventory to MATLOCK1 and MATLOCK2 attachmentpoints
          
          }
          
        }
        
        
      }
      
      //If stop produce
      else if(commandID == this.getCommandID("userStopProduce")) {
      
        //Attempt to read blob name
        string productName;
        if(!argumentStream.saferead_string(productName)) {
          productName = "";
        }
        
        //Check if still producing same product
        if(this.get_string("currentProductName") == productName) {
        
          //Reset product name
          this.set_string("currentProductName", "");
          
          //Unset repeat flag
          this.set_bool("producingRepeat", false);
          
        }
        
      }
      
      //If repeat produce
      else if(commandID == this.getCommandID("userRepeatProduce")) {
        
        //Attempt to read blob name
        string productName;
        if(!argumentStream.saferead_string(productName)) {
          productName = "";
        }
        
        //Stop, if product mismatch (something happened meanwhile)
        if(this.get_string("currentProductName") != productName) {
          return;
        }
        
        //Check if repeat is already active
        if(this.get_bool("producingRepeat")) {
        
          //Deactivate/toggle
          this.set_bool("producingRepeat", false);
          
        }
        
        //Otherwise
        else {
          
          //Set repeat flag
          this.set_bool("producingRepeat", true);
          
        }
        
      }
      
    }
    
    
    
    /**
     *
     */
    bool isInventoryAccessible(CBlob@ this, CBlob@ userBlob) {
    
      //Return true if on same team and is overlapping
      return
        userBlob.getTeamNum() == this.getTeamNum()
        && userBlob.isOverlapping(this);
      
    }
    
    
    
    /**
     * 
     */
    void GetButtonsFor(CBlob@ this, CBlob@ userBlob) {
    
      //Abort if inventory is not accessible
      if(!isInventoryAccessible(this, userBlob)) {
        return;
      }
      
      //Create argument bit stream
      CBitStream argumentStream;
      
      //Write user ID to stream
      argumentStream.write_u16(userBlob.getNetworkID());
      
      //Determine positional offset depending on whether inventory button needs space
      Vec2f buttonPositionOffset = (ProducerVariables::hasMaterialStorage) ? Vec2f(-8, 0) : Vec2f(0, 0);
      
      //Create a button to the left that sends the show production command
      userBlob.CreateGenericButton(
          "$userShowProduction$",                   //iconName
          buttonPositionOffset,                     //_offset
          this,                                     //attached
          this.getCommandID("userShowProduction"),  //cmdID
          "Production",                             //caption
          argumentStream                            //parameters
        );
      
    }

    
    
    
  }
  
}