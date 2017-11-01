
#    Dieses Programm dient zur automatischen Verarbeitung einer Vielzahl an Audiodateien, bei denen eine Periodenbestimmung von Peaks vorgenommen werden muss. Es ist entstanden im Rahmen des Projektlabor Physik an der TU Berlin in der Gruppe PG432.
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

from scipy.io import wavfile #Bibliothek zum importieren von Wav-Dateien
from matplotlib import pyplot as plt #Bibliothek zum plotten
import numpy as np
import sys #Bibliothek zum Daten in File loggen

#Die Audiodateien sind in einem Ordner durchnummeriert.
number = 1 #erste Nummer
number_max = 25 #letzte Nummer

while (number <= number_max): #Die Dateien werden durchgegangen.
    sys.stdout = open(str(number)+'.txt', 'w') #zum loggen der einzelnen Daten

    samplerate, data = wavfile.read(str(number)+'.wav') #Datei wird ausgelesen.

    schwelle = -0.99 #Schwellenwert zur Peakfindung
    position = 0.0 #Frage ob gerade Peak oder kein Peak ist
    time = 0.0
    events = [] #Hier werden die Zeitpunkte der Peaks gelistet.
    laenge = len(data)
    sam = [] #Hier wird ein Kanal drin gespeichert.
    prellzeit = 10000 #Zum Ausgleichen von Schwingungen bei Peak-Uebergaengen.
    x = 1 #Position in der Wav-Datei
    v = [] #Liste der verschiedenen Geschwindigkeiten

    for i in data: #Ein Kanal wird in eine Liste uebernommen.
	    (l,r) = i
	    sam.append(l)

    while (x < laenge): #Die Peaks werden detektiert.
	    if (sam[x] < schwelle and position == 0.0):
		    events.append(float(x)/samplerate)
		    x+= prellzeit
		    position = 1.0

	    elif(sam[x] > schwelle and position == 1.0):
		    x+= prellzeit
		    position = 0.0

	    else:
		    x+=1

    for t in range(len(events)-1): #Die Geschwindigkeiten werden ermittelt.
	    v.append(events[t+1]-events[t])

    ########## Daten werden geloggt. ###########
    print 'Auswertung des Versuches Stirlingmotor im PL PG432. Messung ' + str(number)
    print '\nRegistrierte Ereignisse bei t in Sekunden:\n'
    for d in events:
	    print d

    print 'Gemessene Abstaende zwischen zwei Ereignissen in Sekunden:\n'
    for z in v:
	    print z

    ### Plot wird erstellt. ###
    plt.plot(events[0:-1],v,color='green', linestyle='dashed', marker='x',markerfacecolor='blue', markersize=12)
    plt.xlabel('Zeit in Sekunden')
    plt.ylabel('Periodendauer in Sekungen x2')
    plt.grid(True)
    plt.savefig(str(number)+'.png') #Plot wird gespeichert.
    plt.clf()
    #plt.show()

    sys.stdout.close() #Fuer diesen Durchgang wird das Loggen beendet.
    number += 1 #Die Dateinummer wird erhoeht.

