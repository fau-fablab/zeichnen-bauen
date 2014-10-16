zeichnen-bauen
==============

make image, threshold, crop, vectorize, open inkscape, profit :)


requirements:
* linux system (could also work on windows if you had all these programs or equivalent ones and set the paths accordingly)
* processing (tested with processing-2.0.1)
* autotrace
* gphoto2
* inkscape

usage:
* connect gphoto2-able camera (e.g. Canon Powershot A620, Nikon SLR, ...) to PC
  * you can test the camera with: gphoto2 --capture-image-and-download
* start processing IDE, open file ./fab_shawow_eyefi/fab_shawow_eyefi.pde
  * in this file you can set a few config settings. change the path to wherever your temporary directory for shots and vectorised images is
  * click play
* follow instructions on screen: blur/crop -> threshold -> vectorisation, inkscape is opened
