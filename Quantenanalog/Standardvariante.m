addpath('/home/robin/Studium/Matlab_Toolbox')
addpath('/home/robin/Studium/Matlab_Toolbox/altmany-export_fig-cafc7c5')

% Ohne Ringe

% Spektrum
path = '/home/robin/Studium/PL_3/Quantenanalog/Messungen' % Pfad zum Ordner mit den Messungen
% 3
i = 3 % NUll grad werden ausgewählt
dateien = dir(path)
fileID = fopen([path,'/',dateien(i).name],'r');

formatSpec = '%f %f';
sizeA = [2 Inf];

A = fscanf(fileID,formatSpec,sizeA);
B = A';

f = figure;
set(f,'Color', 'white', 'Position', [-1919, 1, 715, 350]); %Das sind die Abmessungen für Spektrogramme für diess Protokoll


plot(B(:,1),B(:,2))
xlabel('Frequenz in Hz','interpreter','latex')
ylabel('Amplitude in VE','interpreter','latex')
export_fig('ohne_ring_Spektrum_0_grad.pdf')

% Polardigramme werden für die Resonanzfrequenzen gemacht.
path = '/home/robin/Studium/PL_3/Quantenanalog/Quantenanalog vollständig/Quantenanalog 0 - Mat' % Pfad zum Ordner mit den Messungen
dateien = dir(path)

for i = 3:size(dateien,1) % NUll grad werden ausgewählt
    f = figure;
    set(f,'Color', 'white', 'Position', [-1919, 1, 375, 358]); %Das sind die Abmessungen für die Polarplotte für diess Protokoll
    fileID = fopen([path,'/',dateien(i).name],'r');

    formatSpec = '%f %f %f'; %Alpha  Theta  Amplitude
    sizeA = [3 Inf];
    A = fscanf(fileID,formatSpec,sizeA);
    B = A';
    
    format = 'x-'
    polarplot(deg2rad(B(:,2)),B(:,3),format,'color', [0,0.447,0.776])
    hold on
    polarplot(deg2rad(B(:,2))+pi,B(:,3),format,'color', [0,0.447,0.776])
    polarplot(deg2rad(180-B(:,2))+pi,B(:,3),format,'color', [0,0.447,0.776])
    polarplot(deg2rad(180-B(:,2)),B(:,3),format,'color', [0,0.447,0.776])
    polarplot(deg2rad(180-B(:,2))+pi,B(:,3),format,'color', [0,0.447,0.776])
    hold off
    export_fig([dateien(i).name,'.pdf'])
    %pause
    close
end

% LEgendrepolynome werden bestimmt.
X = 0:2*pi/360:2*pi
for l = 0:10
    polarplot(X,legendreP(l,X))
    pause
end

% Mit Ringen------------------------------------

% Spektren werden vergleichen
path = '/home/robin/Studium/PL_3/Quantenanalog/Quantenanalog vollständig/Quantenanalog mit Ring' % Pfad zum Ordner mit den Messungen

f = figure;
set(f,'Color', 'white', 'Position', [-1919, 1, 715, 350]); %Das sind die Abmessungen für Spektrogramme für diess Protokoll


fileID = fopen(['/home/robin/Studium/PL_3/Quantenanalog/Messungen','/','000.dat'],'r')
formatSpec = '%f %f';
sizeA = [2 Inf];
A = fscanf(fileID,formatSpec,sizeA);
B = A';
plot(B(:,1),B(:,2))
hold on


fileID = fopen([path,'/','Spektrum_dünn.dat'],'r')
formatSpec = '%f %f';
sizeA = [2 Inf];
A = fscanf(fileID,formatSpec,sizeA);
B = A';
plot(B(:,1),B(:,2),'--')
    
fileID = fopen([path,'/','Spektrum_dick.dat'],'r')
formatSpec = '%f %f';
sizeA = [2 Inf];
A = fscanf(fileID,formatSpec,sizeA);
B = A';
plot(B(:,1),B(:,2),'.-')

fileID = fopen([path,'/','Spektrum_zwei_Ringe.dat'],'r')
formatSpec = '%f %f';
sizeA = [2 Inf];
A = fscanf(fileID,formatSpec,sizeA);
B = A';
plot(B(:,1),B(:,2),':')

xlabel('Frequenz in Hz','interpreter','latex')
ylabel('Amplitude in VE','interpreter','latex')
legend('kein Ring','dünner Ring','dicker Ringe','beide Ringe')
%export_fig('mit_ring_komplett.pdf')
%export_fig('mit_ring_ausschnitt.pdf')


% Das Gradmäßig passende Spektrum wird gesucht
% Spektrum
path = '/home/robin/Studium/PL_3/Quantenanalog/Messungen' % Pfad zum Ordner mit den Messungen
% 3
i = 3 % NUll grad werden ausgewählt
dateien = dir(path)
f = figure;
set(f,'Color', 'white', 'Position', [-1919, 1, 715, 350]); %Das sind die Abmessungen für Spektrogramme für diess Protokoll
for i = 3:size(dateien,1)
    fileID = fopen([path,'/',dateien(i).name],'r');

    formatSpec = '%f %f';
    sizeA = [2 Inf];

    A = fscanf(fileID,formatSpec,sizeA);
    B = A';
    plot(B(:,1),B(:,2))
    xlabel('Frequenz in Hz','interpreter','latex')
    ylabel('Amplitude in VE','interpreter','latex')
    
    title(dateien(i).name)
    pause
end
   
% Die Polardiagramme zu 2238 Hz werden erzeugt
path = '/home/robin/Studium/PL_3/Quantenanalog/Quantenanalog vollständig/Quantenanalog mit Ring/2238Hz-Ringe' % Pfad zum Ordner mit den Messungen
dateien = dir(path)

for i = 3:size(dateien,1) % NUll grad werden ausgewählt
    f = figure;
    set(f,'Color', 'white', 'Position', [-1919, 1, 375, 358]); %Das sind die Abmessungen für die Polarplotte für diess Protokoll
    fileID = fopen([path,'/',dateien(i).name],'r');

    formatSpec = '%f %f %f'; %Alpha  Theta  Amplitude
    sizeA = [3 Inf];
    A = fscanf(fileID,formatSpec,sizeA);
    B = A';
    
    format = 'x-';
    polarplot(deg2rad(B(:,2)),B(:,3),format,'color', [0,0.447,0.776])
    hold on
    polarplot(deg2rad(B(:,2))+pi,B(:,3),format,'color', [0,0.447,0.776])
    polarplot(deg2rad(180-B(:,2))+pi,B(:,3),format,'color', [0,0.447,0.776])
    polarplot(deg2rad(180-B(:,2)),B(:,3),format,'color', [0,0.447,0.776])
    polarplot(deg2rad(180-B(:,2))+pi,B(:,3),format,'color', [0,0.447,0.776])
    hold off
    export_fig([dateien(i).name,'.pdf'])
    %pause
    close
end

