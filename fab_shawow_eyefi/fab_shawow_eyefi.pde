import processing.pdf.*;
import java.awt.event.*;

int screenHeight = 768;
int screenWidth;

float bwthreshold = 0.6;

float selectionTop  = -1;
float selectionLeft = -1;
float selectionBottom = -1;
float selectionRight = -1;

float shadowheightmm = 100 ; // max height of resulting shadow for PDF generation in mm
float shadowheightpx = shadowheightmm / 25.4 * 72;

float PDFwidthmm = 406; // 406 mm for the ZING 4030
float PDFheightmm = 306; // 306 mm for the ZING 4030
int dpi = 72; // constant in processing?
float PDFwidthpx = PDFwidthmm / 25.4 * 72;
float PDFheightpx = PDFheightmm / 25.4 * 72;
int PDFwidth = int(PDFwidthpx);
int PDFheight = int(PDFheightpx);

boolean thChange = true;
boolean fileChange = true;

PImage img, blackwhite, cut, thumb;

String pathfolder = "C:\\Users\\Michael\\Documents\\FabLab\\fab_shadows\\results\\"; // path to folder for the generated files, include trailing / 
String pathautotrace = "c:\\cygwin\\bin\\autotrace.exe"; // full path to autotrace binary (including autotrace executable itself)
String pathvector = "C:\\Program Files (x86)\\Adobe\\Adobe Illustrator CS2\\Support Files\\Contents\\Windows\\Illustrator.exe";
String pathsilhouette = "C:\\Program Files (x86)\\Silhouette Studio\\Silhouette Studio.exe";
String inPath = "C:\\Users\\Michael\\Documents\\FabLab\\fab_shadows\\shots";
String fileFile = "C:\\Users\\Michael\\Documents\\FabLab\\fab_shadows\\shots\\file.txt";

String message = "";

void setup()
{
  addMouseWheelListener(new MouseWheelListener() { 
    public void mouseWheelMoved(MouseWheelEvent mwe) { 
      mouseWheel(mwe.getWheelRotation());
  }}); 
  
  String inFile = loadStrings(fileFile)[0];
  inFile = inFile.replace("\"", "").trim();
  img = loadImage(inFile);
    
  screenWidth = 768 * img.width / img.height;
  
  blackwhite = new PImage(screenWidth, screenHeight); 
  size(screenWidth, screenHeight);
}

void draw()
{
    drawImage(); 
    drawSelection();
    drawMessage();
}

void drawMessage()
{
  fill(0,255,0);
  textSize(18);
  text(message, 100, 100);
}

void drawList()
{
  File[] files = listFiles(inPath);
  for (int i = 0; i < files.length; i++) {
    File f = files[i];
    img = loadImage(inPath+"\\"+f.getName());
    image(img, 0+((i%5)*200),0+(int(i/5)*150),200,150);
    if (i > 5) break; 
  }
}

void drawImage()
{
  if (thChange)
  {
    blackwhite.copy(img, 0, 0, img.width, img.height, 0, 0, blackwhite.width, blackwhite.height);
  
    blackwhite.filter(THRESHOLD, bwthreshold);
    thChange = false;
  }
  if (selectionBottom != -1)
  {
    background(100);
    cut = createImage(int(selectionRight-selectionLeft), int(selectionBottom-selectionTop), RGB); 
    cut.copy(blackwhite, int(selectionLeft), int(selectionTop), int(selectionRight-selectionLeft), int(selectionBottom-selectionTop), 0, 0, cut.width, cut.height);
    image(cut, selectionLeft,selectionTop,cut.width,cut.height);
  }
  else
  {
     image(blackwhite, 0,0,blackwhite.width,blackwhite.height);
  }

}

void drawSelection()
{
  fill(255,255,255,100);
  if (selectionTop != -1 && selectionBottom == -1)
  {
    rect(selectionLeft, selectionTop, mouseX-selectionLeft, mouseY-selectionTop);
  }
}

void mouseWheel(int delta) {
  bwthreshold += delta * 0.01;
  thChange = true;
}

void mousePressed() {
  if (mouseButton == LEFT) {
    if (selectionTop == -1)
    {
      selectionTop = mouseY;
      selectionLeft = mouseX;
    }
    else if  (selectionBottom == -1 && mouseY > selectionTop &&  mouseX > selectionLeft)
    {
      selectionBottom = mouseY;
      selectionRight = mouseX;
      message = "save on left click";
    }
    else if  (selectionBottom != -1)
    {
      saveFiles();
      message = "Silhouette gespeichert";
      exit();
    }
  }
  if (mouseButton == RIGHT) {
      selectionTop = -1;
      selectionLeft = -1;
      selectionBottom = -1;
      selectionRight = -1;
      message = "";
  } 
}

String getTimestamp()
{
    int[] timestamp = new int[6];

      timestamp[0] = year();   // 2003, 2004, 2005, etc.
      timestamp[1] = month();  // Values from 1 - 12
      timestamp[2] = day();    // Values from 1 - 31 
      timestamp[3] = hour();    // Values from 0 - 23
      timestamp[4] = minute();  // Values from 0 - 59
      timestamp[5] = second();  // Values from 0 - 59

      return join(nf(timestamp, 0), "-");
}

void autoTrace(String type, String name)
{
  String[] params = {
        pathautotrace, // actual command 
        "--input-format=png", // reading png
        "--output-file="+name+"."+type, // filename of SCG output
        "--dpi=72", // resolution
        "--color-count=2",
        "--despeckle-level=10", 
        "--despeckle-tightness=5", 
        "--corner-always-threshold=60", 
        "--line-threshold=0.05", 
        "--width-weight-factor=0.1", 
        "--line-reversion-threshold=0.1", 
        "--preserve-width", 
        "--filter-iterations=2", 
        "--remove-adjacent-corners", 
        "--background-color=ffffff", 
        "--output-format="+type, 
        name+".png"
      };

      exec(params); 
}

void openVectorSoftware(String name)
{
  String[] params = {
        pathvector, // actual command 
        name
      };

      exec(params); 
}

void openSilhouette(String name)
{
  String[] params = {
        pathsilhouette, // actual command 
        name
      };

      exec(params); 
}


void saveFiles()
{
    String fileNamePlain = pathfolder + "shadow"+getTimestamp();
    
    cut.save(fileNamePlain + ".png");
    autoTrace("svg", fileNamePlain);
    delay(1000);
    
    String lines[] = loadStrings(fileNamePlain+".svg");
    String[] lines2 = split(lines[2], "\"fill:#010101; stroke:none;\" ");
      lines2[0] = lines2[0] + "\"fill:#ffffff;stroke:#000000;stroke-opacity:1;stroke-width:0.028;stroke-miterlimit:0.01;stroke-dasharray:none\"";
    
      
    lines[2] = lines2[0] + " " + lines2[1];
    
    saveStrings(fileNamePlain+".svg", lines);

    //makeLaserPdf(fileNamePlain, cut);
    openVectorSoftware(fileNamePlain+".svg");
    //openSilhouette(fileNamePlain+".svg");
}

void makeLaserPdf(String name, PImage imageObject)
{
      PShape s;
      s = loadShape(name+".svg");
     
      PGraphics pdf = createGraphics(PDFwidth, PDFheight, PDF, name+".pdf");
      
      pdf.beginDraw();
      
      s.scale(shadowheightpx/float(imageObject.height));
      strokeWeight(0.01);
      s.disableStyle();
      
      pdf.shape(s);
      
      pdf.endDraw();
      pdf.dispose();
}

File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}
