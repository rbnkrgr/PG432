% Dieses Skript wird für einen Teil des Auswertung des Versuches
% Quantenanalog im Projeklabor Physik der TU Berlin von der Gruppe PG432
% genutzt. Dabei wird das Skript nicht hintereienander ausgeführt, sondern
% es dient ledgilich als Zusammenfassung der einzelnen Auswertungsschritte.
% Die Teile des Skriptes werden folglich einzeln, nacheinander ausgeführt.

addpath('/home/robin/Studium/Matlab_Toolbox')
addpath('/home/robin/Studium/Matlab_Toolbox/altmany-export_fig-cafc7c5') % Diese Toolbox erlaubt das Speichern von Graphiken als Vektorgraphik


%-------------------------------------------------------------------------%
% Die Kugelflächenfunktionen werden berechnet und geplottet
for l = 0:20
    for m = 0:l
    Ymn = legendre(l,cos(-pi:0.01:pi))
    f = figure;
    set(f,'Color', 'white', 'Position', [-1919, 1, 375, 358]); % Das sind die Abmessungen für die Polarplotte für diess Protokoll
    %fileID = fopen([path,'/',dateien(i).name],'r');
    polarplot(-pi:0.01:pi,abs(Ymn(m+1,:)),'color',[1,0,0] )
    %title(['\rm l = ',num2str(l),', m = \pm',num2str(m)])
    export_fig(['l',num2str(l),'m',num2str(m),'.pdf'])
    %pause
    close
    end
end

%-------------------------------------------------------------------------%
% Ein GIF wird erstellt
filename = 'Kugelfunktion.gif';
for l = 0:5
    for m = 0:l
    Ymn = legendre(l,cos(-pi:0.01:pi))
    f = figure;
    set(f,'Color', 'white');
    polarplot(-pi:0.01:pi,abs(Ymn(m+1,:)),'color',[1,0,0] )
    title(['\rm l = ',num2str(l),', m = \pm',num2str(m)])
     frame = getframe(f); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
        %pause
      % Write to the GIF File 
      if l == 0 
          imwrite(imind,cm,filename,'gif','DelayTime',0.1, 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
      end
    %pause
    close
    end
end

%-------------------------------------------------------------------------%
% Eine Übersicht über verschiedene Kugelflächenfunktionen wird erstellt.
eme = figure;
set(eme,'Color', 'white'); % Das sind die Abmessungen für die Polarplotte für diess Protokoll
l_max = 20
for l = 0:l_max
    for m = 0:l
    Ymn = legendre(l,cos(-pi:0.01:pi))
    subplot('position',[m/(l_max+3) 1-(l+1)/(l_max+1) 1/(l_max+3) 1/(l_max+1)]) % Das steuert die Positionen und Abmessungen der Subplots
    polarplot(-pi:0.01:pi,abs(Ymn(m+1,:)),'color',[1,0,0] )
    end
end
export_fig('Kugelflächenfunktionen_gross.pdf')

