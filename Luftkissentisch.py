#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  Luftkissentisch.py
#  
#  This program was created as part of the physics project laboratory at the Technical University Berlin.
#  Copyright 2017 Robin Krueger <robin.krueger@physik.tu-berlin.de>
#  
#  The programm base on a programm created in the laboratory Mathesis at the Technical University Berlin.
#  Copyright 2016 Henriette Behr, Henriette Rilling, Max Wehner, Robin Krueger <das_orchester_ist_programm@web.de>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.

#=== Benutzung ===#
# + Erste Huerde ist die Installation von OpenCV, welche sich manchmal schwierig gestaltet. https://opencv.org/
# + Dann muss der Dateiname des Videos geaendert werden. Das Video sollte im gleichen Ordner, wie das Programm liegen.
# + Als nächstes muessen die Abmessungen des Videos auf die Grosse des Lutkissentisches geaendert werden. Das Ergbenis kann direkt durch ausfuehren ueberpueft werden. 
# + Die Farben der einzelnen Puks muessen eingestellt werden. Hierzu am besten ein Standbild in ein Bildbearbeitungsprogramm importieren
#   und die Farben der Pukt im HSV-Format auslesen und im Programm mit den Werten spielen. Ueber das Anzeigen der Maske (einkommentieren in der color_rec Funktion)
#   kann das Ergebnis ueberpüft werden. Wenn nur der gesuchte Puck Weiss ist, ist das optimal.
# + ggf. koennen auch noch Pucks in weiteren Farben hinzugefuegt werden. Fuer diese Farben muessen die Funktionen entsprechend ergaenzt werden.
# + Das Programm ausfuehren und nach Beendigung Geschwindigkeiten in der Textdatei in ein Histogramm ueberfuhren (kann direkt in Qti-Plot importiert werden).
#=================#

import math as m
import numpy as np
import cv2

def color_rec(hsv,farbe): # Funktion, welche eine nach Farbe definierte Stelle ermittelt.

	hue_min, hue_max, sat_min, sat_max, val_min, val_max = farbe # Die als Tupel uebergebene Farbe wird entpackt.

	lower = np.array([hue_min, sat_min, val_min]) # Untere schranke wird festgelegt.
	upper = np.array([hue_max, sat_max, val_max]) # Obere schranke wird festgelegt.

	mask =  cv2.inRange(hsv, lower, upper)   	                        # Erstellt maske, welche für Werte innerhalb des Intervalls
																		# den wert 1 annimmt, sonst 0.

	#==== Es empfiehlt sich zur Farbeinstellung den folgenden Teil einzukommentieren, damit man sieht, ob man die Intervalle anpassen muss. ====#																	
	#cv2.namedWindow('Farberkennung',cv2.WINDOW_NORMAL) 					# Benennt ein Fenster.
	#cv2.resizeWindow('Farberkennung', 600,600) 							# Gibt dem Fenster mit Namen 'Farberkennung' die Abmessungen in Pixel.
	#cv2.imshow('Farberkennung',mask)										# Hiermit kann die erzeugte Maske für eine bestimmte Farbe angezeigt werden.
																		
	y_werte, x_werte = np.where(mask == 255)							# Es werden die x- und y-Werte ausgelesen, welche ein True (255) bekomen haben.
	if len(x_werte) != 0 and len(y_werte) != 0:
		y_mittel = int(np.mean(y_werte))								# Es wird der Mittelwert aus allen y-Werten gebildet.
		x_mittel = int(np.mean(x_werte))								# Es wird der Mittelwert aus allen x-Werten gebildet.
		position = (x_mittel, y_mittel)									# Die mittlere Position aller Trues entspricht dem Tupel beider Mittelwerte.

	else:
		position = (0,0)												# Wenn kein Wert gefunden, wird hier (0,0) als Position gewaehlt.
		
	return position														# Ergebnis wird zurueckgegeben.

def zeichne_kreis(frame, position): # Funktion, welche einen Kreis zeichnet.
	cv2.circle(frame,position, 25, (0,0,255), 4)   # Wer mag kann Radius, Farbe und Dicke anpassen (letzten drei Argumente). Farbe hier als RGB kodiert.
	
def geschwindigkeit_ermitteln(liste): # Funktion, welche die letzte Geschwindigkeit eines Pucks ermittelt.
	letzter_x, letzter_y = liste[-1] # Der letzte Eintrag der Liste wird ausgelesen.
	vorletzter_x, vorletzter_y = liste[-2] # Ebenso der davor.
	velocity = m.sqrt((letzter_x-vorletzter_x)**2 + (letzter_y-vorletzter_y)**2) # Die Geschwindigkeit wird entsprechend Satz des Pythagoras und v = s/t mit t genormt auf 1 ermittelt.
	print velocity # Geschwindigkeit wird im Terminal ausgegeben.
	return velocity # Geschwindigkeit wird zurueckgegeben.
		# Fuer die tatsaechliche Geschwindigkeit muessen die Framerate und die Anzahl an uebersprungenen Frames beruecksichtigt werden.


###============ Beginn eigentliches Programm ===================###

def main():
	
	# Die verschiedenen Farben werden in HSV-Intervallen angegeben.
	# Form der Eingabe als Tupel: farbe = (hue_min, hue_max, sat_min, sat_max, val_min, val_max).
	# Kodiert werden die HSV-Werte in 0-256, ggf. muessen die Werte aus dem Grafikprogramm umgerechnet werden.
	# Die ersten beiden werte entscheiden ueber den Farbwert (H) und sind am wichtigsten.
	rote_farbe   = (110,256,60,256,246,256)
	#-------------------------------------#
	gelbe_farbe  = (30,60,100,256,100,256)
	#-------------------------------------#
	blaue_farbe  = (85,100,100,256,100,256)
	#-------------------------------------#
	gruene_farbe = (64,75,100,256,80,256) 
	#-------------------------------------#
	
	rote_position   = [] # Diese Listen werden die gemessenen Positionen der verschiedenfarbigen Puks enthalten.
	gelbe_position  = []
	blaue_position  = []
	gruene_position = []
	
	cap = cv2.VideoCapture('00006.MTS') # Videodatei wird geoeffnet.

	cv2.namedWindow('Tracking',cv2.WINDOW_NORMAL) # Benennt ein Fenster
	cv2.resizeWindow('Tracking', 600,600) # Gibt dem Fenster mit Namen 'Tracking' die Abmessungen in Pixel. (Hier wird nur die Anzeige geandert.)

	ausgabe = open("Ausgabedateititel.txt","w") # Der Stream zu einer Ausgabedatei wird im Schreibmodus geoeffnet.

	while(True):
	
		ret, frame = cap.read() # Holt Frame ggf. mehrere hintereinander, wenn nicht jedes Bild ausgewertet werden soll (einfach mehrmals aufrufen).
		ret, frame = cap.read() # Hier nur jedes fuenfte Bild um Ungenauigkeit in Positionsbestimmung zu vernachlaessigen.
		ret, frame = cap.read()
		ret, frame = cap.read()
		ret, frame = cap.read()
		if frame is None:  # Wenn kein Bild mehr da ist gibt cap.read() ein None zurück und hier wird die Schleife abgebrochen.
			break
			
		frame = frame[30:1024, 366:1350] # Ein Teil des Bildes (der mit Luftkissentisch) wird ausgeschnitten. Angabe der Maße: Erst vertikal von oben bis unten, dann horizontal von links nach rechts.

		hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV) # Das Bild wird zur besseren Verarbeitung in das hsv-Format konvertiert.

		rote_position.append(color_rec(hsv,rote_farbe)) #
		gelbe_position.append(color_rec(hsv,gelbe_farbe))
		blaue_position.append(color_rec(hsv,blaue_farbe))
		gruene_position.append(color_rec(hsv,gruene_farbe))
		
		zeichne_kreis(frame,rote_position[-1])   # An die Position, welche im letzten Listenelement der jeweiligen Farbe steht, wird ein Kreis gezeichnet.
		zeichne_kreis(frame,gelbe_position[-1])
		zeichne_kreis(frame,blaue_position[-1])
		zeichne_kreis(frame,gruene_position[-1])
		
		if len(rote_position) >= 2: # Es sind zwei bereits ermittelte Positionen fuer eine Geschwindigkeit noetig.
			ausgabe.write(str(geschwindigkeit_ermitteln(rote_position))+ '\n')    # Die Funktionen zur Geschwindigkeitsermittlung werden aufgerufen,
			ausgabe.write(str(geschwindigkeit_ermitteln(gelbe_position))+ '\n')   # das Ergebnis wird in eine Zeichenkette konvertiert und in die Augabedatei
			ausgabe.write(str(geschwindigkeit_ermitteln(blaue_position))+ '\n')   # geschrieben.
			ausgabe.write(str(geschwindigkeit_ermitteln(gruene_position))+ '\n')
			
		cv2.imshow('Tracking',frame) # Ergebnis wird angezeigt.
		
		
		if cv2.waitKey(1) & 0xFF == ord('q'): #'q' zum Beenden drücken
			break
	
	ausgabe.close() # Die Ausgabe der Messwerte wird geschlossen.
	cap.release() # Der Zugang zur Videodatei wird beendet.
	cv2.destroyAllWindows() # Alle Fenster werden geschlossen.
	

if __name__ == "__main__":
	main()
