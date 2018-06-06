% Dieses Skript wird für einen Teil des Auswertung des Versuches
% Quantenanalog im Projeklabor Physik der TU Berlin von der Gruppe PG432
% genutzt. Dabei wird das Skript nicht hintereienander ausgeführt, sondern
% es dient ledgilich als Zusammenfassung der einzelnen Auswertungsschritte.
% Die Teile des Skriptes werden folglich einzeln, nacheinander ausgeführt.

addpath('/home/robin/Studium/Matlab_Toolbox')
addpath('/home/robin/Studium/Matlab_Toolbox/altmany-export_fig-cafc7c5') % Diese Toolbox erlaubt das Speichern von Graphiken als Vektorgraphik

path = '/home/robin/Studium/PL_3/Quantenanalog/Audacity Messung' % Pfad zum Ordner mit den Messungen

dateien = dir(path) % Die Dateinamen werdne eingelesen

rawData = [];

SR = 44100; % Samplerate
samples = [1,10*SR]; % Es wird nur ein Bereich der Samples spezifiziert, der 10 Sekunden lang ist.

for i = 3:size(dateien,1)
    [y,SR] = audioread([path,'/',dateien(i).name],samples); % 10 Sekunden der Audiodatei werden importiert.
    rawData = cat(2,rawData,y);
end

frequenzen = 0:(SR*10)-1;
frequenzen = frequenzen/10.0; % Die Frequenzen für das Spektrum nach der FFT werden berechnet

transformed = fft(rawData,[],1); % Die Daten werden Foueriertransformiert

frequenzsammlung = [2301,3698,4971,6242,6575,7479,8066,8546,8661,9493,9876,10180,10870,12150,11030,11740,12060,13210,13360,13590,13720,14700,14920,15320,15560,16200,16770,17240,17540,17990,18360,18730,18860,19140,19830];
% Hier sind die Resonanzfrequenzen aufgeführt 

abweichung = 400; % Die Breite, in der nach einem Peak gesucht wird

eme = figure;
set(eme,'Color', 'white', 'Position', [-1919, 1, 715, 350]); % Das sind die Abmessungen für die Polarplotte für diess Protokoll
filename = 'AnimationVar3.gif';

angles = 0:5:360 % In diesen Gradschritten wurde gemessen

%-------------------------------------------------------------------------%
% Spektren werden erstellt

for a = 1:73
    % Das Spektrum wird geplottet
    hold off
    plot(frequenzen(1:200000),abs(transformed((1:200000),a)))
    ylim([0,180])
    xlabel('Frequenz in Hz','interpreter','latex')
    ylabel('Amplitude in VE','interpreter','latex')
    title(['\rm Spektrum bei \alpha = ',num2str(angles(a)) ,' Grad'])
    hold on
    
    % Die Peaks werden bestimmt
    for frequenz = frequenzsammlung
        value = max(abs(transformed(frequenz*10-abweichung:frequenz*10+abweichung,a)))
        line([frequenz-abweichung/10 frequenz+abweichung/10],[value value],'Color','r')
        plot(frequenz,value,'x','Color','r')
    end
    
      % Bild wird an GIF angehängt
      frame = getframe(eme); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
        %pause
      % Write to the GIF File 
      if a == 1 
          imwrite(imind,cm,filename,'gif','DelayTime',0.1, 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
      end
    
    %pause
end


angles = acos(0.5*cosd(0:5:360)-0.5) % Die Winkel Theta werden aus den Winkeln Alpha berechnet.
angles(37:73) = 2*pi-angles(37:73) % Muss entsprechend angepasst werden, da Intervall der Umkehrfunktion ungünstig gewählt ist. (Plots machen das deutlich.)

%-------------------------------------------------------------------------%
% Die Polardiagramme werden erstellt

eme = figure;
set(eme,'Color', 'white', 'Position', [-1919, 1, 375, 358]); % Das sind die Abmessungen für die Polarplotte für diess Protokoll
filename = 'Animation_variante3.gif';
for frequenz = frequenzsammlung
    values = max(abs(transformed(frequenz*10-abweichung:frequenz*10+abweichung,:)),[],1)
    format = 'x-'
    polarplot(angles,values,format,'color', [0,0.447,0.776])
    hold on
    polarplot(deg2rad(180-rad2deg(angles)),values,format,'color', [0,0.447,0.776])
    
    export_fig(['Var3_',num2str(frequenz),'.pdf'])
    
%     % GIF Variante
%     title(['\rm',num2str(frequenz),' Hz'])
%      frame = getframe(eme); 
%       im = frame2im(frame); 
%       [imind,cm] = rgb2ind(im,256); 
%         %pause
%       % Write to the GIF File 
%       if frequenz == 2301 
%           imwrite(imind,cm,filename,'gif','DelayTime',0.1, 'Loopcount',inf); 
%       else 
%           imwrite(imind,cm,filename,'gif','WriteMode','append'); 
%       end
%     
    
    
    %pause
    hold off
end

%-------------------------------------------------------------------------%
% Ein GIF wird erstellt
h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'Spektrogramm.gif';
grad = 0:5:360

for a = 1:73
    hold off
    plot(frequenzen(1:200000),abs(transformed((1:200000),a)))
    hold on
    
    
    for frequenz = frequenzsammlung
        value = max(abs(transformed(frequenz*10-abweichung:frequenz*10+abweichung,a)))
        line([frequenz-abweichung/10 frequenz+abweichung/10],[value value],'Color','r')
        plot(frequenz,value,'x','Color','r')
    end
      title(['Winkel = ',num2str(grad(a))])
      ylabel('Intensität')
      xlabel('Frequenz in Hz')
      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
        pause
      % Write to the GIF File 
      if a == 1 
          imwrite(imind,cm,filename,'gif','DelayTime',0.1, 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
      end
    
end


h = figure;
axis tight manual
filename = 'Polarplot.gif';
grad = 0:5:360
i=1
for frequenz = frequenzsammlung
    values = max(abs(transformed(frequenz*10-abweichung:frequenz*10+abweichung,:)),[],1)
    hold off
    polarplot(deg2rad(0:5:360),values)
    hold on
    title([num2str(frequenz),' Hz - Eingestellter Winkel (ohne Anpassung)'])
    pause
    frame = getframe(h); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256)
    if i == 1 
       imwrite(imind,cm,filename,'gif','DelayTime',0.1, 'Loopcount',inf); 
       i = 0
    else 
       imwrite(imind,cm,filename,'gif','WriteMode','append'); 
    end
    
end

%-------------------------------------------------------------------------%
% Analyse weißes Rauschen von Audacity
path = '/home/robin/Studium/PL_3/Quantenanalog/Example_weisses_Rauschen.wav'

SR = 44100; % Samplerate
samples = [1,10*SR]; % Es wird nur ein Bereich der Samples spezifiziert, der 10 Sekunden lang ist.

[y,SR] = audioread(path,samples); % 10 Sekunden der Audiodatei werden importiert.

frequenzen = 0:(SR*10)-1;
frequenzen = frequenzen/10.0;

transformed = fft(y);
eme = figure;
set(eme,'Color', 'white', 'Position', [-1919, 1, 715, 350]); %Das sind die Abmessungen für die Polarplotte für diess Protokoll 
plot(frequenzen(1:200000),abs(transformed(1:200000)))
    xlabel('Frequenz in Hz','interpreter','latex')
    ylabel('Amplitude in VE','interpreter','latex')

export_fig('weisses-rauschen.pdf')



