class Button {
  float x, y;
  float w = width/2, h = height;
  float shake = 0;

  String name, caption;
  String face;


  boolean hide;
  boolean buttonState;
  boolean lastButtonState = false;
  boolean enabled = true;
  boolean hover = false;

  int lastDebounceTime = 0; 
  int debounceDelay = 20;

  color baseColor;
  color hoverColor;
  color neutralColor;
  color clickedColor;
  color disabledColor;

  Button(float x, float y, String caption, String name, String face) {
    this.x = x; 
    this.y = y;
    this.face = face;
    this.caption = caption; // display text 
    this.name = name; // Button unique name
    this.baseColor = color(0, 100, 255); // button current color
    this.hoverColor = color(0, 200, 255); // when mouse hover
    this.neutralColor = color(0, 100, 255); // default color
    this.clickedColor = color(0, 90, 220); // when clicked
    this.disabledColor = color(130); // when disabled
  }

  // face, stylize this
  void display() {
    stroke(baseColor);
    float noise = random(-shake, shake);

    strokeWeight(1.3);

    switch(face) {
    case  "SOLID_FILL"  :
      fill(baseColor);
      rect(x+noise, y, w, h);
      fill(255);
      break;
    case "OUTLINE_NOFILL" : 
      noFill();
      rect(x+noise, y, w, h, 8);
      fill(baseColor);
      break;
    }


    textSize(30);
    textAlign(CENTER, CENTER);
    text(caption, x+noise + w/2, y+h/2 - 2);
  }

  // button update
  void update() {
    if (!hide) {
      display();
      if (enabled) {
        isHovering();
        clicked();
        shake = constrain(shake - 0.7, 0, 10);
      }
    }
    display();
  }

  // for disabling the functionality
  void disable() {
    enabled = false;
    baseColor = disabledColor;
  }

  // for enabling the functionality
  void enable() {
    enabled = true;
    baseColor = neutralColor;
  }

  // is hovering?
  void isHovering() {
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y+h) {
      baseColor = lerpColor(baseColor, hoverColor, 0.1);
      hover = true;
    } else {
      baseColor = lerpColor(baseColor, neutralColor, 0.1);
      hover =  false;
    }
  }

  // hide button and disable functionality
  void hide() {
    hide = true;
  }

  // unhide button and enable functionality
  void show() {
    hide = false;
  }

  // Shake the button
  void shake() {
    shake = 20;
  }

  // is clicked?
  boolean clicked() {
    boolean state = hover && mousePressed;
    if (state != lastButtonState) {
      lastDebounceTime = millis();
    }

    if ((millis() - lastDebounceTime) > debounceDelay) {
      if (state != buttonState) {
        buttonState = state;
        if (buttonState == true) {
          baseColor = clickedColor;
          raiseEvent(name + "_clicked");
          return true;
        }
      }
    }
    lastButtonState = state;
    return false;
  }
}

//-------------------------------------------------------
public void callByName(Object obj, String funcName) throws Exception {
  obj.getClass().getDeclaredMethod(funcName).invoke(obj);
}

void raiseEvent(String funcName) {
  try {
    callByName(this, funcName);
  } 
  catch (Exception ex) {
    println("No action executed!" );
  }
}
