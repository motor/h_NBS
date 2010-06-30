function varargout = h_NBS(varargin)
% H_NBS M-file for h_NBS.fig
%      H_NBS, by itself, creates a new H_NBS or raises the existing
%      singleton*.
%      TEST GIT 1
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
% Last Modified by GUIDE v2.5 23-May-2010 18:55:24
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
if((sel+1) <= size(str,1)) %immer zwischen aktueller und nächster suchen
    z = strmatch(str((sel+1),:),col1text);
    while(x <= z); %füllt die tabelle seq_sel mit allen sequences des ausgewählten exams (daten aus col2text)
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
if(sel) == size(str,1) %für letzte immer zwischen letzter und ende der textdata tabelle suchen
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
while(y<=N) %prompt enthält alle sequences, die zu dem gewählten exam gehören
    while(x<=M)
        n=find(char((seq_sel(x,y))), 1, 'last' );
        prompt(z,(1:n))=char(seq_sel(x,y));
        x=x+1;
        z=z+1;
    end
    z=z+1; %lässt eine Zeile frei
    y=y+1;
    x=1;
end
s=size(prompt);
cnt_max=ceil((s(1,1))/40); %gibt an, wieviele durchläufe maximal stattfinden sollen
cnt=1; %zählt die Durchläufe für inputdlg
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
%herauslesen der notwendigen Zeilen für die Einträge zu eval listbox
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
if sel+1 <= size(str,1) %immer zwischen aktueller und nächster suchen
    z = strmatch(str((sel+1),:),col1text);
    while(x <= z); %füllt die tabelle seq_sel mit allen sequences des ausgewählten exams (daten aus col2text)
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
if(sel) == size(str,1) %für letzte immer zwischen letzter und ende der textdata tabelle suchen
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
while(y<=N) %prompt enthält alle sequences, die zu dem gewählten exam gehören
    while(x<=M)
        n=max(find(char((seq_sel(x,y)))));
        prompt(z,(1:n))=char(seq_sel(x,y));
        x=x+1;
        z=z+1;
    end
    z=z+1; %lässt eine Zeile frei
    y=y+1;
    x=1;
end
s=size(prompt);
cnt_max=ceil((s(1,1))/40); %gibt an, wieviele durchläufe maximal stattfinden sollen
cnt=1; %zählt die Durchläufe für inputdlg
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
%herauslesen der notwendigen Zeilen für die Einträge zu eval listbox
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
                            ANSWER = str2num(cell2mat(INPUTDLG('Please enter the desired reference amplitude (µV):','PP Reference',1,{num2str(round(mean(m)))})));
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
                            try ANSWER = str2num(cell2mat(INPUTDLG('No non-zero stimintensity, Please enter the desired reference amplitude (µV):','PP Reference',1,{'1000'})));
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
                set(gca, 'yticklabel',str(1:3),'ytick',[1:ind])
                if NBS.defaults.print
                    figcnt = figcnt +1;
                    print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig)
                    close(fig)
                end
                t.orthog = toc;
            end
            
            clear AMPS
            
            % make orthogonolized maps and CoG
            for cnd = 1:size(conds,2);
                AMPS = Ptrns(:,cnd); %1,2,3
                log{5} = [chnnls{conds(cnd)} '; cond:' num2str(cnd)];
                %  M
                M = zeros(ceil(max(Y)*scl1),ceil(max(X)*scl1)); % matrix in micrometers
                for i=1:length(AMPS)
                    M(round([Y(i)+1]*scl1),round([X(i)+1]*scl1))=AMPS(i);
                end
                % correct if is empty
                if ~any(M);
                    M(1,1) = -100;
                end
                % MAPS
                MAPS.M(cnd).map = M;
                MAPS.M(cnd).ortho = M;
                MAPS.type{cnd,end+1} = 'orthogonalized';
                % CoG
                CoG(cnd).ortho  = feval('h_CoG',[ ] , AMPS, LOCn);
                CoD(cnd).ortho = feval('h_CoD',AMPS,ORNTRNG);
                Max(cnd).ortho = LOC(:,find(AMPS == max(AMPS)));
                
                
                %STATS
                Ms = imfilter(M,h,'same');
                STATS = regionprops(bwlabel(Ms), M,'all');
                RESULTS(subj).MAPS(sess).stats(cnd).log.ortho = log;
                RESULTS(subj).MAPS(sess).stats(cnd).cog = CoG(cnd);
                RESULTS(subj).MAPS(sess).stats(cnd).cod = CoD;
                RESULTS(subj).MAPS(sess).stats(cnd).max = Max(cnd);
                RESULTS(subj).MAPS(sess).stats(cnd).orthoraw = STATS;
                assignin('base','MAPS_RESULTS',RESULTS)
                
                
                % display
                if NBS.defaults.ctrl;
                    % figs
                    fig = figure; set(gcf,'pos',get(0,'ScreenSize'))
                    set(gcf,'name',['condsition PC' num2str(cnd)])
                    subplot(2,2,4)
                    scatter(X,Y,200,AMPS/1000,'filled');
                    y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                    x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                    xlabel('LR[mm]');
                    ylabel('AP[mm]');
                    title(['PC ' num2str(cnd) ': scatter plot' ])
                    axis tight
                    grid on
                    subplot(2,2,1)
                    imagesc(M)
                    y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                    x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                    colorbar
                    title(['PC-' num2str(cnd) ])
                    text(round(CoG(cnd).ortho(1)),round(CoG(cnd).ortho(3)),'x [CoG]','color','w')
                    grid on
                    subplot(2,2,2)
                    Ms = imfilter(M,h,'same'); Ms(isnan(Ms)) = 0; if sum(sum(Ms))~=0; Ms = Ms.*[max(max(M))/max(max(Ms))]; Ms(isnan(Ms)) = 0; end
                    imagesc(Ms), colorbar
                    y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                    x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                    title('smoothed')
                    subplot(2,2,3)
                    contour(flipud(Ms),20)
                    y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                    x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                    title('contour')
                    grid on
                    if NBS.defaults.print
                        figcnt = figcnt +1;
                        print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig),
                        close(fig)
                    end
                end
                
            end
        else
            Ptrns = A_pastespecial(:,conds(cnd));
        end
        
        %%%%%%%%%%%%%%%%
        % contrast?
        %%%%%%%%%%%%%%%%
        if anlyss.contrast == 1;% contrast all possible contrasts (subtractions)
            tic;
            log = log(1:7);
            indx = [1 2 3 1 2]; %%%%%%%%%%%%%%%%%%%%%%%%%
            str = chnnls([1,3,5]);
            if NBS.defaults.ctrl
                f1 = figure; set(gcf,'pos',get(0,'ScreenSize'))
                f2 = figure; set(gcf,'pos',get(0,'ScreenSize'))
                sbplt = 1;
            end
            clear Mm
            cnds = [1:3];
            for i=cnds;
                log{5} = [chnnls{conds(i)} '; cond:' num2str(i)];
                ind = indx(i:i+2);
                
                % raw
                M_raw = [MAPS.M(ind(1)).raw];
                Ms = imfilter(M_raw,h,'same'); Ms(isnan(Ms)) = 0;
                if sum(sum(Ms))~=0; Ms = Ms.*[max(max(M))/max(max(Ms))]; Ms(isnan(Ms)) = 0; end
                Ms_raw = Ms;
                Mm(1,:,:) = MAPS.M(ind(2)).raw;
                Mm(2,:,:) = MAPS.M(ind(3)).raw;
                Mx_raw = reshape(max(Mm),size(Mm,2),size(Mm,3));
                Mc_raw = M_raw - Mx_raw;
                Mc_raw(find(Mc_raw<=0)) = 0;
                Ms = imfilter(M_raw,h,'same'); Ms(isnan(Ms)) = 0;
                if sum(sum(Ms))~=0; Ms = Ms.*[max(max(M))/max(max(Ms))]; Ms(isnan(Ms)) = 0; end
                Mcs_raw = Ms;
                MAPS.M(cnd).map = Mc_raw;
                MAPS.M(i).contrast_raw = Mc_raw;
                cmax_raw = max(max(max(Mm))); if cmax_raw < 1; cmax_raw = 1; end
                
                
                
                % orthog
                M = [MAPS.M(ind(1)).map];
                Ms = imfilter(M,h,'same');Ms(isnan(Ms)) = 0;
                if sum(sum(Ms))~=0; Ms = Ms.*[max(max(M))/max(max(Ms))]; Ms(isnan(Ms)) = 0; end
                Mm(1,:,:) = MAPS.M(ind(2)).map;
                Mm(2,:,:) = MAPS.M(ind(3)).map;
                Mx = reshape(max(Mm),size(Mm,2),size(Mm,3));
                Mx(isnan(Mx)) = 0;
                Mc = M - Mx;
                Mc(find(Mc<=0)) = 0;
                Mcs = imfilter(Mc,h,'same');Ms(isnan(Ms)) = 0;
                if sum(sum(Ms))~=0; Ms = Ms.*[max(max(M))/max(max(Ms))]; Ms(isnan(Ms)) = 0; end
                cmax = max(max(max(Mm))); if cmax < 1; cmax = 1; end
                MAPS.M(cnd).map = M;
                MAPS.M(cnd).contrast_ortho = M;
                MAPS.type{cnd,end+1} = 'contrast';
                
                %analysis
                %analysis
                AMPS = [Ptrns(:,cnd)';max(Ptrns(:,find(cnds~=cnd))')];
                AMPS = diff(AMPS);
                CoG(i).cntrst  = feval('h_CoG',[ ] , AMPS', LOCn);
                CoD(i).cntrst = feval('h_CoD',AMPS,ORNTRNG);
                Max(i).cntrst = LOC(:,find(AMPS == max(AMPS)));
                
                
                %STATS
                Ms = imfilter(M,h,'same');
                STATS = regionprops(bwlabel(Ms), M,'all');
                RESULTS(subj).MAPS(sess).stats(i).log.cntrst = log;
                RESULTS(subj).MAPS(sess).stats(i).cog = CoG(i);
                RESULTS(subj).MAPS(sess).stats(i).cod = CoD;
                RESULTS(subj).MAPS(sess).stats(i).max = Max(i);
                RESULTS(subj).MAPS(sess).stats(i).contrast = STATS;
                assignin('base','MAPS_RESULTS',RESULTS)
                
                
                if NBS.defaults.ctrl
                    figure(f1),
                    set(gcf,'name',str{ind(1)})
                    subplot(3,4,sbplt)
                    try imagesc(Ms_raw,[0 max(max(Ms_raw))]), catch imagesc(Ms_raw,[0 1]), end,  title([str{ind(1)} '(raw)'])
                    y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                    x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                    subplot(3,4,sbplt+1)
                    imagesc(Mx_raw,[0 cmax_raw]), title(['max(' str{ind(2)}  '&' str{ind(3)} ')']),
                    y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                    x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                    subplot(3,4,sbplt+2)
                    imagesc(Mc_raw,[0 cmax_raw]), title([str{ind(1)} '(raw) - max(' str{ind(2)}  '&' str{ind(3)} ')']),
                    y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                    x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                    subplot(3,4,sbplt+3)
                    try imagesc(Mcs_raw,[0 max(max(Mcs_raw))]), catch imagesc(Mcs_raw,[0 1]), end, title('... smoothed (>0)'),
                    y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                    x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                    
                    figure(f2)
                    set(gcf,'name',[str{ind(1)} '/ortho'])
                    subplot(3,4,sbplt)
                    try imagesc(Ms,[0 max(max(Ms))]), catch imagesc(Ms, [0 1]), end,  title(['PC - ' num2str(ind(1))]),
                    y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                    x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                    subplot(3,4,sbplt+1)
                    imagesc(Mx,[0 cmax]), title(['max(PC' num2str(ind(2))  '&' num2str(ind(3)) ')']),
                    y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                    x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                    subplot(3,4,sbplt+2)
                    imagesc(Mc,[0 cmax]),title(['PC' num2str(ind(1)) ' - max(PC' num2str(ind(2))  '&' num2str(ind(3)) ')']),
                    y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                    x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                    subplot(3,4,sbplt+3)
                    try imagesc(Mcs, [0 max(max(Mcs))]), catch imagesc(Mcs, [0 1]), end,  title('... smoothed (>0)'),
                    y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                    x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                    
                    sbplt = sbplt+4;
                end
            end
            if NBS.defaults.print
                figure(f1)
                figcnt = figcnt +1;
                print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], gcf)
                close(gcf)
                figure(f2)
                figcnt = figcnt +1;
                print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], gcf)
                close(gcf)
            end
            t.contrast = toc;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % --> Ptrans = Ptrans (preprocessed AMPS)
        % --->MAPS = ??? (preprocessed MAPS)
        % use orthogonalized data/ contrasted data /or raw data
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        switch MAPS.type{end,end} %analysesdatatype
            case 'contrast'
                Ptrns = A_pastespecial(:,[1,3,5]);
                Ptrns(:,1) = Ptrns(:,1) - max(Ptrns(:,[2,3])')';
                Ptrns(:,2) = Ptrns(:,2) - max(Ptrns(:,[1,3])')';
                Ptrns(:,3) = Ptrns(:,3) - max(Ptrns(:,[1,2])')';
        end
        
        
        %%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%
        % gridfit
        %%%%%%%%%%%%%%%%%%%
        if anlyss.grdft == 1
            tic;
            for cnd = 1:size(conds,2);
                M = MAPS.M(cnd).map;
                [x y] = find(M);
                z = M(find(M))*-1;
                % [yi, xi] = size(M);
                % [xg, yg] = meshgrid(1:0.125:xi,1:0.125:yi);
                xl =  linspace(min([x;y]),max([x;y]),max(size(M)));
                %zpgd = griddata(x,y,z,xg,yg,'cubic');
                zpgf = gridfit(x,y,z,xl,xl, 'interp','triangle','smoothness',NBS.gridfit.smooth, 'overlap', 0.2, 'solver','lsqr');% 'triangle''bilinear'
                zpgf = zpgf*-1;
                %zpgi = interp2(z,xg,yg,'spline');
                
                % CoG - image
                CoG(cnd).gridfit = feval('h_CoG',zpgf);
                CoD(cnd).gridfit = feval('h_CoD',AMPS,ORNTRNG);
                if NBS.defaults.ctrl
                    fig = figure; set(gcf,'pos',get(0,'ScreenSize'))
                    subplot(2,2,1), imagesc(M), grid on, title(['signal ' num2str(cnd) ' (raw amps)']), axis tight
                    y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                    x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                    subplot(2,2,2), imagesc(zpgf), grid on, title('gridfit'), axis tight
                    y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                    x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                    text(round(CoG(cnd).gridfit(1)),round(CoG(cnd).gridfit(3)),'x [CoG]','color','w')
                    subplot(2,2,3), contour(flipud(zpgf)), grid on, title('gridfit contour and amps'), axis tight
                    y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                    x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                    subplot(2,2,4), sh = surf(fliplr(zpgf)); axis tight, grid on, title('surf gridfit');  rotate(sh,[0 0 1], 180),
                    y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                    x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                    if NBS.defaults.print
                        figcnt = figcnt +1;
                        print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig)
                        close(fig)
                    end
                end
                MAPS.M(cnd).gridfit = zpgf;
                MAPS.M(cnd).type{end+1} = 'gridfit';
            end
            t.grdft = toc;
        end
        % print(gcf, '-dps', 'results' )
        
        if anlyss.convolution == 1;
            tic;
            for cnd = 1:length(conds);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%
                % oonvolution kernel
                %%%%%%%%%%%%%%%%%%%%%%%%%5
                M = MAPS.M(cnd).map;
                C = imfilter(M,h,'same');
                %title(['PC-' num2str(cnd) ' [CoG: ' sprintf('%6.2f',[CoG(3) +
                %REF(3)]) '/' sprintf('%6.2f',[CoG(1) + REF(3)]) ']' ])
                % fig
                fig = figure; set(gcf,'pos',get(0,'ScreenSize'))
                set(gcf,'name',['corrcoef2 ' num2str(cnd)])
                subplot(2,2,1)
                imagesc(M),title(['image ' num2str(cnd)])
                y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                subplot(2,2,3)
                imagesc(h), title('kernel')
                y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                subplot(2,2,4), plot(max(h)), title('kernel plot')
                subplot(2,2,2)
                r = [size(M), size(C)];
                C = resample(resample(C,r(1),r(3))',r(2),r(4));
                C = C';
                MAPS.M(cnd).convolution = C;
                MAPS.type{cnd, end+1} = 'convolution';
                % CoG - image
                CoG(cnd).conv  = feval('h_CoG',C,[ ], LOCn');
                feval('h_CoD',AMPS,ORNTRNG);;
                imagesc(C), title('corrcoef')
                y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                text(round(CoG(cnd).conv(1)),round(CoG(cnd).conv(3)),'x [CoG]','color','w')
                subplot(2,2,4)
                contour(flipud(C));
                y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                grid on
                if NBS.defaults.print
                    figcnt = figcnt +1;
                    print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig)
                    close(fig)
                end
            end
            t.conv = toc;
        end
        
        if anlyss.deconvolution == 1;
            tic;
            for cnd = 1:length(conds);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%
                % oonvolution kernel
                %%%%%%%%%%%%%%%%%%%%%%%%%5
                M = MAPS.M(cnd).map;
                C = normxcorr2(EF,M); % THIS SHOULD BE THE ELECTRICFIELD!
                MY = fft2(M');
                MC = fft2(C',31,36);
                MCpY = (MY/MC);
                DC= ifft2(MCpY);
                % CoG - image
                CoG(cnd).deconv  = feval('h_CoG',C);
                feval('h_CoD',AMPS,ORNTRNG);;
                MAPS.M(cnd).deconvolution = C;
                MAPS.type{cnd,end+1} = 'deconvolution';
                
                fig = figure; %set(gcf,'pos',get(0,'ScreenSize'))
                set(gcf,'name',['deconvolution ' num2str(cnd)])
                subplot(2,2,1)
                imagesc(M),title(['image ' num2str(cnd)])
                y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                subplot(2,2,2)
                imagesc(h), title('kernel')
                y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                subplot(2,2,3)
                imagesc(abs(DC)), title('deconvoluted')
                y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                subplot(2,2,4)
                contour(flipud(abs(DC))); title('deconvoluted')
                y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                grid on
                if NBS.defaults.print
                    figcnt = figcnt +1;
                    print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig)
                    close(fig)
                end
            end
            t.deconv = toc;
        end
        
        %%%%%%%%%%%%%%%%%%%5
        % simR2/polyfit correlation
        %%%%%%%%%%%%%%%%%%%%%%
        if max(anlyss.sim) == 1;
            tic;
            cnt_conds = 1;
            cnt_sbplt = 1;
            f1 = figure; set(gcf,'pos',get(0,'ScreenSize'))
            h0 = waitbar(0,'Please wait (channel)...');
            pos = get(h0,'pos');
            pos(2) = pos(2)-85;
            set(h0,'pos', pos)
            for cnd = 1:length(conds);
                AMPS = Ptrns(:,cnd); %1,3,5
                M = MAPS.M(cnd).map;
                [mx my] = find(M == max(max(M)));
                
                figure(f1)
                subplot(3,4,cnt_sbplt)
                imagesc(M)
                y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                title(['max'])
                text(round(my),round(mx),'x [max]','color','w')
                ylabel(chnnls{cnd+cnd-1})
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % euclid
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                cog  = feval('h_CoG',M,AMPS,LOCn);
                feval('h_CoD',AMPS,ORNTRNG);;
                clear LOCcog
                for i=1:length(AMPS)
                    try LOCcog(i) = pdist([LOCn([1,3],i)';cog([1,3]);],'euclidean');
                    catch LOCcog(i) = dist(LOCn([1,3],i)',cog([1,3])');
                    end
                end
                Ecld = [LOCcog-max(LOCcog)]*-1;
                clear Mx
                Mx = zeros(ceil(max(Y)*scl1),ceil(max(X)*scl1)); % matrix in micrometers
                for i=1:length(AMPS)
                    Mx(round([Y(i)+1]*scl1),round([X(i)+1]*scl1))=Ecld(i);
                end
                figure(f1)
                subplot(3,4,cnt_sbplt+1)
                imagesc(Mx)
                y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                title(['CoG'])
                text(round(cog(1)),round(cog(3)),'x [CoG]','color','w')
                
                M = zeros(ceil(max(Y)*scl1),ceil(max(X)*scl1)); % matrix in micrometers
                cnt = 1;
                h1 = waitbar(0,'Please wait (row)...');
                pos = get(h0,'pos');
                pos(2) = pos(2)-85;
                set(h1,'position',pos)
                h2 = waitbar(0,'Please wait (column)...');
                pos = get(h1,'pos');
                pos(2) = pos(2)-85;
                set(h2,'position',pos)
                
                % euclid distance calculation
                tic;
                clear Ecld pAMPS
                Ecld_radius = pdist([[1,1];size(M)]);
                Ecld_y = zeros(round(Ecld_radius*scl2),1);
                ymin = find(Y==min(Y)); xmax = find(X==min(X));
                pAMPS = zeros(size(M,1)*size(M,2),fix(pdist([1,1;max(Y), max(X)],'euclidean')));
                waitbar(cnd/length(conds),h0)
                for i=1:size(M,1)
                    waitbar(i/size(M,1),h1)
                    for ii=1:size(M,2)
                        waitbar(ii/size(M,2),h2)
                        for iii=1:length(AMPS)
                            try Ecld(iii)= pdist([[i,ii];[round(Y(iii)*scl1),round(X(iii)*scl1)]],'euclidean');
                            catch Ecld(iii)= dist([i,ii],[round(Y(iii)*scl1),round(X(iii)*scl1)]');
                            end
                        end
                        Ecld_i = round(Ecld*scl2)+1; % distance zwischen punkt 1 und punkt selbs = 0 daher +1;
                        pAMPS(cnt, Ecld_i) = AMPS;
                        cnt = cnt+1;
                    end
                end
                try close(h1), end
                try close(h2), end
                t.eucliddist = toc;
                clear  B P
                cnt = 0;
                switch fittype
                    case 'linear'
                        %% linearfit
                        pX = zeros(size(pAMPS,2),1);
                        tmp = sort([1:1: NBS.hotspotradius*scl2]*-1)*-1;
                        pX(1:length(tmp)) =  tmp;
                        pX = pX*[max(max(pAMPS))/max(pX)];
                    case 'amp derived'
                        %% AMP derived predictor
                        pX = sort(sort(AMPS)*-1)*-1;
                        pX = resample(pX, size(pAMPS,2),length(pX));
                        % pX = smooth(pX,10*scl2); % 10 mm
                        [l_zwi_, S, MU]=polyfit(1:length(pX),pX', 3);
                        pX = polyval(l_zwi_,1:length(pX), [ ], MU);
                    case 'log'
                        hsize = [1 size(pAMPS,2)*2];
                        sgm = NBS.sgm*scl2;
                        h = fspecial('log',hsize,abs(sgm));
                        h = h*-1;
                        pX = h(size(pAMPS,2)+1:end);
                        if min(pX) < 0; pX = pX + abs(min(pX)); end
                        pX = pX*[max(max(pAMPS))/max(pX)];
                end
                if NBS.defaults.print && NBS.defaults.ctrl && cnd;
                    fig = figure; set(gcf,'pos',get(0,'ScreenSize'))
                    plot(pX), grid on
                    figcnt = figcnt +1;
                    print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)],f1)
                    close(gcf)
                end
                
                
                % polyfit
                tic;
                if size(pX,2)< size(pX,1); pX = pX'; end
                if NBS.polyctrl, f2 = figure; set(f2,'pos',pos), end
                for i=1:size(M,1);
                    for ii=1:size(M,2);
                        cnt = cnt + 1;
                        pY = pAMPS(cnt,:);
                        pY(find(pY<0)) = 0;
                        % b = robustfit(pX',pY');
                        % b = robustfit([1:length(AMPS)]',pY');
                        % [b,BINT,R] = regress([1:length(AMPS)]',pY');
                        % [p,S,MU] = polyfit(pX,smooth(pY,10*scl2),1);
                        % [p,S,MU] = polyfit(pX,pY,1);
                        % f = polyval(p,pX,MU);
                        % sse = sum(f-pX);
                        
                        [R,P,RLO,RUP]=corrcoef(pX',pY');
                        
                        % b(1) or p(1)
                        M(i,ii) = R(2); % with or without sse??
                        SSE(i,ii) = P(2);
                        if NBS.polyctrl
                            h_hld off
                            figure(f2)
                            plot(pX)
                            ylim([min(pX) max(pX)+max(pX)/20])
                            hold on
                            plot(pY,'r')
                            text(round(max(pX)/2), round(length(pY)/2),['R(' sprintf('%5.2f',R(2)), ') -- p('  sprintf('%5.2f',P(2)) ')'])
                            legend({'Distribution model','MEPs/euclid distance'})
                            pause(1)
                        end
                    end
                end
                t.polyfit = toc;
                %%%%%%
                %                 NBS.DATA(subj).RESULTS(sess).MAPS(cnd) = MAPS(cnd).M;
                %                 NBS.DATA(subj).ANALYSES(sess).DIST(cond).pAMPS = pAMPS;
                %                 NBS.DATA(subj).ANALYSES(sess).DIST(cond).pX = pAMPS;
                MLR.M{cnd} = zeros(ceil(max(Y)*scl1),ceil(max(X)*scl1)); %matrix size
                MLR.pX{cnd}= pX; % predictor
                MLR.pAMPS{cnd}= pAMPS; % polyfit to data
                MLR.SSE{cnd} = SSE;
                %%%%%%
                % CoG - image
                CoG(cnd).plyft  = feval('h_CoG',M);
                feval('h_CoD',AMPS,ORNTRNG);;
                
                figure(f1)
                subplot(3,4,cnt_sbplt+2),
                imagesc(M)
                y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
                x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
                [mr mc] = find(M==max(max(M)));
                title(['Plyft (corrcoef)']);
                text(round(CoG(cnd).plyft(1)),round(CoG(cnd).plyft(3)),'x [CoG]','color','w')
                ylabel(num2str(mean(mr))),
                xlabel(num2str(mean(mc)))
                cnt_sbplt = cnt_sbplt+4;
                cnt_conds = cnt_conds+1;
                waitbar(h1)
            end
            if NBS.defaults.print
                figcnt = figcnt +1;
                print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)],f1)
            end
            t.sim = toc;
            try close(h0),end
            assignin('base',['MLR_' num2str(sess)],MLR)
        end
        
        
        
        if  anlyss.glm == 1;
            %%%%%%%%%%%%%%%%%%%%
            % multiple regression
            %%%%%%%%%%%%%%%%%%%%%
            X = cat(1,MLR.pX{:}); % make a mean of the three predictors (prestd?)
            pX = mean(X,1);
            if size(pX,1)<size(pX,2); pX = pX'; end
            Y = cat(1,MLR.pAMPS{:}); % MEP with respects to distance from CoG
            warning off
            for i=1:size(Y,1)/3
                pY = Y([i,size(Y,1)/3+i,(size(Y,1)/3*2)+i],:)';
                pY(find(pY<0))=0;
                pY = [pY,ones(length(pX),1)];
                pX = pX * max(max(pY))/max(pX);
                [b,bint,r,rint,stats] = regress(pX,pY);
                %[b,stats] = robustfit(pX,pY)
                %disp(['acounts for ' num2str(stats(1)*100) '% of the variance'])
                B(:,i)=b(1:3);
            end
            warning on
            dim = size(M);
            clear Mglm
            Mglm{1} = zeros(dim(1),dim(2));
            Mglm{2} = zeros(dim(1),dim(2));
            Mglm{3} = zeros(dim(1),dim(2));
            cnt = 0;
            for i=1:size(Mglm{1},1);
                for ii=1:size(Mglm{1},2);
                    cnt = cnt + 1;
                    Mglm{1}(i,ii) = B(1,cnt);
                    Mglm{2}(i,ii) = B(2,cnt);
                    Mglm{3}(i,ii) = B(3,cnt);
                end
            end
            % CoG
            for id = 1:3
                CoG(id).MLR  = feval('h_CoG',Mglm{id});
                CoD(id).MLR = feval('h_CoD',AMPS,ORNTRNG);
            end
            % smooth?
            if  MLRsmooth == 1;
                for imglm=1:length(Mglm)
                    Mglm{imglm} = imfilter(Mglm{imglm},h,'same');
                end
            end
            figure(f1)
            subplot(3,4,4)
            imagesc(Mglm{1})
            y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
            x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
            title('MLR (multiregr)')
            text(round(CoG(1).MLR(1)),round(CoG(1).MLR(3)),'x [CoG]','color','w')
            subplot(3,4,8)
            imagesc(Mglm{2}),
            y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
            x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
            title('MLR (multiregr)')
            text(round(CoG(2).MLR(1)),round(CoG(2).MLR(3)),'x [CoG]','color','w')
            subplot(3,4,12)
            imagesc(Mglm{3}),
            y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
            x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
            title('MLR (multiregr)')
            text(round(CoG(3).MLR(1)),round(CoG(3).MLR(3)),'x [CoG]','color','w')
            if NBS.defaults.print && cnd
                figcnt = figcnt +1;
                print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], f1)
                %close(f1)
            end
        end
        try
            NBS.DATA(subj).ANALYSES(sess).MAPS.MLR = MLR;
            MAPS.MLR{sess} = MLR;
        end
        
        NBS.DATA(subj).ANALYSES(sess).CoGs = CoG; NBS.CoGs{sess} = CoG;
        disp(['... finished # ' num2str(sess)])
    end
    try close(fig_hdr), end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%
    go = 0;
    if go == 1
        clear M m
        names = {'raw','ortho','conv','plyft','MLR'};
        sesss = size(A1,1);
        cnds = 3;
        cnt = 1;
        for sess = 1:sesss
            for cnd = 1:cnds
                REF = NBS.CoGs{sess}(cnd).REF;
                raw = round(NBS.CoGs{sess}(cnd).raw+REF);
                try ortho = round(NBS.CoGs{sess}(cnd).ortho+REF); catch ortho = [NaN NaN NaN]; end
                try conv = round(NBS.CoGs{sess}(cnd).conv+REF); catch conv = [NaN NaN NaN]; end
                try plyft = round(NBS.CoGs{sess}(cnd).plyft+REF); catch plyft = [NaN NaN NaN]; end
                try MLR = round(NBS.CoGs{sess}(cnd).MLR+REF); catch MLR = [NaN NaN NaN]; end
                m(:,1) = raw;
                m(:,2) = ortho;
                m(:,3) = conv;
                m(:,4) = plyft;
                m(:,5) = MLR;
                M{cnt} = m;
                cnt = cnt +1;
            end
        end
        % M
        f2 = figure; set(gcf,'pos',get(0,'ScreenSize'))
        symb = {'b<','b^','b>'};
        for cnd = 1:cnds
            conds =  cat(1,M{cnd:cnds:sesss*cnds});
            %conds1 =  cat(1,M{1:1:27}); % all condsitions all sessions
            condsx = conds(1:cnds:cnds*sesss,:);
            condsy = conds(cnds:cnds:cnds*sesss,:);
            condsx(isnan(condsx)) = 0;
            condsy(isnan(condsy)) = 0;
            
            f3 = figure; % set(f3,'pos',pos)
            subplot(2,2,1)
            imagesc(condsy), colorbar
            title(['condsition ' num2str(cnd) ': y values'])
            set(gca,'xtick',[1:5], 'xticklabel',names)
            ylabel('sessions')
            grid on
            subplot(2,2,2)
            imagesc(condsx), colorbar
            title(['condsition ' num2str(cnd) ' x values'])
            set(gca,'xtick',[1:5], 'xticklabel',names)
            ylabel('sessions')
            grid on
            subplot(2,2,3:4)
            plot(condsy,condsx,'x')
            y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
            x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
            grid on
            legend(names,'Location','bestoutside')
            ylabel('AP[mm]')
            xlabel('LR[mm]')
            if NBS.defaults.print
                figcnt = figcnt +1;
                print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], f3)
                close(f3)
            end
            figure(f2)
            tmp = find(sum(condsx)>0);
            condsx = condsx(:,tmp)+REF(1);
            condsy = condsy(:,tmp)+REF(3);
            
            se = std(condsx)./sqrt(sum(diff(A1')+1));
            % se = std(condsx)./sqrt(size(condsx,1));
            cstr = {'r','m','g','c'};
            if sum(diff([mean(condsy); mean(condsx)]'))<0.001;
                condsy(:,1) = condsy(:,1)+0.01;  condsx(:,1) = condsx(:,1)+0.001;
            end
            errorbar(mean(condsy),mean(condsx),se, symb{cnd});
            for ic=1:size(condsx,2)
                text(mean(condsy(:,ic)),mean(condsx(:,ic)),names{ic},'color',cstr{ic},'HorizontalAlignment','left')
            end
            hold on
        end
        figure(f2)
        title('mean over sessions/ finger:raw vs. orth')
        legend({'APB','FDI','ADM'},'Location','BestOutside')
        %     for i=1:cnds
        %         conds =  cat(1,M{i:cnds:sesss*cnds});
        %         %conds1 =  cat(1,M{1:1:27}); % all condsitions all sessions
        %         condsx = conds(1:cnds:cnds*sesss,:);
        %         condsy = conds(cnds:cnds:cnds*sesss,:);
        %         condsx(isnan(condsx)) = 0;
        %         condsy(isnan(condsy)) = 0;
        %         fnplt(rsmak('circle',std(condsy(:,1))/sesss, [mean(condsy(:,1)),mean(condsx(:,1))]),'k')
        %         fnplt(rsmak('circle',std(condsy(:,2))/sesss, [mean(condsy(:,2)),mean(condsx(:,2))]),'b')
        %         %fnplt(rsmak('circle',std(condsy(:,3))/sesss, [mean(condsy(:,3)),mean(condsx(:,3))]),'r')
        %         %fnplt(rsmak('circle',std(condsy(:,4))/sesss, [mean(condsy(:,4)),mean(condsx(:,4))]),'g')
        %           .... or line
        %         for ipt = 1:size(condsx,2)
        %         Pt = mean(condsx(:,ipt));
        %         mC = mean(condsy(:,ipt));
        %         sC = std(condsy(:,ipt))/sqrt(length(condsy(:,ipt)));
        %         vb = [mC-sC:mC+sC]; xy = Pt; line(vb, ones(1,length(vb))*xy,'color','c')
        %         end
        %     end
        
        grid on
        
        %     prompt={'ylim:','xlim:'};
        %     name='Input for Image Print';
        %     numlines=1;
        %     defaultanswer={num2str(ylim),num2str(xlim)};
        %     answer=inputdlg(prompt,name,numlines,defaultanswer);
        %     eval(['ylim([' answer{1} '])'])
        %     eval(['xlim([' answer{2} '])'])
        y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
        x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
        if NBS.defaults.print
            figcnt = figcnt +1;
            print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], f2)
        end
    end
end

try assignin('base','MAPS',MAPS), catch disp('no MAPS to base'), end
assignin('base','NBS',NBS)
h = msgbox('done!');pause(2); try close(h), end


%%%% hang stuff on
try
    set(handles.popupmenu4,'val',5)
    feval('popupmenu4_Callback',handles.popupmenu4,1,handles);
catch
    set(handles.popupmenu4,'val',5)
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% dgrss = feval('r_drctnsx',DIR);

prompt = {'Enter MIN. deg to be shown';'Enter MAX. deg to be shown'};
degshow = inputdlg(prompt,'set deg');
degshow = str2num(char(degshow));
seq_s = 202;
seq_e = 281;
%START (seq_s) UND ENDE (seq_e) DER SEQUENCE FESTLEGEN:
dir_s = ['S',num2str(seq_s),':']; %% x-Achse, Begrenzung der Matrix innerhalb der Excel Tabelle
dir_e = ['U',num2str(seq_e)]; % z-Achse, Begrenzung der Matrix innerhalb der Excel Tabelle
m = horzcat(dir_s,dir_e);
str = get(handles.popupmenu1,'str');
val = get(handles.popupmenu1,'val');

dir = xlsread(str{val},m);

x = dir(:,1);
y = dir(:,2);
hyp = sqrt((x.^2)+(y.^2));
deg180 = y<0 & x<0; %Filtern nach Koordinaten, die nicht im I. Quadranten liegen
deg270 = y<0 & x>0; %Filtern nach Koordinaten, die nicht im I. Quadranten liegen
deg90 = y>0 & x<0; %Filtern nach Koordinaten, die nicht im I. Quadranten liegen
y(find(y<0),1) = y(find(y<0),1)*(-1);
deg = asind(y./hyp); %Vektor im I. Quadranten bestimmen lassen
deg((find(deg180)),1) = deg((find(deg180)),1) + 180;
deg((find(deg270)),1) = deg((find(deg270)),1) + 270;
deg((find(deg90)),1) = deg((find(deg90)),1) + 90;

degfin = (((deg >= degshow(1,1)) .* (deg <= degshow(2,1)))) .* deg; %sucht die deg, die zwischen min deg und max deg liegen

%DIR.deg=deg ???

%Hinzufügen der z-angulation
z = dir(:,3);
tilt = ones(size(deg,1),1)*90;
tilt = tilt.*z;

%%Matrix der Locations
loc_s = ['M',num2str(seq_s),':']; %% x-Achse, Begrenzung der Matrix innerhalb der Excel Tabelle
loc_e = ['O',num2str(seq_e)]; % z-Achse, Begrenzung der Matrix innerhalb der Excel Tabelle
m = horzcat(loc_s,loc_e);
loc = xlsread(str{val},m);

%AMPLITUDE
ch = ['AA';'AC';'AE';'AG';'AI';'AK'];
cnt = 1;
for(cnt = 1:1:length(ch))
    amp_s(cnt,:) = [ch(cnt,:),num2str(seq_s),':']; %% x-Achse, Begrenzung der Matrix innerhalb der Excel Tabelle
    amp_e(cnt,:) = [ch(cnt,:),num2str(seq_e)];
    cnt = cnt+1;
end
amp = horzcat(amp_s,amp_e); %amp enthält die excel koordinaten für alle eingebenen kanäle zeilenweise

%%% Generierung der Matrizen mit Koordinaten und Amplituden %%%
x = loc(:,1);
y = loc(:,2);
z = loc(:,3);
chs = inputdlg('Please enter channel no. to be analysed (e.g. 1,2,5)');
for i = 1:2:length(chs)
    ch = amp((str2num(char(chs(1,i)))),:);
end
co = [x,y] .* [degfin > 0, degfin > 0];
co = [(co((find(co(:,1) > 0)),1)).*10,(co((find(co(:,1) > 0)),2)).*10]; %bestimmt alle Koordinaten, die innerhalb von deg liegen und >0 und ~= NaN sind
im = zeros((ceil(max(x))-round(min(x))).*10,(ceil(max(y))-round(min(y))).*10);
co(:,1) = co(:,1) - min(co(:,1))+1; %Anpassung der x-Koordinaten zur Darstellung
co(:,2) = co(:,2) - min(co(:,2))+1; %Anpassung der y-Koordinaten zur Darstellung
for n = 1:1:(size(ch,1))
    amps(:,n) = xlsread(str{val},ch(n,:));
end
amps = amps(find(degfin > 0),:);
cnt = 1;
for cnt = 1:1:length(amps)
    im(co(cnt,1),co(cnt,2)) = sum(amps(cnt,:));
end;
assignin('base','deg_image',im);

% smoothing der image matrix
x = 1;
cycles =inputdlg('Please enter the number of desired smoothing cycles');
cycles = str2num(char(cycles));
while x ~= cycles
    for cnt = 1:1:max(size(im,1))
        im(cnt,:) = smooth(im(cnt,:));
    end
    cnt = 1;
    for cnt = 1:1:max(size(im,2))
        im(:,cnt) = smooth(im(:,cnt));
    end
    x = x+1;
end
assignin('base','deg_image_smooth',im)
figure, imagesc(im)


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NBS = evalin('base','NBS');
%cd(NBS.PATHNAME{get(handles.popupmenu1,'val')})
PRMS = NBS.CONFIG(1).PARAMS{1};
eval(PRMS{strmatch('scl1', strvcat(PRMS))});%    scl1 = 1;  %mm*scl11 e.g. 10.12 mm is rounded to 10, if scl1 = 10, then works withs 101
eval(PRMS{strmatch('scl2', strvcat(PRMS))}); %     scl2 = 1; %mm*scl2 for fitting over euclidean distance from CoG
eval(PRMS{strmatch('A1',   strvcat(PRMS))});
eval(PRMS{strmatch('conds', strvcat(PRMS))});
eval(PRMS{strmatch('sigma', strvcat(PRMS))});
eval(PRMS{strmatch('radius', strvcat(PRMS))});
eval(PRMS{strmatch('chnnls', strvcat(PRMS))}); %chnnls = {'APB','LATapb','FDI','LATfdi','ADM','LATadm'};
eval(PRMS{strmatch('sheetname', strvcat(PRMS))}); %sheetname = 'NBS';
NBS.hotspotradius = radius; % mm / for euclidean and MLR (linear or log (sgm) fit)
NBS.sgm = sigma;


% scatter, orthog, contrast
scl1 = 1;  %mm*scl11 e.g. 10.12 mm is rounded to 10, if scl1 = 10, then works withs 101
% analyses
scl2 = 1; %mm*scl2 for fitting over euclidean distance from CoG
eval(PRMS{strmatch('sgm', strvcat(PRMS))});
NBS.sgm = sgm;
NBS.gridfit.smooth = 0;
goortho = 0;
%yl =[20,60];
%xl =[1 35];
conds = [1 3 5];
chnnls = {'APB','LATapb','FDI','LATfdi','ADM','LATadm'};

filenames = get(handles.popupmenu1,'str');

subj = get(handles.popupmenu1,'val');
[tmp,filename, ext] = fileparts(filenames{subj});
filename = [filename,ext];
sheetname = 'NBS';
cnt = 1;
for sess = 1:size(A1,1);
    disp(['... reading worksheet: ' sheetname '(' filenames{subj} ') --> [' ['AA' num2str(A1(sess,1)) ':AF' num2str(A1(sess,2))] ']' ])
    A_pastespecial{sess} = NBS.DATA(subj).RAW(sess).AMPS; %xlsread(filenames{subj}, sheetname,['AG' num2str(A1(sess,1)) ':AL' num2str(A1(sess,2))]);
    [A_thresh] = A_pastespecial{sess}(:,conds);
    A_thresh(A_thresh<50) = 0;
    A_pastespecial{sess}(:,conds) = A_thresh;
    if isempty(A_pastespecial{sess}); errordlg('could not import MEPs (empty), return ...'), return, end
    if ~any(A_pastespecial{sess}); errordlg(['no MEPs in session ' num2str(sess) '(' ['AA' num2str(A1(sess,1)) ':AF' num2str(A1(sess,2))] ') trip catch ...']), tripcatch = 'go'; end
    if size(A_pastespecial{sess},2)~=6; A_pastespecial{sess} = A_pastespecial{sess}'; end
    % Physical Parameters
    LOC{sess} = NBS.DATA(subj).RAW(sess).PP.data(:,10:12); %xlsread(filenames{subj}, sheetname,['V' num2str(A1(sess,1)) ':X' num2str(A1(sess,2))]);
    ORNTRNG = NBS.DATA(subj).RAW(sess).PP.data(:,7:9);
    if size(LOC{sess},1)~=3; LOC{sess} = LOC{sess}'; end
    tmp = mean(LOC{sess}([1,3],:));
    % Outliers
    %     outlrs = find(tmp > mean(tmp)+3*std(tmp) | tmp < mean(tmp)-3*std(tmp));
    %     inlrs = ones(1,length(tmp)); inlrs(outlrs) = 0; inlrs = find(inlrs);
    %     if isempty(outlrs) ~= 1;
    %         fig = figure;
    %         plot(tmp),hold on, plot(outlrs, tmp(outlrs),'r*')
    %         title(['outlier(s > 3 std found - removing ' num2str(length(outlrs)) ' LOCATION(S) ...'])
    %         drawnow, pause(1)
    %         A_pastespecial{sess} = (A_pastespecial{sess}(inlrs,:));
    %         LOC{sess} = LOC{sess}(:,inlrs);
    %         pause(2)
    %         try close(fig), end
    %     end
end
% a little bit of preprocessing of AMPS
% percentualize
for sess = 1:size(LOC{sess},1)
    for i = [1,3,5]
        if find(A_pastespecial{sess}(:,i))
            A_pastespecial{sess}(:,i) = A_pastespecial{sess}(:,i)/max(A_pastespecial{sess}(:,i));
        end
    end
end
% orthogonolaize
if goortho == 1;
    disp('... orthogonalization!')
    AMPS_temp = A_pastespecial;
    try
        for i=1:length(A_pastespecial)
            A_pastespecial{i} = mgrscho(A_pastespecial{i});
        end
    catch
        [Z,MU,sgm] = ZSCORE(A_pastespecial{sess}(:,conds));
        [COEFF, SCORE, LATENT] = princomp(Z);
        for iz=1:size(SCORE,2);
            SCORE(:,iz) = (SCORE(:,iz)+MU(iz))./sgm(iz);
        end
        A_pastespecial{sess}(:,conds)= SCORE;
    end
    % not necessarily necessary
    %     AMPs_raw = cat(1,AMPS_temp{:});
    %     R = corrcoef([AMPs;AMPs_raw]);
    %     str = {'APB','FDI','ADM','O1','O2','O3'};
    %     figure, imagesc(R), colorbar, set(gca, 'yticklabel',str, 'xticklabel', str)
end
% concatenate LOCS and AMPS
LOCs = cat(2,LOC{:})';
AMPs = cat(1,A_pastespecial{:});
if ~any(mean(LOCs,2)==0)~=1,
    ind = find(mean(LOCs,2)>0);
    LOCs = LOCs(ind,:);
    AMPs = AMPs(ind,:);
end
REF = min(LOCs);
% bug, es gibt ein zero wert
LOCn(:,1) = LOCs(:,1)-REF(1);
LOCn(:,2) = LOCs(:,2)-REF(2);
LOCn(:,3) = LOCs(:,3)-REF(3);
X = LOCn(:,1);
Y = LOCn(:,3);
Z = LOCn(:,2);
% make maps and display figures
clear LOCn Ms LA Ecld CoG
fig1 = figure; set(gcf,'pos',get(0,'ScreenSize'))
for cnd = conds;
    AMPS = AMPs(:,cnd); %1,3,5
    clear M
    M = zeros(ceil(max(Y)*scl1),ceil(max(X)*scl1)); % matrix in micrometers
    for i=1:length(AMPS)
        M(round([Y(i)+1]*scl1),round([X(i)+1]*scl1))=AMPS(i);
    end
    if ~any(M), M(1,1) = -100; end
    h = fspecial('log',[NBS.hotspotradius*scl1 NBS.hotspotradius*scl1],NBS.sgm*scl1)*-1000000;
    Ms = imfilter(M,h,'same');
    Ms = Ms.*[max(max(M))/max(max(Ms))];
    
    xax(1) = [[[X(1)+1]*scl1]+ REF(1)]/[[X(1)+1]*scl1];
    xax(2) = xax(1)+size(Ms,2);
    xax = [xax(1):diff(xax)/2:xax(2)];
    yax(1) = [[[Y(1)+1]*scl1]+ REF(3)]/[[Y(i)+1]*scl1];
    yax(2) = yax(1)+size(Ms,1);
    yax = [yax(1):diff(yax)/2:yax(2)];
    for i=1:3
        xax_str{i} = num2str(round(xax(i)));
        yax_str{i} = num2str(round(yax(i)));
    end
    
    figure
    set(gcf,'name',['condition ' chnnls{cnd}])
    subplot(2,2,2)
    imagesc(M)
    try ylim(yl), xlim(xl), end
    set(gca,'xtick',1:size(M,2)/3:size(M,2),'xticklabel',xax_str);
    %     set(gca,'ytick',1:size(M,2)/3:size(M,2),'yticklabel',yax_str);
    title('MEPs')
    colorbar
    subplot(2,2,1)
    scatter(X,Y,200,AMPS/1000,'filled');
    xlabel('LR[mm]');
    ylabel('AP[mm]');
    title([ chnnls{cnd} ': scatter plot'])
    grid on
    %colorbar
    subplot(2,2,3)
    imagesc(Ms)
    try ylim(yl), xlim(xl), end
    %     set(gca,'xtick',1:size(M,2)/3:size(M,2),'xticklabel',xax_str);
    %     set(gca,'ytick',1:size(M,2)/3:size(M,2),'yticklabel',yax_str);
    title('smoothed MEPs')
    subplot(2,2,4)
    try ylim(yl), xlim(xl), end
    %     set(gca,'xtick',1:size(M,2)/3:size(M,2),'xticklabel',xax_str);
    %     set(gca,'ytick',1:size(M,2)/3:size(M,2),'yticklabel',yax_str);
    title('contour')
    try contour(flipud(Ms([yl(1):yl(2)],[xl(1):xl(2)])),20),
    catch contour(flipud(Ms),20),
    end
    grid on
    figure(fig1);
    subplot(2,2,1:2)
    try contour(flipud(Ms([yl(1):yl(2)],[xl(1):xl(2)])),20),
    catch contour(flipud(Ms),20),
    end
    hold on
    try MS{cnd} = Ms([yl(1):yl(2)],[xl(1):xl(2)]);
    catch MS{cnd} = Ms;
    end
    try MR{cnd} = M([yl(1):yl(2)],[xl(1):xl(2)]);
    catch MR{cnd} = M;
    end
end
try
    for i=1:length(conds); Mz(i,:,:) = zscore(MR{conds(i)}); end
catch
    for i=1:length(conds); Mz(i,:,:) = prestd(MR{conds(i)}); end
end
for imz = 1:size(Mz,1)
    tmp = reshape(Mz(imz,:,:),size(Mz,2),size(Mz,3));
    Mz(i,:,:) = imfilter(tmp,h,'same');
end

figure(fig1)
subplot(2,2,3)
imagesc(rot90(fliplr(reshape(mean(Mz,1),size(Mz,2),size(Mz,3)))))
colorbar
title('mean of all maps')
subplot(2,2,4)
imagesc(rot90(fliplr(reshape(max(Mz),size(Mz,2),size(Mz,3)))))
colorbar
title('max of all maps')
subplot(2,2,1:2)
grid on

% --------------------------------------------------------------------
function MenuBar_File_Callback(hObject, eventdata, handles)
% hObject    handle to MenuBar_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MenuBar_File_Open_Callback(hObject, eventdata, handles)
% hObject    handle to MenuBar_File_Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ext = get(handles.fileextension,'label');
try COMPARE = evalin('base','COMPARE'); end
[filename, pathname] = uigetfile(['*' ext], 'Pick an nbs-file');
try
    cd(pathname);
    set(handles.resultsdirectory,'str',pathname)
catch, return;
end
if filename == 0
    return;
end
try COMPARE.path_file(end+1,1:2) = {pathname, filename};
catch COMPARE.path_file(1,1:2) = {pathname, filename}; %#ok<CTCH>
end
set(handles.popupmenuSearchResults,'str',COMPARE.path_file(:,2));
assignin('base','COMPARE',COMPARE);


% --- Executes on selection change in popupmenuSearchResults.
function popupmenuSearchResults_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuSearchResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenuSearchResults contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuSearchResults

try
    val = get(gcbo,'val');
    str = ['File (' num2str(val) '/' num2str(length(get(gcbo,'str'))) ')'];
    set(handles.uipanelFiles,'title',str)
end

try
    GUI = evalin('base','NBS.GUI');
    val = get(handles.popupmenuSearchResults,'val');
    showstr = GUI(1,val).sequences;
end

%filter tag
tag_val = get(handles.editsearch,'val');
tagstr = get(handles.editsearch,'str');
tagstr = char(tagstr(tag_val,1));
seperator = strfind(tagstr,' ');
if isempty(seperator) == 1
    tags = {tagstr};
else
    for i = 1:1:(size(seperator,2) + 1)
        if i == 1
            tags{i,1} = tagstr(1,1:(seperator(1,i)-1));
        elseif i ~= 1 && i ~= (size(seperator,2) + 1)
            tags{i,1} = tagstr(1,(seperator(1,i-1)+1):(seperator(1,i)-1));
        elseif i ~= 1 && i == (size(seperator,2) + 1)
            tags{i,1} = tagstr(1,(seperator(1,i-1)+1):end);
        end
    end
end

if isempty(strfind(tagstr(1,:),'tags')) == 0 && size(tags,1) == 1
    tags = {' '};
elseif isempty(strfind(tagstr(1,:),'all')) == 0 && size(tags,1) == 1
    tags = {' '};
end

%%%%%%%
%SEARCH DESCRIPTION FOR MATCHES
%%%%%%%
try curr_descr = lower(showstr);
catch curr_descr = [ ];
end

if size(curr_descr,1) == 0
    showstr = {'no matches...'};
    set(handles.showseq,'str',showstr,'val',1);
    return;
end

for x = 1:1:size(tags,1)
    for j = 1:1:size(curr_descr,1)
        found = strfind(curr_descr(j,:),char(tags(x,1)));
        skip = 0;
        if strmatch(char(tags(x,1)),'dh') == 1
            skp = strfind(curr_descr(j,:),'ndh');
            if isempty(cell2mat(skp)) == 0
                skip = 1;
            end
        end
        if isempty(cell2mat(found)) == 0 && skip == 0
            row_match(j,x) = 1;
        else
            row_match(j,x) = 0;
        end
    end
end
for u = 1:1:size(row_match,1)
    if sum(row_match(u,:)) == size(row_match,2)
        indx(u) = 1;
    else
        indx(u) = 0;
    end
end
showstr = showstr(find(indx == 1),:);
if sum(row_match) == 0
    showstr = {'no matches...'};
end


%%set display
set(handles.showseq,'str',showstr,'val',1);
feval('showseq_Callback',handles.showseq,eventdata,handles)


% --- Executes during object creation, after setting all properties.
function popupmenuSearchResults_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuSearchResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editsearch_Callback(hObject, eventdata, handles)
% hObject    handle to editsearch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editsearch as text
%        str2double(get(hObject,'String')) returns contents of editsearch as a double


feval('popupmenuSearchResults_Callback',handles.popupmenuSearchResults,eventdata,handles);




% --- Executes during object creation, after setting all properties.
function editsearch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editsearch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonSearch.
function pushbuttonSearch_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSearch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

xls = evalin('base', 'xls');
searchStrings = get(handles.editsearch, 'String');
% separate search strings
switch searchStrings
    case 'all'
        for i=1:length(xls)
            str{i} = xls{i}.name;
        end
    otherwise
        p = '\S*';
        searchStrings = regexp(searchStrings, p, 'match');
        [dummy numOfSearch] = size(searchStrings);
        resultFiles = [];
        [dummy numOfItems] = size(xls);
        doBreak = false;
        progress = waitbar(0, 'please wait...');
        for i = 1:numOfItems
            item = xls{1, i};
            [rows cols] = size(item.textdata);
            for row = 1:rows
                if doBreak
                    doBreak = false;
                    break;
                end
                for col = 1:cols
                    if doBreak
                        break;
                    end
                    cell = item.textdata{row, col};
                    for s = 1:numOfSearch
                        if doBreak
                            break;
                        end
                        if strfind(cell, searchStrings{s}) > 0
                            resultFiles{end + 1} = item.name;
                            doBreak = true;
                            break;
                        end
                    end
                end
            end
            waitbar(i / numOfItems, progress);
        end
        close(progress);
        %assignin('base', 'resultFiles', resultFiles);
        
        [dummy numOfResults] = size(resultFiles);
        str = [];
        for l = 1:numOfResults
            str{end + 1} = resultFiles{1, l};
        end
end
set(handles.popupmenuSearchResults, 'String', str);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over editsearch.
function editsearch_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to editsearch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

MNMZ;
NBS = CREATE4D('mean');
ARR = CMPL4D(NBS);

helpdlg('Subject successfully added...');

assignin('base','NBS',NBS);

feval('evaltype_Callback',handles.evaltype,0,handles);

% % params
% PRM = get(handles.listbox1,'str');
% ind = strmatch('A1', strvcat(PRM));
% eval(PRM{ind});
% INDX = A1;
% ch.ch13 = 'AG-AL';
% ch.ch46 = 'AA-AF';
% % file
% filenames = get(handles.popupmenu1,'str');
% val = get(handles.popupmenu1,'val');
% filename = filenames{val};
% sheetname = 'NBS';
% clear Ap1 Ap2
% chnnls = [1 3 5];
% chnnl = chnnls(2);
%
% for i=1:size(INDX,1)
%     disp(i)
%     ind = [INDX(i,:)];
%     disp(ind)
%     VAR = xlsread(filename, sheetname,['AA' num2str(ind(1)) ':AL' num2str(ind(2))]);
%     if mean(VAR(:,3)) > mean(VAR(:,9));
%         disp('... dominant')
%         A(:,i) = VAR(:,chnnl);
%     else
%         disp('... non-dominant')
%         A(:,i) = VAR(:,chnnl+6);
%     end
% end
% for i=1:size(A,2)
%     for ii=1:size(A,1)
%         A_cm(ii,i) = mean(A(1:ii,i));
%     end
% end
%
% for i=1:size(A,2)
%     cnt = 1;
%     for ii=21:size(A,1)
%         A_cm20(cnt,i) = mean(A(1:ii,i));
%         cnt = cnt+1;
%     end
%     str{i} = [' timecourse: ' num2str(i)];
% end
%
% % repeatability
% clear ind
% for i=1:size(A,2)
%     m(i) = mean(A_cm20(:,i));
%     s(i) = std(A_cm20(:,i));
%     ind{i} = find(abs(diff(A_cm(1:end,i)))<2*s(i));
%     indx(i) = ind{i}(1);
% end
%
% figure, plot(A_cm./1000,'-*')
% ylabel('[mV]')
% legend(str)
% hold on
% for i=1:length(ind)
%     plot(ind{i},A_cm(ind{i},i)./1000,'.r')
%     plot(indx(i),A_cm(indx(i),i)./1000,'Or')
% end
% xlabel(['mean realible cuttoff sample: ' num2str(floor(mean(indx)))])
%
% [H,P] = ttest(A_cm(1:end,1),A_cm(1:end,2));
% [Hc,Pc] = ttest(A_cm(floor(mean(indx)):end,1),A_cm(floor(mean(indx)):end,2));
%
% figure,
% subplot(1,2,1)
% boxplot(A_cm(1:end,:)./1000)
% if H==0
%     title('uncorrected')
% else
%     title('uncorrected*')
%     xlabel(['N.B. T-test: p < ' num2str(P) ])
% end
% ylabel('[mV]')
% subplot(1,2,2)
% boxplot(A_cm(floor(mean(indx)):end,:)./1000)
% if Hc==0
%     title('corrected')
% else
%     title('corrected*')
%     xlabel(['N.B. T-test: p < ' num2str(Pc)])
% end
% ylabel('[mV]')





% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4

%del? NBS = evalin('base','NBS');
str = get(gcbo,'str');
val = get(gcbo, 'val');
switch str{val}
    case '- DS5-Eldith'
        nrsubj = length(get(handles.popupmenu1,'str'));
        nrsubj = 1;
        % defaults
        INDX = get_defaults('A1',handles);
        nrsess = size(INDX,1)/14;
        ch.ch13 = 'AG-AL';
        ch.ch46 = 'AA-AF';
        chnnlstr ={'APB','apb lat','FDI','fdi lat','ADM', 'adm lat'};
        chnnls = get_defaults('conds',handles);
        chnnl = chnnls(2);
        % file
        filenames = get(handles.popupmenu1,'str');
        if isstr(filenames); tmp = filenames; clear filenames; filenames{1} = tmp; end
        val = get(handles.popupmenu1,'val');
        filename = filenames{val};
        sheetname = 'NBS';
        clear Ap1 Ap2
        cnt_ind = 1;
        for sess = 1:nrsess
            hem = 1;
            cnt = 1;
            for i=1:14
                ind = [INDX(cnt_ind,:)];
                cnt_ind = cnt_ind+1;
                if i==1
                    disp(['reading file (' filename '}'])
                    disp(['reading chnnl ('  chnnlstr{chnnl} ')'])
                end
                disp(['... ' num2str(i) ') ' num2str(ind)])
                ind(end) = ind(end)+1;
                data = xlsread(filename, sheetname,['AA' num2str(ind(1)) ':AL' num2str(ind(2))]);
                if sum(isnan(data(end,:))) > 0; % RMT condsition
                    rmt = data(end,:);
                    ind = find(isnan(rmt)==0);
                    DATA{sess}{hem}{cnt} = rmt(ind);
                    rmtgo = 1;
                    disp('RMT condstion:')
                else
                    try
                        if mean(data(:,chnnl)) > mean(data(:,chnnl+6));
                            disp('... dominant')
                            DATA{sess}{hem}{cnt} = data(:,chnnl);
                        else
                            disp('... non-dominant')
                            DATA{sess}{hem}{cnt} = data(:,chnnl+6);
                        end
                    catch
                        disp('Please check that the excel file has exchanged "-" with "0"')
                        disp(['...' filename '(' sheetname ' - ' ['AA' num2str(ind(1)) ':AL' num2str(ind(2))] ')'])
                    end
                end
                cnt = cnt+1;
                if i==7
                    disp(['... seconds hemisphere!'])
                    hem = 2;
                    cnt = 1;
                end
            end
        end
        
        disp(['CAVE!, data should be in order (2 hemispheres): 1) premean, 2)prermt, 3) postmean, 4) postrmt, 5) postmean2, 6)[ici], 6[icf]'])
        for subj = 1:nrsubj
            for hem = 1:2
                for sess = 1:nrsess % EA EK ES
                    D(subj).raw(sess).premean{hem} = DATA{sess}{hem}{1};
                    D(subj).raw(sess).prermt{hem} = DATA{sess}{hem}{2}; %lower CI RMT upper CI
                    D(subj).raw(sess).postmean{hem} = DATA{sess}{hem}{3};
                    D(subj).raw(sess).postrmt{hem} = DATA{sess}{hem}{4};
                    D(subj).raw(sess).postmean2{hem} = DATA{sess}{hem}{5};
                    D(subj).raw(sess).ici{hem} = DATA{sess}{hem}{6};
                    D(subj).raw(sess).icf{hem} = DATA{sess}{hem}{7};
                end
            end
        end
        % preprocess 1
        for subj = 1:nrsubj
            for hem = 1:2
                for sess = 1:nrsess
                    go = 0; % standardize to pre mean
                    if go == 1
                        A{1} = mean(D(subj).raw(sess).premean{hem});
                        A{2} = mean(D(subj).raw(sess).prermt{hem});
                        D(subj).raw(sess).premean{hem} = D(subj).raw(sess).premean{hem}/A{1};;
                        D(subj).raw(sess).prermt{hem} = D(subj).raw(sess).prermt{hem}/A{2}; %lower CI RMT upper CI
                        D(subj).raw(sess).postmean{hem} = D(subj).raw(sess).postmean{hem}/A{1};
                        D(subj).raw(sess).postrmt{hem} = D(subj).raw(sess).postrmt{hem}/A{2};
                        D(subj).raw(sess).postmean2{hem} = D(subj).raw(sess).postmean2{hem}/A{1};
                        D(subj).raw(sess).ici{hem} = DATA{sess}{hem}{6};
                        D(subj).raw(sess).icf{hem} = DATA{sess}{hem}{7};
                    end
                    go = 0; % prestd
                    if go == 1
                        % prestd over measures
                        try Means = prestd([D(subj).raw(sess).premean{hem},  D(subj).raw(sess).postmean{hem}, D(subj).raw(sess).postmean2{hem}]);
                        catch
                            lngth = [length(D(subj).raw(sess).premean{hem}), length(D(subj).raw(sess).postmean{hem}),length(D(subj).raw(sess).postmean2{hem})];
                            disp(['seems the number of samples are of different length: (',...
                                num2str(lngth(1)),...
                                ')(' num2str(lngth(2)),...
                                ')(' num2str(lngth(3)) ')']);
                            Means = prestd([D(subj).raw(sess).premean{hem}(1:min(lngth)),  D(subj).raw(sess).postmean{hem}(1:min(lngth)), D(subj).raw(sess).postmean2{hem}(1:min(lngth))]);
                        end
                        try RMT = prestd([D(subj).raw(sess).prermt{hem}, D(subj).raw(sess).postrmt{hem}]);
                        catch
                            lngth = [length(D(subj).raw(sess).prermt{hem}), length(D(subj).raw(sess).postrmt{hem})];
                            disp(['seems the number of samples are of different length: (',...
                                num2str(lngth(1)),...
                                ')(' num2str(lngth(2)) ')']);
                            RMT = prestd([D(subj).raw(sess).prermt{hem}(1:min(lngth)), D(subj).raw(sess).postrmt{hem}(1:min(lngth))]);
                        end
                        D(subj).raw(sess).premean{hem} = Means(:,1);
                        D(subj).raw(sess).postmean{hem} = Means(:,2);
                        D(subj).raw(sess).postmean2{hem}= Means(:,3);
                        D(subj).raw(sess).prermt{hem}= RMT(:,1);
                        D(subj).raw(sess).postrmt{hem}= RMT(:,2);
                    end
                    go = 1; % reilability
                    if go == 1
                        D(subj).processed(sess).premean{hem} = D(subj).processed(sess).premean{hem}(20:end);
                        D(subj).processed(sess).postmean{hem} = D(subj).processed(sess).postmean{hem}(20:end);
                        D(subj).processed(sess).postmean2{hem} = D(subj).processed(sess).postmean2{hem}(20:end);
                        D(subj).processed(sess).ici{hem} = D(subj).processed(sess).ici{hem}(20:end);
                        D(subj).processed(sess).icf{hem} = D(subj).processed(sess).icf{hem}(20:end);
                        % standardize to 1
                    end
                    go = 0; % reilability
                    if go == 1
                        D(subj).processed(sess).premean{hem} = h_cm(D(subj).raw(sess).premean{hem});
                        D(subj).processed(sess).postmean{hem} = h_cm(D(subj).raw(sess).postmean{hem});
                        D(subj).processed(sess).postmean2{hem} = h_cm(D(subj).raw(sess).postmean2{hem});
                        D(subj).processed(sess).ici{hem} = h_cm(D(subj).raw(sess).ici{hem});
                        D(subj).processed(sess).icf{hem} = h_cm(D(subj).raw(sess).icf{hem});
                        % standardize to 1
                    end
                end
            end
        end
        % preprocess 2
        for subj = 1:nrsubj
            for hem = 1:2
                for sess = 1:nrsess
                    
                end
            end
        end
        
        for subj = 1:nrsubj
            for hem = 1:2
                cnt = 1;
                for sess = 1:nrsess
                    M(sess,cnt+0) = mean(D(subj).raw(sess).premean{hem});
                    M(sess,cnt+1) = mean(D(subj).raw(sess).prermt{hem});
                    M(sess,cnt+2) = mean(D(subj).raw(sess).postmean{hem});
                    M(sess,cnt+3) = mean(D(subj).raw(sess).postrmt{hem});
                    M(sess,cnt+4) = mean(D(subj).raw(sess).postmean2{hem});
                    S(sess,cnt+0) = std(D(subj).raw(sess).premean{hem});
                    S(sess,cnt+1) = std(D(subj).raw(sess).prermt{hem});
                    S(sess,cnt+2) = std(D(subj).raw(sess).postmean{hem});
                    S(sess,cnt+3) = std(D(subj).raw(sess).postrmt{hem});
                    S(sess,cnt+4) = std(D(subj).raw(sess).postmean2{hem});
                    % reliable
                    Mp(sess,cnt+0) = D(subj).processed(sess).premean{hem}.mean;
                    Mp(sess,cnt+1) = mean(D(subj).raw(sess).prermt{hem});
                    Mp(sess,cnt+2) = D(subj).processed(sess).postmean{hem}.mean;
                    Mp(sess,cnt+3) = mean(D(subj).raw(sess).postrmt{hem});
                    Mp(sess,cnt+4) = D(subj).processed(sess).postmean2{hem}.mean;
                    
                    Sp(sess,cnt+0) = D(subj).processed(sess).premean{hem}.std;
                    Sp(sess,cnt+1) = std(D(subj).raw(sess).prermt{hem});
                    Sp(sess,cnt+2) = D(subj).processed(sess).postmean{hem}.std;
                    Sp(sess,cnt+3) = std(D(subj).raw(sess).postrmt{hem});
                    Sp(sess,cnt+4) = D(subj).processed(sess).postmean2{hem}.std;
                end
                HEM{hem}.Mp = Mp;
                HEM{hem}.Sp = Sp;
                HEM{hem}.M = M;
                HEM{hem}.S = S;
                HEM{hem}.str = str;
                clear Mp Sp M S
            end
            TDCS(subj).HEM = HEM;
        end
        assignin('base','TDCS',TDCS)
        
    case '- MappingResults'
        pwd = cd;
        
        
        % Example — Writing To an XLS File.   This example writes a mix of text and
        % numeric data to the file tempdata.xls. Call xlswrite, specifying a
        %worksheet labeled Temperatures, and the region within the worksheet
        %where you want to write the data. The 4-by-2 matrix is written to the
        %rectangular region that starts at cell E1 in its upper-left corner:
        % d = {'Time', 'Temp'; 12 98; 13 99; 14 97}
        % d =
        %     'Time'    'Temp'
        %     [  12]    [  98]
        %     [  13]    [  99]
        %     [  14]    [  97]
        % xlswrite('tempdata.xls', d, 'Temperatures', 'E1');
        
        MAPS_RESULTS = evalin('base','MAPS_RESULTS');
        NBS = evalin('base','NBS');
        % MAPS_RESULTS(1).MAPS.stats.log;
        % NBS.DATA(end).ANALYSES.CoGs;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % NBS
        % MAPS_RESULTS(1).MAPS.stats.smoothed;
        % MAPS_RESULTS(subj).MAPS.stats.raw;
        type = questdlg('What type of data?', ...
            'Data Question', ...
            'smoothed', 'ortho', 'contrast', 'smoothed');
        % type = 'ortho'; %{'raw';'smoothed':'ortho';'contrast'};
        filename = 'NBS-MAPRESULTS.xlsx';
        if exist(fullfile(cd,filename))
            answer=inputdlg({'enter new filename'},'file exists',1,{filename});
            filename = answer{1};
        end
        
        sheetname = 'xyz'; % see line 33
        subjs = 1:length(MAPS_RESULTS);
        try CNDS = evalin('base','condind');
        catch CNDS = 1:3;
        end
        
        donotwrite ={'SubarrayIdx','ConvexHull','ConvexImage','FilledImage',...
            'PixelIdxList', 'PixelList', 'PixelValues','Image'};
        
        
        % area
        COL = 2;
        clear E
        for subj = subjs
            sesss = 1:length(MAPS_RESULTS(subj).MAPS);
            for sess = sesss
                % header
                try seqname =  strrep(NBS.CONFIG(subj).SEQ{sess},'Sequence Description: ','');end % something off in h_NBS
                if length(CNDS)>length(MAPS_RESULTS(subj).MAPS(sess).stats);
                    cnds = 1:length(MAPS_RESULTS(subj).MAPS(sess).stats);
                    sbj = subj;
                    msgbox(['CAVE: changed number of conditions for subj: ' num2str(subj)])
                else
                    cnds = CNDS;
                end
                for cnd = cnds;
                    try
                        % data
                        ROW = 2;
                        % data (e.g. header 1-3)
                        switch type
                            case 'raw'
                                DATA = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).raw;
                                sheetname = 'raw';
                            case 'smoothed'
                                DATA = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).smoothed;
                                sheetname = 'smooth';
                            case 'ortho'
                                DATA = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).orthoraw;
                                sheetname = 'ortho';
                            case 'contrast'
                                DATA = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).contrast;
                                sheetname = 'contrast';
                            otherwise
                                DATA = RESULTS;
                                sheetname = sheetname;
                        end
                        names = fieldnames(DATA);
                        
                        for i=1:length(names)
                            if ~any(strcmp(names{i},donotwrite))
                                E{ROW,1} = strrep(names{i},'Centroid', 'Centroid (x,y)'); % leave the 1 alone!                                val = getfield(DATA,names{i});
                                val = getfield(DATA,names{i});
                                % special deals
                                switch names{i}
                                    case 'Extrema'
                                        val = length(val);
                                    case 'BoundingBox'
                                        E{24,1} = 'BoundingBox (x)';
                                        E{25,1} = 'BoundingBox (y)';
                                        E{24,COL} = val(1);
                                        E{25,COL} = val(2);
                                        val = NaN;
                                    case 'Centroid'
                                        CoGR = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).cog.REF;
                                        E{26,1} = 'Centroid (x)';
                                        E{27,1} = 'Centroid (y)';
                                        E{26,COL} = val(1)+CoGR(1); %guess
                                        E{27,COL} = val(2)+CoGR(3); %guess
                                        val = NaN;
                                    case 'WeightedCentroid'
                                        CoGR = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).cog.REF;
                                        E{28,1} = 'WeightedCentroid (x)';
                                        E{29,1} = 'WeightedCentroid (y)';
                                        E{28,COL} = val(1)+CoGR(1); %guess
                                        E{29,COL} = val(2)+CoGR(3); %guess
                                        val = NaN;
                                end
                                % add to matrix
                                for ii=1:length(val)
                                    E{ROW,COL-1+ii} = val(ii);
                                end
                                % stats
                                ROW = ROW+1;
                            else
                                % disp(['did not add: ' names{i}])
                            end
                        end
                    catch
                        disp(lasterr)
                    end
                    %disp([num2str(subj) num2str(sess) num2str(cnd) num2str(COL)])
                    T1(:,COL-1) = cat(1,E{5:end,COL});
                    COL = COL+1;
                end
            end
        end
        %clean up before writing
        ind = ones(1,size(E,1));
        ind([3,4,17,21,22,23]) = 0;
        E = E(find(ind),:);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        warning off MATLAB:xlswrite:AddSheet
        try xlswrite(filename,E,sheetname,'A10')
        catch errordlg(lasterr), return
        end
        disp(['Wrote area results to excel file: ' fullfile(cd,filename)])
        
        
        COL = 2;
        clear E ADDON CoG CoD
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for subj = subjs
            sesss = 1:length(MAPS_RESULTS(subj).MAPS);
            for sess = sesss
                if length(CNDS)>length(MAPS_RESULTS(subj).MAPS(sess).stats);
                    cnds = 1:length(MAPS_RESULTS(subj).MAPS(sess).stats);
                    sbj = subj;
                    msgbox(['CAVE: changed number of conditions for subj: ' num2str(subj)])
                else
                    cnds = CNDS;
                end
                for cnd = cnds;
                    %try
                    switch type
                        case 'smoothed'
                            CoG = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).cog.raw;
                            CoGR = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).cog.REF;
                            CoG = CoGR + CoG;
                            CoD = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).cod.raw;
                            CoDR = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).cod.REF;
                            MaX = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).max.raw(:,1);
                            
                        case 'ortho'
                            CoG = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).cog.ortho;
                            CoGR = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).cog.REF;
                            CoG = CoGR + CoG;
                            CoD = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).cod.ortho;
                            CoDR = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).cod.REF;
                            MaX = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).max.ortho(:,1);
                        case 'contrast'
                            CoG = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).cog.cntrst;
                            CoGR = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).cog.REF;
                            CoG = CoGR + CoG;
                            CoD = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).cod.cntrst;
                            CoDR = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).cod.REF;
                            MaX = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).max.cntrst(:,1);
                    end
                    if length(CoD)>1, CoD = -3; end
                    if isempty(CoD), CoD = NaN; end
                    if length(CoDR)>1, CoDR = -3; end
                    E{1,COL} = CoG(1);
                    E{2,COL} = CoG(2);
                    E{3,COL} = CoG(3);
                    E{4,COL} = CoD;
                    E{5,COL} = MaX(1);
                    E{6,COL} = MaX(2);
                    E{7,COL} = MaX(3);
                    T2(1:7,COL-1) = [CoG CoD MaX'];
                    COL = COL+1;
                    %                     catch disp(lasterr)
                    %                     end
                end
            end
        end
        E{1,1} = 'CoG (x)';
        E{2,1} = 'CoG (z)';
        E{3,1} = 'CoG (y)';
        E{4,1} = 'CoD';
        E{5,1} = 'Max1 (x)';
        E{6,1} = 'Max1 (z)';
        E{7,1} = 'Max1 (y)';
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        warning off MATLAB:xlswrite:AddSheet
        xlswrite(filename,E,sheetname,'A33')
        disp(['Wrote CoG/CoD results to excel file: ' fullfile(cd,filename)])
        
        COL = 2;
        clear E ADDON
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for subj = subjs
            sesss = 1:length(MAPS_RESULTS(subj).MAPS);
            for sess = sesss
                if length(CNDS)>length(MAPS_RESULTS(subj).MAPS(sess).stats);
                    cnds = 1:length(MAPS_RESULTS(subj).MAPS(sess).stats);
                    sbj = subj;
                else
                    cnds = CNDS;
                end
                for cnd = cnds;
                    switch type
                        case 'smoothed'
                            log = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).log.raw;
                        case 'ortho'
                            log = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).log.ortho;
                        case 'contrast'
                            log = MAPS_RESULTS(subj).MAPS(sess).stats(cnd).log.cntrst;
                    end
                    
                    ADDON(1,COL) = strrep(log(5),'cond:','');
                    ADDON(2,COL) = strrep(log(6),'Sequence Description: ','');
                    str = strrep(log(7),' events','');
                    str = strrep(str, ' MEPS','');
                    str = strrep(str,'; ','/');
                    str = str{1};
                    ind = strfind(str,'/');
                    ADDON(3,COL) = {[str([ind(1)+1]:end)]};
                    ADDON(4,COL) = {[str(1:ind(1)-1)]};
                    ADDON(5,COL) = {['= ' str([ind(1)+1]:end) '/'  str(1:ind(1)-1)]};
                    ADDON(6,COL) = {log{10}(9:16)};
                    ADDON(7,COL) = {strrep(log{12},'Kurtosis: ','')};
                    E(:,COL) = log';
                    COL = COL+1;
                end
            end
        end
        E{1,1} = 'LOG';
        ADDON{1,1} = 'Condition';
        ADDON{2,1} = 'Session';
        ADDON{3,1} = 'MEPS';
        ADDON{4,1} = 'Stimuli';
        ADDON{5,1} = 'MEPS/Stim';
        ADDON{6,1} = 'Volume';
        ADDON{7,1} = 'Kurtosis';
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        warning off MATLAB:xlswrite:AddSheet
        xlswrite(filename,ADDON,sheetname,'A3')
        xlswrite(filename,E,sheetname,'A44')
        disp(['Wrote header and log results to excel file: ' fullfile(cd,filename)])
        cd(pwd)
        disp('... done')
        
        % subject names
        COL = 2;
        clear E
        for subj = subjs;
            sesss = 1:length(MAPS_RESULTS(subj).MAPS);
            subjname = strrep(NBS.CONFIG(subj).FILENAMES{1},'auto_','');
            E{1,COL} = subjname{1};
            E{1,COL+1} = ' ';
            for sess = sesss
                for cnd = CNDS;
                    COL = COL +1;
                end
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        warning off MATLAB:xlswrite:AddSheet
        try xlswrite(filename,E,sheetname,'A1')
        catch errordlg(lasterr), return
        end
        disp(['Wrote subjects to excel file: ' fullfile(cd,filename)])
        
        % if TTEST
        ttestgo = 0
        if ttestgo
            COND = ADDON(1,2:end);
            SESS = ADDON(2,2:end);
            SESS = lower(SESS);
            str  = {'palmor','m1','lh','rh','mapping','fdi',...
                'fine  (','ersatz)','_','01mt','1mv','?',' ',' '};
            for is = 1:length(str)
                SESS = deblank(strrep(SESS,str{is},''));
            end
            SESS = strvcat(SESS);
            ind_pa = cat(1,strmatch('pa',SESS),strmatch('ap',SESS));
            ind_lm = cat(1,strmatch('lm',SESS),strmatch('ml',SESS));
            ind_or = cat(1,strmatch('perp',SESS));
            if size(SESS,1) == sum([size(ind_lm,1),size(ind_pa,1),size(ind_or,1)])
            else
                ctrl = strvcat(SESS);
                ctrl(cat(1,ind_pa, ind_lm, ind_or),:) = ' ';
            end
            disp(['pa ind: ' num2str(size(ind_pa,1))])
            disp(['lm ind: ' num2str(size(ind_lm,1))])
            disp(['or ind: ' num2str(size(ind_or,1))])
            T = cat(1,T1,T2);
            [h_lmor p_lmor] = ttest2(T(:,ind_lm)',T(:,ind_or)');
            p_lmor = p_lmor';
            [h_paor p_paor] = ttest2(T(:,ind_pa)',T(:,ind_or)');
            p_paor = p_paor';
            [h_lmpa p_lmpa] = ttest2(T(:,ind_lm)',T(:,ind_pa)');
            p_lmpa = p_lmpa';
            %         for ii = 1:32
            %          ranksum(T(ii,ind_lm),T(ii,ind_or))
            %         end
            %         p_lmor = p_lmor';
            %         [h_paor p_paor] = ttest2(T(:,ind_pa)',T(:,ind_or)');
            %         p_paor = p_paor';
            %         [h_lmpa p_lmpa] = ttest2(T(:,ind_lm)',T(:,ind_pa)');
            %         p_lmpa = p_lmpa';
        end
        
        
        
        
    case '- DS5-Eldith (results)'
        TDCS =  evalin('base','TDCS');
        %%%%
        str = get(handles.showseq,'str');
        col2text = evalin('base',['NBS.GUI(' num2str(subj) ').col2text']);
        textdata = evalin('base','textdata');
        seq = 1;
        for i=1:length(str)/14;
            seq_names{i} = num2str(i);
            row = strmatch(str{seq},col2text);
            if isempty(strfind(textdata{row+3,2},' EK'))==0
                seq_names{i} = 'EK';
            elseif isempty(strfind(textdata{row+3,2},' ES'))==0
                seq_names{i} = 'ES';
            elseif isempty(strfind(textdata{row+3,2},' EA'))==0
                seq_names{i} = 'EA';
            elseif isempty(strfind(textdata{row+3,2},' DA'))==0
                seq_names{i} = 'DA';
            elseif isempty(strfind(textdata{row+3,2},' DS'))==0
                seq_names{i} = 'DS';
            elseif isempty(strfind(textdata{row+3,2},' DK'))==0
                seq_names{i} = 'DK';
            end
            seq = seq+14;
        end
        ind = [1:size(TDCS(1).HEM{1}.M,1)];
        try ind(1) = find(strcmp(seq_names,'EK')); end
        try ind(2) = find(strcmp(seq_names,'ES')); end
        try ind(3) = find(strcmp(seq_names,'EA')); end
        if length(find(ind))> 1;
            if sum(ind)==3
                ind(find(ind==0)) = 3;
            elseif sum(ind) == 4;
                ind(find(ind==0)) = 2;
            elseif sum(ind) == 5;
                ind(find(ind==0)) = 1;
            end
        end
        
        
        str = {'M1','R1','M2','R2','M3'};
        for subj = 1: 1
            f1 = figure;
            set(f1,'name',['mean (subj:' num2str(subj) ')'])
            f2 = figure;
            set(f2,'name',['std (subj:' num2str(subj) ')'])
            cnt = 1;
            for hem = 1:2
                HEM =  TDCS(subj).HEM;
                lim = [-3,3];
                
                figure(f1)
                subplot(2,2,cnt) %1,2
                plot(HEM{hem}.M(ind,:)','-*')
                legend(seq_names(ind),'location','NorthWest')
                legend(gca,'boxoff')
                %ylim([lim(1) lim(2)])
                title(['HEM: ' num2str(hem) ' (mean)'])
                ylabel('mV')
                set(gca,'xticklabel',str,'xtick',[1:5])
                subplot(2,2,cnt+1) %2
                plot(HEM{hem}.Mp(ind,:)','-*')
                %ylim([-5 lim(1)])
                legend(seq_names(ind),'location','NorthWest')
                legend(gca,'boxoff')
                title(['HEM: ' num2str(hem) ' (reliable mean)'])
                ylabel('mV')
                set(gca,'xticklabel',str,'xtick',[1:5])
                
                figure(f2)
                subplot(2,2,cnt)
                plot(HEM{hem}.S(ind,:)','-*')
                legend(seq_names(ind),'location','NorthWest')
                legend(gca,'boxoff')
                %ylim([0 lim(2)])
                title(['HEM: ' num2str(hem) ' (std)'])
                ylabel('mV')
                set(gca,'xticklabel',str,'xtick',[1:5])
                subplot(2,2,cnt+1)
                plot(HEM{hem}.Sp(ind,:)','-*')
                legend(seq_names(ind),'location','NorthWest')
                legend(gca,'boxoff')
                %ylim([0 lim(1)])
                title(['HEM: ' num2str(hem) ' (reliable std)'])
                ylabel('mV')
                set(gca,'xticklabel',str,'xtick',[1:5])
                cnt = cnt+2;
                hold on
            end
        end
        
        for hem = 1:2;
            M = HEM{hem}.Mp(ind,:);
            Mc = [M(:,3)./M(:,2),M(:,5)./M(:,4)];
            Mc = Mc -1;
            Mc(find(isnan(Mc)))= 0;
            figure,
            bar3(Mc')
            colormap(cool)
            zlim([-1.5 1.5])
            set(gca,'yticklabel',{'M1/R1','M2/R2'})
            set(gca,'xticklabel',seq_names(ind))
            legend(seq_names(ind))
            title(['HEM: ' num2str(hem)])
        end
        
    case '- PP-NBS import'
        h_PPfrom_h_Nexstim(evalin('base','NBS'), handles)
        
    case '- Leonardo'
        %maps
        
        MAPS_STATS = evalin('base','MAPS_STATS');
        lbl = {'area (raw)','volume (raw)','diameter (raw)','area (smoothed}',...
            'volume(smoothed)','convex area (smoothed)','equiv. diameter (smoothed)',...
            'perimeter (smoothed)'};
        try subjind = evalin('base','sessind');
        catch
            subjind = [1:size(A1,1)];
            assignin('base','sessind',sessind)
        end
        str = {'1','2','3','4','5','6','7'}; %,'9','10','11','13','14','15'};
        xlm = [-50 50];
        ylm = [-50 50];
        for i=1:size(MAPS_STATS,3)
            fig = figure;
            R = reshape(MAPS_STATS(subjind,1:4,i),length(subjind),4);
            subplot(3,1,1:2)
            boxplot(R)
            title('boxplot')
            set(gca,'xtick',[1:4],'xticklabel',{'250mV','500mV','110%','120%'})
            hold on
            plot(R','*')
            title(lbl{i}),
            grid on
            %ylabel('[mm2]')
            legend(str,'location','bestoutside')
            
            subplot(3,1,3)
            m(1) = mean(R(find(R(:,1)),1));
            m(2) = mean(R(find(R(:,2)),2));
            m(3) = mean(R(find(R(:,3)),3));
            m(4) = mean(R(find(R(:,4)),4));
            s(1) = std(R(find(R(:,1)),1))/length(find(R(:,1)));
            s(2) = std(R(find(R(:,2)),2))/length(find(R(:,2)));
            s(3) = std(R(find(R(:,3)),3))/length(find(R(:,3)));
            s(4) = std(R(find(R(:,4)),4))/length(find(R(:,4)));
            errorbar(m,s,'*')
            grid on
            set(gca,'xtick',[1:4],'xticklabel',{'250mV','500mV','110%','120%'})
            title('mean & SE')
            ylabel(['mm'])
        end
        % equivalent diameter/circles
        D = MAPS_STATS(subjind,:,find(strcmp(lbl,'diameter (raw)')));
        mstr = mean(D)/2;
        sstr = std(D)/2;
        nms = {'250mV','500mV','110%','120%'};
        figure
        set(gcf,'name','radius (raw)')
        for cond = 1:4
            subplot(2,2,cond),
            for subj = 1:size(D,1)
                hold on
                fnplt(rsmak('circle',D(subj,cond)/2))
            end
            xlim([xlm(1) xlm(2)])
            ylim([ylm(1) ylm(2)])
            grid on
            title([nms{cond} ' (' sprintf('%5.2f',mstr(cond)) '+/- ' sprintf('%5.2f',sstr(cond))  ')'])
            ylabel('[mm]')
            xlabel('[mm]')
        end
        D = MAPS_STATS(subjind,:,find(strcmp(lbl,'equiv. diameter (smoothed)')));
        mstr = mean(D)/2;
        sstr = std(D)/2;
        nms = {'250mV','500mV','110%','120%'};
        figure
        set(gcf,'name','equiv. radius (smoothed)')
        for cond = 1:4
            subplot(2,2,cond),
            for subj = 1:size(D,1)
                hold on
                fnplt(rsmak('circle',D(subj,cond)/2))
            end
            xlim([xlm(1) xlm(2)])
            ylim([ylm(1) ylm(2)])
            grid on
            title([nms{cond} ' (' sprintf('%5.2f',mstr(cond))  '+/- ' sprintf('%5.2f',sstr(cond)) ')'])
            ylabel('[mm]')
            xlabel('[mm]')
        end
        
        
        return
        %other (older stuff)
        ztrnsfrm = 0;
        P = genpath('D:\TMS by Leo');
        ind = [findstr(P,pathsep)];
        for i=1:length(ind);
            try p = P(ind(i)+1:ind(i+1)-1);
            catch p = P(ind(i)+1:end-1);
            end
            
            d = dir(fullfile(p,'*RC.mat'));
            if isempty(d) ~=1
                disp([p '.... found file!'])
                try F{end+1} = fullfile(p,d.name);
                catch F{1} = fullfile(p,d.name);
                end
            else
                disp(p)
            end
        end
        
        [s,v] = listdlg('PromptString','Select a file:',...
            'SelectionMode','multiple',...
            'ListString',F);
        F = F(s);
        
        disp('... reading into group matrix')
        try MT = evalin('base','gMT')
        catch
            for i=1:length(F)
                % RC ztransform mV
                disp(F{i})
                load(F{i});
                mV = NBS.ANALYSES.RC.A;
                dim = size(mV);
                if ztrnsfrm
                    mV = reshape(zscore(reshape(mV,1,dim(1)*dim(2))),dim(1),dim(2));
                end
                mVz = zeros(16,9);
                mVz(1:dim(1),1:dim(2)) = mV;
                RC.mV{i} = mVz;
                RC.MSO = [100 110 120 130 140 150 160 170 180];
                RC.mso{i} = zeros(1,9);
                mso = median(NBS.ANALYSES.RC.mso);
                RC.mso{i}(1:length(mso)) = mso;
                
                % MT ztransform MSO
                load(strrep(F{i},'RC','MvT'));
                mso = NBS.ANALYSES.MT.mso;
                dim = size(mso);
                if ztrnsfrm
                    mso = reshape(zscore(reshape(mso,1,dim(1)*dim(2))),dim(1),dim(2));
                end
                msoz = zeros(16,9);
                msoz(1:dim(1),1:dim(2)) = mso;
                MT.MSO{i} = msoz;
                MT.mV = [50 250 500 1000 2000 3000 4000 5000 6000];
                MT.mv{i} = zeros(1,9);
                mv = NBS.ANALYSES.MT.mV;
                MT.mv{i}(1,1:length(mv)) = mv;
            end
        end
        MT.mV = median(cat(1,MT.mv{:}));
        assignin('base','gMT',MT)
        
        %%
        figure, imagesc(cat(1,MT.mv{:})), colorbar, title('MT [mV]')
        figure,
        set(gcf,'name', 'RC (group)!')
        subplot(3,1,1)
        CmV = cat(1,RC.mV{:});
        plot(RC.MSO,CmV,'*')
        title('RC - Group')
        subplot(3,1,2)
        boxplot(CmV)
        title('boxplot')
        subplot(3,1,3)
        plot(RC.MSO, median(CmV),'*')
        title('median')
        xlabel('[MSO]')
        ylabel('[znorm-mV]')
        
        figure,
        set(gcf,'name', 'MT (group)!')
        subplot(3,1,1)
        Cmso = cat(1,MT.MSO{:});
        plot(Cmso','*')
        title('MT - Group')
        set(gca,'xticklabel',MT.mV)
        subplot(3,1,2)
        boxplot(Cmso)
        title('boxplot')
        set(gca,'xtick',[1:9],'xticklabel',MT.mV)
        subplot(3,1,3)
        plot(median(Cmso),'*')
        set(gca,'xticklabel',MT.mV)
        title('median')
        xlabel('[mV]')
        ylabel('[znorm-MSO]')
        
        
        figure
        subplot(3,1,1)
        hold on
        plot(median(CmV),'+')
        plot(median(Cmso),'o')
        legend({'RC','MvT'},'location','best')
        subplot(3,1,2)
        plot(median(Cmso(:,1:8)),median(CmV(:,1:8)),'-*')
        subplot(3,1,3)
        
        % %RMT to MSO
        rmtmso = median(cat(1,RC.mso{:}));
        figure
        imagesc(cat(1,RC.mso{:}))
        colorbar
        title('RC')
        ylabel('subjects')
        xlabel('% RMT')
        
        
        figure
        subplot(3,2,1)
        imagesc(Cmso)
        title('MT')
        subplot(3,2,2)
        imagesc(CmV)
        title('RC')
        subplot(3,2,3)
        plot(MT.mV,Cmso','*')
        subplot(3,2,4)
        plot(rmtmso,CmV','*')
        subplot(3,2,5:6)
        
        figure, hold on
        plot(rmtmso,median(CmV),'r*')
        plot(median(Cmso),MT.mV,'+')
        grid on, legend({'RC','MT'},'location','bestoutside')
        xlabel(['mso'])
        ylabel(['mV'])
        
    otherwise
        
end
set(gcbo,'val',1)
disp(['done, see HEM in base workspace'])




% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function val = get_defaults(str,handles)
PRM = get(handles.listbox1,'str');
ind = strmatch(str, strvcat(PRM));
eval(PRM{ind});
eval(['val=' str ';']);


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%%%%%%%%%%%%%%%%%%%%%%%5
% subfunction % CoG - image
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = h_CoG(M,AMPS,LOC)
% LOC mal AMPS/ sum(AMPS); LA = LOC*AMPS
if isempty(AMPS) == 0 && isempty(LOC) == 0;
    if any(AMPS<0);
        AMPS = AMPS-min(AMPS);
    end
    LA = LOC*AMPS;
    if size(LA,1)>3
        CoG = [sum(LA)/sum(AMPS)]';
    else
        CoG = [LA/sum(AMPS)]';
    end
elseif isempty(M) == 0
    if sum(size(M))>4 % maps
        try loc = LOC;
        catch [loc(3,:) loc(1,:)] = find(M);
        end
        for i = 1:length(loc(3,:))
            amps(i) = M(loc(3,i),loc(1,i));
        end
        loc([1,3],:) = loc([1,3],:);
        for i=1:3;
            la(:,i) = loc(i,:).*amps;
        end
        tmp = sum(la,1)/sum(amps);
        CoG = [tmp(2)-1, NaN, tmp(1)-1]; % subtract 1 because matrix(1,1) = 1 statt 0
    end
else % vectors
    CoG = [NaN NaN NaN];
end
disp(['... CoG (x,z,y - due to Nexstim): ' num2str(CoG) ])
varargout{1} = CoG;


%%%%%%%%%%%%%%%%%%%%%%%%5
% subfunction % CoD - image
%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = h_CoD(AMPS,ORI)
% ORI mal AMPS/ sum(AMPS);
if AMPS == 1;
    x = ORI(1); % direction colums
    y = ORI(3);
    hyp = sqrt((x.^2)+(y.^2));
    dgrss90 = y>0 & x<0; %Filtern nach Koordinaten, die im I. Quadranten liegen
    dgrss180 = y<0 & x<0; %Filtern nach Koordinaten, die im II. Quadranten liegen
    dgrss270 = y<0 & x>0; %Filtern nach Koordinaten, die im III. Quadranten liegen
    dgrss360 = y>0 & x>0; %Filtern nach Koordinaten, die im IV. Quadranten liegen
    dgrss = asind(y./hyp); %Vektor im I. Quadranten bestimmen lassen
    dgrss((find(dgrss90)),1) = 90 - dgrss((find(dgrss90)),1);
    dgrss((find(dgrss180)),1) = 90 - dgrss((find(dgrss180)),1);
    dgrss((find(dgrss270)),1) = dgrss((find(dgrss270)),1) + 270;
    dgrss((find(dgrss360)),1) = dgrss((find(dgrss360)),1) + 270;
    
elseif size(ORI,2)> 1
    if size(ORI,2)~=3,
        ORI = ORI';
    end
    x = ORI(:,1); % direction colums
    y = ORI(:,3);
    hyp = sqrt((x.^2)+(y.^2));
    dgrss90 = y>0 & x<0; %Filtern nach Koordinaten, die im I. Quadranten liegen
    dgrss180 = y<0 & x<0; %Filtern nach Koordinaten, die im II. Quadranten liegen
    dgrss270 = y<0 & x>0; %Filtern nach Koordinaten, die im III. Quadranten liegen
    dgrss360 = y>0 & x>0; %Filtern nach Koordinaten, die im IV. Quadranten liegen
    dgrss = asind(y./hyp); %Vektor im I. Quadranten bestimmen lassen
    dgrss((find(dgrss90)),1) = 90 - dgrss((find(dgrss90)),1);
    dgrss((find(dgrss180)),1) = 90 - dgrss((find(dgrss180)),1);
    dgrss((find(dgrss270)),1) = dgrss((find(dgrss270)),1) + 270;
    dgrss((find(dgrss360)),1) = dgrss((find(dgrss360)),1) + 270;
end
ORI = dgrss';
try varargout{1} = [ORI*AMPS]/sum(AMPS);
catch varargout{1} = [NaN];
end

% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% str = get(handles.popupmenuSearchResults,'str');
% subj = get(handles.popupmenuSearchResults,'val');

doindxng = strcmp(get(handles.editsearch,'str'),evalin('base','TAGS'));
if sum(doindxng)==length(doindxng)
    disp('... tags were not changed using old index')
else
    feval('tagfiles_Callback',handles.tagfiles,1,handles);
end

COMPARE = evalin('base','COMPARE');
NBS = evalin('base','NBS');

try
    NBS = rmfield(NBS,'CONFIG');
    NBS = rmfield(NBS,'DATA');
end

% new indices
cnt = 1;
for newsubj = 1:size(COMPARE.path_file,1)
    % check for empty cells
    if isempty( NBS.GUI(1,newsubj).sequences);
        NBS.CONFIG(newsubj).FILENAMES{1} = COMPARE.path_file(newsubj,2);
        NBS.CONFIG(newsubj).PATHNAME{1} = COMPARE.path_file(newsubj,1);
        NBS.CONFIG(newsubj).SEQ{1} = get(handles.showseq,'str');  %%% descript
        NBS.CONFIG(newsubj).PARAMS{1} = get(handles.listbox1,'str');
    else
        % gui stuff
        set(handles.uipanel10,'title',['Analyses (' num2str(newsubj) '/' num2str(size(COMPARE.path_file,1)) ')'])
        %
        subj =  COMPARE.path_file(newsubj,2);
        disp(['loading ... ' subj{1}])
        
        try %means that they were already loaded and accepted
            loadedandaccepted = 1;
            PRM = NBS.CONFIG(newsubj).PARAMS{1};
            set(handles.listbox1,'str', PRM)
            indx = getfield(COMPARE.results,char(COMPARE.results.subjects(newsubj,1)));
        catch %load for the first time
            loadedandaccepted = 0;
            % gui structure
            indxfound_gui = str2num(strvcat(NBS.GUI(1,newsubj).sequencesindices{:}));
            disp('gui:'), disp(indxfound_gui(:,1))
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% / roberts compare stucture
            indx = getfield(COMPARE.results,char(COMPARE.results.subjects(newsubj,1)));
            indxall = indx.indxSeq.start;
            indxfound = indx.matches.matchlines;
            disp('compare:'), disp(indxfound)
            % fix for deleteions, concatenations and reorganiyations
            if length(indxfound_gui(:,1))< length(indxfound);
                ind = zeros(1,length(indxfound_gui(:,1)));
                for ii = 1:length(indxfound_gui(:,1))
                    d = abs(indxfound - indxfound_gui(ii,1));
                    ind(ii) = find(d==min(d));
                end
                indxfound = indxfound(ind);
                
            elseif length(indxfound_gui(:,1))>length(indxfound);
                % fix for concatenations
            else
                % fix for reorginzations
                [tmp ind] = sort(indxfound_gui(:,1));
                indxfound = indxfound(ind);
            end
            disp('==> final:'), disp(indxfound)
            % compare structure (will use ind_get(sess,1) ind_get(sess,2)
            prm = [ ];
            ind = { };
            for i = 1:length(NBS.GUI(1,newsubj).sequences)
                ind_data(1,1:2) = indxall(find(indxall(:,1) == indxfound(i,1)),2:3);
                ind_get(i,1:2) = ind_data;
                ind{i} = deblank([strrep(num2str(ind_data),'  ',',') ' ']);
                prm = [prm, ind{i} ';'];
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            try inptctrl = evalin('base', 'inptctrl');
            catch inptctrl = 0;
                disp('setting inptctrl = 1')
                assignin('base','inptctrl',inptctrl)
            end
            if inptctrl
                prm = inputdlg(subj{1},'check indices',1,cellstr(prm));
                prm = char(prm);
            end
            PRM = get(handles.listbox1,'str');
            PRM{strmatch('A1', strvcat(PRM))} = ['A1 = ' strrep(['[' prm(1:end-1) ']'],',', ' ') ';'];
            
            set(handles.listbox1,'str', PRM)
        end
        
        %tfx paths
        switch get(handles.changepath,'checked')
            case 'off'
            case 'on'
        end
        
        
        % new structure
        NBS.CONFIG(newsubj).FILENAMES{1} = COMPARE.path_file(newsubj,2);
        NBS.CONFIG(newsubj).PATHNAME{1} = COMPARE.path_file(newsubj,1);
        NBS.CONFIG(newsubj).SEQ{1} = get(handles.showseq,'str');  %%% descript
        NBS.CONFIG(newsubj).PARAMS{1} = get(handles.listbox1,'str');
        
        
        eval(PRM{strmatch('A1', strvcat(PRM))});
        eval(PRM{strmatch('offset', strvcat(PRM))});
        ind_get = A1+offset;
        for sess = 1:size(ind_get,1);
            disp(['... session: ' num2str(sess) '/' num2str(size(ind_get,1)) '(' num2str(ind_get(sess,:)) ')'])
            subdata = indx.rawmatrix(ind_get(sess,1) : ind_get(sess,2),:);
            %     [x,yc] = find(strcmp(textdata,'Ch1 '));
            %     [x,yc] = find(strcmp(textdata,'Coil'));
            %     [x,yc] = find(strcmp(textdata,'EF max.'));
            %     [x,yc] = find(strcmp(textdata,'EF at'));
            %     [x,yt] = find(strcmp(textdata,'Time'));
            %     indf = yc(1)-yt(1)+1;
            
            ind = find(strcmp(subdata,'-'));
            subdata(ind) = {0};
            ind = find(strcmp(subdata,'NaN'));
            subdata(ind) = {0};
            
            %MSO
            MSO = cell2mat(subdata(:,7:8));
            % ms
            TIMELINE = cell2mat(subdata(:,4));
            
            % get AMPS and PP
            try AMPS = cell2mat(subdata(:,27:38));
            catch
                try
                    AMPS = cell2mat(subdata(:,27:size(subdata,2)));
                catch
                    %% if for some reasons latencies or amplitudes hvbe
                    %% been converted to dates or chars have been created instead of doubles, fix that
                    for AMrow = 1:size(subdata,1)
                        for AMcol = 27:1:38;
                            
                            TMP = cell2mat(subdata(AMrow,AMcol));
                            
                            if ischar(TMP)
                                fTMP = strfind(TMP,'/');
                                
                                if isempty(fTMP)
                                    subdata(AMrow,AMcol) = {str2num(TMP)};
                                elseif length(fTMP) == 2
                                    CNUM = strrep(TMP(1,1:(fTMP(end)-1)),'/','.');
                                    
                                    if CNUM(fTMP(1,1) + 1) == '0'
                                        IDX = ones(1,length(CNUM));
                                        IDX(fTMP(1,1) + 1) = 0;
                                        CNUM = CNUM(logical(IDX));
                                    end
                                    subdata(AMrow,AMcol) = {str2num(CNUM)};
                                else
                                    errordlg('Your AMP data is incosistent, check for Excel autoformat');
                                    return;
                                end
                            end
                        end
                    end
                    
                    AMPS = cell2mat(subdata(:,27:size(subdata,2)));
                end
            end
            
            if isempty(AMPS), msgbox('Cave', 'empty!','warn'), end
            AMPS(isnan(AMPS))=0;
            % if NaN's are in the NBS excel file a mistake is made - fix
            if size(AMPS,1) < diff(A1(sess,:))+1
                fx(1) = size(AMPS,1)+1;
                fx(2) = diff(A1(sess,:))+1;
                AMPS(fx,:) = 0;
            end
            % PP
            data = subdata(:,13:26);
            % correct for paired pulse treatments
            dI = strncmp('-1.$',data,2);
            [dI] = find(dI);
            for di = 1:length(dI)
                data{dI(di)}=0;
            end
            %
            if isempty(data), msgbox(['Physical Parameters: (M' num2str(A1(sess,1)) ':Z' num2str(A1(sess,2)) ')' ], 'empty!','warn'), end
            if size(data,2)==13,
                disp('... N.B.: EF at Target is empty')
                PP.names = {'MEP [abs]','Location [mm]','Normal [°]','Orientation [°]','EF-Location [mm]','EFmax [V/m]','EFmax [V/m]'};
                PP.data = cell2mat(cat(2, data, data(:,end)));
            else
                PP.names = {'MEP [abs]','Location [mm]','Normal [°]','Orientation [°]','EF-Location [mm]','EFmax [V/m]','EF@Loc'};
                try
                    PP.data = cell2mat(data);
                catch
                    try
                        for AMrow = 1:size(data,1)
                            for AMcol = 1:1:size(data,2);
                                
                                TMP = cell2mat(data(AMrow,AMcol));
                                
                                if ischar(TMP)
                                    fTMP = strfind(TMP,'/');
                                    
                                    if length(fTMP) == 2
                                        CNUM = strrep(TMP(1,1:(fTMP(end)-1)),'/','.');
                                        
                                        if CNUM(fTMP(1,1) + 1) == '0'
                                            IDX = ones(1,length(CNUM));
                                            IDX(fTMP(1,1) + 1) = 0;
                                            CNUM = CNUM(logical(IDX));
                                        end
                                        data(AMrow,AMcol) = {str2num(CNUM)};
                                    else
                                        data(AMrow,AMcol) = {str2num(TMP)};
                                        
                                    end
                                end
                            end
                        end
                        PP.data = cell2mat(data);
                    catch
                        disp([num2str(AMrow) ' ' num2str(AMcol)]);
                        errordlg('Your LOC/DIR/EF data is incosistent, check for Excel autoformat');
                        return;
                    end
                end
            end
            if find(isnan(PP.data)),
                figure, imagesc(PP.data), title(['NaNs: ' num2str(A1(sess,:)) ' (' strrep(subj{1},'_','-') ')']),
            end
            
            NBS.DATA(newsubj).RAW(sess).TMLN = TIMELINE;
            NBS.DATA(newsubj).RAW(sess).MSO = MSO;
            NBS.DATA(newsubj).RAW(sess).AMPS = AMPS;
            NBS.DATA(newsubj).RAW(sess).ISI = cell2mat(subdata(:,6));
            NBS.DATA(newsubj).RAW(sess).PP =  PP;
            NBS.DATA(newsubj).PROCESSED(sess).names = NBS.DATA(newsubj).RAW(sess).PP.names;
            
            % make Matrix
            EMGCHANNELNBS = 3; %e.g. 1= APB 2 = APB latency 3 = FDI
            M = cat(2,NBS.DATA(newsubj).RAW(sess).AMPS(:,3), NBS.DATA(newsubj).RAW(sess).PP.data);
            clear M2
            M2(:,1) = M(:,1);                   % MEP variations
            M2(:,2) = sum(abs(M(:,2:4))');      % Location
            M2(:,3) = sum(abs(M(:,5:7))');      % r_drctnsx(M(:,5:7));   % Normal
            M2(:,4) = sum(abs(M(:,8:10))');     % r_drctnsx(M(:,8:10));     % Orientation
            M2(:,5) = sum(abs(M(:,11:13))');    % Location (EF)
            M2(:,6) = M(:,14);                  % Max (EF)
            M2(:,7) = M(:,15);
            NBS.DATA(newsubj).PROCESSED(sess).MAT = M2;
            
            
            switch get(handles.vwdtldng,'checked');
                case 'on', seq_preview = 1;
                case 'off', seq_preview = 0;
            end
            
            
            if loadedandaccepted ~= 1 && seq_preview == 1 %&& NBS.defaults.ctrl ==1; "cR_: replacement ok?"
                fp = figure;
                strfig = {'MEP','Loc','Norm','Ori','EFloc','EFmax','EFtar'};
                set(gcf,'name', ['subject: ' num2str(newsubj) ', session: ' num2str(sess) '(MEP,Loc,Norm,Ori,EFloc,EFmax) -- NBS.DATA(subj).PROCESSED(sess).MAT'])
                for sp = 1:7
                    subplot(7,1,sp)
                    imagesc(M2(:,sp)')
                    title(strfig{sp})
                    axis off
                end
                pause(1), try close(fp), end
            end
        end
        assignin('base','NBS',NBS);
    end
end

% filter out Subjects/Sessions
filterout = 0;
if filterout == 1
    str = {'MEPempty','MEPno'};
    clear sbjsessind
    for subj = 1:length(NBS.DATA)
        for sess = 1:length(NBS.DATA(subj).PROCESSED)
            amps = NBS.DATA(subj).PROCESSED(sess).MAT(:,1);
            if length(find(amps))<1
                sbjsessind(subj,sess) = 0;
            else
                sbjsessind(subj,sess) = 1;
            end
        end
    end
    %subjects to keep
    sbjind = find(sum(sbjsessind')>0);
    NBS.DATA = NBS.DATA(sbjind);
    NBS.GUI = NBS.GUI(sbjind);
    NBS.CONFIG = NBS.CONFIG(sbjind);
    sbjsessind = sbjsessind(sbjind,:);
    % sessions to keep
    for subj = 1:length(NBS.DATA)
        ind = find(sbjsessind(subj,:));
        NBS.DATA(subj).PROCESSED = NBS.DATA(subj).PROCESSED(ind);
        NBS.DATA(subj).RAW = NBS.DATA(subj).RAW(ind);
        NBS.GUI(subj).sequences = NBS.GUI(subj).sequences(ind);
        NBS.GUI(subj).sequencesindices = NBS.GUI(subj).sequencesindices(ind);
        NBS.GUI(1).sbjind = ind;
        NBS.GUI(1).sbjsessind = sbjsessind;
        %NBS.CONFIG(3).SEQ{1}
        PRMS = NBS.CONFIG(subj).PARAMS{1};
        eval(PRMS{strmatch('A1', strvcat(PRMS))});
        A1 = A1(ind,:);
        A1str = ['A1 = ['];
        for ai = 1:size(A1,1);
            A1str = [A1str deblank(num2str(A1(ai,:))) '; '];
        end
        A1str(end-1:end) = '];';
        PRMS{strmatch('A1', strvcat(PRMS))} = A1str;
        NBS.CONFIG(subj).PARAMS{1} = PRMS;
    end
    assignin('base','NBS',NBS);
end

for h = 1:1:size(NBS.CONFIG,2)
    list_sub(h,1) = NBS.CONFIG(1,h).FILENAMES{1,1};
end
set(handles.popupmenu1,'str',list_sub);


assignin('base','handles',handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTIONs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dgrss = r_drctnsx(DIR)

% DIR = directions, in a (nx3) vector

x = DIR(:,1); % direction colums
y = DIR(:,3);
hyp = sqrt((x.^2)+(y.^2));
dgrss90 = y>0 & x<0; %Filtern nach Koordinaten, die im I. Quadranten liegen
dgrss180 = y<0 & x<0; %Filtern nach Koordinaten, die im II. Quadranten liegen
dgrss270 = y<0 & x>0; %Filtern nach Koordinaten, die im III. Quadranten liegen
dgrss360 = y>0 & x>0; %Filtern nach Koordinaten, die im IV. Quadranten liegen
dgrss = asind(y./hyp); %Vektor im I. Quadranten bestimmen lassen
dgrss((find(dgrss90)),1) = 90 - dgrss((find(dgrss90)),1);
dgrss((find(dgrss180)),1) = 90 - dgrss((find(dgrss180)),1);
dgrss((find(dgrss270)),1) = dgrss((find(dgrss270)),1) + 270;
dgrss((find(dgrss360)),1) = dgrss((find(dgrss360)),1) + 270;


% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%function dgrss = r_drctnsx(DIR);

% DIR = directions, in a (nx3) vector
subj = get(handles.popupmenu1,'val');
sess = 1;

NBS = evalin('base','NBS');
ORI = NBS.DATA(subj).RAW.PP.data(:,8:10);
NORM = NBS.DATA(subj).RAW.PP.data(:,5:7);
LOC = NBS.DATA(subj).RAW.PP.data(:,2:4);
AMPS = NBS.DATA(subj).RAW.AMPS;

for i=1:2;
    if i == 1
        DIR = ORI;
    else
        DIR = NORM;
    end
    x = DIR(:,1); % direction colums
    y = DIR(:,3);
    hyp = sqrt((x.^2)+(y.^2));
    dgrss90 = y>0 & x<0; %Filtern nach Koordinaten, die im I. Quadranten liegen
    dgrss180 = y<0 & x<0; %Filtern nach Koordinaten, die im II. Quadranten liegen
    dgrss270 = y<0 & x>0; %Filtern nach Koordinaten, die im III. Quadranten liegen
    dgrss360 = y>0 & x>0; %Filtern nach Koordinaten, die im IV. Quadranten liegen
    dgrss = asind(y./hyp); %Vektor im I. Quadranten bestimmen lassen
    dgrss((find(dgrss90)),1) = 90 - dgrss((find(dgrss90)),1);
    dgrss((find(dgrss180)),1) = 90 - dgrss((find(dgrss180)),1);
    dgrss((find(dgrss270)),1) = dgrss((find(dgrss270)),1) + 270;
    dgrss((find(dgrss360)),1) = dgrss((find(dgrss360)),1) + 270;
    if i == 1
        ori = dgrss;
    else
        norm = dgrss;
    end
end
loc = zeros(size(LOC,1),1);
for i=2:size(LOC,1)
    loc(i) = pdist([LOC(1,:);LOC(i,:)],'euclidean');
end
loc = loc + sum(LOC(1,:));

NBS.DATA(subj).PROCESSED(sess).MAT(:,2) = loc;
NBS.DATA(subj).PROCESSED(sess).MAT(:,3) = norm;
NBS.DATA(subj).PROCESSED(sess).MAT(:,4) = ori;
%assignin('base','NBS',NBS)

figure,
subplot(4,1,1),plot(ori),title(['orientation (' num2str(mean(ori)) ' +/-' num2str(std(ori)) '°)']), ylabel('[°]'), xlabel('[event]')
subplot(4,1,2),plot(norm),title(['normal (' num2str(mean(norm)) ' +/-' num2str(std(norm)) ')°']), ylabel('[°]'), xlabel('[event]')
subplot(4,1,3),plot(loc),title(['loc (' num2str(mean(loc)) ' +/-' num2str(std(loc)) ')mm']), ylabel('[mm eucld]'), xlabel('[event]')
subplot(4,1,4),plot(AMPS),title(['AMPS (' num2str(mean(AMPS)) ' +/-' num2str(std(AMPS)) ')mV']), ylabel('[mV]'), xlabel('[event]')

figure,
[THETA,RHO] = cart2pol(ORI(:,1),ORI(:,3)); %,ORIn(:,3));
subplot(2,2,1),compass(THETA,AMPS), title('orientation')
[THETA,RHO] = cart2pol(NORM(:,1),NORM(:,3));%,NORMn(:,3));
subplot(2,2,2), compass(THETA,AMPS), title('normal')
[THETA,RHO] = cart2pol(LOC(:,1),LOC(:,3));%,NORMn(:,3));
subplot(2,2,3), compass(THETA,AMPS), title('location')


% cnt = cnt+1;
% if cnt>7; cnt=1; end
% x = [Loc{1}(:,subj), Loc{2}(:,subj), Loc{3}(:,subj)];
% for i=1:size(x,1)
%     tmp(i) = atan2(norm(cross(x(1,:),x(i,:))),dot(x(1,:),x(i,:)));
%     %             compass(Z)
%     %             compass(x(i),:)
%     %             vectorinradians = vectorinangles * pi/180;
%     %             [x,y] = pol2cart(vectorinradians,vectormagnitude);
%     %             figure, compass(x,y)
%
%     %vectarrow([0 0 0],x(i+1,:),str{1})
% end
% anglebetweentwovectors(subj,:) = tmp;
% radiansbetweentwovectors(subj,:) = unwrap(tmp * pi/180);


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%songetfile
addpath(genpath(fullfile(fileparts(which('h_NBS')),'h_waves')))
h_waves



% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

addpath(fullfile(fileparts(which('h_NBS')),'h_EMG'))
h_EMG



% --------------------------------------------------------------------
function Data_Callback(hObject, eventdata, handles)
% hObject    handle to Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

go = 1;
while go > 0
    [filename, pathname] = uigetfile('*.mat', 'Pick a NBS.mat-file(s)','*.mat','MultiSelect','on');
    if isequal(filename,0) || isequal(pathname,0)
        disp('User pressed cancel')
        go = 0;
    else
        if iscell(filename)==0; filename = cellstr(filename); end
        cd(pathname)
        p = cellstr(repmat(pathname,length(filename),1));
        tmp = horzcat(char(p), char(filename));
        PF{go} = deblank(tmp);
        go = go+1;
    end
end

if go >1
    for subj=1:length(PF)
        cd(fileparts(PF{subj}))
        disp(['please wait loading ....' PF{subj}])
        load(deblank(PF{subj}))
        if length(NBS.GUI.subjects)>1  %NBS.GUI.subjects ++ NBS.FILENAMES
            [s,v] = listdlg('PromptString','Select a file:',...
                'SelectionMode','single','ListSize', [900 150], ...
                'ListString',NBS.GUI.subjects);
        else
            s = 1;
        end
        %%%%%%%%%
        GUI(subj) = NBS.GUI(s);
        DATA(subj) = NBS.DATA(s);
        PARAMS{subj} = NBS.PARAMS{s};
        FILENAMES{subj} = NBS.FILENAMES{s};
        CONFIG(subj) = NBS.CONFIG(s);
    end
    clear NBS
    NBS.GUI = GUI;
    NBS.PARAMS = PARAMS;
    NBS.FILENAMES = FILENAMES;
    NBS.CONFIG = CONFIG;
    NBS.DATA = DATA;
else
    cd(fileparts(PF{1}))
    disp(['please wait loading ....' PF{1}])
    load(deblank(PF{1}))
end

%%%%%%%%%%%%%%%%%%
% updates
%%%%%%%%%%%%%%%%%
for subj=1:length(NBS.GUI(1).subjects)
    
    if strmatch('cond = ',strvcat(NBS.CONFIG(subj).PARAMS{1}))
        NBS.CONFIG(subj).PARAMS{1} = strrep(NBS.CONFIG(subj).PARAMS{1},'cond','conds');
    end
    if strmatch('scl = ',strvcat(NBS.CONFIG(subj).PARAMS{1}))
        NBS.CONFIG(subj).PARAMS{1} = strrep(NBS.CONFIG(subj).PARAMS{1},'scl = 1;','scl1 = 1;');
    end
    if isempty(strmatch('offset =',strvcat(NBS.CONFIG(subj).PARAMS{1})))
        NBS.CONFIG(subj).PARAMS{1}{end+1} = ['offset = 0;'];
    end
    if isempty(strmatch('sgm =',strvcat(NBS.CONFIG(subj).PARAMS{1})))
        NBS.CONFIG(subj).PARAMS{1}{end+1} = ['sgm = 7;'];
    end
    if isempty(strmatch('radius =',strvcat(NBS.CONFIG(subj).PARAMS{1})))
        NBS.CONFIG(subj).PARAMS{1}{end+1} = ['radius = 100;'];
    end
end

assignin('base','NBS',NBS)


set(handles.popupmenu1,'str', NBS.GUI(1).subjects, 'val',1)
set(handles.listbox1,'str', NBS.CONFIG(1).PARAMS{1},'val',1)
%set(handles.stimex,'str',NBS.GUI(1).exams,'val',1);
set(handles.showseq,'str', NBS.GUI(1).sequences,'val',1);
set(handles.popupmenuSearchResults,'str',NBS.GUI(1).subjects, 'val',1);

disp('... done loading (see NBS variable in workspace)')

%     try
%         eval( NBS.PARAMS{1}{5})
%         for sess=1:length(A1)
%             textdata = evalin('base','textdata');
%             col2text = evalin('base',['NBS.GUI(' num2str(subj) ').col2text']);
%             row = strmatch(textdata(A1(sess,1)-11,2),col2text);
%             %[ind_data] = feval('get_indx',str{i},col2text);
%             t=textdata(((row):(row+4)),2);
%             seq_datastr{sess} = t{1};
%         end
%         set(handles.showseq,'str',seq_datastr)
%     catch
%         disp('could not set sequence descriptions - best guess textdata.mat and col2text.mat are missing')
%     end
set(gcbo,'checked','on')


% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

NBS = evalin('base','NBS');
str = get(handles.popupmenu1,'str');
val = get(handles.popupmenu1,'val');
try [a b c] = fileparts(str{val});
catch clear str, str{val} = 'edit'; c = '';
end
[filename, pathname] = uiputfile(strrep(str{val},c,'.mat'), 'Pick an mat-file');
if isequal(filename,0) || isequal(pathname,0)
    disp('User pressed cancel')
else
    disp(['User saved ', fullfile(pathname, filename)])
    NBS.GUI(1).subjects = get(handles.popupmenuSearchResults,'str');
    save(fullfile(pathname,filename),'NBS')
end
set(gcbo,'checked','on')
set(handles.autosave,'label',['... update (' fullfile(pathname, filename) ')'])
set(handles.autosave,'enable','on')


% --------------------------------------------------------------------
function Configuration_Callback(hObject, eventdata, handles)
% hObject    handle to Configuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function prepare_Callback(hObject, eventdata, handles)
% hObject    handle to prepare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dirname = uigetdir;
if dirname == 0,  return; end
try COMPARE = evalin('base','COMPARE'); end
ext = get(handles.fileextension,'label');
cd(dirname)
set(handles.resultsdirectory,'label',['resultsdirectory: ' dirname])
content = dir([dirname filesep '*', ext]);
if isempty(content), errordlg('No excel files found...'); return, end
for i = 1:1:size(content,1)
    match(i,1) = {getfield(content,{i,1},'name')};
end
try
    for i = 1:size(match,1)
        COMPARE.path_file((end+1),1:2) = {dirname, char(match(i,1))};
    end
catch
    for i = 1:size(match,1)
        if i == 1
            COMPARE.path_file(1,1:2) = {dirname, char(match(i,1))};
        else
            COMPARE.path_file((end+1),1:2) = {dirname, char(match(i,1))};
        end
    end
end
set(handles.popupmenuSearchResults,'str',COMPARE.path_file(:,2));
set(gcbo,'checked','on')
assignin('base','COMPARE',COMPARE);



% --------------------------------------------------------------------
function context_Callback(hObject, eventdata, handles)
% hObject    handle to context (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function Defaults_Callback(hObject, eventdata, handles)
% hObject    handle to Defaults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function changepath_Callback(hObject, eventdata, handles)
% hObject    handle to changepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(gcbo,'checked')
    case 'on'
        set(gcbo,'checked','off')
        str = get(handles.popupmenu1,'str');
        for i=1:length(str)
            [a b c] = fileparts(str{i});
            str{i} = which([b c]);
        end
        set(handles.popupmenu1,'str',str)
    case 'off'
        set(gcbo,'checked','on')
        % path
end


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% PHYSICAL PARAMETERS
NBS = evalin('base','NBS');
switch get(handles.printresults,'checked'), case 'on', NBS.defaults.print = 1; case 'off', NBS.defaults.print = 0; end

% directory
subjs = get(handles.popupmenu1,'str');
subj = get(handles.popupmenu1,'val');
subj = 1:length(NBS.DATA);

prompt={'detrend:','z-transsorm:','common length (data [1:NaN]):',...
    'subjects (NaN = all):','min. nr. successful MEPS','nr. bootstraps'};
name='Input for Peaks function';
numlines=1;
try defaultanswer = evalin('base','answer');
catch defaultanswer={'1','1','NaN','1', ' ','20','10'};
end
defaultanswer{4} = num2str(get(handles.popupmenu1,'val'));
answer=inputdlg(prompt,name,numlines,defaultanswer);
dtrnd = str2num(answer{1});
ztrnsfrm = str2num(answer{2});
dtlngths = str2num(answer{3});
subjsx = str2num(answer{4});
if isnan(subjsx) subjsx = 1:length(NBS.DATA); end
assignin('base','answer',answer)

nrbtrp = str2num(answer{6});
subjsess = 1;
ldr = 0;
for subj = subjsx;
    disp(subjs{subj})
    NBS.defaults.resultsPF = fullfile(cd,subjs{subj});
    %cd(NBS.PATHNAME)
    preprocess.detrend.linear = dtrnd;
    preprocess.ztransform = ztrnsfrm;
    for sess = 1:length(NBS.DATA(subj).PROCESSED)
        % setup parameters
        clear M2 M2d M2prestd
        M2 = NBS.DATA(subj).PROCESSED(sess).MAT;
        
        if find(M2(:,1)>0)<str2num(answer{5});
            disp(['empty MEP: ' num2str(subj) ' ' num2str(sess)])
        else
            disp(['found MEPs: ' num2str(subj) ' ' num2str(sess)])
            name = NBS.DATA(subj).PROCESSED(sess).names;
            preinn = 1; % exchange target for preinnervation
            try
                if preinn
                    PI = NBS.DATA(subj).RAW(sess).EMG(1).preinnervation;
                    try M2(:,end) = PI(1:size(M2,1));
                    catch M2(1:length(PI),end) = PI;
                    end
                    name{end} = 'prnnvtn';
                end%
            end
            % set dtlngth if full
            if isnan(dtlngths)
                dtlngth = size(M2,1);
            else
                dtlngth = dtlngths;
            end
            M2 = M2(1:dtlngth,:);
            %check for NaNs
            [x y] = find(isnan(M2));
            if isempty(x) ~=1
                eventcut = 1;
                if eventcut == 1;
                    xc = min(x)-1;
                    M2 = M2(1:xc,:);
                else
                    xy = 1:size(M2,2); xy(find(xy==mean(y)))=0;
                    M2 = M2(:,find(xy));
                end
            end
            %
            if preprocess.detrend.linear == 1;
                for i=1:size(M2,2);
                    M2d(:,i) = detrend(M2(:,i));
                end
            else
                M2d = M2;
            end
            if preprocess.ztransform == 1;
                % z-transfrorm
                clear M2prestd
                for i=1:size(M2d,2);
                    try M2prestd(:,i) = prestd(M2d(:,i));
                    catch M2prestd(:,i) = zscore(M2d(:,i));
                    end
                end
            else
                M2prestd = M2d;
            end
            M2prestd = M2prestd(1:dtlngth,:);
            
            % regress
            X = [M2prestd(1:end,[2:end]), ones(length(M2prestd(1:end,1)),1)];
            Y = M2prestd(1:end,1);
            [b,BINT,R,RINT,STATS] = regress(Y,X);
            [br,statsr]= robustfit(X(:,1:6),Y);
            [bs,se,pval,inmodel,stats] = stepwisefit(X,Y);
            disp('... please wait, bootstrapping')
            warning off
            [bootstat_r] = bootstrp(nrbtrp,@robustfit,X(:,1:6),Y);
            [bootstat_c] = bootstrp(nrbtrp,@corr,X(:,1:6),Y);
            warning on
            % try RESULTS = evalin('base','RESULTS'); end
            RESULTS.time(subjsess).datestr = datestr(now);
            RESULTS.Y{subjsess} = Y;
            RESULTS.X{subjsess} = X;
            RESULTS.regress_b(subjsess,:) = b;
            RESULTS.regress_BINT(subjsess,:) = BINT(:,1);
            RESULTS.regress(subjsess).stats = STATS;
            RESULTS.robustregress_b(subjsess,:) = br;
            RESULTS.robustregress_SE(subjsess,:) = statsr.se;
            RESULTS.robustregress(subjsess).stats = statsr;
            RESULTS.robustregressbootstrap_b(subjsess,:) = mean(bootstat_r);
            RESULTS.robustregressbootstrap_SE(subjsess,:) = std(bootstat_r)/1000;
            RESULTS.nrbootstraps = nrbtrp;
            %[fi,xi] = ksdensity(bootstat);
            %plot(xi,fi);
            
            %correlation
            [C P] = corrcoef(M2prestd);
            RESULTS.corrcoef(subjsess).C = C;
            RESULTS.corrcoef(subjsess).P = P;
            assignin('base','RESULTS',RESULTS)
            
            MEPy{subjsess} = Y;
            PPx{subjsess} = X;
            subjsess = subjsess+1;
            
            if ~any(BINT==0)~=1 & ldr == 0;
                msgbox('it seems that some of the columns are linearly dependent','Mutlple Regression:','warn')
                ldr = 1;
            end
            
            
            if NBS.defaults.ctrl == 1
                % display
                fig = figure; set(gcf,'pos',get(0,'ScreenSize'))
                set(gcf,'name','raw data')
                for i=1:size(M2,2)
                    subplot(size(M2,2),1,i)
                    plot(M2(:,i))
                    grid on
                    ylabel(name{i})
                    title('raw data')
                end
                if NBS.defaults.print
                    figcnt = 1;
                    print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig)
                    close(fig)
                end
                fig = figure; set(gcf,'pos',get(0,'ScreenSize'))
                set(gcf,'name','preprocessed data')
                for i=1:size(M2prestd,2)
                    subplot(size(M2prestd,2),1,i)
                    plot(M2prestd(:,i))
                    grid on
                    ylabel(name{i})
                end
                if NBS.defaults.print
                    figcnt = figcnt+1;
                    print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig)
                    close(gcf)
                end
                
                fig = figure; set(gcf,'pos',get(0,'ScreenSize'))
                subplot(2,2,1:2)
                [r c] = find(P<0.05);
                for ri = 1:length(r)
                    if c(ri)<=r(ri); c(ri) = 0; r(ri)=0; end
                end
                c = c(r>0); r = r(r>0);
                imagesc(C)
                text(r,c,'*');
                colorbar
                for i=1:length(name)
                    text(-0.5,i,name{i})
                end
                title('Correlations Matrix (*p<0.05)')
                axis off
                subplot(2,2,3)
                boxplot(bootstat_c)
                title(['Correlatons Boxplot (bootstrp)'])
                grid on
                subplot(2,2,4)
                boxplot(bootstat_r)
                title(['Robustfit Boxplot (bootstrp)'])
                grid on
                if NBS.defaults.print
                    figcnt = figcnt+1;
                    print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig)
                    close(fig)
                end
                
                
                fig = figure; set(gcf,'pos',get(0,'ScreenSize'))
                subplot(2,2,1)
                rcoplot(b,BINT)
                miniy = get(gca,'ylim');
                minib = (min(b)+ miniy(1));
                for i=2:length(name)
                    text(i-1,minib,name{i}(1:3),'color','w','HorizontalAlignment','center')
                end
                text(i,minib,'constant','color','w','HorizontalAlignment','center')
                ylabel('beta')
                title(['Regression (STATS: p [' num2str(STATS(3)) '], resVar [' num2str(STATS(4)) ']'])
                subplot(2,2,2)
                errorbar(bs,se,'*')
                hold on, grid on
                pind = find(pval<=0.05);
                if any(pind), errorbar(pind,bs(pind),se(pind),'r*'), end
                miniy = get(gca,'ylim');
                minib = (min(b)+ miniy(1))/2;
                for i=2:length(name)
                    text(i-1,minib,name{i}(1:3),'color','k','HorizontalAlignment','center')
                end
                text(i,minib,'constant','color','k','HorizontalAlignment','center')
                ylabel('beta')
                title(['Stepwise Regression'])
                subplot(2,2,3)
                errorbar(br,statsr.se,'*')
                hold on, grid on
                pind = find(statsr.p<=0.05);
                if any(pind), errorbar(pind,br(pind),statsr.se(pind),'r*'), end
                miniy = get(gca,'ylim');
                minib = (min(b)+ miniy(1));
                for i=2:length(name)
                    text(i-1,minib,name{i}(1:3),'color','k','HorizontalAlignment','center')
                end
                text(i,minib,'constant','color','k','HorizontalAlignment','center')
                ylabel('beta')
                title(['Robust Regression'])
                subplot(2,2,4)
                try
                    errorbar(RESULTS.robustregressbootstrap_b(subj,:),RESULTS.robustregressbootstrap_SE(subj,:),'*')
                    title('Robust Regression (bootstrap)')
                    ylabel('se')
                    grid on
                end
                if NBS.defaults.print
                    figcnt = figcnt+1;
                    print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig)
                    close(fig)
                end
                
                %%%%%%for publication (temp)
                fig = figure; set(gcf,'pos',get(0,'ScreenSize'))
                errorbar(br,statsr.se,'*')
                hold on, grid on
                pind = find(statsr.p<=0.05);
                if any(pind), errorbar(pind,br(pind),statsr.se(pind),'r*'), end
                miniy = get(gca,'ylim');
                minib = (min(b)+ miniy(1));
                for i=2:length(name)
                    text(i-1,minib,name{i}(1:3),'color','k','HorizontalAlignment','center')
                end
                text(i,minib,'constant','color','k','HorizontalAlignment','center')
                ylabel('beta')
                title(['Robust Regression'])
                %write
                pcd = cd;
                %pcd = ['\\helmholtz\Eigene Dokumente\Research\#Publications\1 Preparation\S2SV-PhysicalParameters\Abbildungen\Figures-PhysicalParameters\Figures-for Publication\robust_regression_not_detrended'];
                %cd('D:\Projects\TMS\NBS - PP\Figures-PhysicalParameters\robust_regression_full_detrended')
                cd(pcd)
                X=getframe(gcf);
                [a b c] = fileparts(subjs{subj});
                if isempty(X.colormap)
                    imwrite(X.cdata, ['timecourses-' strrep(subjs{subj},c,'.bmp')])
                else
                    imwrite(X.cdata, ['timecourses-' strrep(subjs{subj},c,'.tif')])
                end
                %%%%%%
                if NBS.defaults.print
                    figcnt = figcnt+1;
                    print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig)
                    close(fig)
                end
                
                fig = figure; set(gcf,'pos',get(0,'ScreenSize'))
                subplot(3,2,1:2)
                plot(M2prestd(:,1),'b'),hold on, plot(R,'.-k'), grid on
                ylabel('mV (prestd)'),
                title('MEPs (blue), Residuals (black)')
                subplot(3,2,3:4)
                rcoplot(R,RINT)
                subplot(3,2,5)
                boxplot(M2(:,1))
                title('MEPs (raw)')
                subplot(3,2,6)
                boxplot([M2prestd(:,1),R])
                title(['MEPs (1) & Rsdls (' num2str(STATS(4)) ') --> ' num2str([1-STATS(4)]*100) '% reduction of MEP variance'])
                if NBS.defaults.print
                    figcnt = figcnt+1;
                    print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig)
                    close(fig)
                end
                
                ORI = NBS.DATA(subj).RAW(sess).PP.data(:,7:9);
                NORM = NBS.DATA(subj).RAW(sess).PP.data(:,4:6);
                LOC = NBS.DATA(subj).RAW(sess).PP.data(:,1:3);
                fig = figure; set(gcf,'pos',get(0,'ScreenSize'))
                [THETA,RHO] = cart2pol(ORI(:,1),ORI(:,3)); %,ORIn(:,3));
                subplot(2,2,1),compass(THETA,RHO), title('orientation')
                [THETA,RHO] = cart2pol(NORM(:,1),NORM(:,3));%,NORMn(:,3));
                subplot(2,2,2), compass(THETA,RHO), title('normal')
                [THETA,RHO] = cart2pol(LOC(:,1),LOC(:,3));%,NORMn(:,3));
                subplot(2,2,3), compass(THETA,RHO), title('location')
                if NBS.defaults.print
                    figcnt = figcnt+1;
                    print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig)
                    close(fig)
                end
                
                try
                    fig = figure;
                    fs = 0.33;
                    ns = 8; % number of sinusoide
                    sl = 50; % segmentlength
                    ol = 49; % overlap length
                    wn = 'boxcar'; %'rectangular',{'chebyshev',60}; % window
                    st = 2; % subspace thresh_hld
                    nfft = 1024; % nfft
                    %h = spectrum.music(8);    % Instantiate a music object.
                    subplot(3,1,1)
                    pmusic(M2prestd(:,1),ns,nfft,fs,sl,ol);
                    title('MEPs: Pseudospectrum Estimate via MUSIC')
                    subplot(3,1,2)
                    pmusic(R,ns,nfft,fs,sl,ol);
                    title('Residuals: Pseudospectrum Estimate via MUSIC')
                    subplot(3,1,3)
                    try
                        [s1, f] = pmusic(M2prestd(:,1),ns,nfft,fs,sl,ol);
                        [s2, f] = pmusic(R,ns,nfft,fs,sl,ol);
                        s3 = s2-s1;
                        plot(f,s3),
                        axis tight
                        grid on
                        title('Difference Spectrum (Res-MEPS)')
                    catch
                    end
                    if NBS.defaults.print
                        figcnt = figcnt+1;
                        print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig)
                        close(fig)
                    end
                catch
                    close(gcf)
                end
            end
        end
    end
end
disp('DONE')

NBS.defaults.ctrl =1;
NBS.defaults.resultsPF = fullfile(cd,'GROUP-RESULTS-removed-zeromeps');
% GROUP RESULTS?
if length(RESULTS.Y)>1
    RESULTS = evalin('base','RESULTS');
    names = name(2:end);
    names{end+1} = 'constant';
    % first level
    Y = cat(1,MEPy{:});
    X = cat(1,PPx{:});
    [b,BINT,R,RINT,STATS] = regress(Y,X);
    disp(STATS)
    [br,statsr]= robustfit(X(:,1:6),Y);
    if NBS.defaults.ctrl
        fig = figure; set(gcf,'pos',get(0,'ScreenSize'))
        plot(br,'*'), hold on
        plot(find(statsr.p <0.05),br(find(statsr.p <0.05)),'r*')
        title('Betas for Robust Fit (group - 1st level)')
        set(gca,'xticklabel',names)
        if NBS.defaults.print
            figcnt = figcnt+1;
            print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig)
        end
    end
    % second level
    D = RESULTS.robustregress_b;
    [h p] = ttest(D);
    if any(find(p))
        ind = find(h);
        for indx = 1:length(ind);
            names{indx} = [names{indx} 'sig!'];
        end
    end
    if NBS.defaults.ctrl
        fig = figure; set(gcf,'pos',get(0,'ScreenSize'))
        boxplot(D,'labels',names)
        title('Betas for Robust Fit (group - 2nd level)')
        
        if NBS.defaults.print
            figcnt = figcnt+1;
            print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig)
        end
    end
    
    [th tp] = ttest(D);
    for i=1:size(D,2)
        [wp(i) wh(i)] = signrank(D(:,i));
    end
    % mean and variance
    for subjsess = 1:length(RESULTS.Y)
        resm(subjsess) = mean(RESULTS.robustregress(subjsess).stats.resid);
        rawm(subjsess) = mean(RESULTS.Y{subjsess});
        resv(subjsess) = var(RESULTS.robustregress(subjsess).stats.resid);
        rawv(subjsess) = var(RESULTS.Y{subjsess});
    end
    
    %correlation
    clear C P
    cnt = 0;
    for subjsess = 1:length(RESULTS.Y)
        cnt = cnt+1;
        C(cnt,:,:) = RESULTS.corrcoef(subjsess).C;
        P(cnt,:,:) = RESULTS.corrcoef(subjsess).P;
    end
    Ac = reshape(median(C,1),7,7);
    Ap = reshape(median(P,1),7,7);
    % stats
    try
        for i = 1:7;
            for ii = 1:7;
                [h, p] = signrank(C(:,i,ii));
                Ch(i,ii) = h;
                Cp(i,ii) = p;
            end
        end
        if NBS.defaults.ctrl
            fig = figure; set(gcf,'pos',get(0,'ScreenSize')),
            imagesc(Ac), colorbar,
            title('Cross Correlation (Group - 1st Level)')
            set(gca,'xticklabel',name)
            if NBS.defaults.print
                figcnt = figcnt+1;
                print('-dtiff',['-r' num2str(NBS.defaults.printres)],'-cmyk',[NBS.defaults.resultsPF '_' num2str(figcnt)], fig)
            end
        end
        [x y] = find(Cp);
        C(:,3,4) % would be significant except for extrema
        hold on, plot(x,y,'w*')
    catch
        errordlg(lasterr)
    end
    msgbox([num2str(length(RESULTS.Y)) ' - subject x sessions'])
end

%save NBSTMS NBS
%h_NBSTMS

% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

MNMZ;
NBS = CREATE4D('recruitment curve');

ARR = CMPL4D(NBS);

SZ = size(ARR);

x = 1;

for i = SZ(2):SZ(2)
    
    for j = 1:SZ(3)
        AMPS = cell2mat(ARR(1,i,j,7));
        
        if isempty(AMPS)
            break;
        end
        
        MSO = cell2mat(ARR(1,i,j,5));
        
        %sort by MSO
        MSO = MSO(:,logical(max(mean(MSO,1)) == mean(MSO,1)));
        
        [MSO IDX] = sort(MSO,'ascend');
        AMPS = AMPS(IDX,:);
        
        ARR(1,i,j,7) = {AMPS};
        
        %yet just the strongest channel
        %AMPS = AMPS(:,logical(max(mean(AMPS,1)) == mean(AMPS,1)));
        %NOT HERE!!!
        
        %search for step increment, think of 10% increments first
        %get number of steps
        STPS = unique(MSO);
        
        
        
        ANSW = inputdlg({char([{'Sequence starts with how many % RMT?'; '(default 100% RMT)'}]);...
            char([{'Increment is: (default 10%)'; 'The tool will try to fit your data to the bins!'}])},...
            'RC def',1, {num2str([100]); num2str([10])});
        
        if isempty(ANSW)
            disp('Process cancelled by user');
            return;
        end
        
        ANSW = [str2double(cell2mat(ANSW(1,1))) str2double(cell2mat(ANSW(2,1)))];
        
        STPMIN = floor((STPS(1,1)/(ANSW(1,1)/100))*(ANSW(1,2)/100)) - 1;
        
        INCR = ((STPS(1,1)/(ANSW(1,1)/100))*(ANSW(1,2)/100));
        
        %fix errors by MSO that differ less than lowest step size
        for z = 1:(length(STPS) - 1)
            
            
            if (z+1) > length(STPS)
                break;
            end
            
            if abs(STPS(z) - STPS(z+1)) < STPMIN
                IDX = ones(1,length(STPS));
                IDX(z+1) = 0;
                
                MSO(logical(MSO(:,1) == STPS(z+1)),1) = STPS(z);
                STPS = STPS(logical(IDX));
            end
        end
        
        
        
        CMPARR = [];
        EXT = 0;
        for k = 1:length(STPS)
            
            if EXT == 1;
                break;
            end
            
            cnt = 0;
            if k > 1
                
                MSO1 = round(STPS(1,1) + INCR*(k-1));
                MSO2 = unique(MSO(logical(STPS(k) == MSO),:));
                
                tic;
                
                while abs(MSO1 - MSO2) > STPMIN && toc < 3
                    %ergo wenn Abweichung voneinander mehr als 2, ist inkrement
                    %auch durch rundung nicht zu erklaeren
                    k = k + 1;
                    cnt = cnt + 1;
                    MSO1 = round(STPS(1,1) + INCR*(k-1));
                    
                    if k > (length(STPS)*2)
                        EXT = 1;
                        break;
                    end
                    
                end
            end
            
            IDX = logical(STPS(k-cnt) == MSO);
            CMPARR((end + 1) : (end + sum(IDX)) ,:) = [MSO(IDX,:),...
                mtimes(ones(sum(IDX),1),(ANSW(1,1) + (k-1)*ANSW(1,2)))];
            
        end
        
        %Is following automatically found assignment correct?
        RES = [unique(CMPARR(:,1)) unique(CMPARR(:,2))];
        PRMPT = {};
        for h = 1:size(RES,1)
            PRMPT(end+1,:) = {num2str(RES(h,1)) num2str(RES(h,2))};
        end
        
        ANSW = inputdlg([{char({'Is following automatic assignment correct?'; ' '; char(PRMPT(1,1))})}; PRMPT(2:end,1)],...
            'in %',1,PRMPT(:,2));
        
        if isempty(ANSW)
            disp('Process cancelled by user');
            return;
        end
        
        for h = 1:size(RES,1)
            CMPARR(logical(CMPARR == RES(h,1)),2) = str2double(cell2mat(ANSW(h,1)));
        end
        
        ARR(1,i,j,5) = {CMPARR};
        
    end
    
end

NBS.ANALYSIS.MTRX(strmatch('recruitment',NBS.ANALYSIS.MTRXhdr(:,1)),1:SZ(2),:,:) = ARR;
assignin('base','NBS',NBS);

feval('evaltype_Callback',handles.evaltype,0,handles);

%SEINS Version
% emgchnnls = [3 9] ;
%
% NBS = evalin('base','NBS');
% filename = get(handles.popupmenu1,'str');
% subj = get(handles.popupmenu1,'val');
% seqstr = get(handles.showseq,'str');
%
% % quick and dirty
% % try
% %     MSO = RC.mso;
% %     rmts = RC.rmts;
% % catch
% %     PRMS = NBS.CONFIG(subj).PARAMS{1};
% %     ind = strmatch('A1', strvcat(PRMS));
% %     eval(PRMS{strmatch('A1', strvcat(PRMS))});
% %     rmts = [100];
% %     [names sind] = sort(rmts);
% %     for i=1:size(A1,1)
% %         MSO(1:16,i) = zeros(16,1);
% %         tmp = xlsread(filename{subj},['G' num2str(A1(i,1)) ':G' num2str(A1(i,2)) ]);
% %         if length(tmp)>16; tmp = tmp(1:16); end %sometime there were more then sixteen (e.g. seventeen)
% %         MSO(1:length(tmp),i) = tmp;
% %         rmts(end+1) = rmts(end)+10;
% %     end
% %     rmts = rmts(1:end-1);
% % end
% for sess=1:size(seqstr,1)
%     if NBS.DATA(subj).RAW(sess).PP.data(1) > 50
%         emgchl = emgchnnls(1);disp('LH') %3
%     else
%         emgchl = emgchnnls(2);disp('RH')
%     end
%     AMPS{sess} = NBS.DATA(subj).RAW(sess).AMPS(:,emgchl);
%     MSO{sess} = NBS.DATA(subj).RAW(sess).MSO(:,1);
%     RMT{sess} = cat(1,100,find(diff(MSO{sess}))+100);
% end
% % sort
% for sess = 1:size(seqstr,1)
%     [temp ind] = sort(MSO{sess});
%     MSO{sess} = MSO{sess}(ind);
%     AMPS{sess} = AMPS{sess}(ind);
% end
% % make matrix
% clear mso amp rmt
% for sess = 1:size(seqstr,1)
%     ind = [1;find(diff(MSO{sess}));length(MSO{sess})];
%     for i = 1:length(ind)-1
%         disp(ind(i+1))
%         mso(i,sess) = median(MSO{sess}(ind(i):ind(i+1)));
%         amp(i,sess) = median(AMPS{sess}(ind(i):ind(i+1)));
%         rmt(i,sess) = RMT{sess}(i);
%     end
% end
% RC.mso = mso;
% RC.amp = amp;
% RC.rmt = RMT;
%
% NBS.RESULTS(subj).RC = RC;
% assignin('base','NBS',NBS);
%
%
% % results (can also be run in base workspace - in work)
% RC = NBS.RESULTS(subj).RC;
% for sess=1:size(RC.mso,2)
%     figure, plot(mso(:,sess),amp(:,sess),'*')
% end
%
% return
%
% figure,
% boxplot(RC.mso{sess})
% set(gcf, 'name',filename{subj})
% set(gca,'xtickLabelMode','auto', 'xtickmode','auto')
% set(gca,'xtick', sind,'xticklabel', MSO(end,sind))
% xlabel('MSO (%RMT)'),
% ylabel('µV'),
% title('RC')
% grid on
% xlim = get(gca,'xlim');
% assignin('base','NBS',NBS)
%
% try
%     figure,
%     set(gcf,'name', filename{subj})
%     indx = MSO(end,sind);
%     subplot(2,2,1)
%     errorbar(indx, median(A),std(A),'*')
%     %boxplot(A,sd')
%     MT = evalin('base','MT');
%     mV = MT.mV;
%     % boxplot(MT.MSO,'orientation','horizontal')
%     [val ind] = sort(mV);
%     subplot(2,2,2)
%     hold on
%     errorbar(sort(mV),median(MT.MSO),std(MT.MSO),'r*')
%     plot(sort(mV), MT.f, 'g*')
%     subplot(2,2,3:4)
%     hold on
%     errorbar(indx, median(A),std(A),'*')
%     plot(median(MT.MSO),sort(mV),'r*')
%     plot(MT.f,sort(mV), 'g*')
%     tx = median(MT.MSO);
%     sd = std(MT.MSO);
%     mV = sort(mV);
%     for i=1:length(tx)
%         ln = [tx(i)-sd(i):tx(i)+sd(i)];
%         line(ln, ones(1,length(ln))*mV(i),'color','r')
%     end
%     legend({'RC%RMT','RCmV(median)','RCmV(mtat)'},'location','Best')
%     [a b c] = fileparts(filename{subj});
%     title([strrep(b,'_','-') ': (Bonus: Synopsis of RC and MT!!!!)'])
%     grid off
%     pY = median(A);
%     pX = indx;
%     [p,S,MU] = polyfit(pX,pY,3);
%     f = polyval(p,pX,[ ], MU);
%     sse = sum(f-pX);
%     plot(pX,pY,'co',pX,f,'c-')
%     subplot(2,2,1)
%     title('RC')
%     hold on
%     plot(pX,pY,'co',pX,f,'c-')
%     subplot(2,2,3:4)
%     hold on
%     pY  = median(MT.MSO)';
%     pX = sort(mV);
%     [p,S,MU] = polyfit(pX,pY,3);
%     f = polyval(p,pX,[ ], MU);
%     sse = sum(f-pX);
%     plot(pY,pX,'mo',f,pX,'m-')
%     subplot(2,2,2)
%     title('MT')
%     hold on
%     plot(pX,pY,'mo',pX,f,'m-')
% catch
%     warndlg(lasterr)
%     pause(2), drawnow
%     close(gcf)
% end



% --- Executes on button press in pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

MNMZ;
NBS = CREATE4D('thresholds');
ARR = CMPL4D(NBS);

SZ = size(ARR);

for i = SZ(2):SZ(2)
    
    for j = 1:SZ(3)
        
        if isempty(ARR{1,i,j,1})
            break;
        end
        
        TMPtag = char(ARR(1,i,j,1));
        TMPmso = ARR{1,i,j,5};
        
        DLM = regexp(TMPtag,' ');
        DLM = [0 DLM (length(TMPtag) + 1)];
        
        GT = [];
        for k = 1:(length(DLM) -1)
            TMP = str2double(TMPtag(DLM(k) + 1: DLM(k+1) - 1));
            if ~isempty(TMP) && ~isnan(TMP)
                GT(end+1,1) = TMP;
            end
        end
        
        GT = GT(find(GT > 10),:);
        
        GT = median(GT);
        
        if abs(GT - max(TMPmso(end,:))) > (GT*0.05)
            
            ANSW = inputdlg({char({'Mismatch betweens tag and MSO output:'; ' '; TMPtag;...
                ['last MSO line is ' num2str(TMPmso(end,:))];' '; 'Which one should be used?';...
                ' '; num2str(GT)}); num2str(max(TMPmso(end,:)))},...
                'Threshold',1,{'1','0'});
            
            if isempty(ANSW)
                disp('Process cancelled by user...');
                return;
            end
            
            ANSW = str2num(cell2mat(ANSW));
            
            if ANSW(1,1) == 0  % ALso doch die letzte Zeile von MSO verwenden
                GT = max(TMPmso(end,:));
            end
        end
        
        ARR(1,i,j,5) = {GT};
        
    end
end

NBS.ANALYSIS.MTRX(strmatch('threshold',NBS.ANALYSIS.MTRXhdr(:,1)),1:SZ(2),:,:) = ARR;

assignin('base','NBS',NBS);

feval('evaltype_Callback',handles.evaltype,0,handles);

%SEINS VERSION
% NBS = evalin('base','NBS');
% subj = get(handles.popupmenu1,'str');
% val = get(handles.popupmenu1,'val');
% PRMS = NBS.CONFIG(val).PARAMS{1};
% ind = strmatch('A1', strvcat(PRMS));
% eval(PRMS{ind});
%
% try
%     MT = NBS.ANALYSES(val).MT;
%     mV = MT.mV;
%     MSO = MT.mso;
% catch
%     strtmp = {'50','250','500','1000'};
%     for i=1:size(A1,1)
%         try str{i} = strtmp{i};
%         catch str{i} = '';
%         end
%         prompt{i} = num2str(i);
%     end
%
%     name='Input for Peaks function';
%     numlines=1;
%     defaultanswer=str;
%     answer=inputdlg(prompt,name,numlines,defaultanswer);
%     if isempty(answer), return, end
%
%     mV = str2num(strvcat(answer{:}));
%     MT.mV = mV;
%     for i=1:size(A1,1)
%         disp(i)
%         MSO(1:16,i) = zeros(16,1);
%         tmp = xlsread(subj{val},['G' num2str(A1(i,1)) ':G' num2str(A1(i,2)) ]);
%         if length(tmp)>16; tmp = tmp(1:16); end %sometime there were more then sixteen (e.g. seventeen)
%         MSO(1:length(tmp),i) = tmp;
%     end
% end
% MT.mso = MSO;
%
% for i=1:size(A1,1)
%     AMPS(1:16,i) = zeros(16,1);
%     tmp = NBS.DATA(val).RAW(i).AMPS(:,3);
%     if length(tmp)>16; tmp = tmp(1:16); end %sometime there were more then sixteen (e.g. seventeen)
%     AMPS(1:length(tmp),i) = tmp;
% end
% %
% clear f
% for i = 1:size(MSO,2)
%     t = [100;   MSO(find(AMPS(:,i)>50),i)];
%     g = [0.001; MSO(find(AMPS(:,i)<50),i)];
%     % "hunting" estimates the thresh_hld value based on a Maximum-Likelihood
%     %stimation,considering a cumulative gaussian distribution of the variable.
%     %The minimization procedure is done by "fminbnd" and the cummulative
%     %function by "quad".
%     f(i) = hunting(t,g);
% end
% % sort by mV
% [mV ind] = sort(mV);
% MSO = MSO(:,ind);
% mV = mV(ind);
% f = f(ind);
%
%
%
% figure,
% set(gcf, 'name',subj{val})
% subplot(1,2,1);
% plot(f,'*') %hist(MSO)
% set(gca,'xticklabel', mV)
% %ylim([40 max(max(MSO))+10])
% ylabel('MSO'), xlabel('µV'), title('Awiskus')
% grid on
% subplot(1,2,2)
% boxplot(MSO)
% set(gca,'xtick',[1:length(mV)],'xticklabel', mV)
% %ylim([40 max(max(MSO))+10])
% ylabel('MSO'), xlabel('µV'), title('Boxplot(MSO''s)')
% grid on
%
% MT.f = f;
% MT.MSO = MSO;
% NBS.ANALYSES(val).MT = MT;
% assignin('base','MT',MT)
% assignin('base','NBS',NBS)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f=hunting(t,g)
% "hunting" estimates the thresh_hld value based on a Maximum-Likelihood
%stimation,considering a cumulative gaussian distribution of the variable.
%The minimization procedure is done by "fminbnd" and the cummulative
%function by "quad".
f=fminbnd(@loglik,0.001,100,[],t,g);

function y=loglik(x,mes,mef)
for k=1:numel(x)
    y(k)=-((sum(real(log(((c_gaus(mes,x(k),x(k).*0.07)))))))+sum(real(log((1-c_gaus(mef,x(k),x(k).*0.07))))));
end

function y=c_gaus(x,med,des)
%c_gaus(x,med,des) estima empiricamente el valor de la pro-
%vabilidad acumulada del evento "x", con una media de "med"
%y una desviacion estandar de "des".
% Utiliza quad, asumiendo que la probabilidad acumulada de
%la mediana es siguiendo una curva gaussiana 0.5, que se.
for m=1:numel(med)
    for k=1:numel(x)
        if x(k)==med
            y(k,m)=0.5;
        else
            q(k,m)=quad(@mi_gaus,med(m),x(k),[],[],med(m),des);
            y(k,m)=q(k,m)+0.5;
        end
    end
end

function y=mi_gaus(x,med,des)
F=exp(-(((x-med).^2)./(2.*(des.^2))))./((sqrt(2.*pi)).*des);
y=F;
return



%









% --------------------------------------------------------------------
function MEPpre_Callback(hObject, eventdata, handles)
% hObject    handle to MEPpre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function orthogonalize_Callback(hObject, eventdata, handles)
% hObject    handle to orthogonalize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(gcbo,'checked')
    case 'on', set(gcbo,'checked','off')
    case 'off', set(gcbo,'checked','on')
end

% --------------------------------------------------------------------
function MEPlargest_Callback(hObject, eventdata, handles)
% hObject    handle to MEPlargest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(gcbo,'checked')
    case 'on', set(gcbo,'checked','off')
    case 'off', set(gcbo,'checked','on')
end

% --------------------------------------------------------------------
function MEPoutliers_Callback(hObject, eventdata, handles)
% hObject    handle to MEPoutliers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(gcbo,'checked')
    case 'on', set(gcbo,'checked','off')
    case 'off', set(gcbo,'checked','on')
end



% --------------------------------------------------------------------
function autosave_Callback(hObject, eventdata, handles)
% hObject    handle to autosave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

NBS = evalin('base','NBS');
str = get(handles.autosave,'label');
save(str(13:end-1),'NBS')
disp(['... done udating: ' str(13:end-1)])


% --------------------------------------------------------------------
function MAPpreprocessing_Callback(hObject, eventdata, handles)
% hObject    handle to MAPpreprocessing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MAPortho_Callback(hObject, eventdata, handles)
% hObject    handle to MAPortho (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(gcbo,'checked')
    case 'on', set(gcbo,'checked','off')
    case 'off', set(gcbo,'checked','on')
end

% --------------------------------------------------------------------
function MAPdeconvolution_Callback(hObject, eventdata, handles)
% hObject    handle to MAPdeconvolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(gcbo,'checked')
    case 'on', set(gcbo,'checked','off')
    case 'off', set(gcbo,'checked','on')
end

% --------------------------------------------------------------------
function MAPconvolution_Callback(hObject, eventdata, handles)
% hObject    handle to MAPconvolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(gcbo,'checked')
    case 'on', set(gcbo,'checked','off')
    case 'off', set(gcbo,'checked','on')
end

% --------------------------------------------------------------------
function MAPcontrast_Callback(hObject, eventdata, handles)
% hObject    handle to MAPcontrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(gcbo,'checked')
    case 'on', set(gcbo,'checked','off')
    case 'off', set(gcbo,'checked','on')
end

% --------------------------------------------------------------------
function MAPgridfitting_Callback(hObject, eventdata, handles)
% hObject    handle to MAPgridfitting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(gcbo,'checked')
    case 'on', set(gcbo,'checked','off')
    case 'off', set(gcbo,'checked','on')
end

% --------------------------------------------------------------------
function MAPglm_Callback(hObject, eventdata, handles)
% hObject    handle to MAPglm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(gcbo,'checked')
    case 'on', set(gcbo,'checked','off')
    case 'off',
        set(gcbo,'checked','on')
        set(handles.cclinear,'checked','on')
end

% --------------------------------------------------------------------
function MAPsim_Callback(hObject, eventdata, handles)
% hObject    handle to MAPsim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.cclinear,'checked','off')
set(handles.ccamp,'checked','off')
set(handles.cclog,'checked','off')



% --------------------------------------------------------------------
function ctrlplts_Callback(hObject, eventdata, handles)
% hObject    handle to ctrlplts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NBS = evalin('base','NBS');
switch get(gcbo,'checked')
    case 'on', set(gcbo,'checked','off')
        NBS.defaults.ctrl = 0;
    case 'off', set(gcbo,'checked','on')
        NBS.defaults.ctrl = 1;
end
assignin('base','NBS',NBS)

% --------------------------------------------------------------------
function printresults_Callback(hObject, eventdata, handles)
% hObject    handle to printresults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NBS = evalin('base','NBS');
switch get(gcbo,'checked')
    case 'on', set(gcbo,'checked','off')
        NBS.defaults.print = 1;
        NBS.defaults.printres = 72;
    case 'off', set(gcbo,'checked','on')
        NBS.defaults.print = 0;
end
assignin('base','NBS',NBS)

% --------------------------------------------------------------------
function MAPscatter_Callback(hObject, eventdata, handles)
% hObject    handle to MAPscatter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in pushbutton32.
function pushbutton32_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% subject specific maps
NBS = evalin('base','NBS');
subj = 1;
scl1 = 1;  %mm*scl11 e.g. 10.12 mm is rounded to 10, if scl1 = 10, then works withs 101
% analyses
scl2 = 1; %mm*scl2 for fitting over euclidean distance from CoG

switch get(handles.ctrlplts,'checked')
    case 'on', NBS.defaults.ctrl = 1; case 'off', NBS.defaults.ctrl = 0;
end
NBS.polyctrl = 0; % shows each individ. polyfit for glm (default no!)
switch get(handles.printresults,'checked')
    case 'on', NBS.defaults.print = 1; case 'off', NBS.defaults.print = 0;
end

PRMS = NBS.PARAMS{subj};
eval(PRMS{strmatch('conds', strvcat(PRMS))});
eval(PRMS{strmatch('A1', strvcat(PRMS))});
eval(PRMS{strmatch('sgm', strvcat(PRMS))});
eval(PRMS{strmatch('radius', strvcat(PRMS))});
NBS.hotspotradius = radius; % mm / for euclidean and MLR (linear or log (sgm) fit)
NBS.sgm = sgm;

% read NBS excel
for sess = 1:size(A1,1);
    disp(['... session: ' num2str(A1(sess,:))])
    try
        textdata = evalin('base','textdata');
        col2text = evalin('base',['NBS.GUI(' num2str(subj) ').col2text']);
        row = strmatch(textdata(A1(sess,1)-11,2),col2text);
        %[ind_data] = feval('get_indx',str{i},col2text);
        t=textdata(((row+1):(row+3)),2);
        seq_datastr = strrep(t{3},'Sequence Description: ','');
        clear textdata col2text row t
    catch
        seq_datastr = '... no sequence data';
    end
    
    %AMPS & PP
    A_pastespecial = NBS.DATA(subj).RAW(sess).AMPS;
    [A_thresh] = A_pastespecial(:,conds); % update may 2009
    A_thresh(A_thresh<50) = 0;
    A_pastespecial(:,conds) = A_thresh;
    if ~any(A_pastespecial); errordlg(['no MEPs in session ' num2str(sess) '(' ['AA' num2str(A1(sess,1)) ':AF' num2str(A1(sess,2))] ') trip catch ...']), tripcatch = 'go'; end
    LOC = NBS.DATA(subj).RAW(sess).PP.data(:,10:12); % or 1:3
    if size(LOC,1)~=3; LOC = LOC'; end
    % check for outliers
    tmp = mean(LOC([1,3],:));
    outlrs = find(tmp > mean(tmp)+3*std(tmp) | tmp < mean(tmp)-3*std(tmp));
    inlrs = ones(1,length(tmp)); inlrs(outlrs) = 0; inlrs = find(inlrs);
    if isempty(outlrs) ~= 1;
        fig = figure; set(gcf,'pos',get(0,'ScreenSize'))
        plot(tmp),hold on, plot(outlrs, tmp(outlrs),'r*')
        title(['outlier(s > 3 std found - removing ' num2str(length(outlrs)) ' LOCATION(S) ...'])
        drawnow, pause(1)
        A_pastespecial = (A_pastespecial(inlrs,:));
        LOC = LOC(:,inlrs);
    end
    % find REFERENCE
    refind = find(min(LOC)== min(min(LOC)));
    REF = LOC(:, refind(1))';
    ref = min(LOC');
    refdiff = max(diff([ref; REF]));
    REF = REF - refdiff;
    
    %%%%%%%%%%%
    % check if you should scale --> takes much! longer maybe
    LOCcheck = length(find(sum(diff(round(LOC)')')==0));
    if LOCcheck > 0;
        m1 = msgbox(['rounding LOCATIONS --> loss of ' num2str(LOCcheck) '/' num2str(length(LOC)) ' (LOCATIONS)'], 'you might want to set scl1/2 to 10','warn');
        drawnow
        pause(3)
        try close(m1), end
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    %%% START
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tic;
    clear LOCn Ms LA Ecld CoG
    for cnd = 1:length(conds);
        AMPS = A_pastespecial(:,conds(cnd)); %1,3,5
        LOCn(1,:)=LOC(1,:)-REF(1);
        LOCn(2,:)=LOC(2,:)-REF(2);
        LOCn(3,:)=LOC(3,:)-REF(3);
        X=LOCn(1,:);
        Y=LOCn(3,:);
        Z=LOCn(2,:);
        
        %  BASICS
        M = zeros(ceil(max(Y)*scl1),ceil(max(X)*scl1)); % matrix in micrometers
        for i=1:length(AMPS)
            M(round([Y(i)+1]*scl1),round([X(i)+1]*scl1))=AMPS(i);
        end
        % correct if is empty
        if ~any(M);
            M(1,1) = -100;
        end
        Mb = zeros(200);
        [yx] = ceil(diff([size(M);size(Mb)])/2);
        Mb([yx(1):size(M,1)-1+yx(1)],[yx(2):size(M,2)-1+yx(2)])=M;
        M = Mb; clear Mb
        % default kernal %matrix
        h = fspecial('log',[NBS.hotspotradius*scl1 NBS.hotspotradius*scl1],NBS.sgm*scl1)*-1000000;
        %h = [h + abs(min(min(h)))];
        Ms = imfilter(M,h,'same');
        Ms(isnan(Ms)) = 0;
        if sum(sum(Ms))~=0;
            Ms = Ms.*[max(max(M))/max(max(Ms))];
            Ms(isnan(Ms)) = 0;
        end
        % display default filter kernerl
        f1 = figure; set(gcf,'pos',get(0,'ScreenSize'))
        subplot(2,3,1)
        plot(mean(h))
        subplot(2,3,2)
        imagesc(h)
        title(['default' ,...
            ' - radius: ' num2str(NBS.hotspotradius),...
            ', sgm: ' num2str(NBS.sgm)]);
        subplot(2,3,4)
        title(seq_datastr)
        imagesc(M),
        colorbar
        xlabel(['found: ' num2str(length(find(AMPS>50))) '/' num2str(length(AMPS)) ])
        subplot(2,3,5)
        imagesc(Ms)
        title(['default (Area:' num2str(bwarea(Ms(find(Ms>0))))  ', Groups:' num2str(bweuler(Ms)) ')'])
        % area games
        %figure, harea = area(Ms);
        %[a] = polyarea(X,Y);
        %Mx = Ms;
        %Ml = bwlabel(Mx,8);
        %Mx = bwareaopen(Mx,32); % remove clusters <33 Voxel
        % identify groups
        % A = bwarea(Ms(find(Ms)));
        % bweuler(Mx)
        
        cf = h_erfcfit(1:length(mean(M)),mean(M));
        suggestedsigma = cf.c/1.38*2/scl1;
        h = fspecial('log',[NBS.hotspotradius*scl1 NBS.hotspotradius*scl1],abs(suggestedsigma)*scl1)*-1000000;
        %h = [h + abs(min(min(h)))];
        subplot(2,3,3)
        imagesc(h)
        title(['adaptive' ,...
            '- radius: ' num2str(NBS.hotspotradius),...
            ', sgm: ' num2str(suggestedsigma)]);
        subplot(2,3,1)
        hold on,
        plot(mean(h),'r');
        legend({'def.','adapt.'},'location','best')
        title(seq_datastr)
        Ms = imfilter(M,h,'same');
        figure(f1)
        subplot(2,3,6)
        imagesc(Ms)
        title(['default (Area:' num2str(bwarea(Ms(find(Ms>0))))  ', Groups:' num2str(bweuler(Ms)) ')'])
        
        
        % collect MAPS
        MAPS.M(cnd).map = M;
        % collect CoGs
        clear LA
        % CoG  miranda 1997
        for i=1:3; LA(:,i) = LOCn(i,:)'.*AMPS; end
        CoG(cnd).REF = REF;
        CoG(cnd).raw  = feval('h_CoG',M);
        feval('h_CoD',AMPS,ORNTRNG);;
    end
    
    goindepth = 0;
    if goindepth == 1
        % SECOND PART -- get better results ( e.g. for two peaks)
        %%%%%%%%
        Ptrns = A_pastespecial(:,[1,3,5]);
        
        tic;
        conds = [1 3 5];
        chnnls = {'APB','LATapb','FDI','LATfdi','ADM','LATadm'};
        cnt_conds = 1;
        cnt_sbplt = 1;
        f2 = figure; set(fig,'pos',get(0,'ScreenSize'))%set(f1,'pos',pos)
        h0 = waitbar(0,'Please wait (channel)...');
        pos = get(h0,'pos');
        pos(2) = pos(2)-85;
        set(h0,'pos', pos)
        for cnd = 1:length(conds);
            AMPS = Ptrns(:,cnd); %1,3,5
            M = MAPS.M(cnd).map;
            [mx my] = find(M == max(max(M)));
            % first subplot
            figure(f2)
            subplot(3,4,cnt_sbplt)
            imagesc(M)
            y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3));
            set(gca,'yticklabel',y_mm); ylabel('[mm]')
            x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1));
            set(gca,'xticklabel',x_mm); xlabel('[mm]')
            title(['MAP'])
            text(round(my),round(mx),'x [max]','color','w')
            %text(round(CoG(cnd).raw(2)),round(CoG(cnd).raw(1)),'x [CoG]','color','w')
            ylabel(chnnls{cnd})
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % euclid
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            cog  = feval('h_CoG',M);
            feval('h_CoD',AMPS,ORNTRNG);;
            clear LOCcog
            for i=1:length(AMPS)
                try LOCcog(i) = pdist([cog([1,3]);LOCn([1,3],i)'],'euclidean');
                catch LOCcog(i) = dist(LOCn([1,3],i)',cog([1,3])');
                end
            end
            Ecld = [LOCcog-max(LOCcog)]*-1; %nearest instead of furthers
            clear Mx
            Mx = zeros(ceil(max(Y)*scl1),ceil(max(X)*scl1)); % matrix in micrometers
            for i=1:length(AMPS)
                Mx(round([Y(i)+1]*scl1),round([X(i)+1]*scl1))=Ecld(i);
            end
            % plot euclidean distance from CoG
            figure(f2)
            subplot(3,4,cnt_sbplt+1)
            imagesc(Mx)
            y_mm = num2str([str2num(get(gca,'yticklabel'))./scl1]+REF(3)); set(gca,'yticklabel',y_mm); ylabel('[mm]')
            x_mm = num2str([str2num(get(gca,'xticklabel'))./scl1]+REF(1)); set(gca,'xticklabel',x_mm); xlabel('[mm]')
            title(['Euclid from CoG'])
            text(round(cog(1)),round(cog(3)),'x [CoG]','color','w')
            % plot flattend response
            [LOCcogflag, indx] = sort(LOCcog);
            AMPSflat = AMPS(indx);
            figure(f2)
            subplot(3,4,cnt_sbplt+2)
            plot(AMPSflat,'-*')
            axis tight
            title('AMPS from CoG')
            
            M = zeros(ceil(max(Y)*scl1),ceil(max(X)*scl1)); % matrix in micrometers
            cnt = 1;
            h1 = waitbar(0,'Please wait (row)...');
            pos = get(h0,'pos');
            pos(2) = pos(2)-85;
            set(h1,'position',pos)
            h2 = waitbar(0,'Please wait (column)...');
            pos = get(h1,'pos');
            pos(2) = pos(2)-85;
            set(h2,'position',pos)
            
            % euclid distance calculation
            tic;
            clear Ecld pAMPS
            Ecld_radius = pdist([[1,1];size(M)],'euclidean');
            Ecld_y = zeros(round(Ecld_radius*scl2),1);
            pAMPS = zeros(size(M,1)*size(M,2),fix(pdist([1,1;length(Y), length(X)],'euclidean')));
            waitbar(cnd/length(conds),h0)
            for i=1:size(M,1)
                waitbar(i/size(M,1),h1)
                for ii=1:size(M,2)
                    waitbar(ii/size(M,2),h2)
                    for iii=1:length(AMPS)
                        try Ecld(iii)= pdist(cat(1,[i,ii],[round(Y(iii)*scl1),round(X(iii)*scl1)]),'euclidean');
                        catch Ecld(iii)= dist([i,ii],[round(Y(iii)*scl1),round(X(iii)*scl1)]');
                        end
                    end
                    Ecld_i = round(Ecld*scl2)+1; % distance zwischen punkt 1 und punkt selbs = 0 daher +1;
                    pAMPS(cnt, Ecld_i) = AMPS;
                    %pAMPSd(cnt, Ecld_i) = AMPS;
                    cnt = cnt+1;
                end
            end
            try close(h1), end
            try close(h2), end
            t.eucliddist = toc;
            clear  B P
            
            cnt = 0;
            % PREDICTOR
            clear pYc
            pctr = size(pAMPS,2);
            for ip=1:size(pAMPS,1)
                px = pAMPS(ip,:);
                %pd = pAMPS(ip,:); % pd = pAMPSd(ip,:);
                pxmax = find(px==max(px));
                py = zeros(length(px)*2,1);
                py(pctr-pxmax:pctr-1-pxmax+length(px)) = px;
                pYc(ip,:) = py;
            end
            pref = round(length(px)/2);
            pYc = pYc(:,pref:pref+length(px)-1);
            % display each voxel euclidean characteristics/centered
            f3 = figure; set(fig,'pos',get(0,'ScreenSize'))
            subplot(4,1,1)
            imagesc(pAMPS)
            subplot(4,1,2)
            imagesc(pYc)
            subplot(4,1,3)
            pYcs = imfilter(pYc,h,'same');
            imagesc(pYcs);
            subplot(4,1,4)
            errorbar(mean(pYcs),std(pYcs),'-x')
            axis tight, grid on
            pause(3)
            
            
            NBS.sigma_subjectspecific{subj}(sess) =  suggestedsigma;
            %y(i) = x(i)*erfc(x(i)-i/
            
            figure(f2)
            close(f3)
            subplot(3,4,cnt_sbplt+3);
            errorbar(mean(pYcs),std(pYcs),'-x')
            axis tight
            title('Ecldn & Adptv (CoG independent)')
            disp('CoG independent: euclidean distance per voxel, fitted with gausschen distribution')
        end
    end
end





% --------------------------------------------------------------------
function MAPsmooth_Callback(hObject, eventdata, handles)
% hObject    handle to MAPsmooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function physicalparameters_Callback(hObject, eventdata, handles)
% hObject    handle to physicalparameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PPoutliers_Callback(hObject, eventdata, handles)
% hObject    handle to PPoutliers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(gcbo,'checked')
    case 'on', set(gcbo,'checked','off')
    case 'off', set(gcbo,'checked','on')
end


% --------------------------------------------------------------------
function MAPraw_Callback(hObject, eventdata, handles)
% hObject    handle to MAPraw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function MAPSMLR_Callback(hObject, eventdata, handles)
% hObject    handle to MAPSMLR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(gcbo,'checked')
    case 'on', set(gcbo,'checked','off')
    case 'off', set(gcbo,'checked','on')
end


% --------------------------------------------------------------------
function MRsmooth_Callback(hObject, eventdata, handles)
% hObject    handle to MRsmooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% obsolete, button was deleted



% --------------------------------------------------------------------
function cclinear_Callback(hObject, eventdata, handles)
% hObject    handle to cclinear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(gcbo,'checked')
    case 'on', set(gcbo,'checked','off')
    case 'off',
        set(gcbo,'checked','on')
        set(handles.cclog,'checked','off')
        set(handles.ccamp,'checked','off')
end

% --------------------------------------------------------------------
function ccamp_Callback(hObject, eventdata, handles)
% hObject    handle to ccamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(gcbo,'checked')
    case 'on', set(gcbo,'checked','off')
    case 'off', set(gcbo,'checked','on')
        set(handles.cclog,'checked','off')
        set(handles.cclinear,'checked','off')
end

% --------------------------------------------------------------------
function cclog_Callback(hObject, eventdata, handles)
% hObject    handle to cclog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(gcbo,'checked')
    case 'on', set(gcbo,'checked','off')
    case 'off', set(gcbo,'checked','on')
        set(handles.cclinear,'checked','off')
        set(handles.ccamp,'checked','off')
end


% --------------------------------------------------------------------
function rem_file_Callback(hObject, eventdata, handles)
% hObject    handle to rem_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    COMPARE = evalin('base','COMPARE');
catch return;
end
answ = listdlg('ListString',get(handles.popupmenuSearchResults,'str'),'Listsize',[300 300]);
liststr = COMPARE.path_file;
if isempty(answ) == 1
    return;
elseif length(answ) == size(liststr,1)
    set(handles.popupmenuSearchResults,'val',1);
    set(handles.popupmenuSearchResults,'str','...');
    COMPARE.path_file = cell(0,2);
else
    indx = ones(size(liststr,1),1);
    indx(answ,1) = 0;
    liststr = liststr(find(indx),:);
    set(handles.popupmenuSearchResults,'val',1);
    set(handles.popupmenuSearchResults,'str',liststr(:,2));
    COMPARE.path_file = liststr;
end

assignin('base','COMPARE',COMPARE);


% --------------------------------------------------------------------
function save_file_Callback(hObject, eventdata, handles)
% hObject    handle to save_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    COMPARE = evalin('base','COMPARE');
    w = cd;
    cd(COMPARE.system.path);
    save(COMPARE.system.filename,'COMPARE');
    warndlg(['Files successfully saved to: ' COMPARE.system.path COMPARE.system.filename]);
    cd(w);
catch
    [file path] = uiputfile('*.mat','Save COMPARE in...');
    if file == 0
        return;
    end
    cd(path);
    COMPARE.system.path = path;
    COMPARE.system.filename = file;
    save(file,'COMPARE');
    assignin('base','COMPARE',COMPARE);
end



% --------------------------------------------------------------------
function load_file_Callback(hObject, eventdata, handles)
% hObject    handle to load_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiload;
assignin('base','COMPARE',COMPARE);
if exist('COMPARE','var') == 0
    return;
end
try
    set(handles.edit_search,'str',COMPARE.tags);
catch
    disp('No tags saved...');
end
try
    set(handles.list_list,'str',COMPARE.path_file(:,2));
catch
    disp('No files saved...');
end


% --- Executes on button press in pushbutton34.
function pushbutton34_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    COMPARE = evalin('base','COMPARE');
end
tag = lower(char(inputdlg('Please enter the tags to be searched for','Tags',1)));
if isempty(tag) == 1
    return;
end
liststr = get(handles.editsearch,'str');
if ischar(liststr) == 1
    liststr = {liststr};
end
if isempty(strfind(char(liststr(1,1)),'tags ...')) == 0
    liststr = {tag};
else
    liststr(end+1,1) = {tag};
end
COMPARE.tags = liststr;
assignin('base','COMPARE',COMPARE);
set(handles.editsearch,'str',liststr,'val',length(liststr));

feval('popupmenuSearchResults_Callback',handles.popupmenuSearchResults,eventdata,handles);

% --- Executes on button press in pushbutton35.
function pushbutton35_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    COMPARE = evalin('base','COMPARE');
end
val = get(handles.editsearch,'val');
liststr = get(handles.editsearch,'str');
if size(liststr,1) == 1
    set(handles.editsearch,'str','tags ...');
    set(handles.editsearch,'val',1);
    COMPARE.tags = {};
    assignin('base','COMPARE',COMPARE);
    return;
end
indx = 1:size(liststr,1);
indx(val) = 0;
liststr = liststr(find(indx ~=0),1);
if val > size(liststr,1)
    set(handles.editsearch,'val',size(liststr,1));
end
set(handles.editsearch,'str',liststr);
COMPARE.tags = liststr;
assignin('base','COMPARE',COMPARE);

feval('popupmenuSearchResults_Callback',handles.popupmenuSearchResults,eventdata,handles);



% --- Executes on button press in pushbutton37.
function pushbutton37_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

COMPARE = evalin('base','COMPARE');
temp = COMPARE.path_file;
INDX = struct;
h = waitbar(0,'Please wait while indexing...');
for i = 1:1:size(temp,1)
    [data textdata raw] = xlsread([cell2mat(temp(i,1)) '\' cell2mat(temp(i,2))]);
    INDX = setfield(INDX,{i,1},'rawmatrix',raw);
    waitbar(i/size(temp,1));
end
close(h);
for i = 1:1:size(INDX,1)
    raw = INDX(i,1).rawmatrix;
    COL2indx = {};
    for j = 1:1:size(raw,1)
        h_hlditem = cell2mat(raw(j,2));
        if ischar(h_hlditem) == 1
            COL2indx(j,1) = {h_hlditem};
        else
            COL2indx(j,1) = {'empty'};
        end
    end
    INDX(i,1).indxSeq.start = strmatch('Sequence Description',COL2indx);
    startindx = INDX(i,1).indxSeq.start;
    COL3indx = INDX(i,1).rawmatrix(:,3);
    for f = 1:1:size(startindx,1)
        if f < size(startindx,1)
            rangesearch = COL3indx(startindx(f,1):startindx(f+1),1);
        elseif f == size(startindx,1)
            rangesearch = COL3indx(startindx(f,1):size(COL3indx,1),1);
        end
        for h = 1:1:size(rangesearch,1)
            resh_hld = strfind(cell2mat(rangesearch(h,1)),'.');
            if isempty(resh_hld) == 1
                found(h) = 0;
            else
                found(h) = 1;
            end
        end
        if isempty(find(found)) == 0
            startindx(f,2:3) = [(startindx(f,1) + min(find(found)) - 1) (startindx(f,1) + max(find(found)) - 1)];
        else
            startindx(f,2:3) = [startindx(f,1) startindx(f,1)];
        end
        found = [];
    end
    INDX(i,1).indxSeq.start = startindx;
    for k = 1:1:size(INDX(i,1).indxSeq.start,1)
        INDX(i,1).indxSeq.descriptions(k,1) = raw(INDX(i,1).indxSeq.start(k,1),2);
    end
end

for i = 1:1:size(INDX,1)
    h_hld = char(INDX(i,1).rawmatrix(8,1));
    if isempty(h_hld(15:end)) == 1
        h_hld(15:19) = 'empty';
    end
    blank = strfind(h_hld,' ');
    if isempty(blank) == 0
        h_hld(blank) = '_';
    end
    blank = strfind(h_hld,',');
    if isempty(blank) == 0
        h_hld(blank) = '_';
    end
    subjects{i,1} = h_hld(15:end);
end

%%%%%%%
%DEFINE TAGS THAT HAVE TO BE FOUND IN DESCRIPTIONS
%%%%%%%
tag_val = get(handles.editsearch,'val');
tagstr = get(handles.editsearch,'str');
tagstr = char(tagstr(tag_val,1));
seperator = strfind(tagstr,' ');
if isempty(seperator) == 1
    tags = {tagstr};
else
    for i = 1:1:(size(seperator,2) + 1)
        if i == 1
            tags{i,1} = tagstr(1,1:(seperator(1,i)-1));
        elseif i ~= 1 && i ~= (size(seperator,2) + 1)
            tags{i,1} = tagstr(1,(seperator(1,i-1)+1):(seperator(1,i)-1));
        elseif i ~= 1 && i == (size(seperator,2) + 1)
            tags{i,1} = tagstr(1,(seperator(1,i-1)+1):end);
        end
    end
end


%%%%%%%
%SEARCH DESCRIPTION FOR MATCHES
%%%%%%%
for i = 1:1:size(INDX,1)
    curr_descr = char(INDX(i,1).indxSeq.descriptions);
    for x = 1:1:size(tags,1)
        for j = 1:1:size(curr_descr,1)
            found = strfind(curr_descr(j,:),char(tags(x,1)));
            skip = 0;
            if strmatch(char(tags(x,1)),'DH') == 1
                skp = strfind(curr_descr(j,:),'NDH');
                if isempty(skp) == 0
                    skip = 1;
                end
            end
            if isempty(found) == 0 && skip == 0
                row_match(j,x) = 1;
            else
                row_match(j,x) = 0;
            end
        end
    end
    INDX(i,1).matches.tags = tags;
    INDX(i,1).matches.matchtable = {row_match};
    match_all = (sum(row_match,2) == size(tags,1));
    matchlines = INDX(i,1).indxSeq.start(find(match_all == 1));
    INDX(i,1).matches.matchlines = matchlines;
    if isempty(matchlines) == 1
        disp(['No matches for subject ' num2str(i) ' and tag: ' tagstr]);
    else
        disp([num2str(sum(match_all)) ' matches for subject ' num2str(i) ' and tag: ' tagstr]);
    end
    row_match = [];
end


%%%%%
%ADD RESULTS TO RESULTS
%%%%%
try
    R_RESULTS = evalin('base','R_RESULTS');
    exists = size(R_RESULTS,1);
catch
    exists = 0;
end

%%%%%%%
%hier schauen, ob die tags schonmal gesucht wurden und dann
%überschreiben!!!
if exists ~= 0
    overwrite = 0;
    for i = 1:1:size(R_RESULTS,1)
        currtags = R_RESULTS(i,1).tags;
        if size(currtags,1) == size(tags,1)
            for x = 1:1:size(tags,1)
                comp = strfind(char(currtags(x,1)),char(tags(x,1)));
                if isempty(comp) == 1
                    found(x) = 0;
                else
                    found(x) = 1;
                end
            end
            if sum(found) == size(tags,1)
                overwrite = i;
            end
        end
    end
    if overwrite ~= 0
        exists = overwrite - 1;
    end
end

R_RESULTS(exists+1,1).tags = tags;
R_RESULTS(exists+1,1).subjects = [subjects temp];

for i = 1:1:size(subjects,1)
    R_RESULTS = setfield(R_RESULTS,{exists+1,1},char(subjects(i,1)),INDX(i,1));
end

COMPARE.results = R_RESULTS;
assignin('base','COMPARE',COMPARE);


% --- Executes on key press with focus on showseq and none of its controls.
function showseq_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to showseq (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

wv= 1;


% --------------------------------------------------------------------
function Recursive_Callback(hObject, eventdata, handles)
% hObject    handle to Recursive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function tagfiles_Callback(hObject, eventdata, handles)
% hObject    handle to tagfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


NBS = evalin('base','NBS');

COMPARE = evalin('base','COMPARE');
temp = COMPARE.path_file;
assignin('base','TAGS', get(handles.editsearch,'str'));
INDX = struct;
h = waitbar(0,'Please wait while indexing...');
for i = 1:size(temp,1)
    disp(['reading: ' [cell2mat(temp(i,1)) '\' cell2mat(temp(i,2))]])
    try [data textdata raw] = xlsread([cell2mat(temp(i,1)) '\' cell2mat(temp(i,2))]);
    catch, msgbox(['please look if ' [cell2mat(temp(i,1)) '\' cell2mat(temp(i,2))] ' file is open'])
    end
    %chk for blank lines in the beginning
    [a b h_hldz] = xlsread([cell2mat(temp(i,1)) '\' cell2mat(temp(i,2))],'',['A' num2str(6) ':A' num2str(10)]);
    for z = 1:1:5
        if z > 10
            errordlg('Patient name not found before line 6 and beyond line 10 in the xls file');
            return;
        end
        h_hldchk = h_hldz(z,:);
        if ischar(cell2mat(h_hldchk)) == 1
            h_hldsrch = strmatch('Patient Name',h_hldchk);
            if h_hldsrch == 1;
                z = z + 5;
                if z == 8
                    %everything's fine
                elseif z > 8
                    % for every step beyond 8 add one empty line
                    raw = vertcat(cell ((-8 + z),size(raw,2)), raw);
                elseif z < 8
                    raw = raw(z : end, :);
                end
            end
        end
    end
    % bug fix (robert was busy sleeping ;-)
    for ai = 1:length(raw);
        if  findstr('analysis exam created:',lower(raw{ai,1}));
            ind = ai;
            break
        else
            ind = length(raw);
        end
    end
    raw = raw(1:ind,:);
    
    INDX = setfield(INDX,{i,1},'rawmatrix',raw);
    waitbar(i/size(temp,1));
end
close(h);
for i = 1:1:size(INDX,1)
    raw = INDX(i,1).rawmatrix;
    COL2indx = {};
    for j = 1:1:size(raw,1)
        h_hlditem = cell2mat(raw(j,2));
        if ischar(h_hlditem) == 1
            COL2indx(j,1) = {h_hlditem};
        else
            COL2indx(j,1) = {'empty'};
        end
    end
    INDX(i,1).indxSeq.start = strmatch('Sequence Description',COL2indx);
    startindx = INDX(i,1).indxSeq.start;
    COL3indx = INDX(i,1).rawmatrix(:,3);
    for f = 1:1:size(startindx,1)
        if f < size(startindx,1)
            rangesearch = COL3indx(startindx(f,1):startindx(f+1),1);
        elseif f == size(startindx,1)
            rangesearch = COL3indx(startindx(f,1):size(COL3indx,1),1);
        end
        for h = 1:1:size(rangesearch,1)
            resh_hld = strfind(cell2mat(rangesearch(h,1)),'.');
            if isempty(resh_hld) == 1
                found(h) = 0;
            else
                found(h) = 1;
            end
        end
        if ~any(found) == 0
            startindx(f,2:3) = [(startindx(f,1) + find(found, 1 ) - 1) (startindx(f,1) + max(find(found)) - 1)]; %#ok<MXFND>
        else
            startindx(f,2:3) = [startindx(f,1) startindx(f,1)];
        end
        found = [];
    end
    INDX(i,1).indxSeq.start = startindx;
    for k = 1:1:size(INDX(i,1).indxSeq.start,1)
        INDX(i,1).indxSeq.descriptions(k,1) = raw(INDX(i,1).indxSeq.start(k,1),2);
    end
    %eind = find(strncmp(raw(:,1),'Stimulation Exam', 16))
end


for i = 1:1:size(INDX,1)
    for ii = 1:20
        try pni(ii) =  strmatch('Patient Name:',char(INDX(i,1).rawmatrix(ii,1)));
        catch pni(ii) = 0;
        end
    end
    if  isempty (strmatch('Patient Name:',char(INDX(i,1).rawmatrix(find(pni),1))))
        disp(lasterr)
        uiwait(msgbox(['something is wrong with subject (return): ' cell2mat(temp(i,2)),...
            ' (e.g. line 9 in excel should be Patient Name):'],'PLEASE FIX!!','warn'))
        return
    else
        h_hld = char(INDX(i,1).rawmatrix(find(pni),1));
    end
    if isempty(h_hld(15:end)) == 1
        h_hld(15:24) = 'empty name';
    end
    blank = strfind(h_hld,' ');
    if isempty(blank) == 0
        h_hld(blank) = '_';
    end
    blank = strfind(h_hld,',');
    if isempty(blank) == 0
        h_hld(blank) = '_';
    end
    subjects{i,1} = h_hld(15:end);
end
% fixnames
subjects = strrep(subjects,'-','_');
subjects = strrep(subjects,'__','_');
subjects = strrep(subjects,'ä','ae');
subjects = strrep(subjects,'ö','oe');
subjects = strrep(subjects,'ü','ue');
% look for duplcates
for is = 1:size(subjects,1)
    ind = strmatch(subjects(is,1),subjects);
    if length(ind)>1
        for il=1:length(ind)
            subjects{ind(il)} = [subjects{ind(il),1} '_' num2str(il)];
        end
    end
end


%%%%%%
%DEFINE TAGS THAT HAVE TO BE FOUND IN DESCRIPTIONS
%%%%%%%
tag_val = get(handles.editsearch,'val');
tagstr = get(handles.editsearch,'str');
tagstr = char(tagstr(tag_val,1));
seperator = strfind(tagstr,' ');
if isempty(seperator) == 1
    tags = {tagstr};
else
    for i = 1:1:(size(seperator,2) + 1)
        if i == 1
            tags{i,1} = tagstr(1,1:(seperator(1,i)-1));
        elseif i ~= 1 && i ~= (size(seperator,2) + 1)
            tags{i,1} = tagstr(1,(seperator(1,i-1)+1):(seperator(1,i)-1));
        elseif i ~= 1 && i == (size(seperator,2) + 1)
            tags{i,1} = tagstr(1,(seperator(1,i-1)+1):end);
        end
    end
end

if isempty(strfind(tagstr(1,:),'tags')) == 0 && size(tags,1) == 1
    tags = {' '};
elseif isempty(strfind(tagstr(1,:),'all')) == 0 && size(tags,1) == 1
    tags = {' '};
end


%%%%%%%
%SEARCH DESCRIPTION FOR MATCHES
%%%%%%%
empt = [];
for i = 1:1:size(INDX,1)
    curr_descr = char(INDX(i,1).indxSeq.descriptions);
    curr_descr = lower(curr_descr);
    SEQ{i} = curr_descr;
    assignin('base','SEQ',SEQ)
    for x = 1:1:size(tags,1)
        for j = 1:1:size(curr_descr,1)
            found = strfind(curr_descr(j,:),char(tags(x,1)));
            skip = 0;
            if strmatch(char(tags(x,1)),'DH') == 1
                skp = strfind(curr_descr(j,:),'NDH');
                if isempty(skp) == 0
                    skip = 1;
                end
            end
            if isempty(found) == 0 && skip == 0
                row_match(j,x) = 1;
            else
                row_match(j,x) = 0;
            end
        end
    end
    INDX(i,1).matches.tags = tags;
    INDX(i,1).matches.matchtable = {row_match};
    match_all = (sum(row_match,2) == size(tags,1));
    matchlines = INDX(i,1).indxSeq.start(find(match_all == 1));
    INDX(i,1).matches.matchlines = matchlines;
    if isempty(matchlines) == 1
        disp(['No matches for subject ' num2str(i) '(' subjects{i} ') and tag: ' tagstr]);
        if eventdata == 1;
            empt(i) = 0;
        end
    else
        disp([num2str(sum(match_all)) ' matches for subject ' num2str(i) ' and tag: ' tagstr]);
        if eventdata == 1;
            empt(i) = 1;
        end
    end
    row_match = [];
end

if eventdata == 1
    INDX = INDX(find(empt == 1),:);
    subjects = subjects(find(empt == 1),:);
    temp = temp(find(empt == 1),:);
    COMPARE.path_file_IMPORT = COMPARE.path_file(find(empt == 1),:);
end


%%%%%
%ADD RESULTS TO RESULTS
%%%%%
try
    R_RESULTS = evalin('base','R_RESULTS');
    exists = size(R_RESULTS,1);
catch
    exists = 0;
end

%%%%%%%
%hier schauen, ob die tags schonmal gesucht wurden und dann
%überschreiben!!!
if exists ~= 0
    overwrite = 1;
    for i = 1:1:size(R_RESULTS,1)
        currtags = R_RESULTS(i,1).tags;
        if size(currtags,1) == size(tags,1)
            for x = 1:1:size(tags,1)
                comp = strfind(char(currtags(x,1)),char(tags(x,1)));
                if isempty(comp) == 1
                    found(x) = 0; %#ok<AGROW>
                else
                    found(x) = 1; %#ok<AGROW>
                end
            end
            if sum(found) == size(tags,1)
                overwrite = i;
            end
        end
    end
    if overwrite ~= 0
        exists = overwrite - 1;
    end
end

R_RESULTS(exists+1,1).tags = tags;

for i = 1:1:size(subjects,1)
    sbjfld = strrep(char(subjects(i,1)),'-','_');
    sbjfld = strrep(sbjfld,'ä','ae');
    sbjfld = strrep(sbjfld,'ö','oe');
    sbjfld = strrep(sbjfld,'ü','ue');
    sbjfld = strrep(sbjfld,'.','');
    subjects(i,1) = {sbjfld};
    try
        R_RESULTS = setfield(R_RESULTS,{exists+1,1},sbjfld,INDX(i,1));
    catch
        msgbox(['....you have a problem with subjects #' num2str(i) ' name: ' subjects{i}])
    end
end


R_RESULTS(exists+1,1).subjects = [subjects temp];

COMPARE.results = R_RESULTS;

clear R_RESULTS

str = get(handles.popupmenuSearchResults,'str');
subj = get(handles.popupmenuSearchResults,'val');

% put new indices
for currsub = 1:1:size(subjects,1)
    indx = getfield(COMPARE.results,char(COMPARE.results.subjects(currsub,1)));
    indxall = indx.indxSeq.start;
    indxfound = indx.matches.matchlines;
    
    prm = [ ];
    currdescr = {};
    ind = { };
    for i = 1:1:size(indxfound,1)
        ind_data(1,1:2) = indxall(find(indxall(:,1) == indxfound(i,1)),2:3);
        ind_get(i,1:2) = ind_data;
        currdescr(i,1) = indx.indxSeq.descriptions(find(indxall(:,1) == indxfound(i,1)),1);
        ind{i} = deblank([strrep(num2str(ind_data),'  ',',') ' ']);
        prm = [prm, ind{i} ';'];
    end
    set(handles.showseq,'str',currdescr,'val',1);
    
    
    %%%%%%%%%%%%%%%
    PRM = get(handles.listbox1,'str');
    PRM{strmatch('A1', strvcat(PRM))} = ['A1 = ' strrep(['[' prm(1:end-1) ']'],',', ' ') ';'];
    
    
    %these NBS fields should become obselete
    switch get(handles.changepath,'checked')
        case 'off'
            
        case 'on'
            
    end
    
    NBS.GUI(currsub).hdr = INDX(currsub,1).rawmatrix(:,1:2);
    NBS.GUI(currsub).sequences = get(handles.showseq,'str');
    NBS.GUI(currsub).sequencesindices = ind;
end

set(gcbo,'checked','on')
set(handles.Seqq_load,'checked','off')
set(handles.save,'checked','off')
set(handles.load,'checked','off')
set(handles.autosave,'checked','off')
set(handles.popupmenuSearchResults,'val',1);
assignin('base','NBS',NBS)
assignin('base','COMPARE',COMPARE)
feval('popupmenuSearchResults_Callback',hObject, eventdata, handles)

% --------------------------------------------------------------------
function fileextension_Callback(hObject, eventdata, handles)
% hObject    handle to fileextension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch(get(gcbo,'label'));
    case '.xlsx'
        set(gcbo,'label','.xls')
    case '.xls'
        set(gcbo,'label','.nbe')
    case '.nbe'
        set(gcbo,'label','.xlsx')
end



% --- Executes during object creation, after setting all properties.
function pushbutton20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --- Executes on button press in pushbutton38.
function pushbutton38_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 	100	158	214	MRI landmark: Nose/Nasion
% 	172	100.5	107.4	MRI landmark: Left ear
% 	22	107	113	MRI landmark: Right ear
%
% 	104.9	155	211.1	Scalp landmark: Nose/Nasion
% 	29	103.9	108.7	Scalp landmark: Right ear
% 	173.8	103.5	105.2	Scalp landmark: Left ear

%NBS DATA
NBS2MRI = [1 3 2]; %some strange format that Nexstim uses
disp('x y z')
MAT = evalin('base',['NBS.DATA(1).RAW.PP.data']);
AMPS = MAT(:,1);
EFLOC = MAT(:,10:12);
COMPARE = evalin('base','COMPARE');
[r c] = find(double(strcmp(COMPARE.results.Daniel_Schlacks.rawmatrix, 'MRI landmark: Nose/Nasion')));
NOSE.NBS(NBS2MRI) = cat(2,COMPARE.results.Daniel_Schlacks.rawmatrix{r,c-3:c-1});
LEFT.NBS(NBS2MRI) = cat(2,COMPARE.results.Daniel_Schlacks.rawmatrix{r+1,c-3:c-1}); %[172 100.5 104.4];
RIGHT.NBS(NBS2MRI) = cat(2,COMPARE.results.Daniel_Schlacks.rawmatrix{r+2,c-3:c-1}); %[22 107 113];


%MRI LANDMARKS
PFvol = 'P:\PROJECTS\TMS by Leo\Eric Holst\Eric_Holst.img';
prompt={'Left:','Right:','Nasion:'};
name='Input for MRI Landmarks (see e.g. MRIcro)';
numlines=1;
defaultanswer={'24 112 107','173 108 102','101 215 161'};
answer=inputdlg(prompt,name,numlines,defaultanswer);

LEFT.MRI = str2num(answer{1}); %#ok<ST2NM> %[24 112 107];
RIGHT.MRI = str2num(answer{2}); %#ok<ST2NM> %[173 108 102];
NOSE.MRI = str2num(answer{3}); %#ok<ST2NM> %[101 215 161];

% match and sort and round
EFLOC = EFLOC(:,NBS2MRI);
[val, ind] = sort(EFLOC(:,3)); % sort by z-axis
EFLOC = EFLOC(ind,:);
LFT = fix([LEFT.MRI; RIGHT.NBS; diff([LEFT.MRI;RIGHT.NBS])*-1]);
RGHT = fix([RIGHT.MRI; LEFT.NBS; diff([RIGHT.MRI;LEFT.NBS])*-1]);
NSE = fix([NOSE.MRI; NOSE.NBS; diff([NOSE.MRI;NOSE.NBS])*-1]);


% make NIFTI volume (SPM)
%IMGxyz = [203 256 256]; % flip LR, UP etc pp. (maybe implement)
V = spm_vol(PFvol);
IMG = zeros(V.dim);
for i=1:size(EFLOC,1)
    crd = fix(EFLOC(i,:));
    IMG(crd(1),crd(2),crd(3)) = AMPS(i);
end
% filter
h = fspecial('log',100,10)*-1;
h = h + abs(min(min(h)));
h = h - min(mean(h));
h = h*[1000/max(max(h))];
z = [fix(min(EFLOC(:,3))) : fix(max(EFLOC(:,3)))];
IMG(:,:,z) = imfilter(IMG(:,:,z),h,'same');
% write
V.fname = strrep(V.fname,'.img','_nbs.img');
spm_write_vol(V,fix(IMG));
% display
crd = fix(EFLOC(1,:));
S = IMG(:,:,crd(3));
figure,
subplot(2,2,1:2)
imagesc(S), colorbar
subplot(2,2,3:4)
plot(mean(h))



% --------------------------------------------------------------------
function resultsdirectory_Callback(hObject, eventdata, handles)
% hObject    handle to resultsdirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function Seq_reorg_Callback(hObject, eventdata, handles)
% hObject    handle to Seq_reorg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%feval('pushbutton18_Callback',hObject, eventdata, handles')

NBS = evalin('base','NBS');
subj = get(handles.popupmenuSearchResults,'val');
ButtonName = questdlg('What do you want to do?', ...
    'Sequence Question', ...
    'delete','reorganize', 'concatenate', 'delete');

switch lower(ButtonName)
    case 'concatenate'
        
        str = NBS.GUI(1,subj).sequences;
        [s,v] = listdlg('PromptString','select sequences to CONCAT:',...
            'SelectionMode','multiple','ListSize',[400,300],...
            'InitialValue',[1:length(str)],...
            'ListString',str);
        try defaultanswer = evalin('base','defaultanswer');
        catch defaultanswer.concat = {'Sequence Description: CONCAT'};
        end
        answer = inputdlg({'Enter a sequence description for the concatenation'},'CONCAT',1,defaultanswer.concat);
        assignin('base','defaultanswer',defaultanswer)
        
        if any(s)
            NBS.GUI(1,subj).sequences = NBS.GUI(1,subj).sequences;
            NBS.GUI(1,subj).sequences{end+1} = answer{1};
            NBS.GUI(1,subj).sequencesindices = NBS.GUI(1,subj).sequencesindices;
            SEQ = NBS.GUI(1,subj).sequencesindices(s);
            for i=1:length(SEQ)
                SEQ{i} = [SEQ{i} ';'];
            end
            NBS.GUI(1,subj).sequencesindices{end+1} = cat(2,SEQ{:});
            assignin('base','NBS',NBS)
            set(handles.showseq,'str',NBS.GUI(1,subj).sequences,'val',1)
        end
        
        
        %delete
    case 'delete'
        str = NBS.GUI(1,subj).sequences;
        [s,v] = listdlg('PromptString','select sequences to KEEP:',...
            'SelectionMode','multiple','ListSize',[400,300],...
            'InitialValue',[1:length(str)],...
            'ListString',str);
        if any(s)
            NBS.GUI(1,subj).sequences = NBS.GUI(1,subj).sequences(s);
            NBS.GUI(1,subj).sequencesindices = NBS.GUI(1,subj).sequencesindices(s);
            assignin('base','NBS',NBS)
            set(handles.showseq,'str',NBS.GUI(1,subj).sequences,'val',1)
        end
        
        
    case 'reorganize'
        % GUI
        str = NBS.GUI(1,subj).sequences;
        % dfstr = mat2cell(1:length(str))
        answer = inputdlg(str);
        % reorganize
        s = [ ];
        for i=1:length(answer)
            if any(answer{i})
                s(i) = str2num(answer{i});
            end
        end
        NBS.GUI(1,subj).sequences = NBS.GUI(1,subj).sequences(find(s));
        NBS.GUI(1,subj).sequencesindices = NBS.GUI(1,subj).sequencesindices(find(s));
        [x ind] = sort(s(find(s)));
        NBS.GUI(1,subj).sequences = NBS.GUI(1,subj).sequences(ind);
        NBS.GUI(1,subj).sequencesindices = NBS.GUI(1,subj).sequencesindices(ind);
        assignin('base','NBS',NBS)
        set(handles.showseq,'str',NBS.GUI(1,subj).sequences,'val',1)
        
        
end






% --------------------------------------------------------------------
function Seq_del_Callback(hObject, eventdata, handles)
% hObject    handle to Seq_del (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NBS = evalin('base','NBS');
str = NBS.GUI(1,subj).sequences;
[s,v] = listdlg('PromptString','select sequences to KEEP:',...
    'SelectionMode','multiple','ListSize',[400,300],...
    'InitialValue',[1:length(str)],...
    'ListString',str);
if any(s)
    NBS.GUI(1,subj).sequences = NBS.GUI(1,subj).sequences(s);
    NBS.GUI(1,subj).sequencesindices = NBS.GUI(1,subj).sequencesindices(s);
    assignin('base','NBS',NBS)
    set(handles.showseq,'str',NBS.GUI(1,subj).sequences,'val',1)
end
assignin('base','NBS',NBS)

% --------------------------------------------------------------------
function Seqq_load_Callback(hObject, eventdata, handles)
% hObject    handle to Seqq_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
feval('pushbutton20_Callback',hObject, eventdata, handles)
set(gcbo,'checked','on')

% --------------------------------------------------------------------
function Seq_load_Callback(hObject, eventdata, handles)
% hObject    handle to Seq_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function ResultsFilename_Callback(hObject, eventdata, handles)
% hObject    handle to ResultsFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function data_subjects_Callback(hObject, eventdata, handles)
% hObject    handle to data_subjects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function data_sessions_Callback(hObject, eventdata, handles)
% hObject    handle to data_sessions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
function MAPquantile_Callback(hObject, eventdata, handles)
% hObject    handle to MAPquantile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

NBS= evalin('base','NBS');
prompt={'lower:','upper:'};
name='Input for Quantile (Maps)';
numlines=1;
defaultanswer={'.5','.975'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
NBS.defaults.quantile(1) = str2num(answer{1});
NBS.defaults.quantile(2) = str2num(answer{2});
set(gcbo,'label',['quantile [' answer{1} ', ' answer{2} ']'],'checked','on')
assignin('base','NBS',NBS);










% --------------------------------------------------------------------
function MAPSmicroV_Callback(hObject, eventdata, handles)
% hObject    handle to MAPSmicroV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function print_res_Callback(hObject, eventdata, handles)
% hObject    handle to print_res (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

NBS = evalin('base','NBS');

str = get(gcbo,'label');
ind(1) = findstr(str,'[');
ind(2) = findstr(str,']');
n{1} = num2str(str(ind(1)+1:ind(2)-1));
answer=inputdlg('new resolution [dpi]:','print resoultion',1,n);
NBS.defaults.printres = str2num(answer{1});
assignin('base','NBS',NBS)

str = [str(1:ind(1)), num2str(NBS.defaults.printres), str(ind(2):end)];

set(gcbo,'label',str)


% --- Executes on button press in pushbutton40.
function pushbutton40_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_NBS2MRI


% --- Executes on button press in seq_preview.
function seq_preview_Callback(hObject, eventdata, handles)
% hObject    handle to seq_preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of seq_preview





% --- Executes on selection change in evaltype.
function evaltype_Callback(hObject, eventdata, handles)
% hObject    handle to evaltype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns evaltype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from evaltype

NBS = evalin('base','NBS');

if ~any(strmatch('ANALYSIS',fieldnames(NBS)))
    return;
end

if get(handles.evaltype,'val') == 1
    
    set(handles.SBJTS,'val',1);
    set(handles.SBJTS,'str','Subjects...');
    
else
    set(handles.SBJTS,'val',1);
    try
        SUBJ = NBS.ANALYSIS.MTRXhdr{(get(handles.evaltype,'val') - 1),2};
        
    catch
        disp('No corresponding subjects loaded...');
        SUBJ = [];
    end
    
    if ~isempty(SUBJ)
        set(handles.SBJTS,'str',SUBJ(:,1));
    else
        set(handles.SBJTS,'str','Subjects...');
    end
end

feval('SBJTS_Callback',handles.SBJTS,0,handles);




% --- Executes during object creation, after setting all properties.
function evaltype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to evaltype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in evaloutlier.
function evaloutlier_Callback(hObject, eventdata, handles)
% hObject    handle to evaloutlier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns evaloutlier contents as cell array
%        contents{get(hObject,'Value')} returns selected item from evaloutlier


% --- Executes during object creation, after setting all properties.
function evaloutlier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to evaloutlier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in SBJTS.
function SBJTS_Callback(hObject, eventdata, handles)
% hObject    handle to SBJTS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SBJTS contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SBJTS

NBS = evalin('base','NBS');

ARR = CMPL4D();

if ~isempty(ARR)
    DESCR = ARR(1,get(handles.SBJTS,'val'),:,1);
    PRMPT = {};
    for i = 1:size(DESCR,3)
        if isempty(cell2mat(DESCR(1,1,i)))
            break;
        end
        PRMPT(end + 1,1) = DESCR(1,1,i);
    end
    set(handles.popupmenu8,'val',1);
    set(handles.popupmenu8,'str',PRMPT);
else
    set(handles.popupmenu8,'val',1);
    set(handles.popupmenu8,'str','Tags...');
end

% --- Executes during object creation, after setting all properties.
function SBJTS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SBJTS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SUBTAGS.
function SUBTAGS_Callback(hObject, eventdata, handles)
% hObject    handle to SUBTAGS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SUBTAGS contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SUBTAGS


% --- Executes during object creation, after setting all properties.
function SUBTAGS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SUBTAGS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8


% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in CHNGSEQ.
function CHNGSEQ_Callback(hObject, eventdata, handles)
% hObject    handle to CHNGSEQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

NBS = evalin('base','NBS');
ARR = feval('CMPL4D');

if isempty(ARR)
    disp('There is no data loaded for this evaluation type...');
    return;
end

HLD = ARR(1,get(handles.SBJTS,'val'),get(handles.popupmenu8,'val'),1);

ANSW = inputdlg('Current sequence description is:','Change',1,HLD);

if ~isempty(cell2mat(ANSW))
    ARR(1,get(handles.SBJTS,'val'),get(handles.popupmenu8,'val'),1) = ANSW;
    disp('Description changed!');
else
    disp('Empty string entered, description not changed!');
    return;
end

NBS.ANALYSIS.MTRX((get(handles.evaltype,'val')-1),1:size(ARR,2),:,:) = ARR;

assignin('base','NBS',NBS);

feval('SBJTS_Callback',handles.SBJTS, 1, handles);

% --- Executes on button press in WTCHSEQ.
function WTCHSEQ_Callback(hObject, eventdata, handles)
% hObject    handle to WTCHSEQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

NBS = evalin('base','NBS');
ARR = feval('CMPL4D');

if isempty(ARR)
    disp('There is no data loaded for this evaluation type...');
    return;
end

HLD = ARR(1,get(handles.SBJTS,'val'),get(handles.popupmenu8,'val'),[5 6 7]);
PRMPT = ['MSO1  ' 'MSO2   ' 'ISI     ' 'CH1      '...
    'CH2      ' 'CH3      ' 'CH4      ' 'CH5      ' 'CH6      '];

PRMPT(2,1) = ' ';

MSO = cell2mat(HLD(1,1,1,1));
ISI = cell2mat(HLD(1,1,1,2));
AMPS = cell2mat(HLD(1,1,1,3));

if get(handles.evaltype,'val') == (strmatch('threshold',NBS.ANALYSIS.MTRXhdr(:,1)) + 1)
    helpdlg(char({'MSO is: '; ' '; num2str(MSO)}));
    return;
end

for i = 1:length(MSO)
    MSOch1(i,1:3) = '___';
    MSOch1(i,1:length(num2str(MSO(i,1)))) = num2str(MSO(i,1));
    MSOch2(i,1:3) = '___';
    MSOch2(i,1:length(num2str(MSO(i,2)))) = num2str(MSO(i,2));
    ISIch(i,1:3) = '___';
    ISIch(i,1:length(num2str(ISI(i,1)))) = num2str(ISI(i,1));
    AMPSch1(i,1:5) = '_____';
    AMPSch1(i,1:length(num2str(AMPS(i,1)))) = num2str(AMPS(i,1));
    AMPSch2(i,1:5) = '_____';
    AMPSch2(i,1:length(num2str(AMPS(i,2)))) = num2str(AMPS(i,2));
    AMPSch3(i,1:5) = '_____';
    AMPSch3(i,1:length(num2str(AMPS(i,3)))) = num2str(AMPS(i,3));
    AMPSch4(i,1:5) = '_____';
    AMPSch4(i,1:length(num2str(AMPS(i,4)))) = num2str(AMPS(i,4));
    AMPSch5(i,1:5) = '_____';
    AMPSch5(i,1:length(num2str(AMPS(i,5)))) = num2str(AMPS(i,5));
    AMPSch6(i,1:5) = '_____';
    AMPSch6(i,1:length(num2str(AMPS(i,6)))) = num2str(AMPS(i,6));
end

for i = 1:length(MSO)
    ddln = ['   ' MSOch1(i,:) '    ' MSOch2(i,:) '      ' ISIch(i,:) '    ' AMPSch1(i,:) ...
        '   ' AMPSch2(i,:) '   ' AMPSch3(i,:)  '   ' AMPSch4(i,:) '   ' AMPSch5(i,:) '   ' AMPSch6(i,:)];
    
    PRMPT(end + 1, 1:(length(ddln))) = ddln;
end

helpdlg(PRMPT);



% --- Executes on selection change in SBGRPS.
function SBGRPS_Callback(hObject, eventdata, handles)
% hObject    handle to SBGRPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SBGRPS contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SBGRPS


% --- Executes during object creation, after setting all properties.
function SBGRPS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SBGRPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RMSBGRP.
function RMSBGRP_Callback(hObject, eventdata, handles)
% hObject    handle to RMSBGRP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

CRRGRP = get(handles.SBGRPS,'str');

if (length(CRRGRP) == 1 || ischar(CRRGRP)) && any(strmatch('subgroups',CRRGRP))
    return;
    
elseif (length(CRRGRP) == 1 || ischar(CRRGRP))
    set(handles.SBGRPS,'val',1);
    set(handles.SBGRPS,'str','subgroups...');
    
else
    IDX = ones(1,length(CRRGRP));
    IDX(get(handles.SBGRPS,'val')) = 0;
    set(handles.SBGRPS,'val',1);
    set(handles.SBGRPS,'str',CRRGRP(logical(IDX),1));
end



% --- Executes on button press in ADDSBGRP.
function ADDSBGRP_Callback(hObject, eventdata, handles)
% hObject    handle to ADDSBGRP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

CRRGRP = get(handles.SBGRPS,'str');
ADDGRP = inputdlg('Add tags that define a subgroup:','Subgroup definition',1);

if isempty(ADDGRP)
    return;
elseif (length(CRRGRP) == 1 || ischar(CRRGRP)) && any(strmatch('subgroups',CRRGRP))
    set(handles.SBGRPS,'val',1);
    set(handles.SBGRPS,'str',ADDGRP);
else
    CRRGRP(end + 1,1) = ADDGRP;
    set(handles.SBGRPS,'val',1);
    set(handles.SBGRPS,'str',CRRGRP);
end


% --- Executes on selection change in PLTTYPE.
function PLTTYPE_Callback(hObject, eventdata, handles)
% hObject    handle to PLTTYPE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns PLTTYPE contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PLTTYPE


% --- Executes during object creation, after setting all properties.
function PLTTYPE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PLTTYPE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SVEVAL.
function SVEVAL_Callback(hObject, eventdata, handles)
% hObject    handle to SVEVAL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in LDEVAL.
function LDEVAL_Callback(hObject, eventdata, handles)
% hObject    handle to LDEVAL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PLTsingle.
function PLTsingle_Callback(hObject, eventdata, handles)
% hObject    handle to PLTsingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PLTsingle


% --- Executes on button press in PLTmultiple.
function PLTmultiple_Callback(hObject, eventdata, handles)
% hObject    handle to PLTmultiple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PLTmultiple


% --- Executes on button press in PLTgo.
function PLTgo_Callback(hObject, eventdata, handles)
% hObject    handle to PLTgo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ARR = CMPL4D;
NBS = evalin('base','NBS');

EXM = get(handles.evaltype,'str');
EXM = lower(EXM(get(handles.evaltype,'val')));

if isempty(ARR)
    disp('No data for this condition loaded');
    return;
end

CURRPLT = get(handles.PLTTYPE,'str');

%-----------------------
% EXAMSPEC PREPROCESSING
CURRSUB = get(handles.SBJTS,'str');

% %% go through different plots
switch char(CURRPLT(get(handles.PLTTYPE,'val'),1))
    
    %-------------
    %%% BARPLOT || SCATTER
    case {'BAR','SCATTER'}
        % GENERATE A DOUBLE MATRIX WITH FOLLOWING SPECIFICATIONS:
        % GROUP: GRPMTRX( GROUPINDEX, CATEGORIES(x scale), VALUE (y-scale),
        % STANDARDDEVIATION (y-scale))
        %
        % SUBJECTS: SUBMTRX( SUBIDX, GROUPINDEX, CATEGORIES(x scale), VALUE (y-scale),
        % STANDARDDEVIATION (y-scale))
        
        
        switch lower(char(NBS.ANALYSIS.MTRXhdr((get(handles.evaltype,'val') -1),1)))
            
            %---------
            %--- 1 ---
            %---------
            case 'paired - pulse'
                
                [MTCHS SGRP] = SBGRP(ARR,{'RAWAMP','MSO','ISI'});
                if isempty(MTCHS)
                    return;
                end
                
                PLTMTRX = [];
                for z = 1:size(MTCHS,1)
                    
                    TMP = cell2mat(MTCHS(z,[4 5 6]));
                    
                    %set isi for reference zero and discard MSO (no longer
                    %required)
                    TMP(logical(sum(([TMP(:,7) == 0 TMP(:,8) == 0]),2)),9) = 0;
                    
                    %welcher Kanal ist der staerkste?
                    CHN = find(max(max(TMP(:,1:6))) == max(TMP(:,1:6)));
                    
                    TMP = TMP(:,[CHN 9]);
                    
                    TMP = [((MEPmean(TMP(logical(TMP(:,2) ~= 0),1)) / MEPmean(TMP(logical(TMP(:,2) == 0),1)))-1)*100 max(TMP(:,2))];
                    
                    if ~isnan(TMP(1,1)) && ~isinf(TMP(1,1))
                        PLTMTRX(end+1,:) = [cell2mat(MTCHS(z,[1:3])) TMP];
                    else
                        disp(['Infinite or illegal result (NaN) for: ' char(CURRSUB(get(handles.SBJTS,'val'),:)) ...
                            ' - sequence: ' char(ARR(1,cell2mat(MTCHS(z,2)),cell2mat(MTCHS(z,3)),1)) '... skipping']);
                    end
                end
                
                %GROUPSPEC MATRIX
                GRPS = unique(PLTMTRX(:,1));
                GRPMTRX = [];
                for z = 1:length(GRPS)
                    TMP = PLTMTRX(logical(PLTMTRX(:,1) == GRPS(z)),:);
                    
                    ISI = unique(TMP(:,5));
                    for y = 1:length(ISI)
                        GRPMTRX(end+1,:) = [z ISI(y) MEPmean(TMP(logical(TMP(:,5) == ISI(y)),4)) std(TMP(logical(TMP(:,5) == ISI(y)),4))];
                    end
                end
                
                %SUBJSPEC MATRIX
                SUBIDX = unique(PLTMTRX(:,2));
                SUBMTRX = [];
                for z = 1:length(SUBIDX)
                    TMP = PLTMTRX(logical(PLTMTRX(:,2) == SUBIDX(z)),:);
                    
                    ISI = unique(TMP(:,5));
                    for y = 1:length(ISI)
                        
                        FITISI = TMP(logical(TMP(:,5) == ISI(y)),:);
                        
                        
                        for h = 1:length(GRPS)
                            if ~isempty(FITISI(logical(FITISI(:,1) == GRPS(h)), 4))
                                SUBMTRX(end+1,:) = [z h ISI(y) MEPmean(FITISI(logical(FITISI(:,1) == GRPS(h)), 4))  std(FITISI(logical(FITISI(:,1) == GRPS(h)), 4))];
                            end
                        end
                        
                    end
                end
                
                %---------
                %--- 2 ---
                %---------
            case 'recruitment curve'
                [MTCHS SGRP] = SBGRP(ARR,{'RAWAMP','MSO'});
                if isempty(MTCHS)
                    return;
                end
                
                PLTMTRX = [];
                for z = 1:size(MTCHS,1)
                    
                    tmpD = cell2mat(MTCHS(z,[4]));
                    tmpM = cell2mat(MTCHS(z,[5]));
                    try TMP = cat(2,tmpD,tmpM);
                    catch
                        if size(tmpM,1)<size(tmpD,1)
                            dmd = abs(size(tmpM,1)-size(tmpD,1));
                            tmpM = cat(1,tmpM,repmat(tmpM(end,:)+ max(diff(tmpM)),dmd,1));
                        else
                            [s,v] = listdlg('ListString',num2str(tmpM),...
                                'PromptString',[CURRSUB{MTCHS{z,2}} '(Sess: ' num2str(MTCHS{z,3})  ') --> select MSO/%RMT to keep!:'],...
                                'SelectionMode','multiple','ListSize',[300 500],'initialValue',1:length(tmpD));
                            if isempty(v), break, end
                            tmpM = tmpM(s,:);
                        end
                        TMP = cat(2,tmpD,tmpM);
                    end
                    
                    INTS = unique(TMP(:,8));
                    
                    HLD = [];
                    for k = 1:length(INTS)
                        HLD(k,:) = mean(TMP(logical(TMP(:,8) == INTS(k)),:),1);
                    end
                    
                    CHN = find(max(MEPmean(HLD(:,1:6))) == MEPmean(HLD(:,1:6)));
                    
                    if length(CHN) > 1
                        CHN = CHN(1,1);
                    end
                    
                    PLTMTRX((end+1):(end+size(HLD(:,[CHN 8]),1)),:) = [mtimes(ones(size(HLD(:,[CHN 8]),1),1),cell2mat(MTCHS(z,1:3))) HLD(:,[CHN 8])];
                    
                end
                
                %GROUPSPEC MATRIX
                GRPS = unique(PLTMTRX(:,1));
                GRPMTRX = [];
                for z = 1:length(GRPS)
                    TMP = PLTMTRX(logical(PLTMTRX(:,1) == GRPS(z)),:);
                    
                    INTS = unique(TMP(:,5));
                    for y = 1:length(INTS)
                        [MN MNSTD] = MEPmean(TMP(logical(TMP(:,5) == INTS(y)),4));
                        GRPMTRX(end+1,:) = [z INTS(y) MN MNSTD];
                    end
                end
                
                %SUBJSPEC MATRIX
                SUBIDX = unique(PLTMTRX(:,2));
                SUBMTRX = [];
                for z = 1:length(SUBIDX)
                    TMP = PLTMTRX(logical(PLTMTRX(:,2) == SUBIDX(z)),:);
                    
                    
                    INTS = unique(TMP(:,5));
                    for y = 1:length(INTS)
                        
                        FITINTS = TMP(logical(TMP(:,5) == INTS(y)),:);
                        
                        
                        for h = 1:length(GRPS)
                            if ~isempty(FITINTS(logical(FITINTS(:,1) == GRPS(h)), 4))
                                [MN MNSTD] = MEPmean(FITINTS(logical(FITINTS(:,1) == GRPS(h)), 4));
                                SUBMTRX(end+1,:) = [z h INTS(y) MN MNSTD];
                            end
                        end
                        
                    end
                end
                
                
                %%%%%%%
                %------
                %--- 3
                %------
                %%%%%%%
            case 'thresholds'
                
                
                [MTCHS SGRP] = SBGRP(ARR,{'MSO'});
                if isempty(MTCHS)
                    return;
                end
                
                PLTMTRX = cell2mat(MTCHS);
                
                %GROUPSPEC MATRIX
                GRPS = unique(PLTMTRX(:,1));
                GRPMTRX = [];
                for z = 1:length(GRPS)
                    GRPMTRX(end+1,:) = [z 1 ...
                        mean(PLTMTRX(PLTMTRX(:,1) == z,4)) std(PLTMTRX(PLTMTRX(:,1) == z,4))];
                end
                
                %SUBJSPEC MATRIX
                SUBIDX = unique(PLTMTRX(:,2));
                SUBMTRX = [];
                
                for t = 1:length(SUBIDX)
                    
                    for z = 1:length(GRPS)
                        
                        TMP = PLTMTRX(PLTMTRX(:,2) == t,:);
                        
                        SUBMTRX(end+1,:) = [t z 1 ...
                            mean(TMP(TMP(:,1) == z,4)) std(TMP(TMP(:,1) == z,4))];
                    end
                    
                end
                
        end
        
    case 'BOXPLOT - first level'
        %%% Bedenke hier auch ANOVA optionen / hier aber second level!
        % GENERATE A DOUBLE MATRIX WITH FOLLOWING SPECIFICATIONS:
        % GROUP: GRPMTRX( GROUPINDEX, CATEGORIES(x scale), VALUES (y-scale))
        %
        % SUBJECTS: SUBMTRX( SUBIDX, GROUPINDEX, CATEGORIES(x scale), VALUES (y-scale))
        
        
        switch lower(char(NBS.ANALYSIS.MTRXhdr((get(handles.evaltype,'val') -1),1)))
            
            %---------
            %--- 1 ---
            %---------
            case {'paired - pulse', 'threshold'}
                
                errordlg('A first-level analysis for this measure is not possible.')
                return;
                
                %---------
                %--- 2 ---
                %---------
            case 'recruitment curve'
                [MTCHS SGRP] = SBGRP(ARR,{'RAWAMP','MSO'});
                if isempty(MTCHS)
                    return;
                end
                
                PLTMTRX = {};
                for z = 1:size(MTCHS,1)
                    
                    TMP = cell2mat(MTCHS(z,[4 5]));
                    
                    INTS = unique(TMP(:,8));
                    
                    CHN = find(max(MEPmean(TMP(:,1:6))) == MEPmean(TMP(:,1:6)));
                    
                    for k = 1:length(INTS)
                        
                        %cell2mat, um den CHN rauszubekommen
                        PLTMTRX(end+1,:) = [MTCHS(z,1:3) {INTS(k)} {TMP(logical(TMP(:,8) == INTS(k)),CHN)}];
                    end
                    
                end
                
                %GROUPSPEC MATRIX
                GRPS = unique(cell2mat(PLTMTRX(:,1)));
                GRPMTRX = {};
                for z = 1:length(GRPS)
                    TMP = PLTMTRX(logical(cell2mat(PLTMTRX(:,1)) == GRPS(z)),:);
                    
                    INTS = unique(cell2mat(TMP(:,4)));
                    for y = 1:length(INTS)
                        GRPMTRX(end+1,:) = [{z} {INTS(y)} {cell2mat(TMP(logical(cell2mat(TMP(:,4)) == INTS(y)),5))}];
                    end
                end
                
                %SUBJSPEC MATRIX
                SUBIDX = unique(cell2mat(PLTMTRX(:,2)));
                SUBMTRX = PLTMTRX(:,[2 1 4 5]);
                
        end
        
    case 'BOXPLOT - second level'
        
        switch lower(char(NBS.ANALYSIS.MTRXhdr((get(handles.evaltype,'val') -1),1)))
            %---------
            %--- 1 ---
            %---------
            case 'paired - pulse'
                %%% Bedenke hier auch ANOVA optionen / hier aber second level!
                % GENERATE A DOUBLE MATRIX WITH FOLLOWING SPECIFICATIONS:
                % GROUP: GRPMTRX( GROUPINDEX, CATEGORIES(x scale), VALUES (y-scale))
                %
                % SUBJECTS: SUBMTRX( SUBIDX, GROUPINDEX, CATEGORIES(x scale),
                % VALUES (y-scale))
                
                [MTCHS SGRP] = SBGRP(ARR,{'RAWAMP','MSO','ISI'});
                if isempty(MTCHS)
                    return;
                end
                
                PLTMTRX = [];
                for z = 1:size(MTCHS,1)
                    
                    TMP = cell2mat(MTCHS(z,[4 5 6]));
                    
                    %set isi for reference zero and discard MSO (no longer
                    %required)
                    TMP(logical(sum(([TMP(:,7) == 0 TMP(:,8) == 0]),2)),9) = 0;
                    
                    %welcher Kanal ist der staerkste?
                    CHN = find(max(max(TMP(:,1:6))) == max(TMP(:,1:6)));
                    
                    TMP = TMP(:,[CHN 9]);
                    
                    TMP = [((MEPmean(TMP(logical(TMP(:,2) ~= 0),1)) / MEPmean(TMP(logical(TMP(:,2) == 0),1)))-1)*100 max(TMP(:,2))];
                    
                    if ~isnan(TMP(1,1)) && ~isinf(TMP(1,1))
                        PLTMTRX(end+1,:) = [cell2mat(MTCHS(z,[1:3])) TMP];
                    else
                        disp(['Infinite or illegal result (NaN) for: ' char(CURRSUB(get(handles.SBJTS,'val'),:)) ...
                            ' - sequence: ' char(ARR(1,cell2mat(MTCHS(z,2)),cell2mat(MTCHS(z,3)),1)) '... skipping']);
                    end
                end
                
                %GROUPSPEC MATRIX
                GRPS = unique(PLTMTRX(:,1));
                GRPMTRX = [];
                for z = 1:length(GRPS)
                    TMP = PLTMTRX(logical(PLTMTRX(:,1) == GRPS(z)),:);
                    
                    ISI = unique(TMP(:,5));
                    for y = 1:length(ISI)
                        SZ = sum(logical(TMP(:,5) == ISI(y))); % size of arry to be added
                        GRPMTRX(end+1 : end + SZ,:) = [(ones(SZ,1) .* z) ...
                            (ones(SZ,1) .* ISI(y)) TMP(logical(TMP(:,5) == ISI(y)),4)];
                    end
                end
                
                %SUBJSPEC MATRIX
                SUBIDX = unique(PLTMTRX(:,2));
                SUBMTRX = [];
                for z = 1:length(SUBIDX)
                    TMP = PLTMTRX(logical(PLTMTRX(:,2) == SUBIDX(z)),:);
                    
                    ISI = unique(TMP(:,5));
                    for y = 1:length(ISI)
                        
                        FITISI = TMP(logical(TMP(:,5) == ISI(y)),:);
                        
                        
                        for h = 1:length(GRPS)
                            if ~isempty(FITISI(logical(FITISI(:,1) == GRPS(h)), 4))
                                
                                SZ = sum(logical(FITISI(:,1) == GRPS(h)));
                                
                                SUBMTRX(end+1 : end + SZ,:) = [(ones(SZ,1) .* z)...
                                    (ones(SZ,1) .* h) (ones(SZ,1) .* ISI(y)) ...
                                    FITISI(logical(FITISI(:,1) == GRPS(h)), 4)];
                                
                            end
                        end
                        
                    end
                end
                
                %---------
                %--- 2 ---
                %---------
            case 'recruitment curve'
                [MTCHS SGRP] = SBGRP(ARR,{'RAWAMP','MSO'});
                if isempty(MTCHS)
                    return;
                end
                
                PLTMTRX = {};
                for z = 1:size(MTCHS,1)
                    
                    TMP = cell2mat(MTCHS(z,[4 5]));
                    
                    INTS = unique(TMP(:,8));
                    
                    CHN = find(max(MEPmean(TMP(:,1:6))) == MEPmean(TMP(:,1:6)));
                    
                    
                    for k = 1:length(INTS)
                        
                        MNADD = MEPmean(TMP(logical(TMP(:,8) == INTS(k)),CHN));
                        %cell2mat, um den CHN rauszubekommen
                        PLTMTRX(end+1,:) = [MTCHS(z,1:3) {INTS(k)} {MNADD}];
                    end
                    
                end
                
                %GROUPSPEC MATRIX
                GRPS = unique(cell2mat(PLTMTRX(:,1)));
                GRPMTRX = {};
                for z = 1:length(GRPS)
                    TMP = PLTMTRX(logical(cell2mat(PLTMTRX(:,1)) == GRPS(z)),:);
                    
                    INTS = unique(cell2mat(TMP(:,4)));
                    for y = 1:length(INTS)
                        GRPMTRX(end+1,:) = [{z} {INTS(y)} {cell2mat(TMP(logical(cell2mat(TMP(:,4)) == INTS(y)),5))}];
                    end
                end
                
                %SUBJSPEC MATRIX
                SUBIDX = unique(cell2mat(PLTMTRX(:,2)));
                PLTMTRX = {};
                for i = 1:length(SUBIDX)
                    
                    HLD = MTCHS(logical(cell2mat(MTCHS(:,2)) == SUBIDX(i)),:);
                    
                    for z = 1:size(GRPS,1)
                        
                        TMP = cell2mat(HLD(logical(cell2mat(HLD(:,1)) == GRPS(z)),[4 5]));
                        
                        if ~isempty(TMP)
                            
                            INTS = unique(TMP(:,8));
                            
                            CHN = find(max(MEPmean(TMP(:,1:6))) == MEPmean(TMP(:,1:6)));
                            
                            for k = 1:length(INTS)
                                %cell2mat, um den CHN rauszubekommen
                                PLTMTRX(end+1,:) = [{i} {z} {INTS(k)} {TMP(logical(TMP(:,8) == INTS(k)),CHN)}];
                            end
                            
                        end
                        
                    end
                end
                SUBMTRX = PLTMTRX;
                
                
                %%%%%%%
                %------
                %--- 3
                %------
                %%%%%%%
            case 'thresholds'
                
                
                [MTCHS SGRP] = SBGRP(ARR,{'MSO'});
                if isempty(MTCHS)
                    return;
                end
                
                PLTMTRX = cell2mat(MTCHS);
                
                %GROUPSPEC MATRIX
                GRPS = unique(PLTMTRX(:,1));
                GRPMTRX = [];
                for z = 1:length(GRPS)
                    
                    SZ = sum(PLTMTRX(:,1) == z);
                    
                    GRPMTRX(end+1 : end + SZ,:) = [(ones(SZ,1) .* z) ones(SZ,1) ...
                        PLTMTRX(PLTMTRX(:,1) == z,4)];
                end
                
                %SUBJSPEC MATRIX
                SUBIDX = unique(PLTMTRX(:,2));
                SUBMTRX = [];
                
                for t = 1:length(SUBIDX)
                    
                    for z = 1:length(GRPS)
                        
                        TMP = PLTMTRX(PLTMTRX(:,2) == t,:);
                        
                        SZ = sum(TMP(:,1) == z);
                        
                        SUBMTRX(end+1 : end + SZ ,:) = [(ones(SZ,1) .* t) (ones(SZ,1) .* z) ...
                            ones(SZ,1) TMP(TMP(:,1) == z,4)];
                    end
                    
                end
                
        end
        
end


if ~exist('GRPMTRX','var')
    errordlg('The chosen plot is not available for this evaluation type');
    return;
end

%-------------------
%----- PLOT --------
%-------------------
switch char(CURRPLT(get(handles.PLTTYPE,'val'),1))
    case {'BAR','SCATTER'}
        %- GROUPS
            GRPIDX = unique(GRPMTRX(:,1));
        if get(handles.PLTsbgrp,'val')
            % sein
            figure; set(gcf, 'name','subgroups / all subjects')
            for i = 1:length(GRPIDX)
                subplot(1,length(GRPIDX),i),
                
                CRRBARS = GRPMTRX(logical(GRPMTRX(:,1) == GRPIDX(i)),[1 2 3 4]);
                switch char(CURRPLT(get(handles.PLTTYPE,'val'),1))
                    case 'BAR'
                        bar(CRRBARS(:,2),CRRBARS(:,3),...
                            'FaceColor',[0.5 0.5 0.5],...
                            'BarWidth',0.8);
                    case 'SCATTER'
                        scatter(CRRBARS(:,2),CRRBARS(:,3),'bx');
                end
                hold on
                
                for j = 1:size(CRRBARS,1)
                    errorbar(CRRBARS(j,2),CRRBARS(j,3),-CRRBARS(j,4),...
                        CRRBARS(j,4));
                end
                title(char(SGRP(i)));
                set(gca,'xlim',[min(GRPMTRX(:,2))-(max(GRPMTRX(:,2))/10) max(GRPMTRX(:,2))+(max(GRPMTRX(:,2))/10)]);
                set(gca,'ylim',[(min(GRPMTRX(:,3) - GRPMTRX(:,4))-10) (max(GRPMTRX(:,3) + GRPMTRX(:,4)) + 10)]);
                hold off
            end
        else

        end
        
        %- SUBJECTS
        if get(handles.PLTsingle,'val') == 1
           
            SUBIDX = unique(SUBMTRX(:,1));
            % sein
            [s,v] = listdlg('PromptString','Select a subject(s):',...
                'SelectionMode','multple',...
                'ListString',CURRSUB,'initialvalue',get(handles.SBJTS,'val'));
            SUBIDX = SUBIDX(s);
            [s,v] = listdlg('PromptString','Select a condition(s):',...
                'SelectionMode','multple',...
                'ListString',get(handles.SBGRPS,'str'),'initialvalue',1:length(get(handles.SBGRPS,'str')));
            GRPIDX = GRPIDX(s);
            %
            figure; set(gcf, 'name','subjects / all subgroups')
            for i = 1:length(SUBIDX)
                CRRBAR = SUBMTRX(logical(SUBMTRX(:,1) == SUBIDX(i)),[1:5]);
                for k = 1:length(GRPIDX)
                    CRRBARS = CRRBAR(logical(CRRBAR(:,2) == GRPIDX(k)),[2:5]);
                    subplot(length(GRPIDX),length(SUBIDX),(i+ (length(SUBIDX)* (k-1)))),
                    switch char(CURRPLT(get(handles.PLTTYPE,'val'),1))
                        case 'BAR'
                            bar(CRRBARS(:,2),CRRBARS(:,3),...
                                'FaceColor',[0.5 0.5 0.5],...
                                'BarWidth',0.8);
                        case 'SCATTER'
                            scatter(CRRBARS(:,2),CRRBARS(:,3),'bx');
                    end
                    hold on
                    for j = 1:size(CRRBARS,1)
                        errorbar(CRRBARS(j,2),CRRBARS(j,3),-CRRBARS(j,4),CRRBARS(j,4));
                    end
                    title([char(SGRP(k)) ' - '  strrep(char(CURRSUB(SUBIDX(i),1)),'_','')]);
                    if length(s) == length(CURRSUB)
                        set(gca,'xlim',[min(GRPMTRX(:,2))-(max(GRPMTRX(:,2))/10) max(GRPMTRX(:,2))+(max(GRPMTRX(:,2))/10)]);
                        set(gca,'ylim',[(min(GRPMTRX(:,3) - GRPMTRX(:,4))-10) (max(GRPMTRX(:,3) + GRPMTRX(:,4)) + 10)]);
                    end
                end
            end
            % contrast plot (sein)
             SUBIDX = unique(SUBMTRX(:,1)); % all
           
            for i = 1:length(SUBIDX)
                CRRBAR = SUBMTRX(logical(SUBMTRX(:,1) == SUBIDX(i)),[1:5]);
                D = zeros(size(CRRBARS,1),length(GRPIDX));
                for k = 1:length(GRPIDX)
                    CRRBARS = CRRBAR(logical(CRRBAR(:,2) == GRPIDX(k)),[2:5]);
                    D(1:length(CRRBARS(:,3)),k) = CRRBARS(:,3);
                end
                 D1(i,:) = zeros(1,6); D2(i,:) = zeros(1,6);
                try D1(i,:) = [D(1:6,3)-D(1:6,1)]'; catch D1(i,1:size(D,2)) = [D(1:end,3)-D(1:end,1)]'; end
                try D2(i,:) = [D(1:6,4)-D(1:6,2)]'; catch D2(i,1:size(D,2)) = [D(1:end,4)-D(1:end,2)]'; end
                figure, set(gcf,'name',CURRSUB{i})
                subplot(3,2,1:2),bar([D]), legend(SGRP)
                subplot(3,2,3),bar([D(:,2)-D(:,1)]), title([SGRP{2} '-' SGRP{1}])
                subplot(3,2,4),bar([D(:,4)-D(:,3)]), title([SGRP{4} '-' SGRP{3}])
                subplot(3,2,5),bar([D(:,3)-D(:,1)]), title([SGRP{3} '-' SGRP{1}])
                subplot(3,2,6),bar([D(:,4)-D(:,2)]), title([SGRP{4} '-' SGRP{2}])
                hold off
                DX{i} = D;
            end
            figure, 
            D1(D1==0) = NaN;D2(D2==0) = NaN;
            subplot(2,1,1), boxplot(D1),grid on, title([SGRP{3} '-' SGRP{1}])
            subplot(2,1,2), boxplot(D2), grid on, title([SGRP{4} '-' SGRP{2}])
        end
        clear DX2
        for dx = 1:size(DX,2);
            DX2(dx,:,:) = DX{dx};
        end
        for dx = 1:size(DX2,1);
            DX2(dx,:,:) = DX2(dx,:,:)/max(max(max(DX2(dx,:,:))));
        end
        DXm = reshape(median(DX2,1),7,4);
        DXs = reshape(quantile(DX2,[.925], 1),7,4);
        figure, 
        bar(DXm);grid on
       
        
    case {'BOXPLOT - first level','BOXPLOT - second level'}
        %- GROUPS
        clear TMP
        if ~iscell(GRPMTRX)
            
            for i = 1:size(GRPMTRX,1)
                
                for j = 1:size(GRPMTRX,2)
                    
                    TMP(i,j) = {GRPMTRX(i,j)};
                    
                end
            end
            
            GRPMTRX = TMP;
            clear TMP;
        end
        
        GRPIDX = unique(cell2mat(GRPMTRX(:,1)));
        figure;
        
        for i = 1:length(GRPIDX)
            subplot(1,length(GRPIDX),i),
            
            TMP = GRPMTRX(logical(cell2mat(GRPMTRX(:,1)) == GRPIDX(i)),:);
            
            TMPgrp = {};
            for k = 1:size(TMP,1)
                TMPgrp((end+1 : end+size(cell2mat(TMP(k,3)),1)),1) = TMP(k,2);
            end
            
            boxplot(cell2mat(TMP(:,3)),TMPgrp);
            hold on
            title(char(SGRP(i)));
            
            if get(handles.evaltype,'val') == (strmatch('threshold',NBS.ANALYSIS.MTRXhdr(:,1)) + 1)
                set(gca,'ylim',[(min(cell2mat(GRPMTRX(:,3))) -20) (max(cell2mat(GRPMTRX(:,3))) + 20)]);
            else
                set(gca,'ylim',[(min(cell2mat(GRPMTRX(:,3))) -200) (max(cell2mat(GRPMTRX(:,3))) + 200)]);
            end
            
            hold off
        end
        
        %- SUBJECTS
        if get(handles.PLTsingle,'val') == 1
            
            clear TMP
            if ~iscell(SUBMTRX)
                
                for i = 1:size(SUBMTRX,1)
                    
                    for j = 1:size(SUBMTRX,2)
                        
                        TMP(i,j) = {SUBMTRX(i,j)};
                        
                    end
                end
                
                SUBMTRX = TMP;
                clear TMP;
            end
            
            GRPIDX = unique(cell2mat(GRPMTRX(:,1)));
            
            figure;
            
            for i = 1:length(SUBIDX)
                
                GRPMTRX = SUBMTRX(logical(cell2mat(SUBMTRX(:,1)) == SUBIDX(i)),2:4);
                
                for k = 1:length(GRPIDX)
                    subplot(length(GRPIDX),length(SUBIDX),(i+ (length(SUBIDX)* (k-1)))),
                    
                    TMP = GRPMTRX(logical(cell2mat(GRPMTRX(:,1)) == GRPIDX(k)),:);
                    
                    TMPgrp = {};
                    for z = 1:size(TMP,1)
                        TMPgrp((end+1 : end+size(cell2mat(TMP(z,3)),1)),1) = TMP(z,2);
                    end
                    
                    boxplot(cell2mat(TMP(:,3)),TMPgrp);
                    hold on
                    title([char(SGRP(k)) ' - ' char(CURRSUB(i))]);
                    if get(handles.evaltype,'val') == (strmatch('threshold',NBS.ANALYSIS.MTRXhdr(:,1)) + 1)
                        set(gca,'ylim',[(min(cell2mat(GRPMTRX(:,3))) -20) (max(cell2mat(GRPMTRX(:,3))) + 20)]);
                    else
                        set(gca,'ylim',[(min(cell2mat(GRPMTRX(:,3))) -200) (max(cell2mat(GRPMTRX(:,3))) + 200)]);
                    end
                    hold off
                end
            end
        end
end





% --- Executes on selection change in STATchs.
function STATchs_Callback(hObject, eventdata, handles)
% hObject    handle to STATchs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns STATchs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from STATchs


% --- Executes during object creation, after setting all properties.
function STATchs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to STATchs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in STATgo.
function STATgo_Callback(hObject, eventdata, handles)
% hObject    handle to STATgo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%%%
% NOTE THAT THE FIRST CALCULATIONS EQUAL THOSE DONE IN THE PLOT SECTION
%%%%


ARR = CMPL4D;
NBS = evalin('base','NBS');

EXM = get(handles.evaltype,'str');
EXM = lower(EXM(get(handles.evaltype,'val')));

if isempty(ARR)
    disp('No data for this condition loaded');
    return;
end

CURRPLT = get(handles.STATchs,'str');

%-----------------------
% EXAMSPEC PREPROCESSING
CURRSUB = get(handles.SBJTS,'str');

% %% go through different plots
switch char(CURRPLT(get(handles.STATchs,'val'),1))
    
    %-------------
    %%% any ttest
    
    case 'ANOVA - first level'
        %%% Bedenke hier auch ANOVA optionen / hier aber second level!
        % GENERATE A DOUBLE MATRIX WITH FOLLOWING SPECIFICATIONS:
        % GROUP: GRPMTRX( GROUPINDEX, CATEGORIES(x scale), VALUES (y-scale))
        %
        % SUBJECTS: SUBMTRX( SUBIDX, GROUPINDEX, CATEGORIES(x scale), VALUES (y-scale))
        
        
        switch lower(char(NBS.ANALYSIS.MTRXhdr((get(handles.evaltype,'val') -1),1)))
            
            %---------
            %--- 1 ---
            %---------
            case 'paired - pulse'
                
                errordlg('A first-level analysis for paired pulse is not possible.')
                return;
                
                %---------
                %--- 2 ---
                %---------
            case 'recruitment curve'
                [MTCHS SGRP] = SBGRP(ARR,{'RAWAMP','MSO'});
                if isempty(MTCHS)
                    return;
                end
                
                PLTMTRX = {};
                for z = 1:size(MTCHS,1)
                    
                    TMP = cell2mat(MTCHS(z,[4 5]));
                    
                    INTS = unique(TMP(:,8));
                    
                    CHN = find(max(MEPmean(TMP(:,1:6))) == MEPmean(TMP(:,1:6)));
                    
                    for k = 1:length(INTS)
                        
                        %cell2mat, um den CHN rauszubekommen
                        PLTMTRX(end+1,:) = [MTCHS(z,1:3) {INTS(k)} {TMP(logical(TMP(:,8) == INTS(k)),CHN)}];
                    end
                    
                end
                
                %GROUPSPEC MATRIX
                GRPS = unique(cell2mat(PLTMTRX(:,1)));
                GRPMTRX = {};
                for z = 1:length(GRPS)
                    TMP = PLTMTRX(logical(cell2mat(PLTMTRX(:,1)) == GRPS(z)),:);
                    
                    INTS = unique(cell2mat(TMP(:,4)));
                    for y = 1:length(INTS)
                        GRPMTRX(end+1,:) = [{z} {INTS(y)} {cell2mat(TMP(logical(cell2mat(TMP(:,4)) == INTS(y)),5))}];
                    end
                end
                
                %SUBJSPEC MATRIX
                SUBIDX = unique(cell2mat(PLTMTRX(:,2)));
                SUBMTRX = PLTMTRX(:,[2 1 4 5]);
                
        end
        
    case {'ANOVA - second level', 'ttest - paired - two-tailed', 'ttest - unpaired - two-tailed'}
        
        switch lower(char(NBS.ANALYSIS.MTRXhdr((get(handles.evaltype,'val') -1),1)))
            %---------
            %--- 1 ---
            %---------
            case 'paired - pulse'
                %%% Bedenke hier auch ANOVA optionen / hier aber second level!
                % GENERATE A DOUBLE MATRIX WITH FOLLOWING SPECIFICATIONS:
                % GROUP: GRPMTRX( GROUPINDEX, CATEGORIES(x scale), VALUES (y-scale))
                %
                % SUBJECTS: SUBMTRX( SUBIDX, GROUPINDEX, CATEGORIES(x scale),
                % VALUES (y-scale))
                
                %WORK
                %hier noch paired-pulse rein!!!
                [MTCHS SGRP] = SBGRP(ARR,{'RAWAMP','MSO','ISI'});
                if isempty(MTCHS)
                    return;
                end
                
                PLTMTRX = [];
                for z = 1:size(MTCHS,1)
                    
                    TMP = cell2mat(MTCHS(z,[4 5 6]));
                    
                    %set isi for reference zero and discard MSO (no longer
                    %required)
                    TMP(logical(sum(([TMP(:,7) == 0 TMP(:,8) == 0]),2)),9) = 0;
                    
                    %welcher Kanal ist der staerkste?
                    CHN = find(max(max(TMP(:,1:6))) == max(TMP(:,1:6)));
                    
                    TMP = TMP(:,[CHN 9]);
                    
                    TMP = [((MEPmean(TMP(logical(TMP(:,2) ~= 0),1)) / MEPmean(TMP(logical(TMP(:,2) == 0),1)))-1)*100 max(TMP(:,2))];
                    
                    if ~isnan(TMP(1,1)) && ~isinf(TMP(1,1))
                        PLTMTRX(end+1,:) = [cell2mat(MTCHS(z,[1:3])) TMP];
                    else
                        disp(['Infinite or illegal result (NaN) for: ' char(CURRSUB(get(handles.SBJTS,'val'),:)) ...
                            ' - sequence: ' char(ARR(1,cell2mat(MTCHS(z,2)),cell2mat(MTCHS(z,3)),1)) '... skipping']);
                    end
                end
                
                %GROUPSPEC MATRIX
                GRPS = unique(PLTMTRX(:,1));
                
                %SUBJSPEC MATRIX
                SUBIDX = unique(PLTMTRX(:,2));
                SUBMTRX = [];
                for z = 1:length(SUBIDX)
                    TMP = PLTMTRX(logical(PLTMTRX(:,2) == SUBIDX(z)),:);
                    
                    ISI = unique(TMP(:,5));
                    for y = 1:length(ISI)
                        
                        FITISI = TMP(logical(TMP(:,5) == ISI(y)),:);
                        
                        
                        for h = 1:length(GRPS)
                            if ~isempty(FITISI(logical(FITISI(:,1) == GRPS(h)), 4))
                                
                                SZ = sum(logical(FITISI(:,1) == GRPS(h)));
                                
                                SUBMTRX(end+1 : end + SZ,:) = [(ones(SZ,1) .* z)...
                                    (ones(SZ,1) .* h) (ones(SZ,1) .* ISI(y)) ...
                                    FITISI(logical(FITISI(:,1) == GRPS(h)), 4)];
                                
                            end
                        end
                        
                    end
                end
                
                clear TMP
                if ~iscell(SUBMTRX)
                    
                    for i = 1:size(SUBMTRX,1)
                        
                        for j = 1:size(SUBMTRX,2)
                            
                            TMP(i,j) = {SUBMTRX(i,j)};
                            
                        end
                    end
                    
                    SUBMTRX = TMP;
                    clear TMP;
                end
                
                
                
                %---------
                %--- 2 ---
                %---------
            case 'recruitment curve'
                [MTCHS SGRP] = SBGRP(ARR,{'RAWAMP','MSO'});
                if isempty(MTCHS)
                    return;
                end
                
                PLTMTRX = {};
                for z = 1:size(MTCHS,1)
                    
                    TMP = cell2mat(MTCHS(z,[4 5]));
                    
                    INTS = unique(TMP(:,8));
                    
                    CHN = find(max(MEPmean(TMP(:,1:6))) == MEPmean(TMP(:,1:6)));
                    
                    
                    for k = 1:length(INTS)
                        
                        MNADD = MEPmean(TMP(logical(TMP(:,8) == INTS(k)),CHN));
                        %cell2mat, um den CHN rauszubekommen
                        PLTMTRX(end+1,:) = [MTCHS(z,1:3) {INTS(k)} {MNADD}];
                    end
                    
                end
                
                %GROUPSPEC MATRIX
                GRPS = unique(cell2mat(PLTMTRX(:,1)));
                GRPMTRX = {};
                for z = 1:length(GRPS)
                    TMP = PLTMTRX(logical(cell2mat(PLTMTRX(:,1)) == GRPS(z)),:);
                    
                    INTS = unique(cell2mat(TMP(:,4)));
                    for y = 1:length(INTS)
                        GRPMTRX(end+1,:) = [{z} {INTS(y)} {cell2mat(TMP(logical(cell2mat(TMP(:,4)) == INTS(y)),5))}];
                    end
                end
                
                %SUBJSPEC MATRIX
                SUBIDX = unique(cell2mat(PLTMTRX(:,2)));
                PLTMTRX = {};
                cnt = 0;
                for i = 1:length(SUBIDX)
                    
                    HLD = MTCHS(logical(cell2mat(MTCHS(:,2)) == SUBIDX(i)),:);
                    
                    for z = 1:size(GRPS,1)
                        
                        TMP = cell2mat(HLD(logical(cell2mat(HLD(:,1)) == GRPS(z)),[4 5]));
                        
                        if ~isempty(TMP)
                            
                            INTS = unique(TMP(:,8));
                            
                            CHN = find(max(MEPmean(TMP(:,1:6))) == MEPmean(TMP(:,1:6)));
                            
                            for k = 1:length(INTS)
                                %cell2mat, um den CHN rauszubekommen ; evtl
                                %ist hier die std mit drin
                                PLTMTRX(end+1,:) = [{i} {z} {INTS(k)} {MEPmean(cell2mat({TMP(logical(TMP(:,8) == INTS(k)),CHN)}))}];
                            end
                            
                        end
                        
                    end
                end
                SUBMTRX = PLTMTRX;
                
                %%%%%%%
                %------
                %--- 3
                %------
                %%%%%%%
            case 'thresholds'
                
                
                [MTCHS SGRP] = SBGRP(ARR,{'MSO'});
                if isempty(MTCHS)
                    return;
                end
                
                PLTMTRX = cell2mat(MTCHS);
                
                %GROUPSPEC MATRIX
                GRPS = unique(PLTMTRX(:,1));
                GRPMTRX = [];
                for z = 1:length(GRPS)
                    
                    SZ = sum(PLTMTRX(:,1) == z);
                    
                    GRPMTRX(end+1 : end + SZ,:) = [(ones(SZ,1) .* z) ones(SZ,1) ...
                        PLTMTRX(PLTMTRX(:,1) == z,4)];
                end
                
                %SUBJSPEC MATRIX
                SUBIDX = unique(PLTMTRX(:,2));
                SUBMTRX = [];
                
                for t = 1:length(SUBIDX)
                    
                    for z = 1:length(GRPS)
                        
                        TMP = PLTMTRX(PLTMTRX(:,2) == t,:);
                        
                        SZ = sum(TMP(:,1) == z);
                        
                        SUBMTRX(end+1 : end + SZ ,:) = [(ones(SZ,1) .* t) (ones(SZ,1) .* z) ...
                            ones(SZ,1) TMP(TMP(:,1) == z,4)];
                    end
                    
                end
                
                clear TMP
                if ~iscell(SUBMTRX)
                    
                    for i = 1:size(SUBMTRX,1)
                        
                        for j = 1:size(SUBMTRX,2)
                            
                            TMP(i,j) = {SUBMTRX(i,j)};
                            
                        end
                    end
                    
                    SUBMTRX = TMP;
                    clear TMP;
                end
                
        end
        
end

if ~exist('SUBMTRX','var')
    errordlg('The chosen stat is not available for this evaluation type');
    return;
end

%-------------------
%----- STAT --------
%-------------------
switch char(CURRPLT(get(handles.STATchs,'val'),1))
    
    %-------------
    %%% any ttest
    case {'ttest - paired - two-tailed', 'ttest - unpaired - two-tailed'}
        
        if length(GRPS) > 2
            errordlg('Reduce the number of subgroups to two to perform a ttest');
            uiwait;
            return;
        elseif length(GRPS) < 1
            errordlg('Need two groups to be compared');
            uiwait;
            return;
        end
        
        SUBIDX = unique(cell2mat(SUBMTRX(:,1)));
        
        ANFCT = {};
        ANMTRX = [];
        
        for i = 1:size(SUBMTRX,1)
            
            VAL = cell2mat(SUBMTRX(i,4));
            
            for k = 1:length(VAL)
                
                ANMTRX(end+1,1) = VAL(k);
                ANFCT(end+1,:) = SUBMTRX(i,1:3);
            end
            
        end
        
        ANFCT = cell2mat(ANFCT);
        
        
        %%%. JUST SORTING DATA
        
        TTMTRX = ones(size(ANMTRX,1),4);
        cnt = 1;
        TMSPRM = unique(ANFCT(:,3));
        
        
        for i = 1:length(TMSPRM)
            
            for j = 1:length(GRPS)
                
                for k = 1:length(SUBIDX)
                    
                    GT = zeros(size(ANFCT,1),3);
                    
                    GT(:,1) = ANFCT(:,1) == SUBIDX(k);
                    GT(:,2) = ANFCT(:,2) == GRPS(j);
                    GT(:,3) = ANFCT(:,3) == TMSPRM(i);
                    GT = sum(GT,2);
                    
                    if max(GT) == 3  %i.e. all conditions exists for this subject
                        
                        TTMTRX(cnt : (cnt + sum(GT == 3) - 1),[2 3 1]) = ANFCT(GT == 3,:);
                        TTMTRX(cnt : (cnt + sum(GT == 3) - 1),4) = ANMTRX(GT == 3,:);
                        
                        %data matrix (Size of matrix must be n-by-4;dependent variable=column 4;
                        %independent variable 1 (TMS_PARAM) =column 1;independent variable 2 (GROUP) =column 2;
                        %subject=column 3).
                        
                        cnt = (cnt + sum(GT == 3) - 1) + 1;
                        
                    else
                        
                        disp(['Skipping following condition: SUB: ' char(CURRSUB(k)) ', GROUP:' ...
                            char(SGRP(j)) ', PARAM ' num2str(TMSPRM(i)) '; does not exist']);
                        
                    end
                    
                end
            end
        end
        
        RES = {'RESULTS:' };
        
        if  length(SUBIDX) < 8
            RES(end+1,1) = {['YOU HAVE ONLY ' num2str(length(SUBIDX)) ' SUBJECTS TO BE TESTED']};
        end
        
        RES(end+1,1) = {' '};
        
        for i = 1:length(TMSPRM)
            
            
            TMP = TTMTRX(TTMTRX(:,1) == TMSPRM(i),:);
            
            
            %%% look for subjects fulfilling all criteria
            SUBS = SUBIDX; %SUBJECTS THAT CAN BE USED FOR EVALUATION
            
            for j = 1:length(SUBIDX)
                
                for k = 1 : length(GRPS)
                    
                    if sum(GRPS(k) == TMP(TMP(:,2) == SUBIDX(j),3)) == 0
                        
                        SUBS = SUBS(SUBS ~= SUBIDX(j),:);
                        TMP = TMP(TMP(:,2) ~= SUBIDX(j),:);
                        
                    end
                    
                end
                
            end
            
            
            if length(SUBS) < 2
                %% falls weniger als 2 subs, kein vergleich
                disp(['Cannot compare PARAM: ' num2str(TMSPRM(i)) ' for GROUP: ' char(SGRP(j)) ...
                    ' because number of subjects for all groups is lower than 2']);
                
            else
                
                DSPSUB = '';
                for l = 1:length(SUBS)
                    
                    DSPSUB(end+1 : (end + length(num2str(SUBS(l))) + 1)) = [num2str(SUBS(l)) ' '];
                    
                end
                
                switch char(CURRPLT(get(handles.STATchs,'val'),1))
                    
                    case 'ttest - paired - two-tailed'
                        
                        if ~(length(TMP(TMP(:,3) == GRPS(1),4)) ~= length(TMP(TMP(:,3) == GRPS(2),4)))
                            
                            [h p] = ttest(TMP(TMP(:,3) == GRPS(1),4),TMP(TMP(:,3) == GRPS(2),4),0.05,'both');
                            
                        else
                            disp(['Groups have arrays of different length for '...
                                'PARAM: ' num2str(TMSPRM(i)) ' | SUBJ: '...
                                DSPSUB]);
                        end
                        
                    case 'ttest - unpaired - two-tailed'
                        
                        [h p] = ttest2(TMP(TMP(:,3) == GRPS(1),4),TMP(TMP(:,3) == GRPS(2),4),0.05,'both');
                end
                
                if exist('p','var') == 1
                    RES(end+1,1) = {['PARAM: ' num2str(TMSPRM(i)) ' | SUBJ: ' DSPSUB ,' | p = ' num2str(p)]};
                else
                    RES(end+1,1) = {['PARAM: ' num2str(TMSPRM(i)) ' | SUBJ: ' DSPSUB ,' | ERROR!']};
                end
                
            end
            
        end
        
        helpdlg(char(RES));
        disp(char(RES));
        
        %%%%%
        % ANOVA
        %%%%%
        
    case {'ANOVA - first level','ANOVA - second level'}
        %- GROUPS
        
        %special case --> one-way anova for thresholds
        if get(handles.evaltype,'val') == (strmatch('threshold',NBS.ANALYSIS.MTRXhdr(:,1)) + 1)
            ANOVA1(cell2mat(SUBMTRX(:,4)),cell2mat(SUBMTRX(:,2)));
            return;
        end
        
        SUBIDX = unique(cell2mat(SUBMTRX(:,1)));
        
        ANFCT = {};
        ANMTRX = [];
        
        for i = 1:size(SUBMTRX,1)
            
            VAL = cell2mat(SUBMTRX(i,4));
            
            for k = 1:length(VAL)
                
                ANMTRX(end+1,1) = VAL(k);
                ANFCT(end+1,:) = SUBMTRX(i,1:3);
            end
            
        end
        
        ANFCT = cell2mat(ANFCT);
        
        %within subject (alle wurden unter allen bedingungen gemessen
        
        %mixed (manche wurden unter allen, manche nicht unter allen
        %bedingungen gemessen)
        
        %between subject (keine auf gleicher ebener)
        
        %%%
        %ANOVA models
        if get(handles.ANbetween,'val') == 1
            
            %%%%%
            %%reines between subject modell
            [P,T,STATS,TERMS] = anovan(ANMTRX,{ANFCT(:,2) ANFCT(:,3)},...
                'model','full','varnames',{'GROUP';'TMS_PARAMS'});
            
        elseif get(handles.ANwithin,'val') == 1
            
            %%%%%
            %%repeatet measures anova
            
            
            %%check for consistent parameters (SUBJ)
            CHK_sub = unique(ANFCT(:,1));
            
            for i = 1:length(CHK_sub)
                CHK_sub(i,2) = sum(ANFCT(:,1) == CHK_sub(i,1));
            end
            
            if length(unique(CHK_sub(:,2))) > 1
                errordlg('Subjects do not have the same amount of data; you can try to use a second level analysis to overcome MEP differences in a first-level analysis');
                uiwait;
                return;
            end
            
            %%check for consistent parameters (GRP)
            CHK_grp = unique(ANFCT(:,2));
            
            for i = 1:length(CHK_grp)
                CHK_grp(i,2) = sum(ANFCT(:,2) == CHK_grp(i,1));
            end
            
            if length(unique(CHK_grp(:,2))) > 1
                errordlg('Data points for groups differ; you can try to use a second level analysis to overcome MEP differences in a first-level analysis');
                uiwait;
                return;
            end
            
            
            %%check for consistent parameters (PARAMS)
            CHK_prm = unique(ANFCT(:,3));
            
            for i = 1:length(CHK_prm)
                CHK_prm(i,2) = sum(ANFCT(:,3) == CHK_prm(i,1));
            end
            
            if length(unique(CHK_prm(:,2))) > 1
                errordlg('Data points for TMS parameters differ; you can try to use a second level analysis to overcome MEP differences in a first-level analysis');
                uiwait;
                return;
            end
            
            %%%% DATA CHECK DONE
            % DATA POINTS FOR ALL VARIABLES CAN BE ASSUMED EQUAL AND WOULD
            % FIT A WITHIN SUBJ CONDITION
            
            RMAOV2MTRX = ones(size(ANMTRX,1),4);
            cnt = 1;
            TMSPRM = unique(ANFCT(:,3));
            
            
            %params must be increasing intg numbers
            for i = 1:length(TMSPRM)
                
                ANFCT(  find(ANFCT(:,3) == TMSPRM(i)),3 ) = i;
                TMSPRM(i) = i;
                
            end
            
            for i = 1:length(TMSPRM)
                
                for j = 1:length(GRPS)
                    
                    for k = 1:length(SUBIDX)
                        
                        GT = zeros(size(ANFCT,1),3);
                        
                        GT(:,1) = ANFCT(:,1) == SUBIDX(k);
                        GT(:,2) = ANFCT(:,2) == GRPS(j);
                        GT(:,3) = ANFCT(:,3) == TMSPRM(i);
                        GT = sum(GT,2);
                        
                        RMAOV2MTRX(cnt : (cnt + sum(GT == 3) - 1),[4 2 3]) = ANFCT(find(GT == 3),:);
                        RMAOV2MTRX(cnt : (cnt + sum(GT == 3) - 1),1) = ANMTRX(find(GT == 3),:);
                        
                        %data matrix (Size of matrix must be n-by-4;dependent variable=column 1;
                        %independent variable 1=column 2;independent variable 2=column 3;
                        %subject=column 4).
                        
                        cnt = (cnt + sum(GT == 3) - 1) + 1;
                        
                    end
                end
            end
            
            
            RMAOV2(RMAOV2MTRX,0.05);
            
            
        elseif   get(handles.ANmixed,'val') == 1
            
            %%%%%
            %%MIXED CONDITION
            
            
            
            %%%% NO DATA CHECK HERE AS DESIGN IS MIXED.. JUST SORTING DATA
            
            BWAOV2MTRX = ones(size(ANMTRX,1),4);
            cnt = 1;
            TMSPRM = unique(ANFCT(:,3));
            
            
            %params must be increasing intg numbers
            for i = 1:length(TMSPRM)
                
                ANFCT(  find(ANFCT(:,3) == TMSPRM(i)),3 ) = i;
                TMSPRM(i) = i;
                
            end
            
            for i = 1:length(TMSPRM)
                
                for j = 1:length(GRPS)
                    
                    for k = 1:length(SUBIDX)
                        
                        GT = zeros(size(ANFCT,1),3);
                        
                        GT(:,1) = ANFCT(:,1) == SUBIDX(k);
                        GT(:,2) = ANFCT(:,2) == GRPS(j);
                        GT(:,3) = ANFCT(:,3) == TMSPRM(i);
                        GT = sum(GT,2);
                        
                        if max(GT) == 3  %i.e. all conditions exists for this subject
                            
                            BWAOV2MTRX(cnt : (cnt + sum(GT == 3) - 1),[4 2 3]) = ANFCT(GT == 3,:);
                            BWAOV2MTRX(cnt : (cnt + sum(GT == 3) - 1),1) = ANMTRX(GT == 3,:);
                            
                            %data matrix (Size of matrix must be n-by-4;dependent variable=column 1;
                            %independent variable 1=column 2;independent variable 2=column 3;
                            %subject=column 4).
                            
                            cnt = (cnt + sum(GT == 3) - 1) + 1;
                            
                        else
                            
                            disp(['Skipping following condition: SUB: ' char(CURRSUB(k)) ', GROUP:' ...
                                char(SGRP(j)) ', PARAM ' num2str(i) '; does not exist']);
                            
                        end
                        
                    end
                end
            end
            
            
            BWAOV2(BWAOV2MTRX,0.05);
            
        end
        
end


% --- Executes on button press in PLTsbgrp.
function PLTsbgrp_Callback(hObject, eventdata, handles)
% hObject    handle to PLTsbgrp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PLTsbgrp





% --- Executes on button press in RMsub.
function RMsub_Callback(hObject, eventdata, handles)
% hObject    handle to RMsub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

NBS = evalin('base','NBS');


IDX = ones(1,size(NBS.ANALYSIS.MTRXhdr{(get(handles.evaltype,'val')-1),2},1));

if isempty(IDX)
    disp('Layer not defined in RMsub_Callback...');
    return;
end

LAYER = get(handles.evaltype,'val')-1;

%Entfernen aller subjects dieser Untersuchung, werden unten wieder
%angefuegt
SBJCT = NBS.ANALYSIS.MTRXhdr{(get(handles.evaltype,'val')-1),2};

IDX(get(handles.SBJTS,'val')) = 0;
NBS.ANALYSIS.MTRXhdr{(get(handles.evaltype,'val')-1),2} = SBJCT(logical(IDX),:);

IDX = zeros(1,size(SBJCT,1));
IDX(get(handles.SBJTS,'val')) = 1;

% zu loeschendes subject mit leeren cells ueberschreiben
NBS.ANALYSIS.MTRX(LAYER,logical(IDX),:,:) = cell(size(NBS.ANALYSIS.MTRX(LAYER,logical(IDX),:,:)));


%Leere zweite Dimensionen werden mit nachfolgend vollen aufgefüllt;
%STEP 1 -> find empty dimensions
LEER = ones(1,size(NBS.ANALYSIS.MTRX,2));

for i = 1:length(LEER)
    
    FLLD = 0; %gefuellte felder, wenigstens eines sollte voll sein
    for j = 1:size(NBS.ANALYSIS.MTRX,3)
        
        for k = 1:size(NBS.ANALYSIS.MTRX,4)
            
            if ~isempty(cell2mat(NBS.ANALYSIS.MTRX(LAYER,i,j,k)))
                FLLD = FLLD + 1;
            end
        end
    end
    
    if FLLD == 0
        LEER(i) = 0;
    end
end

if any(sum(LEER)) %ergo, es gibt ueberhaupt sachen, die nachruecken koennen
    
    for z = 1:length(LEER)
        
        if LEER(z) == 0 && z < length(LEER)
            NBS.ANALYSIS.MTRX(LAYER,z,:,:) = NBS.ANALYSIS.MTRX(LAYER,(z+1),:,:);
            
            %und z+1 muss leer geschrieben werden, sonst bleiben noch daten
            %, falls die naechste matrix kleiner ist
            NBS.ANALYSIS.MTRX(LAYER,z+1,:,:) = cell(size(NBS.ANALYSIS.MTRX(LAYER,z+1,:,:)));
            
            %nochmal neue durchsuchen
            for i = 1:length(LEER)
                
                FLLD = 0; %gefuellte felder, wenigstens eines sollte voll sein
                for j = 1:size(NBS.ANALYSIS.MTRX,3)
                    
                    for k = 1:size(NBS.ANALYSIS.MTRX,4)
                        
                        if ~isempty(cell2mat(NBS.ANALYSIS.MTRX(LAYER,i,j,k)))
                            FLLD = FLLD + 1;
                        end
                    end
                end
                
                if FLLD == 0
                    LEER(i) = 0;
                end
            end
            
        end
    end
end

assignin('base','NBS',NBS);

feval('evaltype_Callback',handles.SBJTS,0,handles);


function [NBS] = CREATE4D(descr)

handles = evalin('base','handles');
%%load variables from base stack
NBS = evalin('base','NBS');

descr = lower(descr);


%%%%%%%%%%%%%%%%%%%
% STEP 1
%Definiere vor dem check, wovon bei den Daten ausgegangen werden soll
%%%%%%%%%%%%%%%%%%%


%%%%%
%NBS MATRIX HEADER WIRD AKTUALISIERT, ERSTELLT / ANGEPASST AN DIE GUI
%%%%%

asysindx = get(handles.evaltype,'str');
asysindx = lower(asysindx(2:end,:));

NBS.ANALYSIS.MTRXhdr(1:length(asysindx),1) = asysindx;

if isempty(descr) == 1
    chkindx = 0;
else
    chkindx = strmatch(descr, asysindx); %index über den switch case den check definiert
end

set(handles.evaltype,'val',chkindx + 1);


%%% UNTERPUNKT
% Definitionen anlegen
NBS.ANALYSIS.MTRXhdr(1,3) = {'Sequences (ascending)'};

DESC4D = {'TAG'; 'MEAN'; 'MEDIAN'; 'STD'; 'MSO'; 'ISI'; 'RAWAMP'};
NBS.ANALYSIS.MTRXhdr(1:length(DESC4D),4) = DESC4D;
clear DESC4D


%%%%% ENDE MATRIX HDR ERZEUGUNG


%%%%%%%%%%%%%%%%%%%
% STEP 2
% LOAD SUBJECT AND SEQUENCES CAUGHT BY h_NBS
% RESULT LOADED TO STRUCT "currsub", FIELDNAME == SUBJECT'S NAME
%%%%%%%%%%%%%%%%%%%

%% load selected subject to EXEVAL
subval = get(handles.popupmenu1,'val');

fname_config = fieldnames(NBS.CONFIG(1,subval));
currsub = struct();

for i = 1:(3 + size(fname_config,1))
    
    if i == 1
        currsub.('RAW') = NBS.DATA(1,subval).RAW; %get raw data for respective subject
        
    elseif i == 2
        tmp = NBS.GUI(1,subval).hdr; %get session details
        tic;
        j = 1;
        while 1 && toc < 5
            try
                hld = char(tmp(j,1));
                if isempty(strfind(hld,'Patient')) == 0
                    break;
                end
            end
            j = j+1;
        end
        hld = strrep(hld,'Patient Name: ','');
        hld = strrep(hld,' ','_');
        %%% chk if subject's name already exists
        try
            currnames = NBS.ANALYSIS.MTRXhdr{chkindx,2}(:,1);
            
            if any(strmatch(hld,currnames))
                
                % Subject already exists, load another time?
                answ = questdlg('Subject does already exist for this condition, load another time?');
                
                if answ(1,1) ~= 'Y'
                    return;
                end
                
                mtchs = currnames(strmatch(hld,currnames),:);
                mtch = char(mtchs(end,1));
                if isempty(str2num(mtch(1,end)))
                    hld = [hld '_2'];
                else
                    %erstelle liste aller benutzter zahlen
                    cntup = [];
                    for j = 1:size(mtchs,1)
                        if j > 9
                            errordlg('Maximum may not exceed 9, clear name tag including "9"');
                            return;
                        end
                        tmpchr = char(mtchs(j,1));
                        if ~isempty(str2num(tmpchr(1,end)))
                            cntup(end + 1) = str2num(tmpchr(1,end));
                        end
                    end
                    
                    hld = [hld '_' num2str(max(cntup) + 1)];
                end
                
            end
            currsub.('SUBJ') = hld;
        end
        
    elseif (i > 2) && (i <= (2 + size(fname_config,1)))
        currsub.(char(fname_config((i - 2) ,1))) = getfield(NBS.CONFIG(1,subval),char(fname_config((i - 2) ,1))); %get subject's details and admin
        
    else %replace sequence descriptions from CONFIG by GUI sequence descriptions;
        %size is different and CONFIG contains too few descriptions, just Sein knows why :)
        currsub.SEQ = NBS.GUI(1,subval).sequences;
        
    end
    
end


%%%%%%%%%%%%%%%%%%%
% STEP 3
% load sequences into 4D space and perform basic check
%%%%%%%%%%%%%%%%%%%

% 4D space instruction
% each layer represents data preprocessed for a particular condition, i.e.
% layer "paried pulse" (layer 2 according to asysindx [can be extended
% anytime]) contains data ment for PP evalutation;
% detailled instruction for other measures/evaluations can be find in hte
% respective section


% indexing subject, file and condition, not to create double entries
SBfile = get(handles.popupmenu1,'str');
SBfile = SBfile(get(handles.popupmenu1,'val'),1);


%%% BITTE descr hier drinstehen lassen, wirkt zunaechst redundant, kann
%%% spaeter aber helfen Daten wieder zuzuordnen, falls die first dimension
%%% indices sich aendern
try
    TMP = NBS.ANALYSIS.MTRXhdr{chkindx,2};
    if ~iscell(TMP)
        NBS.ANALYSIS.MTRXhdr(chkindx,2) = {[{hld} {descr} SBfile]};
    else
        NBS.ANALYSIS.MTRXhdr(chkindx,2) = {[TMP; ([{hld} {descr} SBfile])]};
    end
catch
    disp('Error adding one more subject');
    NBS.ANALYSIS.MTRXhdr(chkindx,2) = {[{hld} {descr} SBfile]};
end

% SUBSOFAR GIVES A LIST OF SUBJECTS FOR WHOM A LAYER HAS ALREADY BEEN
% CREATED, USE IT FOR DYNAMIC INDEXING
SUBSOFAR = size(NBS.ANALYSIS.MTRXhdr{chkindx,2},1);

%get tags and replace Sequence description by white space
TGS = strrep(currsub.SEQ, 'Sequence Description: ', '');

% Syntax: NBS.ANALYSIS.MTRX = {LAYER, SUBJ, TAG, DATA

GNRL = 0;


switch char(asysindx(chkindx,1))
    
    case 'thresholds'
        
        CURRSEQ = TGS;
        RMREF = [];
        
        if length(CURRSEQ) > 1
            ANSW = {};
            
            if length(CURRSEQ) < 10
                PRMPT = {'Which sequences should be considered?';...
                    '"0" indicates no, "1" indicates yes'; '';...
                    char(CURRSEQ(1,1))};
                
                a = cell(length(CURRSEQ),1);
                a(:,1) = {'1'};
                
                ANSW = INPUTDLG([{char(PRMPT)}; CURRSEQ(2:end,1)],'define sequences',1,a);
                if isempty(ANSW)
                    errordlg('Subject is not added to this layer, no sequences have been selected for evaluation');
                    uiwait;
                    return;
                end
                
            else
                
                STPS = ceil(length(CURRSEQ)/10);
                for z = 1:STPS
                    if z < STPS
                        PRMPTSEQ = CURRSEQ(((1:10)+(z-1)*10),:);
                    else
                        PRMPTSEQ = CURRSEQ(((z-1)*10 + 1):length(CURRSEQ),:);
                    end
                    
                    PRMPT = {'Which sequences should be considered?';...
                        '"0" indicates no, "1" indicates yes'; '';...
                        char(PRMPTSEQ(1,1))};
                    
                    a = cell(length(PRMPTSEQ),1);
                    a(:,1) = {'1'};
                    
                    ANSWt = INPUTDLG([{char(PRMPT)}; PRMPTSEQ(2:end,1)],'define sequences',1,a);
                    if isempty(ANSWt)
                        errordlg('Subject is not added to this layer, no sequences have been selected for evaluation');
                        uiwait;
                        return;
                    end
                    
                    ANSW((end + 1) : (end + length(ANSWt)),:) = ANSWt;
                end
                
                if length(strmatch('0',ANSW)) == length(CURRSEQ)
                    errordlg('Subject is not added to this layer, no sequences have been selected for evaluation');
                    uiwait;
                    return;
                end
                
                RMREF(end + 1 : end + length(strmatch('0',ANSW)),1) = strmatch('0',ANSW);
                
            end
        end
        
        TGSIDX = ones(length(TGS),1);
        TGSIDX(RMREF) = 0;
        TGS = TGS(logical(TGSIDX),:);
        
        for i = 1:length(TGS)
            MSO = currsub.RAW(1,i).MSO;
            NBS.ANALYSIS.MTRX(chkindx, SUBSOFAR, i,1) = TGS(i,1);
            NBS.ANALYSIS.MTRX(chkindx, SUBSOFAR, i, 5) = {MSO}; % MSO
        end
        
    case 'paired - pulse' %PP
        
        GNRL = 1; %general matrix is generated, see below
        
    case 'mean' %MEAN
        
        for i = 1:length(TGS)
            AMPS = currsub.RAW(1,i).AMPS;
            MSO = currsub.RAW(1,i).MSO;
            
            NBS.ANALYSIS.MTRX(chkindx, SUBSOFAR, i,1) = TGS(i,1);
            [MN MNSTD] = MEPmean(AMPS(:,[1 3 5 7 9 11])); % MEAN
            NBS.ANALYSIS.MTRX(chkindx, SUBSOFAR, i, 2) = {MN};
            NBS.ANALYSIS.MTRX(chkindx, SUBSOFAR, i, 4) = {MNSTD};
            %NBS.ANALYSIS.MTRX(chkindx, SUBSOFAR, i, 4) = {std(AMPS(:,[1 3 5 7 9 11]))}; % STD
        end
        
    case 'recruitment curve' %RC
        
        GNRL = 1; %general matrix is generated, see below
        
    case 'silent period' %RC
        
        GNRL = 1; %general matrix is generated, see below
end

%general matrix including mean, std, msi and isi
if GNRL == 1
    
    for i = 1:length(TGS)
        
        AMPS = currsub.RAW(1,i).AMPS;
        MSO = currsub.RAW(1,i).MSO;
        ISI = currsub.RAW(1,i).ISI;
        
        %REFERENZTABELLE
        NBS.ANALYSIS.MTRX(chkindx, SUBSOFAR, i,1) = TGS(i,1);
        [MN MNSTD] = MEPmean(AMPS(:,[1 3 5 7 9 11])); % MEAN
        NBS.ANALYSIS.MTRX(chkindx, SUBSOFAR, i, 2) = {MN};
        NBS.ANALYSIS.MTRX(chkindx, SUBSOFAR, i, 3) = {median(AMPS(:,[1 3 5 7 9 11]))}; % MEDIAN
        NBS.ANALYSIS.MTRX(chkindx, SUBSOFAR, i, 4) = {MNSTD}; % STD
        NBS.ANALYSIS.MTRX(chkindx, SUBSOFAR, i, 5) = {MSO}; % MSO
        NBS.ANALYSIS.MTRX(chkindx, SUBSOFAR, i, 6) = {ISI}; % ISI
        NBS.ANALYSIS.MTRX(chkindx, SUBSOFAR, i, 7) = {(AMPS(:,[1 3 5 7 9 11]))}; % raw AMPS
        
    end
end

% --------------------------------------------------------------------
%%% COMPILE 4D SUCH THAT NO EMPTY ARRAYS OCCUR FOR A CERTAIN LAYER
% results in an empty array if no data is loaded or gives an array with
% subjects and belonging data
function ARR = CMPL4D(NBS)

if nargin < 1
    NBS = evalin('base','NBS');
end

handles = evalin('base','handles');


%% COMPILE A SINGLE LAYER FOR THE RESPECTIVE EVALUATION
try % there might be no data for the respective evaluation --> skip
    
    ARR = NBS.ANALYSIS.MTRX((get(handles.evaltype,'val') - 1),:,:,:);
    
catch
    ARR = [];
    return;
end

% check dimensionwise
SZ = size(ARR);

SVstpbck = 1;

stpbck = 0; % falls subject keine brauchbaren daten enthaelt, wird es geloescht
for i = 1:SZ(2)
    %TMPdescr = {};
    TMPidx = [];
    
    if stpbck == 1
        i = i - SVstpbck;
        SVstpbck = SVstpbck + 1;  %merkt sich Spruenge zurueck (muessen aufaddiert werden)
    end
    
    %search for those arrays containing tags, ie.e having been sucessfully
    %imported
    for j = 1:SZ(3)
        if ~isempty(cell2mat(ARR(1,i,j,1)))
            %TMPdescr(end + 1) = ARR(1,i,j,1);
            TMPidx(end + 1) = j;
        end
    end
    
    stpbck = 0; % falls subject keine brauchbaren daten enthaelt, wird es geloescht
    if ~isempty(TMPidx) %i.e. dimension 3 (sequences) is not empty for this subject is not empty for this condition
        
        %put correct imported to the first rows
        ARR(1,i, (1: length(TMPidx)) ,:) = ARR(1,i,TMPidx,:);
        
        %set sucessive rows to "zero"
        for k = (length(TMPidx) + 1) : SZ(3)
            ARR(1,i, k ,:) = cell(1,1,1,SZ(4));
        end
        
    elseif  isempty(TMPidx) && i == SZ(2)% subject does not have any valid loaded sequence
        ARR = ARR(1, 1: (SZ(2)-1),:,:);
        
    else
        IDXsub = ones(1,SZ(2));
        IDXsub(i) = 0;
        ARR = ARR(1, logical(IDXsub),:,:);
        SZ = size(ARR);
        stpbck = 1; %jump a step back as successive subject moves in the position of the removed subject
    end
end


%%% SUBGROUP definition
function [MTCHS SBGRPs] = SBGRP(ARR,PRM)
% MTCHS is a 3 by x array with:
% column 1: Subgroup definition that has been searched
% column 2: Subject that has a matching sequence
% column 3: Sequence number
% all indices refer to their index in the ARR matrix

handles = evalin('base','handles');

SBGRPs = get(handles.SBGRPS,'str');
NBS = evalin('base','NBS');

%check if just one line -> create cell
if ischar(SBGRPs)
    SBGRPs = {SBGRPs};
end


MTCHS = {}; %is a x by 3 matrix containing the description to be matched (first column);
%the subject (second column) and the corresponding sequence (thirs column)

if nargin < 1
    errordlg('SBGRP required an ARR as input. Use CMPL4D to receive an array');
    uiwait;
    return;
elseif nargin < 2
    errordlg('Please give also the parameters (cell array of parameter abbreviations (can be found in NBS.ANALYSIS.MTRXhdr(:,4)) you would like to evaluate to the SBGRP function');
    uiwait;
    return;
end

%check if empty

if any(strmatch('subgroups',SBGRPs)) || get(handles.PLTsbgrp,'val') == 0
    
    for i = 1:size(ARR,2)  %just add all sequences
        
        for j = 1:size(ARR,3)
            if ~isempty(cell2mat(ARR(1,i,j,1)));
                MTCHS(end + 1, 1:3) = {1 i j};
            end
        end
        
    end
    MTCHSL = size(MTCHS,2);
    for k = 1:length(PRM)
        
        for l = 1:size(MTCHS,1)
            
            MTCHS(l,(MTCHSL + k)) = ARR(1,cell2mat(MTCHS(l,2)),cell2mat(MTCHS(l,3)),strmatch(PRM(k),NBS.ANALYSIS.MTRXhdr(:,4)));
        end
    end
    
    return;
end


for k = 1:size(SBGRPs,1)
    
    CURRGRP = regexp(SBGRPs(k,1),' ','split');
    CURRGRP = CURRGRP{1,1};
    for l = 1:length(CURRGRP)
        if ischar(cell2mat(CURRGRP(1,l)))
            CURRGRP(1,l) = lower(CURRGRP(1,l));
        end
    end
    
    for i = 1:size(ARR,2)
        
        %suche die sequenzbeschreibungen fuer einzelne subjects
        for j = 1:size(ARR,3)
            
            %falls hier keine weitere Beschreibung kommt
            if isempty(ARR(1,i,j,1))
                break;
            end
            
            CURRdesc = ARR(1,i,j,1);
            CURRdesc = regexp(CURRdesc,' ','split');
            CURRdesc = CURRdesc{1,1};
            for l = 1:length(CURRdesc)
                if ischar(cell2mat(CURRdesc(1,l)))
                    CURRdesc(1,l) = lower(CURRdesc(1,l));
                end
            end
            
            %check for mathes with SBGRP
            cnt = 0;
            for h = 1:length(CURRGRP)
                
                
                if get(handles.MTCHEX,'val') == 0 %default
                    MTCHRES = strmatch(CURRGRP(1,h),CURRdesc);
                else
                    MTCHRES = strmatch(CURRGRP(1,h),CURRdesc,'exact');
                end
                
                if ~isempty(MTCHRES)
                    cnt = cnt + 1;
                end
                
            end
            
            
            if cnt == length(CURRGRP)
                MTCHS(end + 1,:) = {k i j};
                
            elseif (cnt ~= length(CURRGRP) && cnt ~=0) && get(handles.SBGRPor,'val') == 1
                %es gibt also matches, jedoch nicht alles passt, es ist
                %aber "OR" gewaehlt
                MTCHS(end + 1,:) = {k i j};
                
            end
            
        end
    end
end

if isempty(MTCHS) && get(handles.MTCHEX,'val') == 0
    errordlg('There are no matching subgroups.');
    return;
elseif isempty(MTCHS) && get(handles.MTCHEX,'val') == 1
    errordlg('There are no matching subgroups. Try to switch off "exact match".');
    return;
end


%% ADD PARAMETERS THAT HAVE BEEN ASKED FOR
MTCHSL = size(MTCHS,2);
for i = 1:length(PRM)
    
    for j = 1:size(MTCHS,1)
        
        MTCHS(j,(MTCHSL + i)) = ARR(1,cell2mat(MTCHS(j,2)),cell2mat(MTCHS(j,3)),strmatch(PRM(i),NBS.ANALYSIS.MTRXhdr(:,4)));
    end
end



%-------------------
% Versuche NBS.ANALYSIS.MTRX so klein wie moeglich zu halten und entferne
% leere zweite Dimensionen
function MNMZ()

NBS = evalin('base','NBS');

try
    SZ = size(NBS.ANALYSIS.MTRX);
catch
    return; %i.e. not yet defined
end


% STEP 1 --> Nach Exams suchen, die leer sind

for i = SZ(1):-1:1
    
    FLLD = 0; %gefuellte felder, wenigstens eines sollte voll sein
    for j = 1:size(NBS.ANALYSIS.MTRX,2)
        for k = 1:size(NBS.ANALYSIS.MTRX,3)
            for l = 1:size(NBS.ANALYSIS.MTRX,4)
                
                if ~isempty(cell2mat(NBS.ANALYSIS.MTRX(i,j,k,l)))
                    FLLD = FLLD + 1;
                end
            end
        end
    end
    
    if FLLD == 0
        NBS.ANALYSIS.MTRX = NBS.ANALYSIS.MTRX((1:(i-1)),:,:,:);
    else
        %sobald eine volle matrix gefunden wird, raus aus der schleife
        break;
    end
end

% STEP 2 --> Nach Subjects suchen, die leer sind

SZ = size(NBS.ANALYSIS.MTRX);

for i = SZ(2):-1:1
    
    FLLD = 0; %gefuellte felder, wenigstens eines sollte voll sein
    
    for j = 1:size(NBS.ANALYSIS.MTRX,1)
        for k = 1:size(NBS.ANALYSIS.MTRX,3)
            for l = 1:size(NBS.ANALYSIS.MTRX,4)
                
                if ~isempty(cell2mat(NBS.ANALYSIS.MTRX(j,i,k,l)))
                    FLLD = FLLD + 1;
                end
            end
        end
    end
    
    if FLLD == 0
        NBS.ANALYSIS.MTRX = NBS.ANALYSIS.MTRX(:,1:(i-1),:,:);
    else
        %sobald eine volle matrix gefunden wird, raus aus der schleife
        break;
    end
end

assignin('base','NBS',NBS);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -  MEAN function, check for z-score and log validity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [MN MNSTD] = MEPmean(MTX,VL)

if length(MTX) == 1
    MN = MTX;
    MNSTD = 0;
    return;
end

handles = evalin('base','handles');

if nargin > 1
    if VL == 2
        MTX = MTX';
    end
end

MN = [];
MNSTD = [];

for i = 1:size(MTX,2)
    
    
    TMP = MTX(:,i);
    
    switch get(handles.initial_transient,'Checked')
        
        % see Schmidt paper initial transient state for rationale behind
        
        case 'on'
            
            if length(TMP) > 10
                TMP = TMP(6:end,:); %remove first 5
                
            elseif length(TMP) > 5 &&  length(TMP) < 10
                TMP = TMP(3:end,:); %remove first 2
                
            else
                TMP = TMP(2:end,:); %remove first
                
            end
    end
    
    
    switch get(handles.orthogonalize,'Checked')
        
        case 'on'
            
            TMP = zscore(TMP);
    end
    
    
    switch get(handles.MEPoutliers,'Checked')
        
        case 'on'
            
            LMT = QUANTILE(TMP,0.75) - QUANTILE(TMP,0.25); %i.e. cut off to be used
            FKT = 2;
            
            MNtmp = MTX(TMP >= (mean(TMP) - LMT*FKT),i);
            MNtmp = MNtmp(MNtmp <= (mean(TMP) + LMT*FKT),1);
            
        case 'off'
            
            MNtmp = TMP;
            
    end
    
    switch get(handles.logdist,'Checked')
        
        case 'on'
            
            MNtmp = log10(MNtmp);
            MNtmp = MNtmp(~isinf(MNtmp),:);
            
    end
    
    MN(1,i) = mean(MNtmp);
    MNSTD(1,i) = std(MNtmp);
    
end




% --- Executes on button press in MTCHEX.
function MTCHEX_Callback(hObject, eventdata, handles)
% hObject    handle to MTCHEX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MTCHEX




% --- Executes on button press in pushbutton53.
function pushbutton53_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

MNMZ;
NBS = CREATE4D('silent period');
ARR = CMPL4D(NBS);

assignin('base','NBS',NBS);

feval('evaltype_Callback',handles.SBJTS,0,handles);


% --- Executes on button press in SBGRPand.
function SBGRPand_Callback(hObject, eventdata, handles)
% hObject    handle to SBGRPand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SBGRPand

set(handles.SBGRPor,'val',~get(handles.SBGRPor,'val'));


% --- Executes on button press in SBGRPor.
function SBGRPor_Callback(hObject, eventdata, handles)
% hObject    handle to SBGRPor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SBGRPor

set(handles.SBGRPand,'val',~get(handles.SBGRPand,'val'));
feval('evaltype_Callback',handles.SBJTS,0,handles);


% --------------------------------------------------------------------
function MAPS_concat_Callback(hObject, eventdata, handles)
% hObject    handle to MAPS_concat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(gcbo,'checked')
    case 'off'
        set(gcbo,'checked','on')
    case 'on'
        set(gcbo,'checked','off')
end


% --------------------------------------------------------------------
function logdist_Callback(hObject, eventdata, handles)
% hObject    handle to logdist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(gcbo,'checked')
    case 'on', set(gcbo,'checked','off')
    case 'off', set(gcbo,'checked','on')
end



% --------------------------------------------------------------------
function initial_transient_Callback(hObject, eventdata, handles)
% hObject    handle to initial_transient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function Analysis_Callback(hObject, eventdata, handles)
% hObject    handle to Analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function anlss_subjects_Callback(hObject, eventdata, handles)
% hObject    handle to anlss_subjects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


str = get(handles.popupmenu1,'str');
[s,v] = listdlg('PromptString','Select a file:',...
    'SelectionMode','multiple',...
    'ListString',str);
set(gcbo, 'checked','on')
set(gcbo, 'label', ['Subjects (' num2str(s) ')'])
assignin('base','subjind',s)

% --------------------------------------------------------------------
function anlss_sessions_Callback(hObject, eventdata, handles)
% hObject    handle to anlss_sessions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt={'Session vector:'};
name='';
numlines=1;
defaultanswer={['1, 2, 3']};
answer=inputdlg(prompt,name,numlines,defaultanswer);
eval(['sessind = [' answer{1} '];']);
assignin('base','sessind',sessind)
set(gcbo,'label',['Sessions (' answer{1} ')'],'checked','on')


% --------------------------------------------------------------------
function anlss_conditions_Callback(hObject, eventdata, handles)
% hObject    handle to anlss_conditions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --------------------------------------------------------------------
function anlss_EMG1_Callback(hObject, eventdata, handles)
% hObject    handle to anlss_EMG1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function anlss_EMG2_Callback(hObject, eventdata, handles)
% hObject    handle to anlss_EMG2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function anlss_EMG3_Callback(hObject, eventdata, handles)
% hObject    handle to anlss_EMG3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function anlss_EMG4_Callback(hObject, eventdata, handles)
% hObject    handle to anlss_EMG4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function anlss_EMG5_Callback(hObject, eventdata, handles)
% hObject    handle to anlss_EMG5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function anlss_EMG6_Callback(hObject, eventdata, handles)
% hObject    handle to anlss_EMG6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function vwdtldng_Callback(hObject, eventdata, handles)
% hObject    handle to vwdtldng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(gcbo,'checked')
    case 'on'
        set(gcbo,'checked','off')
    case 'off'
        set(gcbo,'checked','on')
end



% --- Executes on button press in pushbutton54.
function pushbutton54_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

NBS = evalin('base','NBS');
sbj = get(handles.popupmenu1,'val');
seq = get(handles.showseq,'val');
AMPS = NBS.DATA(sbj).RAW(seq).AMPS(:,1:2:12);
MSO = NBS.DATA(sbj).RAW(seq).MSO(:,1);
lbl = sort(max(AMPS));
ind(1) = find(max(AMPS) == lbl(end));
ind(2) = find(max(AMPS) == lbl(end-1));
AMPS = AMPS(:,ind(1));
ind = find(AMPS);
AMPS = AMPS(ind,:);
MSO = MSO(ind,1);

figure
plot(MSO,AMPS,'*'),
xlim(gca,[0 100])
xlabel('MSO'),ylabel('miV')
grid on


% --------------------------------------------------------------------
function autoload_Callback(hObject, eventdata, handles)
% hObject    handle to autoload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function Tools_Callback(hObject, eventdata, handles)
% hObject    handle to Tools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function tools_autotag_Callback(hObject, eventdata, handles)
% hObject    handle to tools_autotag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function autotags_LRH_Callback(hObject, eventdata, handles)
% hObject    handle to autotags_LRH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

COMPARE = evalin('base','COMPARE');
try GUI = evalin('base','NBS.GUI');
catch 
    feval('tagfiles_Callback',hObject, eventdata,handles);
    GUI = evalin('base','NBS.GUI');
end
pwd = COMPARE.path_file{1};
switch get(handles.autotag_selsubj,'checked')
    case 'on'
        [s,v] = listdlg('PromptString','Select a file(s):',...
            'SelectionMode','multiple',...
            'ListString',get(handles.popupmenuSearchResults,'str'));
    otherwise
        s = 1:length(get(handles.popupmenuSearchResults,'str'));
end

h1 = waitbar(0,'Please wait (subj)...');
for subj = s% get(handles.popupmenuSearchResults,'val'):length(COMPARE.path_file)
    PF = fullfile(pwd, COMPARE.path_file{subj,2});
    set(handles.popupmenuSearchResults,'val',subj)
    feval('popupmenuSearchResults_Callback',hObject, eventdata, handles)
    try waitbar(subj/length(COMPARE.path_file),h1), end
    h2 = waitbar(0,'Please wait (sequence)...');
    for i = 1:length(GUI(1,subj).sequences)
        try waitbar(i/length(GUI(1,subj).sequences),h2), end
        disp([COMPARE.path_file{subj,2} ' ( --> ' num2str(i) '/' num2str(length(GUI(1,subj).sequences)) ')'])
        str = GUI(1,subj).sequences{i};
        Dind = str2num(GUI(1,subj).sequencesindices{i});
        if diff(Dind) %check that it is not an empty sequence
            
            hdr = GUI(1,subj).hdr(1:Dind(1),:);
            [tmp tmp D] = xlsread(PF,1,['B' num2str(Dind(1)-15)  ':' 'AL' num2str(Dind(2)) ]); % C Dind
            [ind s] = find(strncmp(hdr(:,2),'Sequence Description', 2));
            for ii = 1:15
                if findstr(D{ii,1},'Sequence Created');
                    To(1:ii) = 0;
                    To(ii) = 1;
                else
                    To(ii) = 0;
                end
            end
            To = find(To);
            S = D(To:To+3,1); 
            T = S(4); Tind(1) = Dind(1)-15+To+2;
            D = D(15:end,2:end);
            % dirty dangerous fix
            cnt = 0;
            while any(isnan(D{1}))==1
                cnt = cnt+1;
                D = D(2:end,:);
            end
            disp(['(old) ' T{1}])
            if any(strfind(T{1},'Sequence Description')) && isempty(strfind(T{1},'XXX'))
                % define deliminator of inserts
                T = strrep(T,':',': - ');
                % RC
                R = cell2mat( D(1:end,5));
                R = R(~isnan(R));%problem with NaN values
                if length(find(diff(R)))>4 && length(find(diff(R)))<8
                    if mean(diff(find(diff(R)))) > 5; % number of times MSO repeated
                        T = strrep(T,'RC',' ');
                        T = strrep(T,': ',': RC ');
                    end
                end
                % mono or bipulse
                if  any(findstr(S{2},'BiPulse'))==1 && any(findstr(D{1,3},'Single'))==1;
                    T = strrep(T,'BiP','');
                    T = strrep(T,':',': BiP');
                elseif any(findstr(S{2},'MonoPulse'))==1 && any(findstr(D{1,3},'Single'));
                    T = strrep(T,'MoP','');
                    T = strrep(T,':',': MoP');
                end
                % paired puls
                if any(findstr(D{1,3},'Paired'))==1 && any(strfind(T{1},'mirror'))==0;
                    % second intense PPuls
                    T = strrep(T,'Ppuls','');
                    T = strrep(T,'PPuls','');
                    T = strrep(T,'ISI','');
                    T = strrep(T,num2str(D{1,4}),'');
                    T = strrep(T,':',[': PPuls ISI' num2str(D{1,4})]);
                end
                % xlocation
                [Nind s] = find(strncmp(GUI(1,subj).hdr,'Landmarks', 2));
                Nind = sort(cat(1,GUI(1,subj).hdr{Nind+4:Nind+6,2})); % not always mapped the same in excel file
                Nind = Nind(2); % Nasiion
                if ischar(Nind); Nind = str2num(Nind); end
                if min(cat(1,D{:,11}))<Nind; % xlocation
                    T = strrep(T,'RH ','');T = strrep(T,'rh ','');
                    T = strrep(T,':',': RH');
                end
                if max(cat(1,D{:,11}))>Nind; % xlocation
                    T = strrep(T,'LH ',''); T = strrep(T,'lh ','');
                    T = strrep(T,':',': LH');
                end
                
                % exam
                T = strrep(T,'PRAE','PRE'); 
                T = strrep(T,['SESS' D{1}(1)],''); 
                T = strrep(T,['EXAM' D{1}(1)],''); 
                T = strrep(T,':',[': EXAM' D{1}(1)]);
                % clean up - map
                T = strrep(T,'mapping','MAP');
                T = strrep(T,'map','MAP');
                T = strrep(T,'grob map','MAP rough');
                T = strrep(T,'grob','MAP rough');
                T = strrep(T,'rough','MAP rough');
                for r=1:3; T = strrep(T,'MAP MAP','MAP'); end
                T = strrep(T,'MAPMAP','MAP');
                % clean up - silent period
                T = strrep(T,'CSP','SP');
                % fix - recru
                T = strrep(T,'recruitment curve','RC');
                % clean up MAP MAP

                % clean up - empty spaces
                for r=1:10; 
                    T = strrep(T,'  ',' '); 
                    T = strrep(T,'- -','-'); 
                end
                % disp
                [S M] = xlswrite(PF,T,1,['B' num2str(Tind)]);
            end
            disp(['(new) ' T{1}])
        end
    end
    try close(h2), end
end
set(gcbo,'checked','on')
try close(h1), end
disp('DONE')


% --------------------------------------------------------------------
function autotag_selsubj_Callback(hObject, eventdata, handles)
% hObject    handle to autotag_selsubj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(gcbo,'checked')
    case 'on'
        set(gcbo,'checked','off')
    case 'off'
        set(gcbo,'checked','on')
end


% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10




% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function AO_map2excel_Callback(hObject, eventdata, handles)
% hObject    handle to AO_map2excel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function readandtestexcel_Callback(hObject, eventdata, handles)
% hObject    handle to readandtestexcel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    NUMERIC = evalin('base','NUMERIC'); TXT = evalin('base','TXT');
catch
    [NUMERIC,TXT,RAW]  = xlsread(uigetfile,-1);
     assignin('base','NUMERIC',NUMERIC);
     assignin('base','TXT',TXT);
end
TXT1 = TXT(1,2:end);
TXT2 = TXT(2:end,1);
%condtion keywords
%  [s,v] = listdlg('PromptString','Select conditions to define prototypes:',...
%                       'SelectionMode','multiple',...
%                       'ListString',TXT);
% prompt = TXT(s);
% name='Input for Peaks function';
% numlines=1;
% defaultanswer=TXT(s);
% options.Resize='on';
% answer=inputdlg(prompt,name,numlines,defaultanswer,options);
answer = {'EXAM1','UH';'EXAM1','AH'}; %;'EXAM2','UH';'EXAM2','AH'};
%answer = {'EXAM2','UH';'EXAM2','AH'}; %;'EXAM2','UH';'EXAM2','AH'};
%answer = {'EXAM1','UH';'EXAM2','UH'}; %;'EXAM2','UH';'EXAM2','AH'};
answer = {'EXAM1','AH';'EXAM2','AH'}; %;'EXAM2','UH';'EXAM2','AH'};
answer = {'EXAM1','UH';'EXAM2','AH'}; %;'EXAM2','UH';'EXAM2','AH'};

STR1 = strvcat(TXT1);
CND = [ ];
for i = 1:size(STR1,1)
    for ii=1:length(answer)
        if any(findstr(STR1(i,:),answer{ii,1})) && any(findstr(STR1(i,:),answer{ii,2}))
            CND(i) = ii;
        end
    end
end
CND = CND';


% stats
% [s,v] = listdlg('PromptString','Which Values:',...
%     'SelectionMode','multiple',...
%     'ListString',TXT2);
s = [6 19 21];
STR2 =  TXT2(s);

N1 = NUMERIC(s,find(CND==1));
N2 = NUMERIC(s,find(CND==2));
ranksum(N1(1,:),N2(1,:))
% N2 = [N2,NaN,NaN];
% figure, boxplot([N1;N2]','orientation','horizontal')
figure, 
bar([median(N1,2),median(N2,2)])
set(gca,'xticklabel',STR2)
legend(strvcat(answer(1,:)'),strvcat(answer(2,:)'))


