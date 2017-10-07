/*
 * Rules script
 * 
 * Author: ANybakk
 */




namespace Base {

  namespace Rules {
  
  
  
    /**
     * Initialization event function.
     */
    void onInit(CRules@ this) {
      
      //Save start time
      this.set_u32("Rules::startTime", getGameTime());
      
      //Finished
      return;
      
    }
    
    
    
    /*
     * Restart event function
     */
    void onRestart(CRules@ this) {
      
      //Finished
      return;
      
    }
    
    
    
    /**
     * Calculates lapsed time since game started.
     */
    int getLapsedTime(CRules@ this) {

      //Finished, return time since start time
      return getGameTime() - this.get_u32("Rules::startTime");
      
    }
    
    
    
    /**
     * Calculates how many days have passed.
     */
    int getDayNumber(CRules@ this) {
    
      //Finished, return result (integer division: lapsed time / day time)
      return getLapsedTime(this) / (this.daycycle_speed * 60 * getTicksASecond());
      
    }
    
    
    
    /**
     * Calculate how far into the current day it is.
     */
    f32 getTimeOfDay(CRules@ this) {
    
      //Finished, return result (rest division: lapsed time / day time)
      return getLapsedTime(this) % (this.daycycle_speed * 60 * getTicksASecond());
      
    }
    
    
    
    /**
     * Determine if it's night time.
     */
    bool isNightTime(CRules@ this) {
    
      //Get time of day
      f32 timeOfDay = getTimeOfDay(this);
    
      //Finished, return result (time of day is within 0.66 - 0.9)
      return timeOfDay >= 0.66 * this.daycycle_speed * 60 * getTicksASecond() && timeOfDay <= 0.9 * this.daycycle_speed * 60 * getTicksASecond();
      
    }
    
    
    
    /**
     * Determine if it's night time.
     */
    bool isDayTime(CRules@ this) {
    
      //Finished, return true if not night time
      return !isNightTime(this);
      
    }
    
    
    
    /**
     * Determine if night has passed.
     */
    bool nightHasPassed(CRules@ this) {
    
      //Finished, return result (time of day is within 0.9 - 1.0)
      return getTimeOfDay(this) > 0.9 * this.daycycle_speed * 60 * getTicksASecond();
      
    }
    
    
    
  }
  
}