import de.bezier.data.sql.*;


class CheckinsOverviewApp {

    SimpleThread_checkinsOverviewApp thread_callDB;
    MySQL dbconnection;
    MySQL dbconnection_exp;
    MySQL dbconnection_int;
    MySQL dbconnection_quest;

  //SQL-QUERIES
    //get all expertise keywords
    String expertise_all = "SELECT expertise, COUNT(expertise) AS frequency FROM expertise_table GROUP BY expertise ORDER BY frequency DESC";
    //get all interest keywords
    String interests_all = "SELECT interest, COUNT(interest) AS frequency FROM interest_table GROUP BY interest ORDER BY frequency DESC";
    //get all interest keywords
    String questions_all = "SELECT question, COUNT(question) AS frequency FROM questions_table GROUP BY question ORDER BY frequency DESC";
    
    // get all checked-in users with user_details and checkin details (user id, firstname, lastname, identification_media_type and id, timestamp, sublimation)
    String users_checkedin = "SELECT eu.id AS edge_user_id, eu.firstname, eu.lastname, eu.occupation, eu.statusmessage, imt.name AS imt_name, im.ThirdPartyID AS im_id, check_in.check_in_time AS checkin_timestamp, check_in.sublocation AS checkin_sublocation FROM (((identification_media im JOIN identification_media_type imt ON im.type = imt.id) JOIN people ON people.identification_id = im.id) JOIN edge_users eu ON eu.id = people.edge_users_id) JOIN check_in ON check_in.identification_media_id = im.id";
    
    // get all expertise keywords from a particular checked_in user (im.thirdpartyid)
    String expertise_user_checkedin = "SELECT et.expertise FROM (((((identification_media im JOIN identification_media_type imt ON im.type = imt.id) JOIN people ON people.identification_id = im.id) JOIN edge_users eu ON eu.id = people.edge_users_id) JOIN check_in ON (check_in.identification_media_id = im.id)) JOIN expertise_table et ON et.edge_users_id = eu.id) WHERE eu.id = "; //+ 28
    
    //...alternatively use edge_user_id to filter a particular user
    //WHERE eu.id = 28 instead of
    //WHERE im.thirdpartyid = 5408543
    //WHERE im.thirdpartyid = 123456
    
    // get all interest keywords from a particular checked_in user
    String interests_user_checkedin = "SELECT it.interest FROM (((((identification_media im JOIN identification_media_type imt ON im.type = imt.id) JOIN people ON people.identification_id = im.id) JOIN edge_users eu ON eu.id = people.edge_users_id) JOIN check_in ON (check_in.identification_media_id = im.id)) JOIN interest_table it ON it.edge_users_id = eu.id) WHERE eu.id = ";
    
    // get all questions from a particular checked_in user
    String questions_user_checkedin = "SELECT qt.question FROM (((((identification_media im JOIN identification_media_type imt ON im.type = imt.id) JOIN people ON people.identification_id = im.id) JOIN edge_users eu ON eu.id = people.edge_users_id) JOIN check_in ON (check_in.identification_media_id = im.id)) JOIN questions_table qt ON qt.edge_users_id = eu.id) WHERE eu.id = ";

    //mysql-account
    String user     = "root";
    String pass     = "";
    String database = "meetmee_checkin3";
    int threadwaittime = 20000; //ms before each DB-fetch
    
    
    	
    // name of the table that will be created
    String table    = "";
    
    PApplet applet;
  
    UserCard[] userCard; 

  CheckinsOverviewApp(PApplet applet) {
    this.applet = applet;
    setup(applet);
  }

  void setup(PApplet applet) {
    thread_callDB = new SimpleThread_checkinsOverviewApp(threadwaittime,"callDB", this);
    thread_callDB.start();
  }
  
  UserCard[] getUserCard(){
    return this.userCard;
  }

  void draw() {
    if (thread_callDB.getCount() > 0){
      for (int i = 0; i < userCard.length; i++) {      
        userCard[i].draw();
      }
    }
  }
  
    //gets user data from all checked-in users and stores them in local array variables
  UserCard[] getUserData(){
  
      UserCard[] uc = new UserCard[0]; 
      // connect to database of server "localhost"
      dbconnection = new MySQL( this.applet, "localhost", database, user, pass );
      
      if ( dbconnection.connect() ){

        // now read it back out
          dbconnection.query(users_checkedin);
          while (dbconnection.next()){
            
              String edge_user_id = dbconnection.getString("edge_user_id");
              String firstname = dbconnection.getString("firstname");
              String lastname = dbconnection.getString("lastname");
              String occupation = dbconnection.getString("occupation");
              String statusmessage = dbconnection.getString("statusmessage");
              String timestamp = dbconnection.getString("checkin_timestamp");
              String sublocation = dbconnection.getString("checkin_sublocation");
              println(firstname + " \t " + lastname + " \t " + timestamp + " \t " + sublocation);
              
              String[] expertise_arr={};
              String[] interests_arr={};
              String[] questions_arr={};
              
                  dbconnection_exp = new MySQL( this.applet, "localhost", database, user, pass ); 
                  if ( dbconnection_exp.connect() ){
                      dbconnection_exp.query(expertise_user_checkedin + edge_user_id);
                      while (dbconnection_exp.next()){
                          String expertise = dbconnection_exp.getString("expertise");
                          expertise_arr = (String[])(append(expertise_arr, expertise));
                      }
                    println(expertise_arr);
                    dbconnection_exp.close();  
                  }
                  else{
                      println("mysql connection failed: expertise");
                  }
                  
                  dbconnection_int = new MySQL( this.applet, "localhost", database, user, pass ); 
                  if ( dbconnection_int.connect() ){
                      dbconnection_int.query(interests_user_checkedin + edge_user_id);
                      while (dbconnection_int.next()){
                          String interest = dbconnection_int.getString("interest");
                          interests_arr = (String[])(append(interests_arr, interest));
                          
                      }
                        println(interests_arr);
                        dbconnection_int.close();
                  }
                  else{
                      println("mysql connection failed: interests");
                  }
                  
                  dbconnection_quest = new MySQL( this.applet, "localhost", database, user, pass ); 
                  if ( dbconnection_quest.connect() ){
                      dbconnection_quest.query(questions_user_checkedin + edge_user_id);
                      while (dbconnection_quest.next()){
                          String questions = dbconnection_quest.getString("question");
                          questions_arr = (String[])(append(questions_arr, questions));
                          
                      }
                        println(questions_arr);
                      dbconnection_quest.close();  
                  }
                  else{
                      println("mysql connection failed: questions");
                  }
                  
                  UserCard newUserCard = new UserCard(firstname, lastname, occupation, statusmessage, timestamp, sublocation, expertise_arr, interests_arr, questions_arr);
                  uc = (UserCard[])(append(uc, newUserCard));
          }
          dbconnection.close();
 
      }
      else{
          // connection failed !
          println("mysql connection failed: users_checkedin");
      }
      
    return uc;
  }

}

class UserCard extends GUI {
  
  String firstname;
  String lastname;
  String occupation;
  String statusmessage;
  String timestamp;
  String sublocation;
  String[] expertise;
  String[] interests;
  String[] questions;
  
    //setFont
  PFont font_username = loadFont("Serif-28.vlw");
  PFont font_usersubtitle = loadFont("Serif-20.vlw");
  PFont font_userdescription = loadFont("Serif-20.vlw");
  
  
  UserCard(String firstname, String lastname, String occupation, String statusmessage, String timestamp, String sublocation, String[] expertise, String[] interests, String[] questions) {
    //ProjectImage image = new ProjectImage(imageUrl); 
    //setBoundaries(200, 100); 
    //addWidget(image); 
    
    this.firstname = firstname;
    this.lastname = lastname;
    this.statusmessage = statusmessage;
    this.occupation = occupation;
    this.timestamp = timestamp;
    this.sublocation = sublocation;
    this.expertise = expertise;
    this.interests = interests;
    this.questions = questions;
    

    
        Label name_lb = new Label(firstname + " " + lastname); 
        name_lb.setTranslation(0, 0);
        name_lb.setFont(font_username); 
        name_lb.textColor = color(0, 10, 20);  
        addWidget(name_lb);
        
        Label occupation_lb = new Label(occupation);
        occupation_lb.setTranslation(0, 40);
        occupation_lb.setFont(font_usersubtitle); 
        occupation_lb.textColor = color(127, 127, 0);  
        addWidget(occupation_lb);
     
        Label statusmessage_lb = new Label(statusmessage);
        statusmessage_lb.setTranslation(0, 70);
        statusmessage_lb.setFont(font_usersubtitle); 
        statusmessage_lb.textColor = color(127, 127, 0);  
        addWidget(statusmessage_lb);     
        
        Label timestamp_lb = new Label("Checked in " + timestamp + " at " + sublocation);
        timestamp_lb.setTranslation(0, 100);
        timestamp_lb.setFont(font_usersubtitle); 
        timestamp_lb.textColor = color(127, 127, 0);  
        addWidget(timestamp_lb);     
    
        float exp_angle = (-PI/expertise.length);
        for (int i = 0; i < expertise.length; i++) {       
            Label expertise_lb = new Label(expertise[i]);
            expertise_lb.setTranslation(-250, 40*i);
            expertise_lb.setFont(font_usersubtitle); 
            expertise_lb.textColor = color(127, 0, 0);  
            //expertise_lb.setRotation(PI/2 - exp_angle * i);
            addWidget(expertise_lb);     
        }
        
        float int_angle = (PI/interests.length);
        for (int i = 0; i < interests.length; i++) {       
            Label interests_lb = new Label(interests[i]);
            //interests_lb.setTranslation(cos(PI/4-int_angle*i)*100, sin(PI/4-int_angle*i)*100);
            interests_lb.setTranslation(250, i*40);
            interests_lb.setFont(font_usersubtitle); 
            interests_lb.textColor = color(127, 0, 0);
            //interests_lb.setRotation(-PI/2 + int_angle * i);  
            addWidget(interests_lb);     
        }
    
    //createManipulator(this);
    
    setTranslation(random(-width/2, width/2), random(-height/2, height/2)); 
//    setTranslation(-100, 100);
    setScale(0.7); 
    //setRotation(random(-PI/4, +PI/4)); 
  }
  
  String getFirstname(){
    return this.firstname;
  } 
  String getLastname(){
    return this.lastname;
  }
  String getTimestamp(){
    return this.timestamp;
  }
  String getOccupation(){
    return this.occupation;
  }  
  String getStatusmessage(){
    return this.statusmessage;
  }  
  String getSublocation(){
    return this.sublocation;
  }
  String[] getExpertise(){
    return this.expertise;
  }
  String[] getInterests(){
    return this.interests;
  }
  String[] getQuestions(){
    return this.questions;
  }  

  
//  float shear = 0.0;
//   
//  
//  void drawWidget() {
//    setTranslation(shear, shear); 
//    shear += PI / 1024;
//    super.drawWidget();  
//  }

//  class ProjectImage extends ImageWidget {
//    ProjectImage(String file) {
//      super(file);
//    }
//
//    void addCursor(MTCursor c) {
//      c.setTarget(container);
//      container.addCursor(c);
//    }
//  }
  
}

class SimpleThread_checkinsOverviewApp extends Thread {
 
  boolean running;           // Is the thread running?  Yes or no?
  int wait;                  // How many milliseconds should we wait in between executions?
  String id;                 // Thread name
  int count;                 // counter
  CheckinsOverviewApp checkinsOverviewApp;
   
  // Constructor, create the thread
  // It is not running by default
  SimpleThread_checkinsOverviewApp (int w, String s, CheckinsOverviewApp checkinsOverviewApp) {
    wait = w;
    running = false;
    id = s;
    count = 0;
    this.checkinsOverviewApp = checkinsOverviewApp;
  }
 
  int getCount() {
    return count;
  }
 
  // Overriding "start()"
  void start () {
    // Set running equal to true
    running = true;
    // Print messages
    println("Starting thread (will execute every " + wait + " milliseconds.)"); 
    // Do whatever start does in Thread, don't forget this!
    super.start();
  }
 
 
  // We must implement run, this gets triggered by start()
  void run () {
    while (running) {
      println(id + ": " + count);
      
      
      checkinsOverviewApp.userCard = checkinsOverviewApp.getUserData();
      count++;
      // Ok, let's wait for however long we should wait
      try {
        sleep((long)(wait));
      } catch (Exception e) {
      }
    }
    System.out.println(id + " thread is done!");  // The thread is done when we get to the end of run()
  }
 
 
  // Our method that quits the thread
  void quit() {
    System.out.println("Quitting."); 
    running = false;  // Setting running to false ends the loop in run()
    // IUn case the thread is waiting. . .
    interrupt();
  }
}

