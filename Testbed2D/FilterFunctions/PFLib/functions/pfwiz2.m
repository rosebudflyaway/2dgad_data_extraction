function varargout = pfwiz2(varargin)
% PFWIZ2 M-file for pfwiz2.fig
%      PFWIZ2, by itself, creates pfwiz2 new PFWIZ2 or raises the existing
%      singleton*.
%
%      H = PFWIZ2 returns the handle to pfwiz2 new PFWIZ2 or the handle to
%      the existing singleton*.
%
%      PFWIZ2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PFWIZ2.M with the given input arguments.
%
%      PFWIZ2('Property','Value',...) creates pfwiz2 new PFWIZ2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pfwiz2_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pfwiz2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pfwiz2

% Last Modified by GUIDE v2.5 02-Aug-2006 18:10:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pfwiz2_OpeningFcn, ...
                   'gui_OutputFcn',  @pfwiz2_OutputFcn, ...
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


% --- Executes just before pfwiz2 is made visible.
function pfwiz2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in pfwiz2 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pfwiz2 (see VARARGIN)

% Choose default command line output for pfwiz2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pfwiz2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pfwiz2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in pfwiz2 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in pfwiz2 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in nextbutton.
function nextbutton_Callback(hObject, eventdata, handles)
% hObject    handle to nextbutton (see GCBO)
% eventdata  reserved - to be defined in pfwiz2 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles, 'fig_h')
    myerrordlg('Please start with pfwiz.'); return;
end;
sysinfo = genCode(handles);
if isempty(sysinfo) return; end;
set(handles.fig_h(2), 'Visible', 'off');
if ~exist('handles.fig_h(3)')
    handles.fig_h(3) = pfwiz3;
    guidata(hObject, handles);
end;
set(handles.fig_h(3), 'Visible', 'on');
hd = guidata(handles.fig_h(3));
hd.fig_h = handles.fig_h;
hd.sysinfo = sysinfo;
guidata(handles.fig_h(3), hd);

% --- Executes on button press in backbutton.
function backbutton_Callback(hObject, eventdata, handles)
% hObject    handle to backbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles, 'fig_h')
    myerrordlg('Please start with pfwiz.'); return;
end;
set(handles.fig_h(2), 'Visible', 'off');
set(handles.fig_h(1), 'Visible', 'on');
% guidata(handles.fig_h(1), handles);

% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_me = gcf;
if ~isfield(handles, 'fig_h') close(h_me); 
else
    for i = 1:length(handles.fig_h)
        if(handles.fig_h(i) ~= h_me)
            close(handles.fig_h(i));
        end;
    end;
    close(h_me);
end;


% --- Executes on selection change in xdim.
function xdim_Callback(hObject, eventdata, handles)
% hObject    handle to xdim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns xdim contents as cell array
%        contents{get(hObject,'Value')} returns selected item from xdim


% --- Executes during object creation, after setting all properties.
function xdim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xdim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in xdim.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to xdim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns xdim contents as cell array
%        contents{get(hObject,'Value')} returns selected item from xdim


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xdim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dimX.
function dimX_Callback(hObject, eventdata, handles)
% hObject    handle to dimX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns dimX contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dimX


% --- Executes during object creation, after setting all properties.
function dimX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dimX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dimW_Callback(hObject, eventdata, handles)
% hObject    handle to dimW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dimW as text
%        str2double(get(hObject,'String')) returns contents of dimW as a double


% --- Executes during object creation, after setting all properties.
function dimW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dimW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dimY_Callback(hObject, eventdata, handles)
% hObject    handle to dimY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dimY as text
%        str2double(get(hObject,'String')) returns contents of dimY as a double


% --- Executes during object creation, after setting all properties.
function dimY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dimY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dimV_Callback(hObject, eventdata, handles)
% hObject    handle to dimV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dimV as text
%        str2double(get(hObject,'String')) returns contents of dimV as a double


% --- Executes during object creation, after setting all properties.
function dimV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dimV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function F_Callback(hObject, eventdata, handles)
% hObject    handle to F (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of F as text
%        str2double(get(hObject,'String')) returns contents of F as a double


% --- Executes during object creation, after setting all properties.
function F_CreateFcn(hObject, eventdata, handles)
% hObject    handle to F (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseF.
function browseF_Callback(hObject, eventdata, handles)
% hObject    handle to browseF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fname = uigetfile('*.m');
if(fname)
    set(handles.F, 'String', fname);
    if ~exist(fname, 'file')
        myerrordlg({[fname ' is NOT on your MATLAB path!'], 'Addpath so that it is.'});
    end;
end;


function H_Callback(hObject, eventdata, handles)
% hObject    handle to H (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of H as text
%        str2double(get(hObject,'String')) returns contents of H as a double


% --- Executes during object creation, after setting all properties.
function H_CreateFcn(hObject, eventdata, handles)
% hObject    handle to H (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseH.
function browseH_Callback(hObject, eventdata, handles)
% hObject    handle to browseH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fname = uigetfile('*.m');
if(fname)
    set(handles.H, 'String', fname);
    if ~exist(fname, 'file')
        myerrordlg({[fname ' is NOT on your MATLAB path!'], 'Addpath so that it is.'});
    end;
end;


% --- Executes on selection change in distrW.
function distrW_Callback(hObject, eventdata, handles)
% hObject    handle to distrW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns distrW contents as cell array
%        contents{get(hObject,'Value')} returns selected item from distrW


% --- Executes during object creation, after setting all properties.
function distrW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distrW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function meanW_Callback(hObject, eventdata, handles)
% hObject    handle to meanW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of meanW as text
%        str2double(get(hObject,'String')) returns contents of meanW as a double


% --- Executes during object creation, after setting all properties.
function meanW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to meanW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function covW_Callback(hObject, eventdata, handles)
% hObject    handle to covW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of covW as text
%        str2double(get(hObject,'String')) returns contents of covW as a double


% --- Executes during object creation, after setting all properties.
function covW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to covW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in distrV.
function distrV_Callback(hObject, eventdata, handles)
% hObject    handle to distrV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns distrV contents as cell array
%        contents{get(hObject,'Value')} returns selected item from distrV


% --- Executes during object creation, after setting all properties.
function distrV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distrV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function meanV_Callback(hObject, eventdata, handles)
% hObject    handle to meanV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of meanV as text
%        str2double(get(hObject,'String')) returns contents of meanV as a double


% --- Executes during object creation, after setting all properties.
function meanV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to meanV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function covV_Callback(hObject, eventdata, handles)
% hObject    handle to covV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of covV as text
%        str2double(get(hObject,'String')) returns contents of covV as a double


% --- Executes during object creation, after setting all properties.
function covV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to covV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in codebutton.
function codebutton_Callback(hObject, eventdata, handles)
% hObject    handle to codebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sysinfo = genCode(handles);
if isempty(sysinfo) return; end;
code = genCodeStrs(sysinfo);
try
    fid = fopen('tmpCodeFile0001.m', 'w+');
    for i=1:length(code) fprintf(fid, '%s\n', code{i}); end;
    fclose(fid);
catch
    myerrordlg(['cannot create temporary file:' lasterr]);
end;
edit tmpCodeFile0001;

function code = genCodeStrs(sysinfo)

if isempty(sysinfo) code = []; return; end;

ind = 1; 
code{ind} = '% The dimension variables were used by PFWiz for error checking'; ind = ind + 1;
code{ind} = ['dimX = ' num2str(sysinfo.dimX) ';']; ind = ind + 1;
code{ind} = ['dimY = ' num2str(sysinfo.dimY) ';']; ind = ind + 1;
code{ind} = '% initial condition of the system; NOT used to initialize the filter'; ind = ind + 1;
code{ind} = ['initX = ' sysinfo.initX.str ';']; ind = ind + 1;
code{ind} = '% function handle for state transition'; ind = ind + 1;
code{ind} = ['f = ' sysinfo.f.str ';']; ind = ind + 1;
code{ind} = '% function handle for observation '; ind = ind + 1;
code{ind} = ['h = ' sysinfo.h.str ';']; ind = ind + 1;
switch sysinfo.distrW
    case 'Gaussian'
        code{ind} = ['meanW = ' sysinfo.meanW.str ';']; ind = ind + 1;
        code{ind} = ['covW = ' sysinfo.covW.str ';']; ind = ind + 1;
        code{ind} = '% constructing a Gaussian distribution'; ind = ind + 1;
        code{ind} = 'wDistr =  GaussianDistr(meanW, covW);'; ind = ind + 1;
    otherwise
end;
switch sysinfo.distrV
    case 'Gaussian'
        code{ind} = ['meanV = ' sysinfo.meanV.str ';']; ind = ind + 1;
        code{ind} = ['covV = ' sysinfo.covV.str ';']; ind = ind + 1;
        code{ind} = 'vDistr =  GaussianDistr(meanV, covV);'; ind = ind + 1;
    otherwise
end;
code{ind} = '% Constructing the system postulated by the filter.'; ind = ind + 1;
code{ind} = '% For some filter, Jacobians are also needed'; ind = ind + 1;
code{ind} = 'theSys = SigObsSys(f, h, wDistr, vDistr, initX);';


% --- Executes on button press in anonymousF.
function anonymousF_Callback(hObject, eventdata, handles)
% hObject    handle to anonymousF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of anonymousF

set(handles.browseF, 'Enable', 'off');


% --- Executes on button press in scriptF.
function scriptF_Callback(hObject, eventdata, handles)
% hObject    handle to scriptF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of scriptF
set(handles.browseF, 'Enable', 'on');


% --- Executes on button press in anonymousH.
function anonymousH_Callback(hObject, eventdata, handles)
% hObject    handle to anonymousH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of anonymousH
set(handles.browseH, 'Enable', 'off');


% --- Executes on button press in scriptH.
function scriptH_Callback(hObject, eventdata, handles)
% hObject    handle to scriptH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of scriptH

set(handles.browseH, 'Enable', 'on');

function sysinfo = genCode(handles)

global DIMX_GLOBAL; % hack, to pass to pfwiz3 before handles are available

sysinfo.dimX = getInt(handles.dimX);
if isnan(sysinfo.dimX) myerrordlg('wrong dimension for x');  sysinfo = []; return; end;

DIMX_GLOBAL = sysinfo.dimX;

sysinfo.dimY = getInt(handles.dimY);
if isnan(sysinfo.dimY) myerrordlg('wrong dimension for y');  sysinfo = []; return; end;

str = get(handles.initX, 'String');
try
    eval(['val=' str ';']);
catch
    myerrordlg(['wrong initial condition for x:' lasterr]);  sysinfo = []; return;
end;
[nrow, ncol] = size(val);
if min(nrow, ncol) ~= 1 || max(nrow, ncol) ~= sysinfo.dimX
    myerrordlg('wrong initial condition for x');  sysinfo = []; return;
else sysinfo.initX.str = str; sysinfo.initX.val = val; end;

str = get(handles.F, 'String'); 
if isempty(str) myerrordlg('wrong function f'); sysinfo = []; return;
else
    hd = get(handles.typeF, 'SelectedObject');
    if hd == handles.scriptF sysinfo.f.str = ['@' strtok(str, '.')];
    elseif hd == handles.anonymousF sysinfo.f.str = str;
    end
    try
        eval(['sysinfo.f.val = ' sysinfo.f.str ';']);
        tmp = sysinfo.f.val(sysinfo.initX.val);
        if length(tmp) ~= sysinfo.dimX 
            myerrordlg('dimension mismatch for f'); sysinfo = []; return;
        end;
    catch 
        myerrordlg(['something wrong with f:' lasterr]); sysinfo = []; return;
    end;
end;

str = get(handles.H, 'String'); 
if isempty(str) myerrordlg('wrong function h'); sysinfo = []; return;
else
    hd = get(handles.typeH, 'SelectedObject');
    if hd == handles.scriptH sysinfo.h.str = ['@' strtok(str, '.')];
    elseif hd == handles.anonymousH sysinfo.h.str = str;
    end
    try
        eval(['sysinfo.h.val = ' sysinfo.h.str ';']);
        tmp = sysinfo.h.val(sysinfo.initX.val);
        if length(tmp) ~= sysinfo.dimY 
            myerrordlg('dimension mismatch for h'); sysinfo = []; return;
        end;
    catch 
        myerrordlg(['something wrong with h:' lasterr]); sysinfo = []; return;
    end;
end;

val = get(handles.distrW, 'Value'); str = get(handles.distrW, 'String');
sysinfo.distrW = str{val};
switch sysinfo.distrW
    case 'Gaussian'
        str1 = get(handles.meanW, 'String'); str2 = get(handles.covW, 'String');
        try
            eval(['val1=' str1 ';']);  eval(['val2=' str2 ';']);
        catch
            myerrordlg(['wrong parameter(s) for w:' lasterr]);  sysinfo = []; return;
        end;
        [nrow1, ncol1] = size(val1); [nrow2, ncol2] = size(val2);
        if min(nrow1, ncol1) ~= 1 || max(nrow1, ncol1) ~= sysinfo.dimX || ...
                nrow2 ~= ncol2 || nrow2 ~= sysinfo.dimX
            myerrordlg('wrong parameter(s) for w');  sysinfo = []; return;
        else
            sysinfo.meanW.str = str1;
            sysinfo.meanW.val = val1;
            sysinfo.covW.str = str2;
            sysinfo.covW.val = val2; 
        end;
    otherwise
        myerrordlg([sysinfo.distrW ': not implemented yet']); sysinfo = []; return;
end;

val = get(handles.distrV, 'Value'); str = get(handles.distrV, 'String');
sysinfo.distrV = str{val};
switch sysinfo.distrV
    case 'Gaussian'
        str1 = get(handles.meanV, 'String'); str2 = get(handles.covV, 'String');
        try
            eval(['val1=' str1 ';']);  eval(['val2=' str2 ';']);
        catch
            myerrordlg(['wrong parameter(s) for v:' lasterr]);  sysinfo = []; return;
        end;
        [nrow1, ncol1] = size(val1); [nrow2, ncol2] = size(val2);
        if min(nrow1, ncol1) ~= 1 || max(nrow1, ncol1) ~= sysinfo.dimY || ...
                nrow2 ~= ncol2 || nrow2 ~= sysinfo.dimY
            myerrordlg('wrong parameter(s) for v');  sysinfo = []; return;
        else
            sysinfo.meanV.str = str1;
            sysinfo.meanV.val = val1;  
            sysinfo.covV.str = str2;
            sysinfo.covV.val = val2; 
        end;
    otherwise
        myerrordlg([sysinfo.distrV ': not implemented yet']); sysinfo = []; return;
end;
try
    wDistr = GaussianDistr(sysinfo.meanW.val, sysinfo.covW.val);
    vDistr = GaussianDistr(sysinfo.meanV.val, sysinfo.covV.val);
    sysinfo.theSys = SigObsSys(sysinfo.f.val, sysinfo.h.val, wDistr, vDistr, sysinfo.initX.val);
catch
    myerrordlg(['something wrong in creating the sys:' lasterr]);
    sysinfo = [];
end;

function n = getInt(h)
% utility function
str = get(h, 'String'); val = str2double(str);
if isnan(val) n = nan; 
else
    n = round(val); % keep it simple
    if n <= 0 n = nan; end;
end;

function initX_Callback(hObject, eventdata, handles)
% hObject    handle to initX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initX as text
%        str2double(get(hObject,'String')) returns contents of initX as a double


% --- Executes during object creation, after setting all properties.
function initX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function myerrordlg(str)

uiwait(errordlg(str, 'error', 'modal'));


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bin_dir = which('pfwiz');
web(['file:///' bin_dir(1:end-7) 'doc/pfwiz/node2.html']);
