% Dieses Skript wird für einen Teil des Auswertung des Versuches
% Quantenanalog im Projeklabor Physik der TU Berlin von der Gruppe PG432
% genutzt. Dabei wird das Skript nicht hintereienander ausgeführt, sondern
% es dient ledgilich als Zusammenfassung der einzelnen Auswertungsschritte.
% Die Teile des Skriptes werden folglich einzeln, nacheinander ausgeführt.

addpath('/home/robin/Studium/Matlab_Toolbox')
addpath('/home/robin/Studium/Matlab_Toolbox/altmany-export_fig-cafc7c5') % Diese Toolbox erlaubt das Speichern von Graphiken als Vektorgraphik

path = '/home/robin/Studium/PL_3/Quantenanalog/Messungen' % Hier Liegen die einzelnen Messungen 
dateien = dir(path) % Die Dateien im Ordner werden aufgelistet



frequenzen = [440,2320,3710,5000,6240,6580,7480,8070,8660,9500,9870] % Das sind die festgestellten Resonanzfrequenzen
ergebnisse = zeros(11,37) % Dieses Array soll die Amplituden der 73 Gradmessungen für die 11 Frequenzen enhalten. Frequenzen x Gradmessung

%-------------------------------------------------------------------------%
% In diesem Teil Werden die Spektren für die einzelnen Winkel bestrachtet und als GIF gespeichert, außerdem die Höhe der Peaks für die Resonanzfrequenzen bestimmt.    
    eme = figure;
    set(eme,'Color', 'white', 'Position', [-1919, 1, 715, 350]); % Graphik mit einheitlicher Abmessung und weißer Hintergrundfarbe
    filename = 'Animation_variante2.gif';
for i = 3:size(dateien,1)

    fileID = fopen([path,'/',dateien(i).name],'r'); % Die Dateien werden geöffnet

    formatSpec = '%f %f';
    sizeA = [2 Inf];

    A = fscanf(fileID,formatSpec,sizeA); % Und entsprechend ihrem Format importiert
    B = A';

    plot(B(:,1),B(:,2))
    hold on
    
    % Im Folgenden werden die Peaks vermessen
    for f = 1:11
        [I position]=min(abs(B(:,1)-frequenzen(f)));
        value = max(B(position-4:position+4,2))
        ergebnisse(f,i-2) = value
        plot(B(position,1),value,'x','color','red')
        ylim([0,13])
    end
    
    % Und das ganze wird geplottet
    dateiname = dateien(i).name
    xlabel('Frequenz in Hz')
    ylabel('Amplitude in VE')
    title(['\rm Spektrum bei \alpha = ',num2str(str2num(dateiname(1:3))) ,' Grad'])
    
    % Hier wird das Bild ans GIF gehängt
    frame = getframe(eme); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
        %pause
      if i == 3 
          imwrite(imind,cm,filename,'gif','DelayTime',0.1, 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
      end
    pause
    hold off
end

%-------------------------------------------------------------------------%
% In diesem Teil werden die einzelnen Polardiagrame erstellt.
f = figure;
set(f,'Color', 'white', 'Position', [-1919, 1, 375, 358]); % Das sind die Abmessungen für die Polarplotte für diess Protokoll
for f = 1:11
    f = 11
    angles = acos(0.5*cosd(0:5:180)-0.5)
    
    format = 'x-'
    polarplot(angles,ergebnisse(f,:),format,'color', [0,0.447,0.776])
    hold on
    polarplot(angles+pi,ergebnisse(f,:),format,'color', [0,0.447,0.776])
    polarplot(deg2rad(180-rad2deg(angles)),ergebnisse(f,:),format,'color', [0,0.447,0.776])
    polarplot(deg2rad(180-rad2deg(angles))+pi,ergebnisse(f,:),format,'color', [0,0.447,0.776])
    %title(num2str(frequenzen(f)))
    export_fig(['Var2_',num2str(frequenzen(f)),'.pdf'])
    %pause
    hold off
end


