% sim R2
% 1. p(x1-xn) - V/m at stimulation sites
% 2. Correlation Ratio value (y1; : : : ; ynjx1(p); : : : ; xn(p))
% 3. Kendall's value  ((x1(p); y1); : : : ; (xn(p); yn)) for p
% 4. CoG

% CoG;
load work
scl = 2;
cond = [1 3 5];
chnnls = {'APB','LATapb','FDI','LATfdi','ADM','LATadm'};
cnt_cond = 1;
cnt_sbplt = 1;
figure
h0 = waitbar(0,'Please wait...');
for cnd = cond;
    waitbar(cnd/length(cond),h0)
    AMPS=A_pastespecial(:,cnd); %1,3,5
    REF=min(LOC');
    LOCn(1,:)=LOC(1,:)-REF(1);
    LOCn(2,:)=LOC(2,:)-REF(2);
    LOCn(3,:)=LOC(3,:)-REF(3);
    LOCn=LOCn*1;
    X=LOCn(1,:);
    Y=LOCn(3,:);
    Z=LOCn(2,:);

    clear M
    M = zeros(ceil(max(Y)*scl),ceil(max(X)*scl)); % matrix in micrometers
    for i=1:length(AMPS)
        M(fix([Y(i)+1]*scl),fix([X(i)+1]*scl))=AMPS(i);
    end
    
    subplot(3,3,cnt_sbplt)
    imagesc(M)
    [my mx] = find(M == max(max(M)));
    title([chnnls{cnd} '[' num2str(my) 'y, ' num2str(mx) 'x]'])

    % CoG - eu
    for i=1:3;
        LA(:,i) = LOCn(i,:)'.*AMPS;
    end
    CoG{cnt_cond} = mean(LA,1)/mean(AMPS);
    for i=1:127
        LOCcog(i) = dist(LOCn(:,i)',CoG{cnt_cond}','euclidean');
    end
    Ecld = [LOCcog-max(LOCcog)]*-1;
    clear Mx
    Mx = zeros(ceil(max(Y)*scl),ceil(max(X)*scl)); % matrix in micrometers
    for i=1:length(AMPS)
        Mx(fix([Y(i)+1]*scl),fix([X(i)+1]*scl))=Ecld(i);
    end
    [s ind_sort] = sort(Ecld);
    y_sort = Y(ind_sort);
    x_sort = X(ind_sort);
    CoGm{cnt_cond}(1) = mean(y_sort(end-3:end));
    CoGm{cnt_cond}(2) = mean(x_sort(end-3:end));
    CoGmf{cnt_cond}(1) = fix([CoGm{cnt_cond}(1)+1]*scl);
    CoGmf{cnt_cond}(2) = fix([CoGm{cnt_cond}(2)+1]*scl);
    
    subplot(3,3,cnt_sbplt+1)
    imagesc(Mx)
    axis off
    title(['CoG [' num2str(CoGm{cnt_cond}(1)*scl) 'y, ' num2str(CoGm{cnt_cond}(2)*scl) 'x]'])
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    AMPS = A_pastespecial(:,cnd);
    M = zeros(ceil(max(Y)*scl),ceil(max(X)*scl)); % matrix in micrometers
    cnt = 1;
    h1 = waitbar(0,'Please wait...');
    pos = get(h0,'pos');
    pos(2) = pos(2)-85;
    set(h1,'position',pos)
    h2 = waitbar(0,'Please wait...');
    pos = get(h1,'pos');
    pos(2) = pos(2)-85;
    set(h2,'position',pos)
    for i=1:size(M,1)
        waitbar(i/size(M,1),h1)
        for ii=1:size(M,2)
            waitbar(ii/size(M,2),h2)
            for iii=1:length(AMPS)
                Ecld(iii)= dist([i,ii],[fix(Y(iii)*scl),fix(X(iii)*scl)]','euclidean');
            end
            [tmp ind] = sort(Ecld);
            pAMPS(cnt,:) = AMPS(ind);
            cnt = cnt+1;
        end
    end
    try, close(h1), end
    try, close(h2), end
    clear  B P
    cnt = 0;
    for i=1:size(M,1);
        for ii=1:size(M,2);
            cnt = cnt + 1;
            pX = sort(AMPS*-1)*-1;
            pY = pAMPS(cnt,:);
            % b = robustfit(pX',pY');
            % b = robustfit([1:length(AMPS)]',pY');
            % [b,BINT,R] = regress([1:length(AMPS)]',pY');
            [p,S,MU] = polyfit(pX,pY',1);
            f = polyval(p,pX,MU);
            sse = sum(f-pX);
            M(i,ii) = p(1);
            %             if ii==14 & i == 16
            %                 figure,
            %                 plot(pY,'*'), hold on,
            %                 plot(pX,'r')
            %                 title(num2str(p(1)))
            %             end
        end
    end

    subplot(3,3,cnt_sbplt+2),
    imagesc(M)
    axis off
    [mr mc] = find(M==max(max(M)));
    title(['Polyfit [' num2str(mr) 'y,' num2str(mc) 'x]']);
    ylabel(num2str(mr)),
    xlabel(num2str(mc))
    
    cnt_sbplt = cnt_sbplt+3;
    cnt_cond = cnt_cond+1;

end
try, close(h0),end