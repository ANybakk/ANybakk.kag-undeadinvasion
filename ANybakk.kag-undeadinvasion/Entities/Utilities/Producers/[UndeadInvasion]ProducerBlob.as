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
#include "[UndeadInvasion]ProductionIngredientBlob.as";



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
      
      AddIconToken("$ProducerBlob::productionTime$", "[UndeadInvasion]Producer.png", Vec2f(16, 16), 0); //Icon number 1 (Clock)
      
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
    
      this.addCommandID("ProducerBlob::showMenu");
      AddIconToken("$ProducerBlob::showMenu$", "InteractionIcons.png", Vec2f(32, 32), 15); //Icon number 16 (Hammer)
      
      this.addCommandID("ProducerBlob::make");
      
      this.addCommandID("ProducerBlob::stop");
      AddIconToken("$ProducerBlob::stop$", "BuilderIcons.png", Vec2f(32, 32), 2); //Icon number 3 (Hammer stop sign)
      
      this.addCommandID("ProducerBlob::repeat");
      AddIconToken("$ProducerBlob::repeat$", "MenuItems.png", Vec2f(32, 32), 21); //Icon number 22 (Circular arrow)
      
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
        
          //Finish up
          finish(this, timeRemaining);
          
        }
        
        //Otherwise (not finished)
        else {
        
          //TODO: Modify "locked" material quantity?
          
        }
        
      }
      
    }
    
    
    
    /**
     * Command event function
     */
    void onCommand(CBlob@ this, u8 commandID, CBitStream @argumentStream) {
    
      //showMenu
      if(commandID == this.getCommandID("ProducerBlob::showMenu")) {
      
        //Attempt to read user ID
        u16 userID;
        if(!argumentStream.saferead_netid(userID)) {
          return;
        }
        
        showMenu(this, userID);
        
      }
      
      //make
      else if(commandID == this.getCommandID("ProducerBlob::make")) {
        
        make(this, UndeadInvasion::ProductionOption(argumentStream));
        
      }
      
      //stop
      else if(commandID == this.getCommandID("ProducerBlob::stop")) {
      
        //Attempt to read blob name (default to nothing)
        string productName;
        if(!argumentStream.saferead_string(productName)) {
          productName = "";
        }
        
        stop(this, productName);
        
      }
      
      //repeat
      else if(commandID == this.getCommandID("ProducerBlob::repeat")) {
        
        //Attempt to read blob name (default to nothing)
        string productName;
        if(!argumentStream.saferead_string(productName)) {
          productName = "";
        }
        
        repeat(this, productName);
        
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
          "$ProducerBlob::showMenu$",                   //iconName
          buttonPositionOffset,                         //_offset
          this,                                         //attached
          this.getCommandID("ProducerBlob::showMenu"),  //cmdID
          "Production",                                 //caption
          argumentStream                                //parameters
        );
      
    }
    
    
    
    /**
     * Shows a production menu for a specific user.
     * TODO: Does not currently check player's inventory if storage isn't enabled
     * TODO: Does not color costs correctly after producing something
     * 
     * @param     this                  producer blob.
     * @param     userID                the user's ID.
     */
    void showMenu(CBlob@ this, u16 userID) {
        
        //Obtain reference to user blob
        CBlob@ userBlob = getBlobByNetworkID(userID);
        
        //Continue, if valid reference and is player
        if(userBlob !is null && userBlob.isMyPlayer()) {
        
          //Create a product grid menu
          CGridMenu@ productMenu = CreateGridMenu(
              userBlob.getScreenPos(),                  //pos2d
              this,                                     //blob
              ProducerVariables::PRODUCTION_MENU_SIZE,  //slots
              "Product"                               //
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
              
              //Serialize to stream, including costs if storage should be enabled
              productionOption.toStream(buttonArgumentStream, ProducerVariables::hasMaterialStorage);
              
              //Begin to build up hover text string
              hoverText = productionOption.mDescription + "\n\n";
            
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
                  
                }
                
                //Append cost to hover text
                hoverText += "$" + productionOptionCost.mName + "$ " + costColor + productionOptionCost.mCaption + " x " + productionOptionCost.mAmount + costColor + "\n\n";
                
              }
              
              //Add button
              @button = productMenu.AddButton(
                  "$" + productionOption.mName + "$",             //iconName
                  productionOption.mCaption,                      //caption
                  this.getCommandID("ProducerBlob::make"),               //cmdID
                  //Vec2f(1.0f, 1.0f),                              //slotsDim (button size, overrides inventory size, but only if larger)
                  buttonArgumentStream                            //parameters
                );
              
              //Continue only if valid reference (to ensure there was enough space)
              if(button !is null) {
                
                //Set hover text
                button.hoverText = hoverText + "$ProducerBlob::productionTime$ Time : " + productionOption.mTime + " second(s)\n";
                
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
            
            //If tool menu is supposed to be enabled
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
                      "$ProducerBlob::stop$",                            //iconName
                      "",                                             //caption
                      this.getCommandID("ProducerBlob::stop"),           //cmdID
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
                      "$ProducerBlob::repeat$",                            //iconName
                      "",                                             //caption
                      this.getCommandID("ProducerBlob::repeat"),           //cmdID
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
            
            //If storage enabled and has attachments
            if(ProducerVariables::hasMaterialStorage && this.getAttachmentPointCount() > 0) {
            
              f32 matlockMenuSize = 1.0f;
              
              //Determine where to position the matlock menu
              Vec2f matlockMenuPosition(
                  userBlob.getScreenPos().x
                  , productMenu.getLowerRightPosition().y 
                      + 32.0f + (matlockMenuSize + 1.0f) * 32 / 2
                );
              
              //Create menu
              CGridMenu@ matlockMenu = CreateGridMenu(
                  matlockMenuPosition         //pos2d
                  , this                      //blob
                  , Vec2f(ProducerVariables::PRODUCTION_MENU_SIZE.x, 1.0f)  //slots
                  , "Ingredients"             //
                );
                
              AttachmentPoint@ attachmentPoint;
              CBlob@ attachedBlob;
              CGridButton@ matlockButton;
              
              //Iterate
              for(int i=0; i<ProducerVariables::PRODUCTION_MENU_SIZE.x; i++) {
                
                //Obtain attachment point reference
                @attachmentPoint = this.getAttachments().getAttachmentPointByName("MATLOCK" + i);
                
                if(attachmentPoint !is null) {
                
                  @attachedBlob = attachmentPoint.getOccupied();
                  
                  if(attachedBlob !is null) {
                  
                    //Add button
                    @matlockButton = matlockMenu.AddButton(
                        "$" + attachedBlob.getName() + "$"                  //iconName
                        , "Ingredients"                                     //caption
                        , Vec2f(1.0f, 1.0f)                                 //slotsDim (button size, overrides inventory size, but only if larger)
                      );
                      
                    if(matlockButton !is null) {
                    
                      matlockButton.SetHoverText(attachedBlob.getInventoryName() + ": " + attachedBlob.getQuantity());
                      matlockButton.clickable = false;
                      
                    }
                    
                  }
                  
                }
                
              }
                
            }
            
          }
          
        }
        
    } //End function
    
    
    
    /**
     * Attempts to make a certain product option. If requirements are not met, production is stopped. Ignores duplicate one-time calls.
     * TODO: Currently does not handle the case where storage is disabled
     * 
     * @param     this                  producer blob.
     * @param     productionOption      product option object.
     */
    void make(CBlob@ this, UndeadInvasion::ProductionOption@ productionOption) {
      
      //Abort if already producing this product and not repeating
      if(productionOption.mName == this.get_string("currentProductName") && !this.get_bool("producingRepeat")) {
        return;
      }
      
      bool undoAndAbort = false;
      
      CInventory@ inventory = this.getInventory();
      
      AttachmentPoint@[] attachmentPoints;
      UndeadInvasion::ProductionOptionCost@ optionCost;
      
      //Repeat for each cost
      for(int i=0; i<productionOption.mCosts.length; i++) {
      
        @optionCost = productionOption.mCosts[i];
        
        //Check if not present
        if(!inventory.isInInventory(optionCost.mName, optionCost.mAmount)) {
        
          //Abort
          undoAndAbort = true;
          break;
          
        }
        
        //Obtain reference to material lock attachment point
        attachmentPoints.push_back(
            this.getAttachments().getAttachmentPointByName("MATLOCK" + i)
          );
        
        if(attachmentPoints[i] !is null) {
        
          //Create new blob
          //CBlob@ lockedBlob = server_CreateBlobNoInit(optionCost.mName);
          CBlob@ lockedBlob = server_CreateBlob(optionCost.mName);
          
          //Set quantity
          lockedBlob.server_SetQuantity(optionCost.mAmount);
          
          //Toggle pickup
          UndeadInvasion::ProductionIngredientBlob::toggleIngredientPickUp(lockedBlob);
          
          //Set invisible
          if(ProducerVariables::INGREDIENT_INVISIBLE) {
            lockedBlob.SetVisible(false);
          }
          
          //Set consume status
          lockedBlob.set_bool("isConsumable", optionCost.mConsumed);
          
          //If able to attach
          if(this.server_AttachTo(lockedBlob, attachmentPoints[i])) {
          
            //Remove from inventory
            int amountRemoved = inventory.server_RemoveItems(optionCost.mName, optionCost.mAmount);
            
          }
          
          //Otherwise, if not able to attach
          else {
            
            //Abort
            undoAndAbort = true;
            break;
            
          }
          
        }
        
      }
      
      //If something happened and stuff has to be undone
      if(undoAndAbort) {
      
        //Stop production of current product
        stop(this, this.get_string("currentProductName"));
        
        //Abort
        return;
        
      }
      
      //Store new product name
      this.set_string("currentProductName", productionOption.mName);
      
      //Store new start time
      this.set_u16("producingStartTime", getGameTime());
      
      //Store new finish time
      this.set_u16("producingFinishTime", getGameTime() + productionOption.mTime * getTicksASecond());
      
    }
    
    
    
    /**
     * Stops producing a certain product type.
     * 
     * @param     this                  producer blob.
     * @param     productName           name of the product.
     */
    void stop(CBlob@ this, string productName) {
    
      //Check if still producing same product
      if(this.get_string("currentProductName") == productName) {
      
        //Reset product name
        this.set_string("currentProductName", "");
        
        //Unset repeat flag
        this.set_bool("producingRepeat", false);
        
        //Release ingredients without consuming anything
        releaseIngredients(this, false);
        
      }
      
    }
    
    
    
    /**
     * Toggles repeat for a certain product.
     * 
     * @param     this                  producer blob.
     * @param     productName           name of the product.
     */
    void repeat(CBlob@ this, string productName) {
    
      //Stop, if product mismatch (something happened meanwhile)
      if(this.get_string("currentProductName") != productName) {
        return;
      }
      
      this.set_bool("producingRepeat", !this.get_bool("producingRepeat"));
      
    }
    
    
    
    /**
     * Finishes whatever production is in progress.
     * 
     * @param     this                  producer blob.
     * @param     timeExceeded          how much time has passed since actual finish time.
     */
    void finish(CBlob@ this, u16 timeExceeded=0) {
    
      //Create blob
      CBlob@ producedBlob = server_CreateBlob(this.get_string("currentProductName"), this.getTeamNum(), this.getPosition());
      
      //Set quantity
      producedBlob.server_SetQuantity(1);
      
      //Set first frame
      producedBlob.getSprite().animation.frame = 0;
      
      //Release ingredients and consume any consumables
      releaseIngredients(this, true);
      
      //Check if repeat is active
      if(this.get_bool("producingRepeat")) {
      
        //Determine production time
        u16 produceTime = this.get_u16("producingFinishTime") - this.get_u16("producingStartTime");
        
        //Store new start time, including correction
        this.set_u16("producingStartTime", getGameTime() + timeExceeded);
        
        //Store new finish time
        this.set_u16("producingFinishTime", getGameTime() + produceTime);
        
        CBitStream repeatArgumentStream;
        UndeadInvasion::ProductionOption@ productionOption;
        
        //Iterate through production options
        for(int i=0; i<ProducerVariables::PRODUCTION_OPTIONS.length; i++) {
          
          @productionOption = ProducerVariables::PRODUCTION_OPTIONS[i];
          
          //Check if current product
          if(productionOption.mName == this.get_string("currentProductName")) {
          
            //Serialize production option
            productionOption.toStream(repeatArgumentStream, ProducerVariables::hasMaterialStorage);
            
            break;
            
          }
          
        }
        
        //Send make command
        this.SendCommandOnlyServer(this.getCommandID("ProducerBlob::make"), repeatArgumentStream);
        
      }
      
      //Otherwise, if repeat is inactive
      else {
      
        //Reset product name
        this.set_string("currentProductName", "");
        
      }
      
    }
    
    
    
    /**
     * Releases ingredients currently in use.
     * 
     * @param     this                  producer blob.
     * @param     consumeConsumables    whether to consume any "consumable" ingredients or not.
     */
    void releaseIngredients(CBlob@ this, bool consumeConsumables) {
    
      AttachmentPoint@ attachmentPoint;
      CBlob@ wasAttachedBlob;
      
      //Iterate
      for(int i=0; i<ProducerVariables::PRODUCTION_MENU_SIZE.x; i++) {
      
        //Obtain attachment point reference
        @attachmentPoint = this.getAttachments().getAttachmentPointByName("MATLOCK" + i);
        
        if(attachmentPoint !is null) {
        
          //Obtain reference to attached blob
          @wasAttachedBlob = attachmentPoint.getOccupied();
          
          if(wasAttachedBlob !is null) {
            
            //Detach
            wasAttachedBlob.server_DetachFrom(this);
            
            //Check if consumable
            if(consumeConsumables && wasAttachedBlob.get_bool("isConsumable")) {
            
              //Remove
              wasAttachedBlob.server_Die();
              
            }
            
            //Otherwise, not consumable
            else {
            
              //Toggle pickup
              UndeadInvasion::ProductionIngredientBlob::toggleIngredientPickUp(wasAttachedBlob);
              
              //Set visible
              if(ProducerVariables::INGREDIENT_INVISIBLE) {
                wasAttachedBlob.SetVisible(true);
              }
              
              //Check if possible to put into inventory
              //if(this.canBePutInInventory(wasAttachedBlob)) {
              
                //Attempt to put into inventory, and if that fails
                if(!this.server_PutInInventory(wasAttachedBlob)) {
                
                  //Move to producer's position
                  wasAttachedBlob.setPosition(this.getPosition());
                  
                };
                
              //}
              
              //else {
              
                //Move to producer's position
              //  wasAttachedBlob.setPosition(this.getPosition());
                
              //}
              
            }
            
          }
          
        }
        
      }
      
    }
    
    
    
  }
  
}