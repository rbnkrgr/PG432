addpath('/home/robin/Studium/Matlab_Toolbox')
addpath('/home/robin/Studium/Matlab_Toolbox/altmany-export_fig-cafc7c5')

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
frequenzen = frequenzen/10.0;

transformed = fft(rawData,[],1);

%frequenzsammlung = [2301,3698,4971,6242,6575,7479,8066,8546,8661,9493,9876,10180,10870,12150,11030,11740,12060,13210,13360,13590,13720,14700,14920,15320,15560,16200,16770,17240,17540,17990,18360,18730,18860,19140,19830];
frequenzsammlung = [11740,12060,13210,13360,13590,13720,14700,14920,15320,15560,16200,16770,17240,17540,17990,18360,18730,18860,19140,19830];

abweichung = 400;

eme = figure;
set(eme,'Color', 'white', 'Position', [-1919, 1, 715, 350]); %Das sind die Abmessungen für die Polarplotte für diess Protokoll
filename = 'AnimationVar3.gif';

angles = 0:5:360

for a = 1:73
    hold off
    plot(frequenzen(1:200000),abs(transformed((1:200000),a)))
    ylim([0,180])
    xlabel('Frequenz in Hz','interpreter','latex')
    ylabel('Amplitude in VE','interpreter','latex')
    title(['\rm Spektrum bei \alpha = ',num2str(angles(a)) ,' Grad'])
    hold on
    
    
    for frequenz = frequenzsammlung
        value = max(abs(transformed(frequenz*10-abweichung:frequenz*10+abweichung,a)))
        line([frequenz-abweichung/10 frequenz+abweichung/10],[value value],'Color','r')
        plot(frequenz,value,'x','Color','r')
    end
    
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

angles = acos(0.5*cosd(0:5:360)-0.5)
angles(37:73) = 2*pi-angles(37:73) %Muss entsprehend angepasst werden, da INtervall der Umkehrfunktion ungünstig gewählt ist. (Plots machen das deutlich.)



eme = figure;
set(eme,'Color', 'white', 'Position', [-1919, 1, 375, 358]); %Das sind die Abmessungen für die Polarplotte für diess Protokoll

filename = 'Animation_variante3.gif';

for frequenz = frequenzsammlung
    values = max(abs(transformed(frequenz*10-abweichung:frequenz*10+abweichung,:)),[],1)
    %polarplot(deg2rad(0:5:360),values)
    %title(num2str(frequenz))
    %pause



    
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

%gifs erstellen
% Füer die GIF-Erstellung
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
axis tight manual % this ensures that getframe() returns a consistent size
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


% ANalyse weißes Rauschen Audacity
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



