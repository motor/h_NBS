function varargout = h_NBS2MRI(varargin)
% H_NBS2MRI M-file for h_NBS2MRI.fig
%      H_NBS2MRI, by itself, creates a new H_NBS2MRI or raises the existing
%      singleton*.
%
%      H = H_NBS2MRI returns the handle to a new H_NBS2MRI or the handle to
%      the existing singleton*.
%
%      H_NBS2MRI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in H_NBS2MRI.M with the given input arguments.
%
%      H_NBS2MRI('Property','Value',...) creates a new H_NBS2MRI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before h_NBS2MRI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to h_NBS2MRI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help h_NBS2MRI

% Last Modified by GUIDE v2.5 28-Oct-2009 00:46:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @h_NBS2MRI_OpeningFcn, ...
                   'gui_OutputFcn',  @h_NBS2MRI_OutputFcn, ...
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


% --- Executes just before h_NBS2MRI is made visible.
function h_NBS2MRI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to h_NBS2MRI (see VARARGIN)

% Choose default command line output for h_NBS2MRI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes h_NBS2MRI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = h_NBS2MRI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
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
NBS2MRIind = [1 3 2]; %some strange format that Nexstim uses
disp('x y z')
% % % MAT = evalin('base',['NBS.DATA(1).RAW.PP.data']);
% % % AMPS = MAT(:,1);
% % % EFLOC = MAT(:,10:12);
% % % COMPARE = evalin('base','COMPARE');
% % % [r c] = find(double(strcmp(COMPARE.results.Daniel_Schlacks.rawmatrix, 'MRI landmark: Nose/Nasion')));
% % % NOSE.NBS(NBS2MRI) = cat(2,COMPARE.results.Daniel_Schlacks.rawmatrix{r,c-3:c-1});
% % % LEFT.NBS(NBS2MRI) = cat(2,COMPARE.results.Daniel_Schlacks.rawmatrix{r+1,c-3:c-1}); %[172 100.5 104.4];
% % % RIGHT.NBS(NBS2MRI) = cat(2,COMPARE.results.Daniel_Schlacks.rawmatrix{r+2,c-3:c-1}); %[22 107 113];
%NBSLOC, e.g. EFLOC
NBSLOC = get(handles.edit9,'str');
NBSLOC = str2num(NBSLOC{1});
NBSLOC = NBSLOC(NBS2MRIind);

% % NBS - Null == upper back right corner in MRI (see SPM graphics) in mm
% NULL.NBS = [87.9, -81.5, 87.7];
% NBS2MRI(1) = NULL.NBS(1) - NBSLOC(1);
% NBS2MRI(2) = NULL.NBS(2) + NBSLOC(2);
% NBS2MRI(3) = NULL.NBS(3) - NBSLOC(3);
% MRI - null == left front top


% % NBS - Null == right back bottom corner in MRI (see SPM graphics) in mm
NBSNULL = str2num(get(handles.edit1,'str')); %[87.9, -81.5, -152.3];
NBS2MRI(1) = NBSNULL(1) - NBSLOC(1);
NBS2MRI(2) = NBSNULL(2) + NBSLOC(2);
NBS2MRI(3) = NBSNULL(3) + NBSLOC(3);

% maybe voxels work better



str = [ ];
for i=1:3;
str = [str, num2str(NBS2MRI(i)), ' '];
end
str = str(1:end-1);

% set GUI
set(handles.edit10,'str',str)


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




