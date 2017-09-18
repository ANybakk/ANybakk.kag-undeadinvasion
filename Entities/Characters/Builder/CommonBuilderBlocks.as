/*
 * UndeadInvasion builder block configuration
 * 
 * This script handles anything related to a builders building options
 * 
 * Author: ANybakk
 */

#include "BuildBlock.as";
#include "Requirements.as";



const string blocks_property = "blocks";
const string inventory_offset = "inventory offset";



void addCommonBuilderBlocks(BuildBlock[][]@ blocks) {

  BuildBlock[] page_0;
  blocks.push_back(page_0);
  
  {
    BuildBlock b(CMap::tile_castle, "stone_block", "$stone_block$", "Stone Block\nBasic building block");
    AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 10);
    blocks[0].push_back(b);
  }
  
  {
    BuildBlock b(CMap::tile_castle_back, "back_stone_block", "$back_stone_block$", "Back Stone Wall\nExtra support");
    AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 2);
    blocks[0].push_back(b);
  }
  
  {
    BuildBlock b(0, "stone_door", "$stone_door$", "Stone Door\nPlace next to walls");
    AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 50);
    blocks[0].push_back(b);
  }
  
  {
    BuildBlock b(CMap::tile_wood, "wood_block", "$wood_block$", "Wood Block\nCheap block\nwatch out for fire!");
    AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 10);
    blocks[0].push_back(b);
  }
  
  {
    BuildBlock b(CMap::tile_wood_back, "back_wood_block", "$back_wood_block$", "Back Wood Wall\nCheap extra support");
    AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 2);
    blocks[0].push_back(b);
  }
  
  {
    BuildBlock b(0, "wooden_door", "$wooden_door$", "Wooden Door\nPlace next to walls");
    AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 30);
    blocks[0].push_back(b);
  }
  
  //{
  //  BuildBlock b(0, "trap_block", "$trap_block$", "Trap Block\nOnly enemies can pass");
  //  AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 25);
  //  blocks[0].push_back(b);
  //}
  
  {
    BuildBlock b(0, "ladder", "$ladder$", "Ladder\nAnyone can climb it");
    AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 10);
    blocks[0].push_back(b);
  }
  
  {
    BuildBlock b(0, "wooden_platform", "$wooden_platform$", "Wooden Platform\nOne way platform");
    AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 15);
    blocks[0].push_back(b);
  }
  
  //{
  //  BuildBlock b(0, "Belt Conveyor", "$Belt Conveyor$", "Conveyor\nTransports stuff");
  //  AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 15);
  //  blocks[0].push_back(b);
  //}
  
  //{
  //  BuildBlock b(0, "spikes", "$spikes$", "Spikes\nPlace on Stone Block\nfor Retracting Trap");
  //  AddRequirement(b.reqs, "blob", "mat_stone", "Stone", 30);
  //  blocks[0].push_back(b);
  //}

  {
    BuildBlock b(0, "building", "$building$", "Workshop\nStand in an open space\nand tap this button.");
    AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 150);
    b.buildOnGround = true;
    b.size.Set(40, 24);
    blocks[0].push_back(b);
  }
  
  {
    BuildBlock b(0, "Bed", "$Bed$", "Bed\nSleep tight");
    AddRequirement(b.reqs, "blob", "mat_wood", "Wood", 30);
    b.buildOnGround = true;
    b.size.Set(24, 16);
    blocks[0].push_back(b);
  }
  
}