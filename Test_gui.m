function varargout = Test_gui(varargin)
% TEST_GUI M-file for Test_gui.fig
%      TEST_GUI, by itself, creates a new TEST_GUI or raises the existing
%      singleton*.
%
%      H = TEST_GUI returns the handle to a new TEST_GUI or the handle to
%      the existing singleton*.
%
%      TEST_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST_GUI.M with the given input arguments.
%
%      TEST_GUI('Property','Value',...) creates a new TEST_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Test_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Test_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Test_gui

% Last Modified by GUIDE v2.5 03-Apr-2009 14:38:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Test_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @Test_gui_OutputFcn, ...
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


% --- Executes just before Test_gui is made visible.
function Test_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Test_gui (see VARARGIN)

handles.video = videoinput('winvideo', 1);
set(handles.video,'TimerPeriod', 0.1, ...
    'TimerFcn',['handles=guidata(gcf);'...  % Update handles
                    'try,'...
                    'image(getsnapshot(handles.video));'...  % Get picture using GETSNAPSHOT and put it into axes using IMAGE
                    'end;'...
                    'set(handles.axes1,''ytick'',[],''xtick'',[])']);    % Remove tickmarks and labels that are inserted when using IMAGE

triggerconfig(handles.video,'manual');

load faceauth_db;
handles.db = faceauth_db;
% Choose default command line output for Test_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Test_gui wait for user response (see UIRESUME)
% uiwait(handles.Test_gui);
uiwait(handles.Test_gui);


% --- Outputs from this function are returned to the command line.
function varargout = Test_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure


% --- Executes on button press in Capture.
function Capture_Callback(hObject, eventdata, handles)
% hObject    handle to Capture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.start_camera,'Enable','on');
user_image = getsnapshot(handles.video);
handles.user_image = rgb2gray(user_image);
stop(handles.video);
image(user_image)
set(handles.axes1,'xtick',[]);
set(handles.Test,'Enable','on');
guidata(hObject, handles);

% --- Executes on button press in start_camera.
function start_camera_Callback(hObject, eventdata, handles)
% hObject    handle to start_camera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.start_camera,'Enable','off');
set(handles.Test,'Enable','off');
start(handles.video)

% set(handles.Result,'ForegroundColor',[0 0 0]);
% set(handles.Result,'String','Result');
    
user_id = str2num(get(handles.Username,'String'));
% user_id = get_user_id(user_name);
pos1 = handles.db(user_id).marker1_pos;
pos2 = handles.db(user_id).marker2_pos;

handles.marker1 =...
annotation(gcf,'ellipse','Position',pos1,'Color',[1 0 0],'LineWidth',2);

handles.marker2 =...
annotation(gcf,'ellipse','Position',pos2,'Color',[1 0 0],'LineWidth',2);

guidata(hObject, handles);


% --- Executes on button press in Exit.
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.video);

delete(gcf)

% --- Executes on button press in Test.
function Test_Callback(hObject, eventdata, handles)
% hObject    handle to Test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Result,'ForegroundColor',[0 0 1]);
set(handles.Result,'String','Wait');

tic
test_result =FaceAuth_main(handles.user_image,str2num(get(handles.Username,'String')));
toc

if test_result == 1
    set(handles.Result,'ForegroundColor',[0 0 1]);
    set(handles.Result,'String','Authenticated');
else
    set(handles.Result,'ForegroundColor',[1 0 0]);
    set(handles.Result,'String','Impostor!');
end


% --- Executes during object creation, after setting all properties.
function Username_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end