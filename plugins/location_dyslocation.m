% Repeat stimulus allows a variation of 2mm in the location (RMS) AND a
% variation of +/-2 degrees about each coil axis (see below; coil axes:
% current direction/stimulation direction, direction of coil wing, coil
% normal vector parallel to the cable).
% 
% Degrees between coil orientation for reference stimulus and repeated
% stimulus are calculated from the elements of 4x4 transformation matrix
% between the two coil coordinate systems (the matrix can be constructed
% from coil position and from unit vectors defining the coil orientation).
% Coil orientation can be measured with the accuracy of about 0.1 degrees
% (reflector sphere localization accuracy).

% %loc
% Loc{1} = A(:,2:ind:end);
% Loc{2} = A(:,3:ind:end);
% Loc{3} = A(:,4:ind:end);
% %normal 
% Loc{1} = A(:,5:ind:end);
% Loc{2} = A(:,6:ind:end);
% Loc{3} = A(:,7:ind:end);
% %orientation
% Loc{1} = A(:,8:ind:end);
% Loc{2} = A(:,9:ind:end);
% Loc{3} = A(:,10:ind:end);
% % Efloc
% Loc{1} = A(:,11:ind:end);
% Loc{2} = A(:,12:ind:end);
% Loc{3} = A(:,13:ind:end);


ind = 15; % or 7
nrsubjs = size(A,2)/ind

% pdist scalp location
% -------------------------------------------------------
Loc{1} = A(:,2:ind:end);
Loc{2} = A(:,3:ind:end);
Loc{3} = A(:,4:ind:end);
%
for subj = 1:nrsubjs
    x = [Loc{1}(:,subj), Loc{2}(:,subj), Loc{3}(:,subj)];
   
    % distance from one to the next
    for i=1:length(x)-1;
        xd(i) = pdist([x(i,:); x(i+1,:)],'euclidean');
    end
    % RMS
    RMS(subj) = sqrt(1/length(xd)*sum(xd));
    % distanc from the first
    tmp = pdist(x,'euclidean');
    xdd = tmp(1:length(x)-1);
    Xdd(subj,:)=xdd; % distance from first
    Xd(subj,:) = xd; % consecutive distance
end
[flagy,flagx] = find(Xdd>3);
flagy = sort(flagy);
tmp = find(diff(flagy));
flagy = cat(1,flagy(tmp-1), flagy(tmp+1));
disp(['> 3mm dyslocation:'])
for i=1:length(flagy)
    disp(['... ' num2str(flagy(i)) ')' subjs{flagy(i)}])
end
RMS_ind = find(RMS>2);


% angles
% Normal
Loc{1} = A(:,5:ind:end);
Loc{2} = A(:,6:ind:end);
Loc{3} = A(:,7:ind:end);
cnt = 0;
for subj = 1:nrsubjs
    cnt = cnt+1;
    if cnt>7; cnt=1; end
    x = [Loc{1}(:,subj), Loc{2}(:,subj), Loc{3}(:,subj)];
    for i=1:size(x,1)
        tmp(i) = atan2(norm(cross(x(1,:),x(i,:))),dot(x(1,:),x(i,:)));
    end
    anglebetweentwovectors(subj,:) = tmp;
    radiansbetweentwovectors(subj,:) = unwrap(tmp * pi/180);
end
degrees = radiansbetweentwovectors*.180/pi;

% %orientation
Loc{1} = A(:,8:ind:end);
Loc{2} = A(:,9:ind:end);
Loc{3} = A(:,10:ind:end);
cnt = 0;
for subj = 1:nrsubjs
    cnt = cnt+1;
    if cnt>7; cnt=1; end
    x = [Loc{1}(:,subj), Loc{2}(:,subj), Loc{3}(:,subj)];
    for i=1:size(x,1)
        tmp(i) = atan2(norm(cross(x(1,:),x(i,:))),dot(x(1,:),x(i,:)));
        %             compass(Z)
        %             compass(x(i),:)
        %             vectorinradians = vectorinangles * pi/180;
        %             [x,y] = pol2cart(vectorinradians,vectormagnitude);
        %             figure, compass(x,y)
        %vectarrow([0 0 0],x(i+1,:),str{1})
    end
    anglebetweentwovectors(subj,:) = tmp;
    radiansbetweentwovectors(subj,:) = unwrap(tmp * pi/180);
end
degrees = radiansbetweentwovectors*.180/pi;



