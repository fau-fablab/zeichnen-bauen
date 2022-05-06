zeichnen-bauen !!! DEPRECATED !!!
==============

DEPRECATED: This has moved to windows and a bit of cleanup in the zeichnen-bauen-windows repository

tl;dr: make image, threshold, crop, vectorize, open inkscape, profit :)

# Requirements
* linux system (could also work on windows if you had all these programs or equivalent ones and set the paths accordingly)
* processing (tested with processing-2.0.1)
* autotrace
* gphoto2
* inkscape

# Program Usage
* connect gphoto2-able camera (e.g. Canon Powershot A620, Nikon SLR, ...) to PC
  * you can test the camera with: gphoto2 --capture-image-and-download
  * To speed up the program, set your camera to some acceptable resolution, not the ultra highest
* start processing IDE, open file ./fab_shawow_eyefi/fab_shawow_eyefi.pde
  * in this file you can set a few config settings. change the path to wherever your temporary directory for shots and vectorised images is
  * click play
* follow instructions on screen: blur/crop -> threshold -> vectorisation, inkscape is opened

# Example Use: Lasercut Silhouettes
This is what FAU FabLab does at Science Night (Lange Nacht der Wissenschaften): Lasercutting the silhouette of people in ~5cm size out of acrylic or plywood.

A person is photographed from the side. The image is then vectorized by this program.

- Photo setup: DSLR on a tripod, a chair for the person, and a white cloth in the background. DSLR has a wireless flash which illuminates the cloth from behind. (Any dark objects or dirt in the background cause problems, so a typical wall is not recommended.)
- Use the program as described above.
- Save file.  Usually it is better if you have one or two additional people, each with their own notebook, for lasercutting and postprocessing.
- To postprocess the vector image for lasercutting, split the path in inkscape (Ctrl-A, Ctrl-K) and set everything to "Only Line, no fill". Unselect all. Then select (Shift-Click) all parts of the path you actually want to cut. Usually you only want to keep two or three paths. Remove everything else (press `!` key and then `Delete` key).
- If necessary, crop the vector image by using a rectangle and the boolean "intersection" or "subtract" operations.
- Scale to ~5cm height, align multiple silhouettes in one file, lasercut a few of them at once to save time.
- While people are waiting in the queue, don't forget to make some advertisement for the FabLab, mainly for the OpenLab hours.
