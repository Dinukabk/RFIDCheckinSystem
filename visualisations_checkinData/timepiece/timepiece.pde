// timepiece.pde

import org.json.*;

int WIN_W = 800;
int WIN_H = 600;

int last_update = millis();

int last_fetch;
int fetch_refresh_time = 5; // seconds

boolean mode = false;
float unravel = 0.0;  
float speed = 0.5;

String url = "http://meetmee.javaprovider.net/php/TheEdge_VisitorProfiles/API/view_number_distinctusercheckins_perhour_15minslots.php";


Timepiece t;

int numsegs = 4*12;

void setup() 
{ 
  size(800, 600);
  //size( screen.width, screen.height); 
  smooth();
  fetch_json(url);
  last_fetch = millis();
}

void draw() 
{
  int now = millis();
  float dt = (now - last_update)/1000.0;
  last_update = now;
  
  if (now - last_fetch > fetch_refresh_time*1000) 
  {
    fetch_json(url);
    last_fetch = now;
  }
  
  if (mode) 
    if (unravel < 1.0)
      unravel += speed*dt;
    else unravel = 1.0;
  else 
    if (unravel > 0.0)
      unravel -= speed*dt;
    else unravel = 0.0;
  
  background(0, 0, 0);
  translate((1.0-unravel)*WIN_W/2.0 + unravel*t.spiral_factor/numsegs, (1+0.8*unravel)*WIN_H/2.0);
  scale(1.0+0.5*unravel*WIN_W/t.spiral_factor, 1);
  t.render(unravel);
  float time = hour()%12 + minute()/60.0;
  t.render_line(unravel, time);
}

class Timepiece
{ 
  float d[];
  String desc[];
  float spiral_factor;
  float unit_length;
    
  Timepiece(float data[], String description[])
  {
    spiral_factor = 400;
    unit_length = 10;
    set_data(data, description);
  }
  
  void set_data(float data[], String description[]) 
  {
    d = data;
    desc = description;
  }
    
  void render_line(float unravelness, float pos)
  {
    float r0 = 4*pos*unravelness*spiral_factor/d.length;
    float a0 = 4*pos*TWO_PI*(1.0-unravelness)/d.length;
    
    // ray
    stroke(255, 153, 255, 128);
    float sw = 1.0f+0.25f*unravelness*(spiral_factor/d.length)-2;
    if (sw < 1) sw = 1;
    strokeWeight(sw);
    float val = 0.9*0.25*WIN_H;
    line(r0*cos(a0), r0*sin(a0), r0*cos(a0)+val*sin(a0), r0*sin(a0)-val*cos(a0));
  }
  
  // draw this timepiece
  void render(float unravelness)
  {    
    float dr = unravelness*spiral_factor/d.length;
    float da = TWO_PI*(1.0-unravelness)/d.length;
    float maxval = 0;
    for (int i = 0; i < d.length; i++)
      maxval = max(maxval, d[i]);
           
    textAlign(RIGHT);
    
    float sw = 2.0f + 0.9f*unravelness*(spiral_factor/d.length)-2;
    if (sw < 2) sw = 2;
    textSize(sw);
    
    // each ray
    for (int i = 0; i < d.length; i++)
    {      
      float r0 = dr*i;
      float a0 = da*i;
      float r1 = dr*(i+1);
      float a1 = da*(i+1);
      
      if (i == d.length - 1)
      {
        r1 = r0;
        a1 = a0;
      }
                
      // spiral segment
      stroke(128, 0, 0, 50);
      strokeWeight(5);
      line(r0*cos(a0), r0*sin(a0), r1*cos(a1), r1*sin(a1));
      
      // ray
      stroke(255, 153, 0);
      strokeWeight(sw);
      float val = (unravel/2 + 1.0f)*0.9*0.5*WIN_H*d[i]/maxval;
      line(r0*cos(a0), r0*sin(a0), r0*cos(a0)+val*sin(a0), r0*sin(a0)-val*cos(a0));
      fill(255, 255, 0, unravelness*255);
      text(int(d[i]), r0*cos(a0)+val*sin(a0), r0*sin(a0)-val*cos(a0)-1.5*sw);
      pushMatrix();
      translate(r0*cos(a0), r0*sin(a0)+1.5*sw);
      rotate(-PI/2);
      text(desc[i], 0, sw/4.0);
      popMatrix();
    }
  }
}

void fetch_json(String url)
{
  println("fetching from " + url);
  
    // parse JSON
  String result = join(loadStrings(url), "");
  try {
    JSONArray checkins = new JSONArray(result);
    int checkins_length = checkins.length();
 
    println("number of time slots recorded " + checkins_length);

    float data[] = new float[numsegs];
    String desc[] = new String[numsegs];
    
    for (int i = 0; i < checkins_length; i++)
    {
      JSONObject checkin = checkins.getJSONObject(i);
      
      String shour = checkin.getString("hour");
      int nhour = int(shour);

      String squarter = checkin.getString("quarterofhour");
      int nquarter = int(squarter);
      
      int index =  4*(nhour-12)+nquarter;     
      if (index < 0) continue;   // only PM times
      
      
      data[index] = float(checkin.getString("distinct_usercheckins"));
    }
    
    for (int i = 0; i < numsegs; i++)
      desc[i] = ((i/4 != 0)?(i/4):"12") + ":" + ((i%4 != 0)?(15*(i%4)):"00");
    
    t = new Timepiece(data, desc);
    
  } catch (JSONException e)
  {
    println ("There was an error parsing the JSONObject.");
  }
  
}

void mouseClicked()
{}

void mouseReleased()
{}

void keyPressed() 
{
  if (key == 'm')
    mode = !mode;
}
 
