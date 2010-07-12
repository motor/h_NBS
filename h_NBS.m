function varargout = h_NBS(varargin)
% H_NBS M-file for h_NBS.fig
%      H_NBS, by itself, creates a new H_NBS or raises the existing
%      singleton*.
%
%      H = H_NBS returns the handle to a new H_NBS or the handle to
%      the existing singleton*.
%
%      H_NBS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in H_NBS.M with the given input arguments.
%
%      H_NBS('Property','Value',...) creates a new H_NBS or raises the
%      existing singleton*.  Starting from the left, property value pairs
%      are
%      applied to the GUI before h_NBS_OpeningFunction gets called.  AnMLR
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to h_NBS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Defaults menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help h_NBS


%
% Last Modified by GUIDE v2.5 30-Jun-2010 22:20:53
%

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @h_NBS_OpeningFcn, ...
    'gui_OutputFcn',  @h_NBS_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before h_NBS is made visible.
function h_NBS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to h_NBS (see VARARGIN)

% Choose default command line output for h_NBS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

NBS.defaults.printres = 72;
NBS.defaults.print = 0;
NBS.defaults.ctrl = 0;

NBS.defaults.refseq = 1;

assignin('base','NBS',NBS);
assignin('base','handles',handles);

% UIWAIT makes h_NBS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = h_NBS_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


val = get(handles.popupmenu1,'val');
str = get(handles.popupmenu1,'str');
set(handles.popupmenuSearchResults,'val',val)
feval('popupmenuSearchResults_Callback',hObject, eventdata, handles)
NBS = evalin('base','NBS');
%set(handles.stimex,'str',NBS.EXCEL.exams,'val',1);
set(handles.showseq,'str',NBS.CONFIG(val).SEQ{1},'val',1);
%set(handles.popupmenuSearchResults,'str',NBS.EXCEL.subjects,'val',1);
set(handles.listbox1,'str', NBS.CONFIG(val).PARAMS{1},'val',1)

set(handles.popupmenuSearchResults,'val',val)
feval('popupmenuSearchResults_Callback',handles.popupmenuSearchResults,1,handles);


if iscell(str) == 0;
    for i=1:length(NBS.CONFIG)
        nstr(i)= NBS.CONFIG(i).FILENAMES{1};
    end
    set(gcbo,'str',nstr,'val',1)
end

% [FILENAMES, PATHNAME] = uigetfile('*.xlsx; *.xls', 'Get NBS files (LOC, REF, A)','multiselect','on');
% if isequal(FILENAMES,0) || isequal(PATHNAME,0)
%     tryset(handles.listbox1,'str',NBS.PARAMS{get(handles.popupmenu1,'val')}),end
% else
%     if ischar(FILENAMES) F = FILENAMES; clear FILENAMES; FILENAMES{1} = F; end
%     NBS.PATHNAME{get(handles.popupmenu1,'val')} = PATHNAME;
%     NBS.FILENAMES{get(handles.popupmenu1,'val')} = FILENAMES;
%     set(gcbo,'str',FILENAMES);
%     assignin('base','NBS',NBS);
% end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

try NBS = evalin('base','NBS'); end
val = get(handles.popupmenu1,'val');

try PRMS = NBS.CONFIG(val).PARAMS{1};
catch PRMS = get(gcbo,'str');
end
if isempty(PRMS); PRMS = get(gcbo,'str'); end

for i=1:length(PRMS)
    ind = findstr(PRMS{i},'=');
    prompt{i} = PRMS{i}(1:ind-2);
    name='Input for Peaks function';
    numlines=1;
    defaultanswer{i}=PRMS{i}(ind+2:end);
end
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer=inputdlg(prompt,name,numlines,defaultanswer,options);

for i=1:length(PRMS)
    PRMS{i} = [prompt{i} ' = ' answer{i}];
end

NBS.CONFIG(val).PARAMS{1} = PRMS;
set(gcbo,'str',PRMS)
assignin('base','NBS',NBS)



% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NBS = evalin('base','NBS');
cd(NBS.PATHNAME{get(handles.popupmenu1,'val')})
filenames = get(handles.popupmenu1,'str');

subj = get(handles.popupmenu1,'val');
[tmp,filename, ext] = fileparts(filenames{subj});
filename = [filename,ext];
PRMS = NBS.PARAMS{subj};
eval(PRMS{5})
offset = 0;
A1 = A1-offset; % some strange bugfix
sheetname = 'NBS';
conds = [1 3 5];
chnnls = {'APB','LATapb','FDI','LATfdi','ADM','LATadm'};
scl1 = 1;

for sess = 1:size(A1,1);
    disp(['... reading worksheet: ' sheetname '(' filenames{subj} ') --> [' ['AA' num2str(A1(sess,1)) ':AF' num2str(A1(sess,2))] ']' ])
    A_pastespecial = NBS.DATA(subj).RAW(sess).AMPS; %xlsread(filenames{subj}, sheetname,['AG' num2str(A1(sess,1)) ':AL' num2str(A1(sess,2))]);
    [A_thresh] = A_pastespecial(:,conds); %update may 2009
    A_thresh(A_thresh<50) = 0;
    A_pastespecial(:,conds) = A_thresh;
    LOC = NBS.DATA(subj).RAW(sess).PP.data(:,10:12); %xlsread(filenames{subj}, sheetname,['V' num2str(A1(sess,1)) ':X' num2str(A1(sess,2))]);
    ORNTRNG = NBS.DATA(subj).RAW(sess).PP.data(:,7:9);
    
    if size(LOC,1)~=3; LOC = LOC'; end
    tmp = mean(LOC([1,3],:));
    outlrs = find(tmp>mean(tmp)+3*std(tmp));
    inlrs = find(tmp<mean(tmp)+2*std(tmp));
    if isempty(outlrs) ~= 1;
        figure, plot(tmp','*'),
        title('outlier(s) found')
        A_pastespecial = (A_pastespecial(inlrs,:));
        LOC = LOC(:,inlrs);
    end
    
    
    clear LOCn Ms LA Ecld CoG
    for cnd = conds;
        AMPS=A_pastespecial(:,cnd); %1,3,5
        REF=min(LOC');
        
        LOCn(1,:)=LOC(1,:)-REF(1);
        LOCn(2,:)=LOC(2,:)-REF(2);
        LOCn(3,:)=LOC(3,:)-REF(3);
        %LOCn=LOCn*1;
        
        X=LOCn(1,:);
        Y=LOCn(3,:);
        Z=LOCn(2,:);
        C=AMPS;
        
        clear M
        M = zeros(ceil(max(Y)*scl1),ceil(max(X)*scl1)); % matrix in micrometers
        for i=1:length(AMPS)
            M(round([Y(i)+1]*scl1),round([X(i)+1]*scl1))=AMPS(i);
        end
        if isempty(find(M)), M(1,1) = 100;, end
        for i=1:size(M,1)
            Ms(i,:) = smooth(M(i,:));
        end
        for i=1:size(M,2)
            Ms(:,i) = smooth(Ms(:,i));
        end
        Ms = Ms.*[max(max(M))/max(max(Ms))];
        
        figure
        set(gcf,'name',['condsition ' chnnls{cnd}])
        subplot(2,2,2)
        imagesc(M)
        title('MEPs')
        colorbar
        subplot(2,2,1)
        scatter(X,Y,200,C/1000,'filled');
        xlabel('LR[mm]');
        ylabel('AP[mm]');
        title('scatter plot')
        grid on
        %colorbar
        subplot(2,2,3)
        imagesc(Ms)
        title('smoothed MEPs')
        subplot(2,2,4)
        contour(flipud(Ms),20)
        title('contour')
        
        MS{cnd}=Ms;
    end
    assignin('base','MS',MS)
    
    A = polyarea(X,Y);
    
    title(['Area = ' num2str(A)]); axis image
    
    ind = [1 5];
    Mp = [MS{ind(1)}+MS{ind(2)}];
    Mm = [MS{ind(1)}-MS{ind(2)}];
    
    figure,
    set(gcf,'name',[chnnls{ind(1)} '/' chnnls{ind(2)}])
    subplot(2,2,1)
    imagesc(Mp)
    title([chnnls{ind(1)} '+' chnnls{ind(2)}])
    subplot(2,2,2)
    contour(flipud(Mp))
    colorbar
    subplot(2,2,3)
    imagesc(Mm)
    title([chnnls{ind(1)} '-' chnnls{ind(2)}])
    subplot(2,2,4)
    contour(flipud(Mm))
    colorbar
    print( gcf, '-dps', 'results' )
    
    indx = [1 3 5 1 3];
    for i=1:3
        ind = indx(i:i+2);
        Mp = [MS{ind(1)}+MS{ind(2)}+MS{ind(3)}]/3;
        Mm = [MS{ind(1)}-[MS{ind(2)}+MS{ind(3)}]/2];
        
        figure,
        set(gcf,'name',chnnls{ind(1)})
        subplot(2,3,3)
        imagesc(Mp)
        title([chnnls{ind(1)} '+ (' chnnls{ind(2)}  '+' chnnls{ind(3)} ')'])
        subplot(2,3,6)
        contour(flipud(Mp/1000)),colorbar
        subplot(2,3,2)
        imagesc(Mm)
        title([chnnls{ind(1)} '- (' chnnls{ind(2)}  '+' chnnls{ind(3)} ')'])
        subplot(2,3,5)
        contour(flipud(Mm/1000)), colorbar
        subplot(2,3,1)
        imagesc(MS{ind(1)})
        title(chnnls{ind(1)})
        subplot(2,3,4)
        contour(flipud(MS{ind(1)}/1000)), colorbar
    end
    
    %%%%%%%%%%%%%%
    %probablistic
    %%%%%%%%%%%%%%%%%
    go_prob = 1;
    if go_prob == 0;
        for pb = 1:1
            load Efield
            % each finger
            conds = [1 3 5];
            r = floor(size(Efield,1)/2);
            for cnd = conds;
                AMPS=A_pastespecial(:,cnd);
                clear ind
                for i=1:length(AMPS)
                    m = zeros(size(M));
                    % MEP coordinates
                    y = round([Y(i)+1]*scl1);
                    x = round([X(i)+1]*scl1);
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
            Thrshhld = 44; %V/m thresh_hld
            r = floor(size(Efield,1)/2);
            clear Ep_ef Ep_null Ep_amp
            for i=1:length(AMPS)
                % MEP coordinates
                y = round([Y(i)+1]*scl1);
                x = round([X(i)+1]*scl1);
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
        end
    end
    
    %%%%%%%%%%%%%%%%%%%5
    % simR2
    %%%%%%%%%%%%%%%%%%%%%%
    go_sim = 0;
    if go_sim == 0;
        cnt_conds = 1;
        cnt_sbplt = 1;
        f1 = figure;
        h0 = waitbar(0,'Please wait (channel)...');
        for cnd = conds;
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
            
            % max amp
            M = zeros(ceil(max(Y)*scl1),ceil(max(X)*scl1)); % matrix in mm * scl1
            if ~any(M), M(1,1) = 100; end
            for i=1:length(AMPS)
                M(round([Y(i)+1]*scl1),round([X(i)+1]*scl1))=AMPS(i);
            end
            [my mx] = find(M == max(max(M)));
            figure(f1)
            subplot(3,4,cnt_sbplt)
            imagesc(M)
            title([chnnls{cnd} '[' num2str(my + REF(3)) 'y, ' num2str(mx + REF(1)) 'x]'])
            clear MLR
            MLR.M = zeros(ceil(max(Y)*scl1),ceil(max(X)*scl1));
            % CoG
            
            clear LA
            for i=1:3;
                LA(:,i) = LOCn(i,:)'.*AMPS;
            end
            % miranda 1997
            CoG = sum(LA)/sum(AMPS);
            % projection (check if right)
            % CoG = mean(LA,1)/mean(AMPS);
            clear LOCcog
            for i=1:length(AMPS)
                try LOCcog(i) = dist(LOCn(:,i)',CoG','euclidean');
                catch LOCcog(i) = dist(LOCn(:,i)',CoG');
                end
            end
            Ecld = [LOCcog-max(LOCcog)]*-1;
            clear Mx
            Mx = zeros(ceil(max(Y)*scl1),ceil(max(X)*scl1)); % matrix in micrometers
            for i=1:length(AMPS)
                Mx(round([Y(i)+1]*scl1),round([X(i)+1]*scl1))=Ecld(i);
            end
            CoG1{cnt_conds}(1) = CoG(3);
            CoG1{cnt_conds}(2) = CoG(1);
            
            figure(f1)
            subplot(3,4,cnt_sbplt+1)
            imagesc(Mx)
            axis off
            title(['CoG [' num2str([CoG1{cnt_conds}(1)*scl1]+REF(3)) 'y, ' num2str([CoG1{cnt_conds}(2)*scl1]+REF(1)) 'x]'])
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % euclid
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            AMPS = A_pastespecial(:,cnd);
            M = zeros(ceil(max(Y)*scl1),ceil(max(X)*scl1)); % matrix in micrometers
            if ~any(M), M(1,1) = 100; end
            cnt = 1;
            h1 = waitbar(0,'Please wait (row)...');
            pos = get(h0,'pos');
            pos(2) = pos(2)-85;
            set(h1,'position',pos)
            h2 = waitbar(0,'Please wait (column)...');
            pos = get(h1,'pos');
            pos(2) = pos(2)-85;
            set(h2,'position',pos)
            
            % euclid
            clear Ecld pAMPS
            waitbar(cnd/length(conds),h0)
            for i=1:size(M,1)
                waitbar(i/size(M,1),h1)
                for ii=1:size(M,2)
                    waitbar(ii/size(M,2),h2)
                    for iii=1:length(AMPS)
                        try Ecld(iii)= dist([i,ii],[round(Y(iii)*scl1),round(X(iii)*scl1)]','euclidean');
                        catch Ecld(iii)= dist([i,ii],[round(Y(iii)*scl1),round(X(iii)*scl1)]');
                        end
                    end
                    [tmp ind] = sort(Ecld);
                    pAMPS(cnt,:) = AMPS(ind);
                    cnt = cnt+1;
                end
            end
            
            try close(h1), end
            try close(h2), end
            clear  B P
            cnt = 0;
            
            % polyfit
            pX = sort(AMPS*-1)*-1;
            MLR.M = zeros(ceil(max(Y)*scl1),ceil(max(X)*scl1));
            MLR.pX{cnd}=pX;
            for i=1:size(M,1);
                for ii=1:size(M,2);
                    cnt = cnt + 1;
                    pY = pAMPS(cnt,:);
                    % b = robustfit(pX',pY');
                    % b = robustfit([1:length(AMPS)]',pY');
                    % [b,BINT,R] = regress([1:length(AMPS)]',pY');
                    [p,S,MU] = polyfit(pX,pY',1);
                    f = polyval(p,pX,MU);
                    sse = sum(f-pX);
                    M(i,ii) = p(1);
                end
            end
            MLR.pAMPS{cnd}=pAMPS;
            figure(f1)
            subplot(3,4,cnt_sbplt+2),
            imagesc(M)
            axis off
            [mr mc] = find(M==max(max(M)));
            title(['Polyfit [' num2str(mean(mr)+REF(3)) 'y,' num2str(mean(mc)+REF(1)) 'x]']);
            ylabel(num2str(mean(mr))),
            xlabel(num2str(mean(mc)))
            
            cnt_sbplt = cnt_sbplt+4;
            cnt_conds = cnt_conds+1;
            waitbar(h1)
        end
    end
    try close(h0),end
    
    %%%%%%%%%%%%%%%%%%%%
    % multiple regression
    %%%%%%%%%%%%%%%%%%%%%
    %     pX = mean(cat(2,MLR.pX{:}),2);
    %     Y = cat(1,MLR.pAMPS{:});
    %     for i=1:floor(length(Y)/3)
    %         pY = Y([i,ceil(size(Y,1)/3+i),ceil((size(Y,1)/3*2)+i)],:)';
    %         pY = [pY,ones(length(pX),1)];
    %         [b,bint,r,rint,stats] = regress(pX,pY);
    %         B(:,i)=b(1:3);
    %     end
    %     dim = size(M);
    %     clear M
    %     M{1} = zeros(dim(1),dim(2));
    %     M{2} = zeros(dim(1),dim(2));
    %     M{3} = zeros(dim(1),dim(2));
    %
    %     cnt = 0;
    %     for i=1:size(M{1},1);
    %         for ii=1:size(M{1},2);
    %             cnt = cnt + 1;
    %             M{1}(i,ii) = B(1,cnt);
    %             M{2}(i,ii) = B(2,cnt);
    %             M{3}(i,ii) = B(3,cnt);
    %         end
    %     end
    %     figure(f1)
    %     subplot(3,4,4)
    %     imagesc(M{1})
    %     axis off
    %     title('MLR')
    %     subplot(3,4,8)
    %     imagesc(M{2})
    %     title('MLR')
    %     axis off
    %     subplot(3,4,12)
    %     imagesc(M{3})
    %     title('MLR')
    %     axis off
end
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%



h = msgbox('done!');
pause(2)
try close(h), end
%assignin('base',['MLR_' num2sgtr,MLR)

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

NBS=evalin('base','NBS');
str=get(handles.popupmenu1,'str');
val=get(handles.popupmenu1,'val');
save([str{val}(1:end-4) 'mat'],'NBS')

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


figure(handles.figure1)
cla(gca)
legend off
axis off


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FILENAME,PATHNAME]=uigetfile('.xls');
h=horzcat(PATHNAME,FILENAME);
set(handles.file,'string',h);
set(handles.file,'ForegroundColor',[0 0 0]);


% --- Executes on button press in getdata.
function getdata_Callback(hObject, eventdata, handles)
% hObject    handle to getdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = msgbox('please wait',' ','help');
e=get(handles.file,'string');
try [data textdata]= xlsread(e,'NBS');
catch [data textdata]= xlsread(e);
end
assignin('base','data',data);
assignin('base','textdata',textdata);
[M,N]=size(textdata);


% Generierung der Matrizen mit Stimulation Exams/date/researcher
n=1;
x=1;
stimex=cell(1,1);
row_stimex=[];
[M,N]=size(textdata);
col1text=char(textdata(:,1)); %Umwandeln der erste Spalte des Excel File in char um diese auszulesen -> Exams etc.
col2text=char(textdata(:,2)); %Umwandeln der erste Spalte des Excel File in char um diese auszulesen -> Sequences
assignin('base','col1text',col1text);
assignin('base','col2text',col2text);
set(handles.stimcrea,'string',strrep(col1text(2,:),'Session',''))
set(handles.stimres,'string',strrep(col1text(3,:),'Session',''))
while(x<=M)
    if(col1text(x,1)=='S' && col1text(x,18)=='C')                            %findet die time created
        stimex(n,1)=textdata(x,1);                                           %schreibt den inhalt in stimex
        row_stimex(n,1)=x;
    elseif(col1text(x,1)=='S' && col1text(x,18)=='R')                        %findet den researcher
        stimex(n,2)=textdata(x,1);                                           %schreibt den inhalt in stimex
        row_stimex(n,2)=x;
    elseif(col1text(x,1)=='S' && col1text(x,18)=='D')                        %findet diue description
        stimex(n,3)=textdata(x,1);                                           %schreibt den inhalt in stimex
        row_stimex(n,3)=x;
        n=n+1;
    end
    x=x+1;
end
show=char(stimex(:,3));
set(handles.stimex,'string',show);

%get information on subject
x=1;
while(col1text(x,1)~='P')
    x=x+1;
end
set(handles.name,'string',col1text(x,:));
set(handles.age,'string',col1text((x+1),:));
set(handles.handedness,'string',col1text((x+3),:));
try close(h), end



% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2

val=get(handles.stimex,'value');
str = get(handles.stimex,'string');
col1text = evalin('base','col1text');
str = str(val,:);
line = strmatch(str,col1text);
set(handles.stimcrea,'string',col1text((line-2),:));
set(handles.stimres,'string',col1text((line-1),:));



% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in showseq.
function showseq_Callback(hObject, eventdata, handles)
% hObject    handle to showseq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns showseq contents as cell array
%        contents{get(hObject,'Value')} returns selected item from showseq

GUI = evalin('base','NBS.GUI');
subj = get(handles.showseq,'value');
str = get(handles.showseq,'str');
val = get(handles.popupmenuSearchResults,'val');

if isempty(str)
    %
else
    str = str{subj};
    disp(['... looking for: ' str])
    [oind s] = find(strncmp(GUI(1,val).hdr,'Session', 7));
    sessstr = strrep(GUI(1,val).hdr(oind,1),'Session','');
    [pind s] = find(strncmp(GUI(1,val).hdr,'Patient', 7));
    patstr = strrep(GUI(1,val).hdr(pind(1):pind(1)+3,1),'Patient','');
    [eind x] = find(strncmp(GUI(1,val).hdr,'Stimulation Exam', 16));
    [sind y] = find(strcmp(GUI(1,val).hdr,str));
    if isempty(sind)
        str = str(1:[findstr(str,'(')]-1);
        [sind y] = find(strcmp(GUI(1,val).hdr,str));
    end
    if length(sind)>1, disp(sind), sind = sind(1); end % sind = input('sind ='); end
    
    [nind] = eind(find(eind<sind, 1, 'last' ));
    examstr = GUI(1,val).hdr(nind-2:nind,1);
    examstr = strrep(examstr,'Stimulation Exam ','');
    nrev = num2str(diff(str2num(GUI(1,val).sequencesindices{subj})));
    seqstr = strrep(GUI(1,val).hdr(sind-3:sind-1,y),'Sequence','');
    seqstr = {seqstr{:},[' Events: ' nrev ], [' A1: ' GUI(1,val).sequencesindices{subj}]};
    set(handles.name,'string',{patstr{:},strrep(examstr{end},'Stimulation Exam Description','Exam')});
    set(handles.seqinf,'string',{[' Sequence: ' num2str(get(handles.showseq,'val')) '/' num2str(length(get(handles.showseq,'str')))],seqstr{:}});
    set(handles.text17,'string',examstr);
    liststr = get(handles.listbox1,'str');
    line9 = ['A1 = ['];
    for i = 1:1:size(GUI(1,val).sequencesindices,2)
        if i < size(GUI(1,val).sequencesindices,2)
            line9 = [line9 GUI(1,val).sequencesindices{1,i} '; '];
        elseif i == size(GUI(1,val).sequencesindices,2)
            line9 = [line9 GUI(1,val).sequencesindices{1,i} ']'];
        end
    end
    liststr(5,1) = {line9};
    set(handles.listbox1,'str',liststr);
end

%%% add-on
% if evalin('base','edt')
%     str = get(handles.showseq,'str');
%     for sess=1:length(str)
%         str{sess} = [str{sess} '(' num2str(diff(str2num(GUI(1,val).sequencesindices{sess}))) ')'];
%     end
%     [s,v] = listdlg('PromptString','Select files to keep:',...
%         'SelectionMode','multiple',...
%         'ListSize',[650 300],...
%         'ListString',str);
%     eval(line9)
%     A1 = A1(s,:);
%     A1str = [ ];
%     for iA = 1:size(A1,1); A1str = [A1str num2str(A1(iA,:)) ';']; end
%     A1str = ['A1 = [' A1str]; A1str(end:end+1) = '];';
%     str = get(handles.showseq,'str');
%     str = str(s);
%     liststr(5,1) = {A1str};
%     NBS = evalin('base','NBS');
%     NBS.CONFIG(val).PARAMS{1} = liststr;
%     set(handles.showseq,'str',str)
%     set(handles.listbox1,'str',NBS.CONFIG(val).PARAMS{1})
%     assignin('base','NBS',NBS)
%
% end


% --- Executes during object creation, after setting all properties.
function showseq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to showseq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sel = get(handles.stimex,'value');
str = get(handles.stimex,'string');
col1text=evalin('base','col1text');
col2text=evalin('base','col2text');
textdata=evalin('base','textdata');
x = strmatch(str((sel),:),col1text);
y=1;
seq_sel=cell(1,y);
if((sel+1) <= size(str,1)) %immer zwischen aktueller und n�chster suchen
    z = strmatch(str((sel+1),:),col1text);
    while(x <= z); %f�llt die tabelle seq_sel mit allen sequences des ausgew�hlten exams (daten aus col2text)
        if(col2text(x,1)=='S');
            seq_sel(1,y)=textdata(x,2);
            seq_sel(2,y)=textdata((x+1),2);
            seq_sel(3,y)=textdata((x+2),2);
            seq_sel(4,y)=textdata((x+3),2);
            row_seqsel(1,y)=x;
            row_seqsel(2,y)=x+1;
            row_seqsel(3,y)=x+2;
            row_seqsel(4,y)=x+3;
            y=y+1;
            x=x+4;
        end;
        x=x+1;
    end
end
if(sel) == size(str,1) %f�r letzte immer zwischen letzter und ende der textdata tabelle suchen
    [M,N]=size(textdata);
    while(x<=M);
        if(col2text(x,1)=='S');
            seq_sel(1,y)=textdata(x,2);
            seq_sel(2,y)=textdata((x+1),2);
            seq_sel(3,y)=textdata((x+2),2);
            seq_sel(4,y)=textdata((x+3),2);
            row_seqsel(1,y)=x;
            row_seqsel(2,y)=x+1;
            row_seqsel(3,y)=x+2;
            row_seqsel(4,y)=x+3;
            y=y+1;
            x=x+4;
        end;
        x=x+1;
    end
end
[M,N]=size(seq_sel);
x=1;
y=1;
z=1;
while(y<=N) %prompt enth�lt alle sequences, die zu dem gew�hlten exam geh�ren
    while(x<=M)
        n=find(char((seq_sel(x,y))), 1, 'last' );
        prompt(z,(1:n))=char(seq_sel(x,y));
        x=x+1;
        z=z+1;
    end
    z=z+1; %l�sst eine Zeile frei
    y=y+1;
    x=1;
end
s=size(prompt);
cnt_max=ceil((s(1,1))/40); %gibt an, wieviele durchl�ufe maximal stattfinden sollen
cnt=1; %z�hlt die Durchl�ufe f�r inputdlg
if(cnt==cnt_max);
    answer=inputdlg(prompt(:,:),'Please enter the number of the sequences that you want to be added, e.g. "1,2,5" or just a single number');
end
if(cnt~=cnt_max)
    answer=inputdlg(prompt((1:39),:),'Please enter the number of the sequences that you want to be added, e.g. "1,2,5" or just a single number');
end
cnt=cnt+1;
while(cnt<=cnt_max)
    if(cnt~=cnt_max)
        answer(cnt,1)=inputdlg(prompt((((cnt-1)*40):(((cnt-1)*40)+39)),:),'Please enter the number of the sequences that you want to be added, e.g. "1,2,5" or just a single number');
        cnt=cnt+1;
    end
    if(cnt==cnt_max)
        answer(cnt,1)=inputdlg(prompt(((cnt-1)*40):(s(1,1)),:),'Please enter the number of the sequences that you want to be added, e.g. "1,2,5" or just a single number');
        cnt=cnt+1;
    end
end
choice=char(answer);
%herauslesen der notwendigen Zeilen f�r die Eintr�ge zu eval listbox
x=find(choice(:,1), 1, 'last' );
cnt=1;
[M,N]=size(choice);
z=1;
h=get(handles.showseq,'string');
h=char(h);
if(isempty(h))
    n = 1;
elseif(~isempty(h))
    show_seq = get(handles.showseq,'string');
    n = size(show_seq,1)+1;
end
while(cnt<=x)
    string=zeros(1,N);
    y=1;
    while(y<=N)
        string(1,y)=str2double(choice(z,y));
        y=y+1;
    end
    y=1;
    z=z+1;
    while(y<=N)
        if(string(1,y)<=8)
            show_seq(n,1)=seq_sel(1,((string(1,y)+((cnt-1)*8))));
            row_showseq(n,1)=row_seqsel(1,((string(1,y)+((cnt-1)*8))));
            n=n+1;
        end
        y=y+1;
    end
    cnt=cnt+1;
end
set(handles.showseq,'string',show_seq(:,1))




% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = get(handles.showseq,'val');
str = get(handles.showseq,'str');
ind = ones(1,length(str));
ind(val) = 0;
str = str(find(ind));
set(handles.showseq,'str',str,'val',1)




% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FILENAME, PATHNAME] = uigetfile('*.xlsx; *.xls', 'Get NBS excel export files','multiselect','on');
h = horzcat(PATHNAME,FILENAME);
set(handles.file,'string',h);
set(handles.file,'ForegroundColor',[0 0 0]);




% --- Executes on selection change in stimex.
function stimex_Callback(hObject, eventdata, handles)
% hObject    handle to stimex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns stimex contents as cell array
%        contents{get(hObject,'Value')} returns selected item from stimex

val = get(handles.stimex,'value');
str = get(handles.stimex,'string');
% set info
col1text = evalin('base','col1text');
str = str(val,:);
line = strmatch(str,col1text);
if length(line)>1; msgbox(['check that exam name: ' str ' is not duplicated in excel file'],' ','warn'), end
set(handles.stimcrea,'string',strrep(col1text(line-2,:),'Stimulation Exam',''),'val',1);
set(handles.stimres,'string',strrep(col1text(line-1,:),'Stimulation Exam',''),'val',1);

% --- Executes on button press in add_seq.
function add_seq_Callback(hObject, eventdata, handles)
% hObject    handle to add_seq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sel = get(handles.stimex,'value');
str = get(handles.stimex,'string');

subj = num2str(get(handles.popupmenuSearchResults,'val'));
try
    col1text = evalin('base',['NBS.GUI(' num2str(subj) ').col1text']);
    col2text = evalin('base',['NBS.GUI(' num2str(subj) ').col2text']);
    textdata = evalin('base',['NBS.GUI(' num2str(subj) ').textdata']);
catch
    col1text = evalin('base',['col1text']);
    col2text = evalin('base',['col2text']);
    textdata = evalin('base',['textdata']);
end

x = strmatch(str((sel),:),col1text);
y = 1;
yy = 1;
seq_sel=cell(1,y);
if sel+1 <= size(str,1) %immer zwischen aktueller und n�chster suchen
    z = strmatch(str((sel+1),:),col1text);
    while(x <= z); %f�llt die tabelle seq_sel mit allen sequences des ausgew�hlten exams (daten aus col2text)
        if(col2text(x,1)=='S');
            seq_sel(1,y)=textdata(x,2);
            seq_sel(2,y)=textdata((x+1),2);
            seq_sel(3,y)=textdata((x+2),2);
            seq_sel(4,y)=strrep(textdata((x+3),2),'Sequence',[num2str(yy) ') Sequence']); %textdata((x+3),2); %
            row_seqsel(1,y)=x;
            row_seqsel(2,y)=x+1;
            row_seqsel(3,y)=x+2;
            row_seqsel(4,y)=x+3;
            y=y+1;
            x=x+4;
            yy = yy+1; if yy == 9; yy=1; end
        end;
        x=x+1;
    end
end
if isempty(seq_sel{1}); disp('you have some exams that are named alike - best guess'), end
if(sel) == size(str,1) %f�r letzte immer zwischen letzter und ende der textdata tabelle suchen
    [M,N]=size(textdata);
    while(x<=M);
        if(col2text(x,1)=='S');
            seq_sel(1,y)=textdata(x,2);
            seq_sel(2,y)=textdata((x+1),2);
            seq_sel(3,y)=textdata((x+2),2);
            seq_sel(4,y)=strrep(textdata((x+3),2),'Sequence',[num2str(yy) ') Sequence']); %textdata((x+3),2); %
            row_seqsel(1,y)=x;
            row_seqsel(2,y)=x+1;
            row_seqsel(3,y)=x+2;
            row_seqsel(4,y)=x+3;
            y=y+1;
            x=x+4;
            yy = yy+1; if yy == 9; yy=1; end
        end;
        x=x+1;
    end
end
[M,N]=size(seq_sel);
x=1;
y=1;
z=1;
while(y<=N) %prompt enth�lt alle sequences, die zu dem gew�hlten exam geh�ren
    while(x<=M)
        n=max(find(char((seq_sel(x,y)))));
        prompt(z,(1:n))=char(seq_sel(x,y));
        x=x+1;
        z=z+1;
    end
    z=z+1; %l�sst eine Zeile frei
    y=y+1;
    x=1;
end
s=size(prompt);
cnt_max=ceil((s(1,1))/40); %gibt an, wieviele durchl�ufe maximal stattfinden sollen
cnt=1; %z�hlt die Durchl�ufe f�r inputdlg
if(cnt==cnt_max);
    answer=inputdlg(prompt(:,:),'Please enter the number of the sequences that you want to be added, e.g. "1,2,5" or just a single number');
end
if(cnt~=cnt_max)
    answer=inputdlg(prompt((1:39),:),'Please enter the number of the sequences that you want to be added, e.g. "1,2,5" or just a single number');
end
cnt=cnt+1;
while(cnt<=cnt_max)
    if(cnt~=cnt_max)
        answer(cnt,1)=inputdlg(prompt((((cnt-1)*40):(((cnt-1)*40)+39)),:),'Please enter the number of the sequences that you want to be added, e.g. "1,2,5" or just a single number');
        cnt=cnt+1;
    end
    if(cnt==cnt_max)
        answer(cnt,1)=inputdlg(prompt(((cnt-1)*40):(s(1,1)),:),'Please enter the number of the sequences that you want to be added, e.g. "1,2,5" or just a single number');
        cnt=cnt+1;
    end
end
choice=char(answer);
if isempty(choice)
    disp('canceled ...')
    return
end
%herauslesen der notwendigen Zeilen f�r die Eintr�ge zu eval listbox
x=find(choice(:,1), 1, 'last' );
cnt=1;
[M,N]=size(choice);
z=1;
h=get(handles.showseq,'string');
h=char(h);
if(isempty(h))
    n = 1;
else
    show_seq = get(handles.showseq,'string');
    n = size(show_seq,1)+1;
end
while(cnt<=x)
    string=zeros(1,N);
    y=1;
    while(y<=N)
        string(1,y)=str2double(choice(z,y));
        y=y+1;
    end
    y=1;
    z=z+1;
    while(y<=N)
        if(string(1,y)<=8)
            show_seq(n,1)=seq_sel(1,((string(1,y)+((cnt-1)*8))));
            row_showseq(n,1)=row_seqsel(1,((string(1,y)+((cnt-1)*8))));
            n=n+1;
        end
        y=y+1;
    end
    cnt=cnt+1;
end
set(handles.showseq,'string',show_seq(:,1),'val',1)



% --- Executes on button press in rem_seq.
function rem_seq_Callback(hObject, eventdata, handles)
% hObject    handle to rem_seq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = get(handles.showseq,'val');
str = get(handles.showseq,'str');
ind = ones(1,length(str));
ind(val) = 0;
str = str(find(ind));
try
    NBS = evalin('base','NBS');
    % remove from NBS
    % - NBS.CONFIG
    NBS.CONFIG(get(handles.popupmenu1,'val')).SEQ{1} = NBS.CONFIG(get(handles.popupmenu1,'val')).SEQ{1}(find(ind));
    % NBS.CONFIG(get(handles.popupmenu1,'val')).PARAMS = NBS.CONFIG(get(handles.popupmenu1,'val')).PARAMS(find(ind));
    % - NBS.DATA
    NBS.DATA(get(handles.popupmenu1,'val')).RAW = NBS.DATA(get(handles.popupmenu1,'val')).RAW(find(ind));
    NBS.DATA(get(handles.popupmenu1,'val')).PROCESSED = NBS.DATA(get(handles.popupmenu1,'val')).PROCESSED(find(ind));
    % NBS.ANALYSES = NBS.ANALYSES(find(ind));
    % NBS.RESULTS = NBS.RESULTS(find(ind));
    NBS.GUI.sequences = NBS.CONFIG(get(handles.popupmenu1,'val')).SEQ{1};
    assignin('base','NBS',NBS)
end

if val > 1;
    set(handles.showseq,'str',str,'val',val-1)
else
    set(handles.showseq,'str',str,'val',1)
end




% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function examfilter_Callback(hObject, eventdata, handles)
% hObject    handle to examfilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of examfilter as text
%        str2double(get(hObject,'String')) returns contents of examfilter as a double


% --- Executes during object creation, after setting all properties.
function examfilter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to examfilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%% SUBFUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

function [ind_data] = get_indx(seq_name, col2text, textdata)
%  seq_name = 'Sequence Created: 2008/05/08 12:15:56 ';

if nargin == 1
    subj = get(handles.popupmenuSearchResults,'val');
    col2text = evalin('base',['NBS.GUI(' num2str(subj) ').col2text']);
    textdata = evalin('base',['NBS.GUI(' num2str(subj) ').textdata']);
end



ind_seq = strmatch('Sequence Created',col2text);
%ind_seq = ind_seq(1:4:end);
% start
[ind_s] = strmatch(seq_name,col2text);
if length(ind_s)>1
    uiwait(msgbox(['found twice:  ' seq_name ],num2str(ind_s'),'warn'))
    return
end
ind_data(1) = ind_s + 11;
try
    ind_e = ind_seq(find(ind_seq == ind_s)+1);
    ind_data(2) = ind_e - 1;
catch
    ind_data(2) = size(col2text,1);
    ind_e = ind_data(2) ;
end

if diff(ind_data)==0
else
    % watch out for extra lines
    tmp = textdata(ind_s:ind_e,1:5);
    ind = strmatch('ID',tmp);
    indx = ceil(ind/size(tmp,1));
    indy = ind - [size(tmp,1)*[indx-1]];
    tmpn = tmp(indy:end,indx);
    evstrs = cat(2,tmpn{2:end});
    ind = findstr('.',evstrs);
    evstr{1} = evstrs(1:ind(3));
    evstr{2} = evstrs(ind(end-3)+1:ind(end));
    indstrs = strmatch(evstr{1},tmpn,'exact');
    if isempty(indstrs), msgbox([' could not find: ' evstr{1}]), end
    indstre = strmatch(evstr{2},tmpn,'exact');
    ind_data(1) = ind_data(1)+indy-1+indstrs-11;
    ind_data(2) = ind_data(1)+indstre-indstrs;
end

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

evalin('base','clear currseq')
NBS.defaults.refseq = 1;

%Sein's version can be found below/commented
%% SUCHE NACH REFERENZMAPS
MNMZ;  % MINIMIERT MATRIXGROESSE
NBS = CREATE4D('paired - pulse');
TMP = CMPL4D(NBS);
SZ = size(TMP);

for i = SZ(2):SZ(2) %go through last subject
    CURRSEQ = {};
    for j = 1:SZ(3) %go through sequences
        if isempty(cell2mat(TMP(1,i,j,1)))
            break;
        end
        CURRSEQ(end + 1,1) = TMP(1,i,j,1);
    end
    
    %%Correct SZ(3) as it might be false high cause of other subjects with more sequences
    SZ(3) = length(CURRSEQ);
    
    % MERKE DIE INDICES DER REFERENZEN, DIE POST-HOC ENTFERNT WERDEN
    % KOENNEN, SIE WERDEN JEDER MATRIX HINZUGEFUEGT; SIND ALSO HINTERHER
    % ALS STANDALONE OBSOLET
    RMREF = [];
    if length(CURRSEQ) > 1 % more then 1 sequence
        ANSW = {};
        if length(CURRSEQ) < 10 % less then 10 sequences
            PRMPT = {'Which sequences should be evaluated for PP?';...
                '"0" indicates no, "1" indicates yes'; '';...
                char(CURRSEQ(1,1))};
            a = cell(length(CURRSEQ),1);
            a(:,1) = {'1'};
            ANSW = INPUTDLG([{char(PRMPT)}; CURRSEQ(2:end,1)],'define sequences',1,a);
            if isempty(ANSW)
                errordlg('Subject is not added to this layer, no sequences have been selected for evaluation'); uiwait;
                return;
            end
        else % more then 1 more then 10 sequences
            STPS = ceil(length(CURRSEQ)/10);
            for z = 1:STPS
                if z < STPS
                    PRMPTSEQ = CURRSEQ(((1:10)+(z-1)*10),:);
                else
                    PRMPTSEQ = CURRSEQ(((z-1)*10 + 1):length(CURRSEQ),:);
                end
                PRMPT = {'Which sequences should be evaluated for PP?';...
                    '"0" indicates no, "1" indicates yes'; '';...
                    char(PRMPTSEQ(1,1))};
                a = cell(length(PRMPTSEQ),1);
                a(:,1) = {'1'};
                ANSWt = INPUTDLG([{char(PRMPT)}; PRMPTSEQ(2:end,1)],'define sequences',1,a);
                if isempty(ANSWt)
                    errordlg('Subject is not added to this layer, no sequences have been selected for evaluation'); uiwait;
                    return;
                end
                ANSW((end + 1) : (end + length(ANSWt)),:) = ANSWt;
            end
            if length(strmatch('0',ANSW)) == length(CURRSEQ)
                errordlg('Subject is not added to this layer, no sequences have been selected for evaluation');uiwait;
                return;
            end
            RMREF(end + 1 : end + length(strmatch('0',ANSW)),1) = strmatch('0',ANSW);
        end
        
        %search for references and concatenate if possible/necessary
        for j = 1:SZ(3) %go through sequences
            if any(j == RMREF) && j == SZ(3) %trifft zu, wenn condition nicht betrachtet werden soll und das ende der schleife erreicht ist
                break;
            end
            while any(j == RMREF) && j < SZ(3) %trifft zu, wenn condition nicht betrachtet werden soll
                j = j + 1;
            end
            MSO = cell2mat(TMP(1,i,j,5));
            % teste ob ueberhaupt ein paired pulse vorlag,
            %0 = kein paired-pulse, 1 = paired-pulse
            if sum(MSO(:,1) == 0) ~= size(MSO,1) && sum(MSO(:,2) == 0) ~= size(MSO,1)
                %check for references within the sequence
                if any(sum(MSO(:,1) == 0))
                    refcnt = sum(MSO(:,1) == 0);
                elseif any(sum(MSO(:,2) == 0))
                    refcnt = sum(MSO(:,2) == 0);
                else refcnt = 0;
                end
                
                if refcnt < 20 && refcnt ~= 0 %number of reference points <20, ref found
                    helpdlg(['Reference found for ' char(TMP(1,i,j,1)) ' , number of reference points is lower than 20 (i.e. ' num2str(refcnt) '), try to use outlier correction']);
                    uiwait;
                elseif refcnt == 0 %no  ref found
                    if NBS.defaults.refseq > length(CURRSEQ); NBS.defaults.refseq = 1; end
                    REFSEQ = listdlg('PromptString',['CHOOSE a reference sequence for: ' char(TMP(1,i,j,1))],...
                        'ListSize',[380 550],'SelectionMode','single',...
                        'ListString',CURRSEQ,'InitialValue',NBS.defaults.refseq);
                    NBS.defaults.refseq = REFSEQ;
                    if isempty(REFSEQ)%No reference chosen
                        % errordlg('No valid reference selected, please enter a reference to be used');uiwait;
                        try tmp = evalin('base','currseq'); catch currseq.currseq = 'NaN'; assignin('base','currseq',currseq); end
                        if strmatch(char(TMP(1,i,j,1)),evalin('base','currseq.currseq'));
                            ANSWER =  evalin('base','currseq.answer');
                        else
                            s = listdlg('PromptString',['CHOOSE the Condition sequences: ' char(TMP(1,i,j,1))],...
                                'ListSize',[280 550],'SelectionMode','multple',...
                                'ListString',CURRSEQ,'InitialValue',j:j+5);
                            A = zeros(20,length(s));
                            cnt = 1;
                            for a = s
                                tmp = NBS.DATA(get(handles.popupmenu1,'val')).RAW(a).AMPS;
                                tmp = tmp(:,find(max(tmp)==max(max(tmp))));
                                m(cnt) = mean(tmp(find(tmp)));
                                A(1:length(tmp),cnt) = tmp; % 3 = fdi
                                cnt = cnt+1;
                            end
                            A(A==0)=NaN;
                            tf = figure; boxplot(A), grid on, uiwait(msgbox(CURRSEQ(s)))
                            ANSWER = str2num(cell2mat(INPUTDLG('Please enter the desired reference amplitude (�V):','PP Reference',1,{num2str(round(mean(m)))})));
                            try close(tf), end
                            if isempty(ANSWER),
                                disp('Process cancelled by user...');
                                return;
                            end
                            currseq.currseq = CURRSEQ(s);
                            currseq.answer  = ANSWER;
                            assignin('base','currseq',currseq);
                        end

%                         addMSO = cell2mat(TMP(1,i,REFSEQ,5));
%                         addISI = cell2mat(TMP(1,i,REFSEQ,6));
%                         addAMPS = cell2mat(TMP(1,i,REFSEQ,7));
                        addMSO(1:20,[1 2]) = mtimes(ones(20,1),[0 MSO(1,2)]);
                        addISI = mtimes(ones(20,1),[0]);
                        addAMPS = mtimes(ones(20,6),ANSWER);
                        TMP(1,i,j,5) = {[cell2mat(TMP(1,i,j,5)); addMSO]};
                        TMP(1,i,j,6) = {[cell2mat(TMP(1,i,j,6)); addISI]};
                        TMP(1,i,j,7) = {[cell2mat(TMP(1,i,j,7)); addAMPS]};
                        %return;
                    else % reference sequence chosen
                        %catch MSO and AMPS of chosen matrix
                        MSO2 = cell2mat(TMP(1,i,REFSEQ,5));
                        if any(sum(MSO2(:,1) == 0))
                            refcnt = sum(MSO2(:,1) == 0);
                            IDXREF = logical(MSO2(:,1) == 0);
                        elseif any(sum(MSO2(:,2) == 0))
                            refcnt = sum(MSO2(:,2) == 0);
                            IDXREF = logical(MSO2(:,2) == 0);
                        else refcnt = 0;
                        end
                        
                        if refcnt == 0 %no non-zero stimulusintensity
                            try ANSWER = str2num(cell2mat(INPUTDLG('No non-zero stimintensity, Please enter the desired reference amplitude (�V):','PP Reference',1,{'1000'})));
                            catch disp('Process cancelled by user...');
                                return;
                            end
                            addMSO(1:20,[1 2]) = mtimes(ones(20,1),[0 MSO(1,2)]);
                            addISI = mtimes(ones(20,1),[0]);
                            addAMPS = mtimes(ones(20,6),ANSWER);
                            TMP(1,i,j,5) = {[cell2mat(TMP(1,i,j,5)); addMSO]};
                            TMP(1,i,j,6) = {[cell2mat(TMP(1,i,j,6)); addISI]};
                            TMP(1,i,j,7) = {[cell2mat(TMP(1,i,j,7)); addAMPS]};
                        else
                            %compare stimulation intensities
                            stimint = max(max(MSO(:,[1 2]))) - max(max(MSO2(:,[1 2])));
                            if abs(stimint) > 100 %wenn unterschied zwischen stimintensities > 2 ist ref ungeeignet
                                errordlg('Max MSO differs more than 2 units! Not a suitable reference, action cancelled...');uiwait;
                                return;
                            else
                                addMSO = cell2mat(TMP(1,i,REFSEQ,5));
                                addISI = cell2mat(TMP(1,i,REFSEQ,6));
                                addAMPS = cell2mat(TMP(1,i,REFSEQ,7));
                                TMP(1,i,j,5) = {[cell2mat(TMP(1,i,j,5)); addMSO(IDXREF,:)]};
                                TMP(1,i,j,6) = {[cell2mat(TMP(1,i,j,6)); addISI(IDXREF,:)]};
                                TMP(1,i,j,7) = {[cell2mat(TMP(1,i,j,7)); addAMPS(IDXREF,:)]};
                            end
                        end
                    end
                end
            else
                RMREF(end + 1) = j;
            end
        end
    end
    %%% REMOVE OBSOLETE REFERENCE SEQUENCES
    IDX = zeros(1,SZ(3));
    IDX(RMREF) = 1;
    IDX = find(IDX);
    for h = 1:length(IDX)
        TMP(1,i,IDX(h),:) = cell(1,1,1,SZ(4));
    end
end

NBS.ANALYSIS.MTRX(strmatch('paired - pulse',NBS.ANALYSIS.MTRXhdr(:,1)),1:SZ(2),:,:) = TMP;
assignin('base','NBS',NBS);
feval('evaltype_Callback',handles.evaltype,0,handles);


%SEINS PAIRED PULSE VARIANTE START

% NBS = evalin('base','NBS');
% subj = get(handles.popupmenu1,'val');
% sesss = length(NBS.DATA(subj));
%
% answer=inputdlg({'how many runs','how many conditions'},'paired pulses',1,{'4','7'});
% rns = str2num(answer{1});
% cnds = str2num(answer{2});
% str = deblank(strrep(get(handles.showseq,'str'),'Sequence Description: ',''));
% isistr = {'baseline','2','5','8','11','14','17'};
% iv = 1;
% for rn = 1:rns
%     [s,v] = listdlg('PromptString',['Select conditions for run: ' num2str(rn)],...
%         'SelectionMode','multiple',...
%         'ListString',str,'initialvalue',iv);
%    % try and guess index with isistr
%     try
%         nstr = str(s);
%         sind = cell(1,cnds);
%         for si = 1:cnds;
%             rx = regexp(nstr,isistr{si},'start');
%             for ri = 1:length(rx)
%                 if any(rx{ri});
%                      sind{ri} = num2str(si);
%                      break,
%                 end
%             end
%             if ~any(sind{si}), sind{si}=''; end
%         end
%     catch
%         for si = 1:cnds;
%             sind{si} = num2str(si);
%         end
%     end
%
%     answer=inputdlg(str(s),'paired pulses',1,sind);
%     PPind = [ ];
%     for i=1:length(answer)
%         if any(answer{i})
%             PairedPuls(rn).ind(i) = str2num(answer{i});
%         end
%         iv = iv+1;
%     end
% end
%
% PPmat = zeros(rns,cnds,10);
% cnt = 1;
% for rn = 1:rns
%     ppind = PairedPuls(rn).ind;
%     for sess = 1:length(ppind) % not sesss in this special case
%         A1 = NBS.DATA(subj).RAW(cnt).AMPS(:,3);
%         A2 = NBS.DATA(subj).RAW(cnt).AMPS(:,9);
%         if median(A1)>=median(A2)
%             A = A1;
%             disp(['LH: ' num2str(median(A1)) '/' num2str(median(A2))])
%         else
%             A = A2;
%             disp(['RH: '  num2str(median(A1)) '/' num2str(median(A2))])
%         end
%         try PPmat(rn,ppind(sess),1:length(A)) = A(1:10);
%         catch PPmat(rn,ppind(sess),1:length(A)) = A;
%         end
%         cnt = cnt+1;
%     end
%     NBS.RESULTS(subj).PairedPuls(rn).AMPS = PPmat(rn,:,1:10);
%     clear AMPS
% end
% assignin('base','NBS',NBS)
%
%
% %results from NBS (can be run from base workspace)
% cnt = 1;
% for subj = 1:length(NBS.RESULTS)
%     for rn = 1:length(NBS.RESULTS(subj).PairedPuls)
%         dim = size(NBS.RESULTS(subj).PairedPuls(rn).AMPS);
%         D{cnt}= reshape(NBS.RESULTS(subj).PairedPuls(rn).AMPS, dim(2),dim(3));
%         cnt = cnt+1;
%     end
% end
% nrmlz = 0;
% if nrmlz
%     for i=1:length(D)
%         %D{i} = mapstd(D{i});
%         DN{i} = 1000/median(median(D{i}))*D{i};
%     end
% end
%
% figure,
% for sess = 1:length(D)
%     subplot(ceil(length(D)/2),2,sess)
%     %boxplot(D{sess}')
%     bar(median(D{sess},2))
%     axis off
%     %title(num2str(sess))
% end
%
% Dc = cat(2,D{:});
% for i=1:7
%     Dt = Dc(i,:);
%     Da(i) = median(Dt(find(Dt)));
% end
% figure, bar(Da)
% figure, imagesc(Dc), colorbar, ylabel('parameter'), xlabel('session')
%
% % pre = 1, post = 2, lh = 1, rh = 2
% CONDITIONS = [12 11 21 22, 11 12 21 22, 11, 12 11, 11, 11 12 22 21, 11, 11 12 21 22];
% pre = [find(CONDITIONS==11), find(CONDITIONS == 12)];
% pst = [find(CONDITIONS==21), find(CONDITIONS == 22)];
%
% % 1st level
% Dpre = cat(2,D{pre});
% Dpst = cat(2,D{pst});
% for i = 1:7
%     [p(i) h(i)] = ranksum(Dpre(i,:),Dpst(i,:));
% end
%
% figure,
% hold on
% errorbar(mean(Dpre,2),std(Dpre')/size(Dpre,2),'b^')
% errorbar(mean(Dpst,2),std(Dpst')/size(Dpst,2),'bo')
% tmp = mean(Dpre,2);
% plot(find(h),tmp(find(h)),'r*'),
% figure,
% bar3([mean(Dpre,2)'; mean(Dpst,2)'],'detached')
%
%
% % second level
% for i=1:21
%     Dt = D{i};
%     for ii=1:size(Dt,1)
%     da(ii) = median(Dt(ii,find(Dt(ii,:))));
%     end
%     Da{i} = da;
% end
% Dpre = cat(1,Da{pre})';
% Dpst = cat(1,Da{pst})';
% Dpre(isnan(Dpre)) = 0;
% Dpst(isnan(Dpst)) = 0;
% for i = 1:7
%     [p(i) h(i)] = ranksum(Dpre(i,:),Dpst(i,:));
% end
% figure,
% bar3([mean(Dpre,2)'; mean(Dpst,2)'],'detached')

%SEINS PAIRED PULSE VARIANTE STOP




% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get preinnervation
NBS = evalin('base','NBS');

% answer=inputdlg(prompt,name,numlines,defaultanswer);

sattrls = 0;
pre = 200; %ms
post = 200;
targetsamplerate = 1000; % supports resampling
dtrnd = 0;

%biosig
addpath(fullfile(fileparts(which('h_NBS')),'h_EMG'))
pth = fullfile(fileparts(which('h_EMG')), 'biosig4octmat-2.11');
addpath(pth)
addpath(fileparts(which('h_EMG')))
addpath(genpath(fullfile(pth,'biosig')))
%addpath(genpath(fullfile(pth,'NaN')))
addpath(genpath(fullfile(pth,'tsa')))
addpath(genpath(fullfile(pth,'xmltree')))
% P = fileparts(fileparts(which('biosigVersion')));
pwd = cd;
cd(fullfile(pth,'biosig'))
install
cd(pwd)

subjs = get(handles.popupmenu1,'str');
val = get(handles.popupmenu1,'val');
P = strrep(which(subjs{val}),'.xlsx','');
P = strrep(P,'auto_','');
e = dir([P filesep '*.edf']); %'D:\Projects\TMS\NBS - PP\MEANS\Claudius____2008_07_10_19_47_31';
if isempty(e)
    P = uigetdir(P, 'Get directory of edfs of subject');
    e = dir([P filesep '*.edf']);
end
edfs = {e(:).name};
% edfs
GUI = evalin('base','NBS.GUI');
strs = get(handles.showseq,'str'); % == sessions
val = get(handles.popupmenuSearchResults,'val');
for i = 1:length(strs)
    try
        str = strs{i};
        disp(['... looking for: ' str])
        [oind s] = find(strncmp(GUI(1,val).hdr,'Session', 7));
        sessstr = strrep(GUI(1,val).hdr(oind,1),'Session','');
        [pind s] = find(strncmp(GUI(1,val).hdr,'Patient', 7));
        patstr = strrep(GUI(1,val).hdr(pind(1):pind(end)-1,1),'Patient','');
        [eind x] = find(strncmp(GUI(1,val).hdr,'Stimulation Exam', 16));
        [sind y] = find(strcmp(GUI(1,val).hdr,str));
        if isempty(sind)
            str = str(1:[findstr(str,'(')]-1);
            [sind y] = find(strcmp(GUI(1,val).hdr,str));
        end
        if length(sind)>1, disp(sind), sind = input('sind ='); end
        
        [nind] = eind(find(eind<sind, 1, 'last' ));
        examstr = GUI(1,val).hdr(nind-2:nind,1);
        examstr = strrep(examstr,'Stimulation Exam ','');
        seqstr = strrep(GUI(1,val).hdr(sind-3:sind,y),'Sequence','');
        nrev = num2str(diff(str2num(GUI(1,val).sequencesindices{i})));
        set(handles.name,'string',{patstr{:},strrep(examstr{end},'Stimulation Exam Description','Exam')});
        set(handles.seqinf,'string',{seqstr{:},[GUI(1,val).sequencesindices{i} ' (' nrev ')']});
        edfstr = strrep(strrep(strrep(strrep(seqstr{1},'Created: ',''),'/','_'),':','_'),' ','_');
        edfstr = [strrep(patstr{1},'Name: ',''), edfstr 'EMG.edf'];
        if isspace(edfstr(1)); edfstr = edfstr(2:end);end
        disp(edfstr)
        edf_ind(i) = strmatch(edfstr, strvcat(edfs{:}));
    catch
        edf_ind(i) = NaN;
    end
end
clear str

% load edf
for subj = 1
    try
        for sess = 1:length(strs)
            disp(['Session: ' num2str(sess)])
            str{subj} = edfs{edf_ind(sess)};
            disp(['reading: ' fullfile(P,str{subj})])
            HDR = sopen(fullfile(P,str{subj}),'r');
            sclose(HDR);
            HDR.Label;
            HDR.SampleRate;
            HDR.EVENT;
            HDR.T0;
            HDR.Patient;
            chstr = HDR.Label;
            [s,v] = listdlg('PromptString','Select a EMG channel(s):',...
                'SelectionMode','multiple',...
                'ListString',chstr);
            NBS.DATA(subj).RAW(sess).EMGHDR = HDR;
            
            % get triggers
            for cnd = s
                chan = cnd;
                disp(['Channel: ' num2str(chan)])
                disp('... getting triggers')
                [signal,header] = sload(fullfile(P,str{val}),find(strcmp('Gate In', chstr)),'SampleRate',targetsamplerate, 'OverflowDetection','off');
                ind = find(signal>std(signal)*2);
                clear trig
                trig(1) = ind(1)-1;
                for i = 2:length(ind)
                    if ind(i)-ind(i-1)==1
                    else
                        trig(end+1) = ind(i)-1;
                    end
                end
                
                disp(['... getting EMG  (' chstr{cnd} ')'])
                [signal,header] = sload(fullfile(P,str{val}),chan,'SampleRate',targetsamplerate,'OverflowDetection','off');
                disp('... got signal')
                trigs = trig;
                % check first period
                ind = 1;
                for i=sattrls+1:length(trigs)
                    prestim{ind} = signal(trigs(i)-pre : trigs(i));
                    poststim{ind} = signal(trigs(i) : trigs(i)+post);
                    gstr{ind} =  num2str(i);
                    ind = ind+1;
                end
                
                % tests
                PRE = cat(2,prestim{:});
                if dtrnd == 1
                    for i=1:size(PRE,2)
                        PRE(:,i) = PRE(:,i) -min(PRE(:,i));
                    end
                end
                for i=1:size(PRE,2)
                    PREsum(i) = sum(PRE(:,i));
                end
                
                % tests
                POST = cat(2,poststim{:});
                
                % AUC
                % [AREA,TH,SEN,SPEC,ACC] = auc(PRE(:,1),ones(1,size(PRE,1))');
                NBS.DATA(subj).RAW(sess).EMG(cnd).channel = chstr{cnd};
                NBS.DATA(subj).RAW(sess).EMG(cnd).preinnervation = PREsum;
                NBS.DATA(subj).RAW(sess).EMG(cnd).posttrig = POST;
                %NBS.DATA.PROCESSED
                assignin('base','NBS',NBS)
                
                if NBS.defaults.ctrl == 1;
                    % post stim
                    figure,
                    plot(POST), hold on
                    plot(mean(POST,2),'*-k')
                    title([strrep(str{subj},'_','-'),' (' chstr{cnd} ' - POST)'])
                    xlabel('ms')
                    ylabel('mV')
                    
                    
                    % pre stim
                    figure
                    imagesc(PRE');
                    ylabel('stimulus')
                    xlabel('[ms, stimulus at 201]')
                    colorbar
                    PRE = cat(2,mean(PRE,2), PRE);
                    [p,t,st] = anova1(PRE,{'mean',gstr{:}},'on');
                    figure
                    [c,m,h,nms] = multcompare(st,'display','on');
                end
            end
        end
    catch
    end
end
disp('done')



% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

type = {'duration','mso','location','v/m'};
[s,v] = listdlg('PromptString','Select variables:',...
    'SelectionMode','multiple',...
    'ListString',type);
type = type(s);

NBS = evalin('base','NBS');

cnt = 1;
subjs = 1:length(NBS.DATA);
for subj = subjs
    F = NBS.CONFIG(subj).FILENAMES{1};
    sesss = 1:length(NBS.DATA(subj).RAW);
    for sess = sesss
        if  strmatch('duration',type)
            %duration
            TMLN = NBS.DATA(subj).RAW(sess).TMLN;
            DURmin = ([TMLN(end) - TMLN(1)]/1000)/60;
            E{cnt,1} = strrep(F{1},'auto_','');
            E{cnt,2} = 'duration [min]';
            E{cnt,3} = DURmin;
            cnt = cnt+1;
        end
        if  strmatch('location',type)
            % location
            LOC = median(NBS.DATA(subj).RAW(sess).PP.data(:,10:12));
            str = {'LOC x','... y','... z'};
            for i=1:3
                E{cnt,1} = strrep(F{1},'auto_','');
                E{cnt,2} = str{i};
                try E{cnt,3} = LOC(i);
                catch E{cnt,3} = NaN;
                end
                cnt = cnt+1;
            end
        end
        % MSO
        if  strmatch('mso',type)
            MSO  = NBS.DATA(subj).RAW(sess).MSO(:,1);
            E{cnt,1} = strrep(F{1},'auto_','');
            E{cnt,2} = 'MSO (end)';
            E{cnt,3} = MSO(end);
            cnt = cnt+1;
            E{cnt,1} = strrep(F{1},'auto_','');
            E{cnt,2} = '... (std)';
            E{cnt,3} = std(MSO);
            cnt = cnt+1;
        end
        % V/m
        if  strmatch('v/m',type)
            VpM  = NBS.DATA(subj).RAW(sess).PP.data(:,end-1);
            E{cnt,1} = strrep(F{1},'auto_','');
            E{cnt,2} = 'VpM (end)';
            E{cnt,3} = VpM(end);
            cnt = cnt+1;
            E{cnt,1} = strrep(F{1},'auto_','');
            E{cnt,2} = '... (std)';
            E{cnt,3} = std(VpM);
            cnt = cnt+1;
        end
    end
end
xlswrite('DurLocMso.xlsx',E,'DurLocMSO')
disp('wrote to:')
disp(fullfile(cd,'DurLocMso.xlsx'))


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in mapping02.
function mapping02_Callback(hObject, eventdata, handles)
% hObject    handle to mapping02 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filenames = get(handles.popupmenu1,'str');
try subjind = evalin('base','subjind');
catch subjind = [1:length(filenames)];
end
log{1} = datestr(now);
for subj = subjind %subj, session, condition
    disp(['... subj: ' filenames{subj}])
    NBS = evalin('base','NBS');
    % bug fix/version compatibility
    try cd(NBS.PATHNAME); end,
    try NBS.sequences = NBS.SEQ{subj}; end
    % set gui
    set(handles.popupmenu1,'val',subj)
    set(handles.listbox1,'str', NBS.CONFIG(subj).PARAMS{1},'val',1)
    try
        set(handles.stimex,'str',NBS.GUI(subj).exams,'val',1);
        set(handles.showseq,'str', NBS.GUI(subj).sequences,'val',1);
        set(handles.popupmenuSearchResults,'str',NBS.GUI(subj).subjects, 'val',1);
    end
    
    drawnow
    
    % set parameters................................
    NBS.gridfit.smooth = 1;
    NBS.polyctrl = 0; % shows each individ. polyfit for glm (default no!)
    try NBS.resultsfilename = evalin('base','resultsfilename');
    catch NBS.resultsfilename = 'NBS_results'; %filename(1:end-4);
    end
    EF = 'some mat file';
    MLRsmooth = 1;
    
    % get parameters
    PRMS = NBS.CONFIG(subj).PARAMS{1};
    eval(PRMS{strmatch('scl1', strvcat(PRMS))});%    scl1 = 1;  %mm*scl11 e.g. 10.12 mm is rounded to 10, if scl1 = 10, then works withs 101
    eval(PRMS{strmatch('scl2', strvcat(PRMS))}); %     scl2 = 1; %mm*scl2 for fitting over euclidean distance from CoG
    eval(PRMS{strmatch('A1',   strvcat(PRMS))});
    eval(PRMS{strmatch('conds', strvcat(PRMS))});
    eval(PRMS{strmatch('sigma', strvcat(PRMS))});
    eval(PRMS{strmatch('radius', strvcat(PRMS))});
    eval(PRMS{strmatch('chnnls', strvcat(PRMS))}); %chnnls = {'APB','LATapb','FDI','LATfdi','ADM','LATadm'};
    eval(PRMS{strmatch('sheetname', strvcat(PRMS))}); %sheetname = 'NBS';
    NBS.hotspotradius = radius; % mm / for euclidean and MLR (linear or log (sgm) fit)
    
    % NOTE commented out the following line because it created a conflict
    % with a function called sigma
    NBS.sgm = sigma;
    
    % realized that the variable sgm is also in the PRMS array, so I get it
    % from there
    %     eval(PRMS{strmatch('sgm', strvcat(PRMS))});
    %     NBS.sgm = sgm;
    
    
    
    % preprocess??
    switch get(handles.MAPscatter,'checked'), case 'on', anlyss.scatter = 1; case 'off', anlyss.scatter = 0;end
    switch get(handles.MAPcontrast,'checked'), case 'on', anlyss.contrast = 1; case 'off', anlyss.contrast = 0; end
    switch get(handles.MAPortho,'checked'), case 'on', anlyss.orthog = 1; case 'off', anlyss.orthog = 0;end
    switch get(handles.MAPgridfitting,'checked'), case 'on', anlyss.grdft = 1; case 'off', anlyss.grdft = 0; end
    switch get(handles.MAPconvolution,'checked'), case 'on', anlyss.convolution = 1; case 'off', anlyss.convolution = 0; end
    switch get(handles.MAPdeconvolution,'checked'),
        case 'on', anlyss.deconvolution = 1;
            try EF = load(EF_file);
            catch msgbox('please set a path to the EF field'); return,
            end
        case 'off', anlyss.deconvolution = 0;
    end
    switch get(handles.MAPglm,'checked'), case 'on', anlyss.glm = 1; case 'off', anlyss.glm = 0; end% switch get(handles.MAPsim,'checked'), case 'on', anlyss.sim = 0; case 'off', anlyss.sim = 0; end
    switch get(handles.cclog,'checked'), case 'on', anlyss.sim(1) = 1; fittype = 'log'; case 'off', anlyss.sim(1) = 0; end
    switch get(handles.ccamp,'checked'), case 'on', anlyss.sim(2) = 1; fittype = 'amp'; case 'off', anlyss.sim(2) = 0; end
    switch get(handles.cclinear,'checked'), case 'on', anlyss.sim(3) = 1; fittype = 'linear'; case 'off', anlyss.sim(3) = 0; end
    switch get(handles.ctrlplts,'checked'), case 'on', NBS.defaults.ctrl = 1; case 'off', NBS.defaults.ctrl = 0; end
    switch get(handles.printresults,'checked'), case 'on', NBS.defaults.print = 1; case 'off', NBS.defaults.print = 0; end
    NBS.res = 72; %dpi
    % results directory
    [tmp,filename, ext] = fileparts(filenames{subj});
    NBS.defaults.resultsPF = fullfile([cd filesep filename],NBS.resultsfilename);
    if isdir(fileparts(NBS.defaults.resultsPF))~=1; mkdir(fileparts(NBS.defaults.resultsPF)); end
    
    mcrv = 50;
    try qntl_amps = NBS.defaults.quantile;
    catch qntl_amps = [0.01 0.999];
    end
    %qntl_locs = [.50 .975]; noch zu implementieren
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % get sessions
    %%%%%%%%%%%%%%%%%%%%%%%%
    figcnt = 0;
    try
        sessind = evalin('base','sessind');
        msgbox('sessind, see baseworkspace')
    catch
        sessind = [1:size(A1,1)];
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % concat?
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    concat =['off'];
    switch concat %get(handles.MAPS_concat,'checked')
        case 'on'
            for sess = 1:length(sessind);
                seq_datastrc{sess} = NBS.GUI(subj).sequences{sessind(sess)};
                ORNTRNGc{sess} = NBS.DATA(subj).RAW(sessind(sess)).PP.data(:,7:9);
                LOCc{sess} = NBS.DATA(subj).RAW(sessind(sess)).PP.data(:,10:12); %1:3 scalp location, 10:12 = intracortical
                A_pastespecialc{sess} = NBS.DATA(subj).RAW(sessind(sess)).AMPS;
                % standardize
                A = A_pastespecialc{sess};
                for cnd = 1:length(conds)
                    A(:,conds(cnd)) = A(:,conds(cnd))/mean(A(:,conds(cnd)));
                end
                A_pastespecialc{sess} = A;
            end
            seq_datastr = 'concatenation'; %cat(2,seq_datastrc{:});
            A_pastespecial = cat(1,A_pastespecialc{:});
            ORNTRNG = cat(1,ORNTRNGc{:});
            LOC = cat(1,LOCc{:});
            A1 = [A1(1),A1(end)];
            sessind = 1;
            CONCAT = 1;
            mcrv = 0;
        case 'off'
            CONCAT = 0;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    for sess = sessind;
        disp(['... session: ' num2str(A1(sess,:))])
        %%%%%%%%%%%%%%%%%%%%%%%%
        % load and preprocesses
        %%%%%%%%%%%%%%%%%%%%%%%%%
        if CONCAT == 0
            seq_datastr = NBS.GUI(subj).sequences{sess};
            ORNTRNG = NBS.DATA(subj).RAW(sess).PP.data(:,7:9);
            LOC = NBS.DATA(subj).RAW(sess).PP.data(:,10:12)*scl1; %1:3 scalp location, 10:12 = intracortical
            A_pastespecial = NBS.DATA(subj).RAW(sess).AMPS;
        end
        %%%%%%%%%%%%%%%%%%%%%
        
        if NBS.defaults.print
            if sess==sessind(1);
                fig_hdr = figure;
                figpos = get(fig_hdr,'pos');
            else
                try figure(fig_hdr);
                catch fig_hdr = figure; figpos = get(fig_hdr,'pos');
                end
            end
            imagesc(zeros(64))
            [a b] = fileparts(filenames{subj});
            b = strrep(b,'_','-');
            str ={['Sheetname: ' sheetname],['Filename: ' b], ['...'], ['Session: ' num2str(sess) ],[seq_datastr], ['Indices: [' ['AA' num2str(A1(sess,1)) ':AF' num2str(A1(sess,2))] ']' ],['Date: ' datestr(now)]};
            text(1,10,char(str));
            axis off
            figcnt = figcnt+1;
            print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig_hdr)
        end
        
        % AMPS
        disp(['... using data: ' sheetname '(' filenames{subj} ') --> [' ['AA' num2str(A1(sess,1)) ':AF' num2str(A1(sess,2))] ']' ])
        % preprocessing
        A_thresh = A_pastespecial;
        q = quantile(A_thresh(A_thresh~=0),qntl_amps);
        qind = find(A_thresh<q(1) | A_thresh>q(2));
        A_thresh(qind) = 0;
        A_thresh(A_thresh<mcrv) = 0;
        A_pastespecial = A_thresh;
        if length(conds)>ceil(size(A_pastespecial,2)/2)
            conds = conds(1:ceil(size(A_pastespecial,2)/2));
            msgbox(['subject #' num2str(subj) ': you had to many conditions, guessing there are: ' num2str(length(conds))])
        end
        if max(max(A_pastespecial(:,conds)))==0;
            disp(' no MEPs'),
            %break,
        end
        if ~any(A_pastespecial);
            errordlg(['subject #' num2str(subj) ': no MEPs in session ' num2str(sess) '(' ['AA' num2str(A1(sess,1)) ':AF' num2str(A1(sess,2))] ')']),
            %return
        end
        %
        
        % Physical Parameters
        %LOC = NBS.DATA(subj).RAW(sess).PP.data(:,10:12); %1:3 scalp location, 10:12 = intracortical
        if find(isnan(LOC))
            figure, imagesc(LOC), title(['you have NaNs in the physical parameters --> sesson:' num2str(A1(sess,:))])
        end
        %ORNTRNG = NBS.DATA(subj).RAW(sess).PP.data(:,7:9);
        if size(LOC,1)~=3; LOC = LOC'; end
        tmp = mean(LOC([1,3],:));
        % Outliers
        outlrs = find(tmp > mean(tmp)+3*std(tmp) | tmp < mean(tmp)-3*std(tmp));
        inlrs = ones(1,length(tmp)); inlrs(outlrs) = 0; inlrs = find(inlrs);
        if isempty(outlrs) ~= 1;
            if NBS.defaults.ctrl
                fig = figure; set(gcf,'pos',get(0,'ScreenSize'))
                plot(tmp),hold on, plot(outlrs, tmp(outlrs),'r*')
                title(['outlier(s > 3 std found - removing ' num2str(length(outlrs)) ' LOCATION(S) ...'])
                drawnow, pause(1), close(fig)
            end
            log{end+1} = ['outlier(s > 3 std found - removing ' num2str(length(outlrs)) ' LOCATION(S) ...'];
            A_pastespecial = (A_pastespecial(inlrs,:));
            LOC = LOC(:,inlrs);
        else
            log{end+1} = ['no outliers > 3 std'];
        end
        % find REFERENCE location
        refind = find(min(LOC)== min(min(LOC)));
        REF = LOC(:, refind(1))'; %x, y, z
        ref = min(LOC');
        refdiff = max(diff([ref; REF]));
        REF = REF - refdiff;
        % check scale measure --> larger scales take much! longer
        LOCcheck = length(find(sum(diff(round(LOC)')')==0));
        if LOCcheck > 0;
            log{end+1} = ['rounding LOCATIONS --> loss of ' num2str(LOCcheck) '/' num2str(length(LOC)) ' (LOCATIONS)'];
            if NBS.defaults.ctrl
                m1 = msgbox(['rounding LOCATIONS --> loss of ' num2str(LOCcheck) '/' num2str(length(LOC)) ' (LOCATIONS)'], 'you might want to set scl1/2 to 10','warn');pause(2)
                try close(m1), end
            end
        else
            log{end+1} = ['no loss of locations due to rounding'];
        end
        % MAPS (raw)
        tic;
        clear LOCn Ms LA Ecld CoG
        try condind = evalin('base','condind');
        catch
            condind = [1:length(conds)];
            assignin('base','condind',condind)
            msgbox({'condind (e.g. 1 3 5)', 'sessind (e.g. 1 3 5)', 'subjind (e.g. 1 17)', 'inptctrl = 1/0'},'see baseworkspace')
        end
        if length(condind)> size(A_pastespecial(:,conds),2)
            condind = 1:length(size(A_pastespecial(:,conds),2));
        end
        for cnd = condind;
            log = log(1:3);
            AMPS = A_pastespecial(:,conds(cnd)); %1,3,5
            %             if max(max(A_pastespecial(:,conds)))==0
            %                 disp(['no MEPs for condition: ' num2str(cnd)])
            %                 break
            %             end
            LOCn(1,:)=LOC(1,:)-REF(1);
            X=LOCn(1,:);
            LOCn(2,:)=LOC(2,:)-REF(2);
            Z=LOCn(2,:);
            LOCn(3,:)=LOC(3,:)-REF(3);
            Y=LOCn(3,:);
            
            
            if NBS.defaults.ctrl == 1 && cnd == conds(1);
                fig = figure; set(gcf,'pos',get(0,'ScreenSize'))
                subplot(2,2,1), plot(LOCn','-x'), legend({'X','Y','Z'}), grid on; xlabel(['(event)']), ylabel(['(mm)'])
                subplot(2,2,2), plot3(X,Y,Z,'-x'),  grid on; xlabel(['LR (mm)']), ylabel(['AP (mm)']), zlabel([' IS (mm)'])
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %RAW
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % MAPS
            clear M
            M = zeros(ceil(max(Y)*scl1),ceil(max(X)*scl1)); % matrix in micrometers
            for i=1:length(AMPS)
                M(round([Y(i)+1]*scl1),round([X(i)+1]*scl1))=AMPS(i);
            end
            if ~any(M);
                M(1,1) = 100;
            end
            % smooth map
            %h = fspecial('log',[NBS.hotspotradius*scl1 NBS.hotspotradius*scl1],NBS.sgm*scl1)*-1;
            h = fspecial('gaussian',[NBS.hotspotradius*scl1 NBS.hotspotradius*scl1],NBS.sgm*scl1);

            Ms = imfilter(M,h,'same');
            Ms = Ms.*[max(max(M))/max(max(Ms))];
            MAPS.M(cnd).raw  = M;
            MAPS.M(cnd).map = M; %THIS IS THE MAP TO PASS THROUGH
            MAPS.type{cnd,1} = 'raw';
            % CoG  miranda 1997
            CoG(cnd).REF = REF;
            CoD(cnd).REF = feval('h_CoD',1,ORNTRNG(1,:));
            CoG(cnd).raw = feval('h_CoG',[ ], AMPS, LOCn);
            CoD(cnd).raw = feval('h_CoD',AMPS,ORNTRNG);
            Max(cnd).raw = LOC(:,find(AMPS == max(AMPS)));
            
            if cnd == conds(1) && NBS.defaults.ctrl;
                figure(fig);
                subplot(2,2,3)
                plot(mean(h)), title('smoothing kernel');
                if NBS.defaults.print
                    figcnt = figcnt +1;
                    print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig)
                    close(fig)
                end
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % volume /Ms
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Mx = Ms;
            Mx(Mx<0) = 0;
            
            % identify blobs
            go = 0;
            if go ==1
                bw = Ms;
                D = bwdist(~bw);
                figure, imshow(D,[],'InitialMagnification','fit')
                title('Distance transform of ~bw')
                D = -D;
                D(~bw) = -Inf;
                L = watershed(D);
                rgb = label2rgb(L,'jet',[.5 .5 .5]);
                figure, imshow(rgb,'InitialMagnification','fit')
                title('Watershed transform of D')
            end
            
            %%%%%%%% STATISTICS ON RAW AND SMOOTHED MAPS (Results - log)
            STATS1 = regionprops(bwlabel(M), M,'all');
            vlm.area = bwarea(M)/scl1;
            vlm.mean = vlm.area * mean(AMPS(find(AMPS)))/1000;
            vlm.std =  std(AMPS(find(AMPS)))/1000;
            
            log{end+1} = ['.........................................'];
            log{end+1} = [chnnls{conds(cnd)} '; cond:' num2str(cnd)];
            log{end+1} = seq_datastr;
            log{end+1} = [num2str(length(AMPS)) ' events; ' num2str(length(find(AMPS))) ' MEPS'] ;
            log{end+1} = ['#ROI: first of ' num2str(length(STATS1))];
            log{end+1} = ['#Clusters (Euler): ' num2str(bweuler(Mx))];
            log{end+1} = ['Volume: ' num2str(vlm.mean) ' +/-' num2str(vlm.std) '[#MEP*mV]'];
            log{end+1} = ['Area: ' num2str(vlm.area) ' [mm]'];
            log{end+1} = ['Kurtosis: ' num2str([kurtosis(mean(Ms)) + kurtosis(mean(Ms'))/2])];
            log{end+1} = ['WeightedCentroid: ' num2str(STATS1(1).WeightedCentroid) ' [x y]'];
            
            STATS2 = regionprops(bwlabel(Mx),Ms, 'all'); %changed Mx to Ms in Sept. 2009
            %STATS2 = regionprops(bwlabel(imerode(Mx,strel('disk',5))),Ms, 'all'); %changed Mx to Ms in Sept. 2009
            
            %STATS2 = regionprops(bwlabel(imextendedmax(Mx,1000)),Ms, 'all'); %changed Mx to Ms in Sept. 2009
            %bweuler(imextendedmax(Mx,1000))
            vlm.sarea = bwarea(Mx)/scl1;
            vlm.smean = vlm.sarea * mean(AMPS(find(AMPS)))/1000;
            vlm.sstd =  std(AMPS(find(AMPS)))/1000;
            
            rawradius = [max(Y(find(AMPS)))-min(Y(find(AMPS)))+max(X(find(AMPS)))-min(X(find(AMPS)))]/4;
            rawquantil = [diff(quantile(find(sum(M)),[.025 .975])) + diff(quantile(find(sum(M')),[.025 .975]))]/2;
            rawradius = rawquantil/2;
            
            % check and print if multiple regions
            bw = bweuler(Mx);
            if bw>1
                fig = figure;
                subplot(2,4,1)
                imagesc(Mx)
                title(['Eulerzahl > 1'])
                clear A
                for ir = 1:bw
                    A(ir) = STATS2(ir).ConvexArea;
                    subplot(2,4,ir+1)
                    imagesc(STATS2(ir).ConvexImage)
                    title(['ROI #' num2str(ir)])
                    subplot(2,4,1)
                    xy = fix(STATS2(ir).Centroid);
                    text(xy(1),xy(2),num2str(ir),'color','white')
                end
                % some more securtiy
                A(2,1) = STATS2(1).MeanIntensity;
                A(2,2) = STATS2(2).MeanIntensity;
                A = sum(A);
                
                lR = find(A==max(A)); % largest ROI
                if NBS.defaults.print
                    figcnt = figcnt +1;
                    print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig)
                    close(fig)
                else
                    close(fig)
                end
            else
                lR = 1;
            end
            STATS2 = STATS2(lR);
            STATS2.EulerNumber = bw;
            
            
            log{end+1} = ['Volume (smoothed): ' num2str(vlm.smean) ' +/-' num2str(vlm.sstd)  ' [#MEP*mV]'];
            log{end+1} = ['Area (smoothed): ' num2str(vlm.sarea)];
            log{end+1} = ['WeightedCentroid (smoothed): ' num2str(STATS2(1).WeightedCentroid) ' [x y]'];
            log{end+1} = ['Convex Area: ' num2str(STATS2(1).ConvexArea)];
            log{end+1} = ['Perimeter: ' num2str(STATS2(1).Perimeter)];
            log{end+1} = ['EquivDiameter: ' num2str(STATS2(1).EquivDiameter)];
            log{end+1} = ['RawDiameter: ' num2str(rawradius*2)];
            
            RESULTS(subj).MAPS(sess).stats(cnd).log.raw = log;
            RESULTS(subj).MAPS(sess).stats(cnd).cog = CoG(cnd);
            RESULTS(subj).MAPS(sess).stats(cnd).cod = CoD;
            RESULTS(subj).MAPS(sess).stats(cnd).max = Max(cnd);
            RESULTS(subj).MAPS(sess).stats(cnd).raw = STATS1;
            RESULTS(subj).MAPS(sess).stats(cnd).smoothed = STATS2;
            
            
            S(subj,sess,:) = [vlm.mean, vlm.area, rawradius*2, vlm.smean, vlm.sarea,  STATS2(1).ConvexArea, STATS2(1).EquivDiameter, STATS2(1).Perimeter];
            
            disp('MAPS_STATS = MAPS_STATS(subj,sess,[raw - volume, area, diameter, smoothed - volume, area, convex area, equiv diameter, perimeter)]')
            disp('RESULTS(subj).MAPS(sess).stats')
            assignin('base','MAPS_STATS',S)
            assignin('base','MAPS_RESULTS',RESULTS)
            
            if NBS.defaults.ctrl
                fig = figure; set(gcf,'pos',get(0,'ScreenSize'))
                text(0,1, log,'VerticalAlignment','top'), axis off
                if NBS.defaults.print
                    figcnt = figcnt +1;
                    print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig)
                    close(fig)
                end
            end
            % CoD
            
            
            %%% scatter
            if anlyss.scatter == 1 && NBS.defaults.ctrl% scatter plots of raw data
                fig = figure; set(gcf,'pos',get(0,'ScreenSize'))
                set(gcf,'name',['condition ' chnnls{conds(cnd)}])
                subplot(2,2,1),
                scatter([LOC(1,:)],[LOC(3,:)],100,AMPS/1000,'filled');hold on
                plot([CoG(cnd).raw(1)+REF(1)],[CoG(cnd).raw(3)+REF(3)],'*r');
                xlabel(['LRcog -->' num2str(CoG(cnd).raw(1)+REF(1)) '[mm]']);
                ylabel(['APcog -->' num2str(CoG(cnd).raw(3)+REF(3)) '[mm]']);
                title([chnnls{conds(cnd)} ': scatter plot' ])
                grid on
                subplot(2,2,2)
                imagesc(M)
                hold on
                fnplt(rsmak('circle',rawradius,STATS2(1).WeightedCentroid),'m')
                fnplt(rsmak('circle',STATS2(1).EquivDiameter/2, STATS2(1).WeightedCentroid),'r')
                title([ chnnls{conds(cnd)} '(' strrep(seq_datastr,'Sequence Description: ','') ')'])
                text(round(CoG(cnd).raw(1)),round(CoG(cnd).raw(3)),'x [CoG]','color','r')
                % y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                % x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm] ... blue = raw; red = smoothed data equiv. diameter')
                grid on
                title('contour of MAP (smoothed)')
                y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                hold on
                contour(Ms,20)
                subplot(2,2,3)
                plot(Ms,1:size(Ms,1))
                title('plot of MAP (smoothed)')
                text(max(max(Ms)),round(CoG(cnd).raw(3)),'<','color','r')
                y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3));
                set(gca,'yticklabel',y_mm);
                xlabel('[mV]')
                ylabel('[mm]')
                % x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                %xlim([0 100]),
                grid on
                subplot(2,2,4)
                plot(1:size(Ms,2),Ms')
                title('plot of MAP (smoothed)')
                text(round(CoG(cnd).raw(1)),max(max(Ms)),'v','color','r')
                %y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm);
                ylabel('[mV]')
                x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1));
                set(subplot(2,2,4),'xticklabel',x_mm);
                xlabel('[mm]')
                %xlim([0 100]),
                grid on
                drawnow
                
                
                
                %subplot(2,2,4)
                if NBS.defaults.print
                    figcnt = figcnt +1;
                    print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig)
                    pause(3)
                    close(fig)
                end
                
                % go back one step and do an gauss fit on the raw data
                fig = figure;
                subplot(3,2,1)
                plot(sum(M),'-*')
                xlim([0 100]), title('plot(sum(M))')
                %title([ chnnls{conds(cnd)} ' (' strrep(seq_datastr,'Sequence Description: ','') ')'])
                subplot(3,2,2)
                plot(sum(M'),'-*')
                xlim([0 100]), title('plot(sum(M inverted))')
                subplot(3,2,5)
                y = diff(quantile(find(sum(M)),[.025 .975]));
                bar(y)
                ylim([0 100]), title('quantile [0.025 0.975]')
                grid on
                subplot(3,2,6)
                y = diff(quantile(find(sum(M')),[.025 .975]));
                bar(y)
                ylim([0 100]), title('quantile [0.025 0.975]')
                grid on
                subplot(3,2,3)
                boxplot(find(sum(M)),'orientation','horizontal')
                title('boxplot (width of plot(sum(M))')
                xlim([0 100]),
                subplot(3,2,4)
                boxplot(find(sum(M')),'orientation','horizontal')
                title('boxplot (width of plot(sum(M inverted))')
                xlim([0 100]),
                if NBS.defaults.print
                    figcnt = figcnt +1;
                    print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig)
                    close(fig)
                end
                % % %                 subplot(2,2,3)
                % % %                 [f xi u] = ksdensity(sm);
                % % %                 plot(xi,f)
                % % %                 [mu,sigma,MUCI,SIGMACI] = normfit(sm) ;
                % % %                 Y = normpdf(X,mu,sigma);
            end
            t.scatter = toc;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
        %%% orthogonalize/corrcoef
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if anlyss.orthog == 1
            log = log(1:7);
            tic; clear Ptrns
            PC = A_pastespecial(:,[1,3,5]);
            rnk = rank(PC); disp(['... ranks: ' num2str(rnk)])
            orthtyp = 'pca';
            switch orthtyp
                case 'pca'
                    %                     try
                    %                         [Ptrns, meanp, stdp] = prestd(PC);
                    %                         [Ptrns,Transmat] = prepca(Ptrns',0.0001);
                    %                         % post processing
                    %                         Ptrns = poststd(Ptrns',meanp,stdp);
                    %                     catch %matlab 2008b
                    [PC,MU,sgm] = zscore(PC);
                    [COEFF, SCORE, LATENT] = princomp(PC);
                    rnk = rank(PC);
                    %for iz=1:size(SCORE,2);
                    %    Ptrns(:,iz) = (SCORE(:,iz)+MU(iz))./sgm(iz);
                    %end
                    %resort by channel (PC1 ~= APB)
                    for chni = 1:length(conds)
                        ind = find(abs(COEFF(chni,:))== max(abs(COEFF(chni,:))));
                        chnind(chni) = ind(1);
                        if  max(COEFF(chni,:)) > 0;
                            Ptrns(:,chni) = fix(SCORE(:,chnind(chni)));
                        else
                            Ptrns(:,chni) = fix(SCORE(:,chnind(chni)).*-1);
                        end
                    end
                    COEFF = COEFF(chnind,:);
                    disp(['... most variance described signals: ' num2str(chnind)])
                    %                     end
                case 'orth'
                    Ptrns = orth(PC);
                case 'svd'
                    [U,Ptrns,V] = svd(PC',0);
                case 'gramschmidt'
                    %  Gram-Schmidt
                    Ptrns = mgrscho(PC); disp(['... gram schmidt orthogonalization'])
            end
            
            if NBS.defaults.ctrl
                str = {'APB','FDI','ADM','PC1','PC2','PC3'};
                fig = figure; set(gcf,'pos',get(0,'ScreenSize'))
                subplot(4,1,1),plot(PC), grid on, title('raw data'), legend(str(1:3))
                subplot(4,1,2),plot(Ptrns), grid on, title(['orthogonal data (rank: ' num2str(rnk) ')']), legend(str(4:6))
                subplot(4,1,3:4)
                imagesc(abs(COEFF)), colorbar
                y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                title('correlations matrix')
                ind = 3+ size(Ptrns,2);
                set(gca, 'xticklabel',str(4:ind),'xtick',[1:ind])
                set(gca, 'yticklabel',str(