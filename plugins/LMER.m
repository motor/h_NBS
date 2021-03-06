% Landmarks (mm)
%
% 	x	y	z	Landmark Type
%
% 	45	123	106	MRI landmark: Right ear
% 	182	123	106	MRI landmark: Left ear
% 	114	119	209	MRI landmark: Nose/Nasion
% x=left-right
% y=inferior sup (guess)
% z=AP
load work
cond = [1 3 5];
chnnls = {'APB','LATapb','FDI','LATfdi','ADM','LATadm'};
scl = 2;
for cnd = cond;
    AMPS=A_pastespecial(:,cnd); %1,3,5
    REF=min(LOC');

    LOCn(1,:)=LOC(1,:)-REF(1);
    LOCn(2,:)=LOC(2,:)-REF(2);
    LOCn(3,:)=LOC(3,:)-REF(3);
    LOCn=LOCn*1;

    X=LOCn(1,:);
    Y=LOCn(3,:);
    Z=LOCn(2,:);
    C=AMPS;

    clear M
    M = zeros(ceil(max(Y)*scl),ceil(max(X)*scl)); % matrix in micrometers
    for i=1:length(AMPS)
        M(fix([Y(i)+1]*scl),fix([X(i)+1]*scl))=AMPS(i);
    end
    for i=1:size(M,1)
        Ms(i,:) = smooth(M(i,:));
    end
    for i=1:size(M,2)
        Ms(:,i) = smooth(Ms(:,i));
    end
    Ms = Ms.*[max(max(M))/max(max(Ms))];


    figure
    set(gcf,'name',['condition ' chnnls{cnd}])
    subplot(2,2,2)
    imagesc(M)
    colorbar
    subplot(2,2,1)
    scatter(X,Y,200,C/1000,'filled');
    xlabel('LR[mm]');
    ylabel('AP[mm]');
    grid on
    %colorbar
    subplot(2,2,3)
    imagesc(Ms)
    subplot(2,2,4)
    contour(flipud(Ms),20)

    MS{cnd}=Ms;
end

ind = [1 5];
Mp = [MS{ind(1)}+MS{ind(2)}];
Mm = [MS{ind(1)}-MS{ind(2)}];

figure,
set(gcf,'name',[chnnls{ind(1)} '-' chnnls{ind(2)}])
subplot(2,2,1)
imagesc(Mp)
subplot(2,2,2)
contour(flipud(Mp))
colorbar
subplot(2,2,3)
imagesc(Mm)
subplot(2,2,4)
contour(flipud(Mm))
colorbar

indx = [1 3 5 1 3];
for i=1:3
    ind = indx(i:i+2);
    Mp = [MS{ind(1)}+MS{ind(2)}+MS{ind(3)}]/3;
    Mm = [MS{ind(1)}-[MS{ind(2)}+MS{ind(3)}]/2];
    
    figure,
    set(gcf,'name',chnnls{ind(1)})
    subplot(2,3,3)
    imagesc(Mp)
    subplot(2,3,6)
    contour(flipud(Mp/1000)),colorbar
    subplot(2,3,2)
    imagesc(Mm)
    subplot(2,3,5)
    contour(flipud(Mm/1000)), colorbar
    subplot(2,3,1)
    imagesc(MS{ind(1)})
    subplot(2,3,4)
    contour(flipud(MS{ind(1)}/1000)), colorbar
end

% Efield wahrscheinlichkeit
load Efield
% each finger
cond = [1 3 5];
r = floor(size(Efield,1)/2);
for cnd = cond;
    AMPS=A_pastespecial(:,cnd);
    clear ind
    for i=1:length(AMPS)
        m = zeros(size(M));
        % MEP coordinates
        y = fix([Y(i)+1]*scl);
        x = fix([X(i)+1]*scl);
        % coordinates in MEPmatrix
        tmp = [y-r:y+r];
        ind{1} = tmp(find(tmp>0 & tmp<29));
        tmp = [x-r:x+r];
        ind{2} = tmp(find(tmp>0 & tmp<21));
        mf = M(ind{1},ind{2});
        % coordinates of EF
        ind{3} =  ind{1}+[r+1-y];
        ind{4} =  ind{2}+[r+1-x];
        ef = Efield(ind{3},ind{4});
        % fill (and weight) zero field
        m(ind{1},ind{2})=ef;
        Em{i} = m;
        Emw{i} = m * AMPS(i);
    end
    E = reshape(cat(2,Emw{:}),size(M,1)*size(M,2),size(LOC,2));
    Emax = max(E');
    figure,
    set(gcf,'name',[chnnls{cnd} ' - max(ef*amp)'])
    imagesc(reshape(Emax,size(M,1),size(M,2)));
end
% make Ep_null, Ep_ef, Ep_amp
Efield = Efield./max(max(Efield));
Efield(find(Efield<0))=0;
Efield = Efield*64; %V/m
Thrshhld = 44; %V/m threshold
r = floor(size(Efield,1)/2);
clear Ep_ef Ep_null Ep_amp
for i=1:length(AMPS)
        % MEP coordinates
        y = fix([Y(i)+1]*scl);
        x = fix([X(i)+1]*scl);
        % coordinates in MEPmatrix
        tmp = [y-r:y+r];
        ind{1} = tmp(find(tmp>0 & tmp<29));
        tmp = [x-r:x+r];
        ind{2} = tmp(find(tmp>0 & tmp<21));
        % coordinates of EF
        ind{3} =  ind{1}+[r+1-y];
        ind{4} =  ind{2}+[r+1-x];
        % 1 or 0
        ef = Efield(ind{3},ind{4});
        ef(ef<Thrshhld)= 0;
        ef(ef>Thrshhld)= 1;
        m = zeros(size(M));
        m(ind{1},ind{2})= ef;
        Ep_null(:,:,i) = m;
        % weighted (EFfield) probability
        ef = Efield(ind{3},ind{4});
        ef =  ef/max(max(Efield))*100;
        m = zeros(size(M));
        m(ind{1},ind{2})= ef;
        Ep_ef(:,:,i) = m;
        % weighted (AMP) probability
        ef = Efield(ind{3},ind{4});
        ef =  ef*AMPS(i);
        m = zeros(size(M));
        m(ind{1},ind{2})= ef;
        Ep_amp(:,:,i) = m;
end
%Ep_ef
nind = zeros(1,size(AMPS,1));
nind(find(max(A_pastespecial(:,[1,3,5])')<50)) = 1;
%diff MEP & noMEP
En_ef = Ep_ef(:,:,find(nind==1));
Ep_ef_neg = max(En_ef,[ ],3)*-1;
Ex = Ep_ef(:,:,find(nind==0));
Ex(find(Ex==0)) = 100+1;
Ep_ef_min = min(Ex,[ ],3);
Ex(find(Ex==101)) = 0;
Ep_ef_max = max(Ex,[ ],3);
MM = Ep_ef_max + Ep_ef_neg;
figure,
set(gcf,'name','max of all MEPs vs None')
subplot(2,2,1)
imagesc(Ep_ef_max,[-100 100]), colorbar, title('meps')
subplot(2,2,2)
imagesc(Ep_ef_neg,[-100 100]), colorbar, title('none')
subplot(2,2,3)
imagesc(MM,[-100 100]), colorbar, title('difference')
subplot(2,2,4)
contour(flipud(MM),30), colorbar
%minimal EF
ind1 = find(MM<0);
ind2 = find(MM>=0);
ind = find(nind);
cnt = 1;
clear ED EDm

%probablistic
nind = zeros(1,size(AMPS,1));
% nind(find(max(A_pastespecial(:,[1,3,5])')<50)) = 1;
nind(find(A_pastespecial(:,5)<50)) = 1;
A = Ep_ef;
A(find(isnan(A)))= 0;
A(:,:,find(nind==1))=A(:,:,find(nind==1))*-1;
B = Ep_amp;
B(:,:,find(nind==1)) = Ep_amp(:,:,find(nind==1))*-1;
for i=1:size(Ep_ef,1)
    for ii=1:size(Ep_ef,2)
        X = reshape(A(i,ii,:),1,size(A,3));
        Non(i,ii) = length(find(X==0));
        Pos(i,ii) = length(find(X>0));
        Neg(i,ii) = length(find(X<0));
        Prob(i,ii)= Pos(i,ii)/[[Pos(i,ii)+Neg(i,ii)]/100];
        Probw(i,ii)= Pos(i,ii)/[[Pos(i,ii)+Neg(i,ii)]/100]/Non(i,ii);
        %ef Weighted
        Pos_ef(i,ii) = mean(X(find(X>0)));
        if isnan(Pos_ef(i,ii));  Pos_ef(i,ii) = 0; end
        Neg_ef(i,ii) = mean(X(find(X<0)));
        if isnan(Neg_ef(i,ii));  Neg_ef(i,ii) = 0; end
        Diff_ef(i,ii)= Pos_ef(i,ii)+Neg_ef(i,ii);
        Diffw_ef(i,ii)= [Pos_ef(i,ii)+Neg_ef(i,ii)]/Non(i,ii);
        %amp Weighted
        Y = reshape(B(i,ii,:),1,size(B,3));
        Pos_amp(i,ii) = mean(Y(find(Y>0)));
        if isnan(Pos_amp(i,ii));  Pos_amp(i,ii) = 0; end
        Neg_amp(i,ii) = mean(Y(find(Y<0)));
        if isnan(Neg_amp(i,ii));  Neg_amp(i,ii) = 0; end
        Diff_amp(i,ii)= Pos_amp(i,ii)+Neg_amp(i,ii);
        Diffw_amp(i,ii)= [Pos_amp(i,ii)+Neg_amp(i,ii)]/Non(i,ii);
    end
end
figure
set(gcf, 'name','probablistic - mean(null)')
subplot(2,3,1)
imagesc(Pos, [0 size(Ep_ef,3)]),title('>0'),colorbar
subplot(2,3,2)
imagesc(Neg, [0 size(Ep_ef,3)]),title('<0'),colorbar
subplot(2,3,3)
imagesc(Non, [0 size(Ep_ef,3)]),title('NaN'),colorbar
subplot(2,3,5)
imagesc(Prob, [0 100]),title('pos/[[pos+neg]/100]'),colorbar
subplot(2,3,4)
imagesc(Pos+Neg, [0 size(Ep_ef,3)]),title('pos-neg'),colorbar
subplot(2,3,6)
Probw = Probw/max(max(Probw));
Probw = Probw*max(max(Prob));
contour(flipud(Probw)),title('pos/[[pos+neg]/100]/NaN'),colorbar
%ef Weighted
figure
set(gcf, 'name','probablistic - mean(ef)')
subplot(2,3,1)
imagesc(Pos_ef,[0 100]),title('>0'),colorbar
subplot(2,3,2)
imagesc(Neg_ef,[-100 0]),title('<0'),colorbar
subplot(2,3,3)
imagesc(Non),title('NaN'),colorbar
subplot(2,3,4)
imagesc(Diff_ef,[0 100]),title('pos-neg'),colorbar
subplot(2,3,5)
contour(flipud(Diff_ef)),title('pos-neg'),colorbar
subplot(2,3,6)
imagesc(Diffw_ef),title('pos-neg/NaN'),colorbar
%amp Weighted
figure
set(gcf, 'name','probablistic - mean(amp)')
subplot(2,3,1)
imagesc(Pos_amp),title('>0'),colorbar
subplot(2,3,2)
imagesc(Neg_amp),title('<0'),colorbar
subplot(2,3,3)
imagesc(Non),title('NaN'),colorbar
subplot(2,3,4)
imagesc(Diff_amp),title('pos-neg'),colorbar
subplot(2,3,6)
imagesc(Diffw_amp),title('pos-neg/#NaN'),colorbar
subplot(2,3,5)
contour(flipud(Diff_amp)),title('pos-neg/#NaN'),colorbar

