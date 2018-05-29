addpath('/home/robin/Studium/Matlab_Toolbox')
addpath('/home/robin/Studium/Matlab_Toolbox/altmany-export_fig-cafc7c5')

path = '/home/robin/Studium/PL_3/Quantenanalog/Messungen'
dateien = dir(path)



frequenzen = [440,2320,3710,5000,6240,6580,7480,8070,8660,9500,9870]
ergebnisse = zeros(11,37) %Dieses Array soll die Amplituden der 73 Gradmessungen für die 11 Frequenzen enhalten. Frequenzen x Gradmessung

    
    eme = figure;
    set(eme,'Color', 'white', 'Position', [-1919, 1, 715, 350]); %Das sind die Abmessungen für die Polarplotte für diess Protokoll

    
    filename = 'Animation_variante2.gif';
for i = 3:size(dateien,1)

    fileID = fopen([path,'/',dateien(i).name],'r');

    formatSpec = '%f %f';
    sizeA = [2 Inf];

    A = fscanf(fileID,formatSpec,sizeA);
    B = A';

    plot(B(:,1),B(:,2))
    hold on
    
    for f = 1:11
        [I position]=min(abs(B(:,1)-frequenzen(f)));
        value = max(B(position-4:position+4,2))
        ergebnisse(f,i-2) = value
        plot(B(position,1),value,'x','color','red')
        ylim([0,13])
    end
    
    dateiname = dateien(i).name
    xlabel('Frequenz in Hz')
    ylabel('Amplitude in VE')
    title(['\rm Spektrum bei \alpha = ',num2str(str2num(dateiname(1:3))) ,' Grad'])
    
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

f = figure;
set(f,'Color', 'white', 'Position', [-1919, 1, 375, 358]); %Das sind die Abmessungen für die Polarplotte für diess Protokoll
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


