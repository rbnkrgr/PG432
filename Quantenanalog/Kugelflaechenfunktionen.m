addpath('/home/robin/Studium/Matlab_Toolbox')
addpath('/home/robin/Studium/Matlab_Toolbox/altmany-export_fig-cafc7c5')


for l = 9:20
    for m = 0:l
    Ymn = legendre(l,cos(-pi:0.01:pi))
    f = figure;
    set(f,'Color', 'white', 'Position', [-1919, 1, 375, 358]); %Das sind die Abmessungen für die Polarplotte für diess Protokoll
    %fileID = fopen([path,'/',dateien(i).name],'r');
    polarplot(-pi:0.01:pi,abs(Ymn(m+1,:)),'color',[1,0,0] )
    %title(['\rm l = ',num2str(l),', m = \pm',num2str(m)])
    export_fig(['l',num2str(l),'m',num2str(m),'.pdf'])
    %pause
    close
    end
end

%GIF wird erstellt alte methode

filename = 'Kugelfunktion.gif';

for l = 0:5
    for m = 0:l
    Ymn = legendre(l,cos(-pi:0.01:pi))
    f = figure;
    set(f,'Color', 'white'); %Das sind die Abmessungen für die Polarplotte für diess Protokoll
    %fileID = fopen([path,'/',dateien(i).name],'r');
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

% Karte erstellen
eme = figure;
set(eme,'Color', 'white'); %Das sind die Abmessungen für die Polarplotte für diess Protokoll

l_max = 20
for l = 0:l_max
    for m = 0:l
    Ymn = legendre(l,cos(-pi:0.01:pi))
    %f = figure;
    %set(f,'Color', 'white', 'Position', [-1919, 1, 375, 358]); %Das sind die Abmessungen für die Polarplotte für diess Protokoll
    %subplot(l_max+1,l_max+3,l*(l_max+3)+m+1))
    %subplot('position',[(i-1)/13 0.4 1/13 0.4])
    subplot('position',[m/(l_max+3) 1-(l+1)/(l_max+1) 1/(l_max+3) 1/(l_max+1)]) 
    
    polarplot(-pi:0.01:pi,abs(Ymn(m+1,:)),'color',[1,0,0] )
    axis off
    %title(['\rm l = ',num2str(l),', m = \pm',num2str(m)])
    %export_fig(['l',num2str(l),'m',num2str(m),'.pdf'])
    %pause
    %close
    end
end

export_fig('Kugelflächenfunktionen_gross.pdf')

