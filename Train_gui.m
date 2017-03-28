function varargout = Train_gui(varargin)
% TRAIN_GUI M-file for Train_gui.fig
%      TRAIN_GUI, by itself, creates a new TRAIN_GUI or raises the existing
%      singleton*.
%
%      H = TRAIN_GUI returns the handle to a new TRAIN_GUI or the handle to
%      the existing singleton*.
%
%      TRAIN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRAIN_GUI.M with the given input arguments.
%
%      TRAIN_GUI('Property','Value',...) creates a new TRAIN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Train_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Train_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Train_gui

% Last Modified by GUIDE v2.5 07-Apr-2009 22:02:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Train_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @Train_gui_OutputFcn, ...
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


% --- Executes just before Train_gui is made visible.
function Train_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Train_gui (see VARARGIN)

% Choose default command line output for Train_gui
handles.output = hObject;

handles.video = videoinput('winvideo', 1);
set(handles.video,'TimerPeriod', .1,'Timeout',60,...
    'TimerFcn',['handles = guidata(gcf);'...  % Update handles
                    'try,'...
                    'image(getsnapshot(handles.video));'... % Get picture using GETSNAPSHOT and put it into axes using IMAGE
                    'end;'...
                    'set(handles.axes1,''ytick'',[],''xtick'',[]),']); % Remove tickmarks and labels that are inserted when using IMAGE

triggerconfig(handles.video,'manual');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Train_gui wait for user response (see UIRESUME)
uiwait(handles.Train_gui);

% --- Executes on button press in Capture.
function Capture_Callback(hObject, eventdata, handles)
% hObject    handle to Capture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Capture,'Enable','off');
set(handles.Start_camera,'Enable','on');
set(handles.Accept,'Enable','on');
handles.user_image = getsnapshot(handles.video);

stop(handles.video);
image(handles.user_image)
set(handles.axes1,'xtick',[]);
guidata(hObject, handles);

% --- Executes on button press in Start_camera.
function Start_camera_Callback(hObject, eventdata, handles)
% hObject    handle to Start_camera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Capture,'Enable','on');
set(handles.Start_camera,'Enable','off');

start(handles.video)

% For trying out marker dimensions
% load trial_img;
% image(trial_img);

if ~isfield(handles,'marker1')    
    mark_x1 = 189/565;
    mark_y1 = 150/296;
          
    mark_x2 = 220/565;
    mark_y2 = 170/296;
    
    width = .05;
    height = .066;

    handles.marker1 =...
    annotation(gcf,'ellipse','Position',[mark_x1 mark_y1 width height],'Color',[1 0 0],'LineWidth',2);

    handles.marker2 =...
    annotation(gcf,'ellipse','Position',[mark_x2 mark_y2 width height],'Color',[1 0 0],'LineWidth',2);
end

guidata(hObject, handles);


% --- Executes on button press in Exit.
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.video);
clear handles.video
delete(gcf)

% --- Executes on button press in Accept.
function Accept_Callback(hObject, eventdata, handles)
% hObject    handle to Accept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.Accept,'Enable','off');
img_count = str2double(get(handles.img_count,'String'));
user_id=str2double(get(handles.user_id,'String'));

load('faceauth_db')
if img_count < 10
   img_count = img_count + 1;
   if (img_count == 1)
        set(handles.Eye_markers,'Enable','off');
        msg_str{1,1} = 'Ensure that your irises';
        msg_str{2,1} = 'are inside the markers';
        set(handles.marker_msg,'String',msg_str)
        faceauth_db(user_id).m1_pos = get(handles.marker1,'Position');
        faceauth_db(user_id).m2_pos = get(handles.marker2,'Position');
   end
else
    img_count = 0;
    user_id = user_id + 1; 
    set(handles.user_id,'String',num2str(user_id));
    set(handles.Eye_markers,'Enable','on');
end
set(handles.img_count,'String',num2str(img_count));

faceauth_db(user_id).marker1_pos = get(handles.marker1,'Position');
faceauth_db(user_id).marker2_pos = get(handles.marker2,'Position');

faceauth_db(user_id).img{img_count} = rgb2gray(handles.user_image);

% For trying out marker dimensions
% trial_img = handles.user_image;
% save('trial_img','trial_img');

save('faceauth_db','faceauth_db');
guidata(hObject, handles);

% --- Executes on button press in Eye_markers.
function Eye_markers_Callback(hObject, eventdata, handles)
% hObject    handle to Eye_markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Eye_markers,'Enable','Off');

pos1 = get(handles.marker1,'Position');
mark_x1 = pos1(1);
mark_y1 = pos1(2);
width = pos1(3);
height = pos1(4);

pos2 = get(handles.marker2,'Position');
mark_x2 = pos2(1);
mark_y2 = pos2(2); 

[x,y] = ginput(1);
[mark_x, mark_y] = convert_coords(x,y);
if (mark_x > mark_x1 && mark_x < mark_x1 + width)
    if (mark_y > mark_y1 && mark_y < mark_y1 + height)
        set(handles.marker1,'Color',[0 0 1]);
        [a,b] = ginput(1);
        [mark_x, mark_y] = convert_coords(a,b);
        set(handles.marker1,'Position',[mark_x - width/2,mark_y - height/2, width, height],'Color',[1 0 0]);        
    end
elseif(mark_x > mark_x2 && mark_x < mark_x2 + width)
    if (mark_y > mark_y2 && mark_y < mark_y2 + height)
        set(handles.marker2,'Color',[0 0 1]);
        [x,y] = ginput(1);
        [mark_x, mark_y] = convert_coords(x,y);
        set(handles.marker2,'Position',[mark_x - width/2,mark_y - height/2, width, height],'Color',[1 0 0]);
    end
end

set(handles.Eye_markers,'Enable','On');
guidata(hObject, handles);

function [a,b] = convert_coords(x,y)
a = x/570;
b = (296-y)/296;


% --- Executes during object creation, after setting all properties.
function user_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to user_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function img_count_CreateFcn(hObject, eventdata, handles)
% hObject    handle to img_count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Outputs from this function are returned to the command line.
function varargout = Train_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure