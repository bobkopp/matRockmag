function varargout = matRockmag(varargin)
% MATROCKMAG M-file for matRockmag.fig
%      MATROCKMAG, by itself, creates a new MATROCKMAG or raises the existing
%      singleton*.
%
%      H = MATROCKMAG returns the handle to a new MATROCKMAG or 
%      MATROCKMAG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATROCKMAG.M with the given input arguments.
%
%      MATROCKMAG('Property','Value',...) creates a new MATROCKMAG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before matRockmag_OpeningFunction gets called.  An
%      unrecogthe handle to
%      the existing singleton*.
%nized property name or invalid value makes property application
%      stop.  All inputs are passed to matRockmag_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help matRockmag

% Last Modified by GUIDE v2.5 23-Jan-2006 14:50:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @matRockmag_OpeningFcn, ...
                   'gui_OutputFcn',  @matRockmag_OutputFcn, ...
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


% --- Executes just before matRockmag is made visible.
function matRockmag_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to matRockmag (see VARARGIN)

% Choose default command line output for matRockmag
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes matRockmag wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global RmgData;
if length(RmgData) > 0
    
    set(handles.listRmgData,'String',{RmgData.samplename});

end

pathname=cd;
pathname=[pathname '/'];
set(handles.txtPathName,'String',pathname);
fileslist=dir([pathname '*.rmg']);
set(handles.listFiles,'String',{fileslist.name});



% --- Outputs from this function are returned to the command line.
function varargout = matRockmag_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function txtPathName_Callback(hObject, eventdata, handles)
% hObject    handle to txtPathName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtPathName as text
%        str2double(get(hObject,'String')) returns contents of txtPathName as a double

pathname=get(handles.txtPathName,'String');
cd(pathname);
fileslist=dir([pathname '*.rmg']);
set(handles.listFiles,'String',{fileslist.name});

% --- Executes during object creation, after setting all properties.
function txtPathName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtPathName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnLoadPath.
function btnLoadPath_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoadPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile('*.rmg','Select sample set');
pathname
cd(pathname);
set(handles.txtPathName,'String',pathname);
fileslist=dir([pathname '*.rmg']);
set(handles.listFiles,'String',{fileslist.name});


% --- Executes on selection change in listFiles.
function listFiles_Callback(hObject, eventdata, handles)
% hObject    handle to listFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listFiles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listFiles


% --- Executes during object creation, after setting all properties.
function listFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkSubplots.
function chkSubplots_Callback(hObject, eventdata, handles)
% hObject    handle to chkSubplots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkSubplots


% --- Executes on button press in chkMultisamples.
function chkMultisamples_Callback(hObject, eventdata, handles)
% hObject    handle to chkMultisamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkMultisamples

% --- Executes on button press in chkAutosaveFIG.
function chkAutosaveFIG_Callback(hObject, eventdata, handles)
% hObject    handle to chkAutosaveFIG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkAutosaveFIG



function txtCustomFilenamePrefix_Callback(hObject, eventdata, handles)
% hObject    handle to txtCustomFilenamePrefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtCustomFilenamePrefix as text
%        str2double(get(hObject,'String')) returns contents of txtCustomFilenamePrefix as a double


% --- Executes during object creation, after setting all properties.
function txtCustomFilenamePrefix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtCustomFilenamePrefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkAutosaveEPS.
function chkAutosaveEPS_Callback(hObject, eventdata, handles)
% hObject    handle to chkAutosaveEPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkAutosaveEPS




% --- Executes on selection change in listRmgData.
function listRmgData_Callback(hObject, eventdata, handles)
% hObject    handle to listRmgData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listRmgData contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listRmgData


% --- Executes during object creation, after setting all properties.
function listRmgData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listRmgData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnLoad.
function btnLoad_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global RmgData;

if length(RmgData)>0
    RD=RmgData;
    counter=length(RD)+1;
else
    counter=1;
end


set(handles.txtBusy,'Visible','on');


fileslist=get(handles.listFiles,'String');

for i=get(handles.listFiles,'Value')
    RD(counter)=RMGImport(fileslist{i});
    counter=counter+1;
end

set(handles.listRmgData,'String',{RD.samplename});


RmgData=RD;


set(handles.txtBusy,'Visible','off');

% --- Executes on selection change in listRoutine.
function listRoutine_Callback(hObject, eventdata, handles)
% hObject    handle to listRoutine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listRoutine contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listRoutine


% --- Executes during object creation, after setting all properties.
function listRoutine_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listRoutine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtAFLevel_Callback(hObject, eventdata, handles)
% hObject    handle to txtAFLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtAFLevel as text
%        str2double(get(hObject,'String')) returns contents of txtAFLevel as a double


% --- Executes during object creation, after setting all properties.
function txtAFLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtAFLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtFilePrefix_Callback(hObject, eventdata, handles)
% hObject    handle to txtFilePrefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtFilePrefix as text
%        str2double(get(hObject,'String')) returns contents of txtFilePrefix as a double


% --- Executes during object creation, after setting all properties.
function txtFilePrefix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtFilePrefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in btnClearFiles.
function btnClearFiles_Callback(hObject, eventdata, handles)
% hObject    handle to btnClearFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear global RmgData;
set(handles.listRmgData,'String','');

% --- Executes on button press in btnRun.
function btnRun_Callback(hObject, eventdata, handles)
% hObject    handle to btnRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

RoutineTypes={'IRM','dIRM','ARM','LowrieFuller','AF','Fuller','RRM','Backfield','StatBox'};

global RmgData;

set(handles.txtBusy,'Visible','on');

options={};
selectedDataSets=get(handles.listRmgData,'Value');
selectedRoutines=get(handles.listRoutine,'Value');

if get(handles.chkMultisamples,'Value');
    options={options{:} 'Multisample'};
end
if get(handles.chkSubplots,'Value');
    options={options{:} 'Subplots'};
end
if get(handles.chkAutosaveEPS,'Value');
    options={options{:} 'AutosaveEPS'};
end
if get(handles.chkAutosaveFIG,'Value');
    options={options{:} 'AutosaveFIG'};
end

fileprefix=get(handles.txtFilePrefix,'String');
if length(fileprefix)>0
    options={options{:},'FilePrefix',fileprefix};
end

if length(selectedRoutines) > 0
    RmgBatchPlotter(RmgData(selectedDataSets),RoutineTypes(selectedRoutines),options{:});
end

if get(handles.chkRmgStats,'Value');
    RmgStatsWriteTable(RmgData(selectedDataSets),[fileprefix 'rockmagstats-summary']);
end


set(handles.txtBusy,'Visible','off');


% --- Executes on button press in chkRmgStats.
function chkRmgStats_Callback(hObject, eventdata, handles)
% hObject    handle to chkRmgStats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkRmgStats


