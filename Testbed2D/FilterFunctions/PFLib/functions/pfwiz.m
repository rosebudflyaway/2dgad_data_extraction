function varargout = pfwiz(varargin)
% PFWIZ M-file for pfwiz.fig
%      PFWIZ, by itself, creates pfwiz new PFWIZ or raises the existing
%      singleton*.
%
%      H = PFWIZ returns the handle to pfwiz new PFWIZ or the handle to
%      the existing singleton*.
%
%      PFWIZ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PFWIZ.M with the given input arguments.
%
%      PFWIZ('Property','Value',...) creates pfwiz new PFWIZ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pfwiz_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pfwiz_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pfwiz

% Last Modified by GUIDE v2.5 03-Aug-2006 11:40:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pfwiz_OpeningFcn, ...
                   'gui_OutputFcn',  @pfwiz_OutputFcn, ...
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


% --- Executes just before pfwiz is made visible.
function pfwiz_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in pfwiz future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pfwiz (see VARARGIN)

% Choose default command line output for pfwiz
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pfwiz wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pfwiz_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in pfwiz future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in pfwiz future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

handles = guidata(hObject);
handles.fig_h(1) = gcf;
guidata(hObject, handles);


% --- Executes on button press in nextbutton.
function nextbutton_Callback(hObject, eventdata, handles)
% hObject    handle to nextbutton (see GCBO)
% eventdata  reserved - to be defined in pfwiz future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.fig_h(1), 'Visible', 'off');
if ~exist('handles.fig_h(2)')
    handles.fig_h(2) = pfwiz2;
    guidata(hObject, handles);
end;
set(handles.fig_h(2), 'Visible', 'on');
hd = guidata(handles.fig_h(2));
hd.fig_h = handles.fig_h;
guidata(handles.fig_h(2), hd);


% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in pfwiz future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_me = gcf;
for i = 1:length(handles.fig_h)
    if(handles.fig_h(i) ~= h_me) 
        close(handles.fig_h(i));
    end;
end;
close(h_me);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bin_dir = which('pfwiz');
web(['file:///' bin_dir(1:end-7) 'doc/pfwiz/node1.html']);


