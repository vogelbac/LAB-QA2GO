function varargout = PanelACR(varargin)
% PANELACR M-file for PanelACR.fig
%      PANELACR, by itself, creates a new PANELACR or raises the existing
%      singleton*.
%
%      PANELACR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PANELACR.M with the given input arguments.
%
%      PANELACR('Property','Value',...) creates a new PANELACR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PanelACR_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PanelACR_OpeningFcn via varargin.
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PanelACR_OpeningFcn, ...
                   'gui_OutputFcn',  @PanelACR_OutputFcn, ...
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


% --- Executes just before PanelACR is made visible.
function PanelACR_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PanelACR (see VARARGIN)

% Choose default command line output for PanelACR
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

v1 = 0;
v2 = 0;
v3 = 0;
v4 = 0;
v5 = 0;
v6 = 0;
v7 = 0;
v8 = 0;
assignin('base','type1',v1);
assignin('base','type2',v2);
assignin('base','type3',v3);
assignin('base','type4',v4);
assignin('base','type5',v5);
assignin('base','type6',v6);
assignin('base','type7',v7);
assignin('base','type8',v8);

% UIWAIT makes PanelACR wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = PanelACR_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Load localizer Browse-pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global hdr img 
[name,path]=uigetfile('*.nii','Choose Localizer');
filename=(fullfile(path,name));
[hdr,img]=niak_read_vol(filename);

% --- Load T1 image Browse-pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global hdr1 img1 filenameT1
[nameT1,pathT1]=uigetfile('*.nii','Choose T1 image');
filenameT1=(fullfile(pathT1,nameT1));
[hdr1,img1]=niak_read_vol(filenameT1);

% --- Load T2 image Browse-pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global hdr2 img2 filenameT2
[nameT2,pathT2]=uigetfile('*.nii','Choose T2 image');
filenameT2=(fullfile(pathT2,nameT2));
[hdr2,img2]=niak_read_vol(filenameT2);


% --- Executes on button press in checkbox1--all test parameters
% Hint: get(hObject,'Value') returns toggle state of checkbox1
function checkbox1_Callback(hObject, eventdata, handles)
if get(hObject,'Value')==1
handles.output=get(hObject,'Value');
end
assignin('base','type1',handles.output);

% --- Executes on button press in checkbox2 --geometry test
function checkbox2_Callback(hObject, eventdata, handles)
if get(hObject,'Value')==1
handles.output=get(hObject,'Value');
end
assignin('base','type2',handles.output);


% --- Executes on button press in checkbox3 --spatial rsolution
function checkbox3_Callback(hObject, eventdata, handles)
if get(hObject,'Value')==1
handles.output=get(hObject,'Value');
end
assignin('base','type3',handles.output);


% --- Executes on button press in checkbox4 --slice thickness
function checkbox4_Callback(hObject, eventdata, handles)
if get(hObject,'Value')==1
handles.output=get(hObject,'Value');
end
assignin('base','type4',handles.output);


% --- Executes on button press in checkbox5 --slice position
function checkbox5_Callback(hObject, eventdata, handles)
if get(hObject,'Value')==1
handles.output=get(hObject,'Value');
end
assignin('base','type5',handles.output);


% --- Executes on button press in checkbox6 --PIU
function checkbox6_Callback(hObject, eventdata, handles)
if get(hObject,'Value')==1
handles.output=get(hObject,'Value');
end
assignin('base','type6',handles.output);


% --- Executes on button press in checkbox7 --PSG
function checkbox7_Callback(hObject, eventdata, handles)
if get(hObject,'Value')==1
handles.output=get(hObject,'Value');
end
assignin('base','type7',handles.output);


% --- Executes on button press in checkbox8 --Low Contrast
function checkbox8_Callback(hObject, eventdata, handles)
if get(hObject,'Value')==1
handles.output=get(hObject,'Value');
end
assignin('base','type8',handles.output);


% --- Run-pushbutton4 (Programm starten).
function pushbutton4_Callback(hObject, eventdata, handles)
run_ACR_qa()

% --- Cancel-pushbutton5 (Fenster schlie�en).
function pushbutton5_Callback(hObject, eventdata, handles)
%[file5,path5] = uiputfile('*.eps','Save file name');
%filename5 = fullfile(path5, file5);
%set(handles.figure1, 'PaperUnits', 'centimeter', ...
%   'PaperPosition', [0, 0, 12, 10], ...
%   'PaperSize', [12, 10]);
%print(handles.figure1, '-deps', filename5);

close(handles.figure1);


