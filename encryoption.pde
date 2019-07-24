import javax.swing.JOptionPane;
Button encrypt_btn;
Button decrypt_btn;
void setup() {
  size(640, 360);
  encrypt_btn = new Button(0, 0, "Encrypt Text", "encrypt", "SOLID_FILL");
  decrypt_btn = new Button(width/2, 0, "Decrypt Text", "decrypt", "SOLID_FILL");
}

void draw() {
  encrypt_btn.update();
  decrypt_btn.update();
}

void encrypt_clicked() {
  selectInput("Select a file to process:", "encryptText");
  mousePressed = false;
}

void decrypt_clicked() {
  selectInput("Select a file to process:", "decryptText");
  mousePressed = false;
}

void encryptText(File selected) {
  if (selected != null) {
    encryption(selected, true);
  }
}

void encryption(File selected, boolean mode) {
  String textPath = selected.getAbsolutePath();
  String textMode = mode ? "Encrypt" : "Decrypt";
  String paswd = "";
  String warnText = "";
  while (paswd.length() < 8) {
    paswd = JOptionPane.showInputDialog(warnText + "Enter " + textMode + "ion" + " Password");
    warnText = "Minimum Password length is 8!\n";
  }
  byte[] encryptionBytes = encryption(loadBytes(textPath), paswd, mode);
  int duplicate = 0;
  File savePath = new File(selected.getParent() + "/" + selected.getName() + "_" + textMode + "ed" + (duplicate > 0 ? duplicate : ""));
  while (savePath.exists()) {
    duplicate++;
    savePath = new File(selected.getParent() + "/" + selected.getName() + "_" + textMode + "ed" + (duplicate > 0 ? duplicate : ""));
  }
  saveBytes(savePath, encryptionBytes);
  JOptionPane.showMessageDialog(null, "Saved to: " + savePath.getAbsolutePath());
}

void decryptText(File selected) {
  if (selected != null) {
    encryption(selected, false);
  }
}

byte[] encryption(byte[] text, String paswd, boolean mode) {
  int paswdLength = paswd.length();
  int textLength = text.length;
  byte[] encryptedBytes = new byte[text.length];
  for (int i = 0; i < textLength; i++) {
    byte shifter = byte(paswd.charAt(i % paswdLength));
    byte shifted = byte(mode ? shifter ^ text[i] : text[i] ^ shifter);
    encryptedBytes[i] = shifted;
  }
  return encryptedBytes;
}
