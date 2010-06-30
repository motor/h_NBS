% 	100	158	214	MRI landmark: Nose/Nasion	
% 	172	100.5	107.4	MRI landmark: Left ear	
% 	22	107	113	MRI landmark: Right ear	
% 					
% 	104.9	155	211.1	Scalp landmark: Nose/Nasion	
% 	29	103.9	108.7	Scalp landmark: Right ear	
% 	173.8	103.5	105.2	Scalp landmark: Left ear

NBSLOC = [93.8 90.5 222.6]; % nose
NBSLOC = [20.1 62.5 110.1]; % right ear
NBSLOC = [57.7 164.6 103.3]; % hotspot
NBS2MRI = [1 3 2]; %some strange format that Nexstim uses
NBSLOC = NBSLOC(NBS2MRI);
zoffset = 32;

% scale = [1.1 0.9375 0.9375]; %x y z/ i j k/ sag, cor, ax
% imdim = [154 256 256]; 

% DATA IN MRI SPACE
BRC = [-83.6 -92 -143.5]; % bottom right hand corner
MRILOC(1) = [BRC(1)+ NBSLOC(1)]*-1; %swith right to left handed
MRILOC(2) = [BRC(2)+ NBSLOC(2)];
MRILOC(3) = [BRC(3)+ NBSLOC(3)]+zoffset;
disp(MRILOC)



% MRILOC(1) = imdim(1) - [NBSLOC(1)/scale(1)];
% MRILOC(2) = [NBSLOC(2)/scale(2)];
% MRILOC(3) = imdim(3) - [NBSLOC(3)/scale(3)]+zoffset;
disp(MRILOC)
return

%NBS DATA
% % % MAT = evalin('base',['NBS.DATA(1).RAW.PP.data']);
% % % AMPS = MAT(:,1);
% % % EFLOC = MAT(:,10:12);
% % % COMPARE = evalin('base','COMPARE');
% % % [r c] = find(double(strcmp(COMPARE.results.Daniel_Schlacks.rawmatrix, 'MRI landmark: Nose/Nasion')));
% % % NOSE.NBS(NBS2MRI) = cat(2,COMPARE.results.Daniel_Schlacks.rawmatrix{r,c-3:c-1});
% % % LEFT.NBS(NBS2MRI) = cat(2,COMPARE.results.Daniel_Schlacks.rawmatrix{r+1,c-3:c-1}); %[172 100.5 104.4];
% % % RIGHT.NBS(NBS2MRI) = cat(2,COMPARE.results.Daniel_Schlacks.rawmatrix{r+2,c-3:c-1}); %[22 107 113];
%MRI LANDMARKS
prompt={'Left:','Right:','Nasion:'};
name='NBS Landmarks (see e.g. MRIcro)';
numlines=1;
defaultanswer={'24 112 107','173 108 102','101 215 161'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
NOSE.NBS(NBS2MRI)=str2num(answer{1});
LEFT.NBS(NBS2MRI)=str2num(answer{2});
RIGHT.NBS(NBS2MRI)= str2num(answer{3});

%MRI LANDMARKS
prompt={'Left:','Right:','Nasion:'};
name='MRI Landmarks (see e.g. MRIcro)';
numlines=1;
defaultanswer={'24 112 107','173 108 102','101 215 161'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
LEFT.MRI = str2num(answer{1}); %#ok<ST2NM> %[24 112 107];
RIGHT.MRI = str2num(answer{2}); %#ok<ST2NM> %[173 108 102];
NOSE.MRI = str2num(answer{3}); %#ok<ST2NM> %[101 215 161];

% match and sort and round
% % % EFLOC = EFLOC(:,NBS2MRI);
% % % [val, ind] = sort(EFLOC(:,3)); % sort by z-axis
% % % EFLOC = EFLOC(ind,:);
LFT = fix([LEFT.MRI; RIGHT.NBS; diff([LEFT.MRI;RIGHT.NBS])*-1]);
RGHT = fix([RIGHT.MRI; LEFT.NBS; diff([RIGHT.MRI;LEFT.NBS])*-1]);
NSE = fix([NOSE.MRI; NOSE.NBS; diff([NOSE.MRI;NOSE.NBS])*-1]);



go = 0;
if go == 1
    %IMGxyz = [203 256 256];
    V = spm_vol('P:\PROJECTS\TMS by Leo\Eric Holst\Eric_Holst.img');
    IMG = zeros(V.dim);
    for i=1:size(EFLOC,1)
        crd = fix(EFLOC(i,:));
        IMG(crd(1),crd(2),crd(3)) = AMPS(i);
    end
    
    h = fspecial('log',100,10)*-1;
    h = h + abs(min(min(h)));
    h = h - min(mean(h));
    h = h*[1000/max(max(h))];
    z = [fix(min(EFLOC(:,3))) : fix(max(EFLOC(:,3)))];
    IMG(:,:,z) = imfilter(IMG(:,:,z),h,'same');
    
    
    
    crd = fix(EFLOC(1,:));
    S = IMG(:,:,crd(3));
    figure,
    subplot(2,2,1:2)
    imagesc(S), colorbar
    subplot(2,2,3:4)
    plot(mean(h))
    
    V.fname = strrep(V.fname,'.img','_nbs.img');
    spm_write_vol(V,fix(IMG));
end



