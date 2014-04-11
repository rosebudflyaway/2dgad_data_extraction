function varargout = pfwiz3(varargin)
% PFWIZ3 M-file for pfwiz3.fig
%      PFWIZ3, by itself, creates pfwiz3 new PFWIZ3 or raises the existing
%      singleton*.
%
%      H = PFWIZ3 returns the handle to pfwiz3 new PFWIZ3 or the handle to
%      the existing singleton*.
%
%      PFWIZ3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PFWIZ3.M with the given input arguments.
%
%      PFWIZ3('Property','Value',...) creates pfwiz3 new PFWIZ3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pfwiz3_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pfwiz3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pfwiz3

% Last Modified by GUIDE v2.5 03-Aug-2006 16:39:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pfwiz3_OpeningFcn, ...
                   'gui_OutputFcn',  @pfwiz3_OutputFcn, ...
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


% --- Executes just before pfwiz3 is made visible.
function pfwiz3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in pfwiz3 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pfwiz3 (see VARARGIN)

% Choose default command line output for pfwiz3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pfwiz3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pfwiz3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in pfwiz3 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in pfwiz3 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in donebutton.
function donebutton_Callback(hObject, eventdata, handles)
% hObject    handle to donebutton (see GCBO)
% eventdata  reserved - to be defined in pfwiz3 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles, 'fig_h')
    errordlg('Please start with pfwiz.'); return;
end;
fltr = genCode(handles);
if isempty(fltr) return; end;
if ~isfield(handles, 'sysinfo') errordlg('Please start with pfwiz'); return; end; 
code = genCodeStrs(handles.sysinfo, fltr);
try
    fid = fopen('tmpCodeFile0001.m', 'w+');
    for i=1:length(code) fprintf(fid, '%s\n', code{i}); end;
    fclose(fid);
catch
    errordlg(['cannot create temporary file:' lasterr]); return; 
end;
switch questdlg('Quit PFWiz? (Code will be displayed in an editor window.)')
    case 'Yes'
       edit tmpCodeFile0001.m;
       cancelbutton_Callback(hObject, eventdata, handles);
end;


% --- Executes on button press in backbutton.
function backbutton_Callback(hObject, eventdata, handles)
% hObject    handle to backbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles, 'fig_h')
    errordlg('Please start with pfwiz.'); return;
end;
set(handles.fig_h(3), 'Visible', 'off');
set(handles.fig_h(2), 'Visible', 'on');
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
        errordlg({[fname ' is NOT on your MATLAB path!'], 'Addpath so that it is.'});
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
        errordlg({[fname ' is NOT on your MATLAB path!'], 'Addpath so that it is.'});
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
if ~isfield(handles, 'fig_h')
    errordlg('Please start with pfwiz.'); return;
end;
fltr = genCode(handles);
if isempty(fltr) return; end;
if ~isfield(handles, 'sysinfo') errordlg('Please start with pfwiz'); return; end; 
code = genCodeStrs(handles.sysinfo, fltr);
try
    fid = fopen('tmpCodeFile0001.m', 'w+');
    for i=1:length(code) fprintf(fid, '%s\n', code{i}); end;
    fclose(fid);
catch
    errordlg(['cannot create temporary file:' lasterr]);
end;
edit tmpCodeFile0001;

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

function fltr = genCode(handles)

ftype = getSelected(handles.filterTypeTag);

switch ftype
    case 'PF -- Simple'
        fltr.ftype = 'PF_Simple'; 
        N = getNumPart(handles.NumPart);
        if isnan(N) fltr = []; return; end;
        opts = getResampOpts(handles);
        if isempty(opts) fltr = []; return; end;
        fltr.opts = opts;
        fltr.opts.NumPart = N;
        
    case 'PF -- EKF proposal'
        fltr.ftype = 'PF_EKF';
        N = getNumPart(handles.NumPart);
        if isnan(N) fltr = []; return; end;
        opts = getResampOpts(handles);
        if isempty(opts) fltr = []; return; end;
        fltr.opts = opts;
        fltr.opts.NumPart = N;
        try
            dh = getFcn(handles.typeH, handles.H);
        catch 
            errordlg(['wrong dh/dx: ' lasterr]);
            fltr = [];
            return;
        end;
        if isempty(dh) 
            errordlg('missing dh/dx'); fltr = []; 
            return;
        end;
        fltr.dh = dh;
        
    case 'PF -- Regularized'
        fltr.ftype = 'PF_Regular';
        N = getNumPart(handles.NumPart);
        if isnan(N) fltr = []; return; end;
        opts = getResampOpts(handles);
        if isempty(opts) fltr = []; return; end;
        fltr.opts = opts;
        fltr.opts.NumPart = N;

        hd = get(handles.regTypePanel, 'SelectedObject');
        switch get(hd, 'String')
            case 'pre'
                fltr.opts.RegularAlgo = 'pre';
            case 'post'
                fltr.opts.RegularAlgo = 'post';
            case 'mixed'
                fltr.opts.RegularAlgo = 'mix';
        end;
        hd = get(handles.whiteTag, 'SelectedObject');
        switch get(hd, 'String')
            case 'yes'
                fltr.opts.RegularWhitening = 1;
            case 'no'
                fltr.opts.RegularWhitening = 0;
        end;
        fltr.opts.RegularWidth = getDouble(handles.widthTag);
        if isnan(fltr.opts.RegularWidth) 
            errordlg('wrong width in Regularized.');
            fltr = [];
            return;
        end;

    case 'PF -- Auxiliary Variable'
        fltr.ftype = 'PF_Aux';
        N = getNumPart(handles.NumPart);
        if isnan(N) fltr = []; return; end;
        fltr.opts.NumPart = N;

    case 'EKF'
        fltr.ftype = 'EKF';
        try
            df = getFcn(handles.typeF, handles.F);
        catch 
            errordlg(['wrong df/dx: ' lasterr]);
            fltr = [];
            return;
        end;
        if isempty(df) 
            errordlg('missing df/dx'); fltr = []; 
            return;
        end;
        try
	  % bug fix, 6/26/2008
	  % dh = getFcn(handles.typeF, handles.F);
            dh = getFcn(handles.typeH, handles.H);
        catch 
            errordlg(['wrong dh/dx: ' lasterr]);
            fltr = [];
            return;
        end;
        if isempty(dh) 
            errordlg('missing dh/dx'); fltr = []; 
            return;
        end;
        fltr.df = df; fltr.dh = dh;
end;

initD = getSelected(handles.initDistrTag); 
switch initD
    case 'Gaussian'
        str1 = get(handles.initMeanTag, 'String'); str2 = get(handles.initCovTag, 'String');
        try
            eval(['val1=' str1 ';']);  eval(['val2=' str2 ';']);
        catch
            errordlg(['wrong parameter(s) for initial distribution:' lasterr]);  fltr = []; return;
        end;
        [nrow1, ncol1] = size(val1); [nrow2, ncol2] = size(val2);
        if min(nrow1, ncol1) ~= 1 || max(nrow1, ncol1) ~= handles.sysinfo.dimX || ...
                nrow2 ~= ncol2 || nrow2 ~= handles.sysinfo.dimX
            errordlg('wrong parameter(s) for initial condition');  fltr = []; return;
        else
            fltr.initType = 'Gaussian';
            fltr.initMean.str = str1;
            fltr.initMean.val = val1;
            fltr.initCov.str = str2;
            fltr.initCov.val = val2; 
            try
                fltr.initDistr = GaussianDistr(fltr.initMean.val, fltr.initCov.val); 
            catch
                errordlg(['wrong initial distribution: ' lasterr]); fltr = []; return;
            end;
        end;
    otherwise
        errordlg([initD ': not implemented yet']); fltr = []; return;
end;


function code = genCodeStrs(sysinfo, fltr)

if isempty(sysinfo) || isempty(fltr) code = []; return; end;

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

switch fltr.ftype
    case 'EKF'
        code{ind} = '% function handle for the Jacobian df/dx '; ind = ind + 1;
        code{ind} = ['df = ' fltr.df.str ';']; ind = ind + 1;
        code{ind} = '% function handle for the Jacobian dh/dx '; ind = ind + 1;
        code{ind} = ['dh = ' fltr.dh.str ';']; ind = ind + 1;
        code{ind} = '% Constructing the system postulated by the filter.'; ind = ind + 1;
        code{ind} = 'theSys = SigObsSys(f, h, wDistr, vDistr, initX, df, dh);'; ind = ind + 1;
    case 'PF_EKF'
        code{ind} = '% function handle for the Jacobian dh/dx'; ind = ind + 1;
        code{ind} = ['dh = ' fltr.dh.str ';']; ind = ind + 1;
        code{ind} = '% Constructing the system postulated by the filter; note that df/dx is not needed'; ind = ind + 1;
        code{ind} = 'theSys = SigObsSys(f, h, wDistr, vDistr, initX, [], dh);'; ind = ind + 1;
    otherwise
        code{ind} = '% Constructing the system postulated by the filter.'; ind = ind + 1;
        code{ind} = 'theSys = SigObsSys(f, h, wDistr, vDistr, initX);'; ind = ind + 1;
end

switch fltr.initType
    case 'Gaussian'
        code{ind} = ['initMean = ' fltr.initMean.str ';']; ind = ind + 1;
        code{ind} = ['initCov = ' fltr.initCov.str ';']; ind = ind + 1;
        code{ind} = '% constructing the initial distribution postulated by the filter'; ind = ind + 1;
        code{ind} = ['initDistr = GaussianDistr(initMean, initCov);']; ind = ind + 1;
    otherwise
end;

switch fltr.ftype
    case 'EKF'
        code{ind} = '% constructing EKF'; ind = ind + 1;
        code{ind} = 'theFltr = EKF(theSys, initDistr);'; ind = ind + 1;
    case {'PF_Simple', 'PF_EKF'}
        code{ind} = '% constructing the options'; ind = ind + 1; 
        switch fltr.opts.ResampAlgo
            case 'none'
                code{ind} = ['opts = setPFOptions(''NumPart'', ' num2str(fltr.opts.NumPart), ...
                    ', ''ResampAlgo'', ''none'');'];
                ind = ind + 1;
            case 'fcn_ResampSimp'
                code{ind} = ['opts = setPFOptions(''NumPart'', ' num2str(fltr.opts.NumPart), ...
                    ', ''ResampAlgo'', ''fcn_ResampSimp'', ''ResampPeriod'',' ...
                    num2str(fltr.opts.ResampPeriod) ');'];
                ind = ind + 1;
            case 'fcn_ResampResid'
                code{ind} = ['opts = setPFOptions(''NumPart'', ' num2str(fltr.opts.NumPart), ...
                    ', ''ResampAlgo'', ''fcn_ResampResid'', ''ResampPeriod'',' ...
                    num2str(fltr.opts.ResampPeriod) ');'];
                ind = ind + 1;
            case 'fcn_ResampSys'
                code{ind} = ['opts = setPFOptions(''NumPart'', ' num2str(fltr.opts.NumPart), ...
                    ', ''ResampAlgo'', ''fcn_ResampSys'', ''ResampPeriod'',' ...
                    num2str(fltr.opts.ResampPeriod) ');'];
                ind = ind + 1;
            case 'fcn_ResampBran'
                code{ind} = ['opts = setPFOptions(''NumPart'', ' num2str(fltr.opts.NumPart), ...
                    ', ''ResampAlgo'', ''fcn_ResampBran'', ''ResampPeriod'',' ...
                    num2str(fltr.opts.ResampPeriod) ', ''BranchThresh'',' num2str(fltr.opts.BranchThresh) ');'];
                ind = ind + 1;
            otherwise 
                errordlg('?');
        end;
        code{ind} = '% constructing the particle filter'; ind = ind + 1;
        code{ind} = ['theFltr = ' fltr.ftype '(theSys, initDistr, opts);']; ind = ind + 1;
        
    case 'PF_Regular'
        code{ind} = '% constructing the options'; ind = ind + 1;
        code{ind} = ['opts = setPFOptions(''NumPart'', ' num2str(fltr.opts.NumPart) ...
            ', ''RegularAlgo'', ''' fltr.opts.RegularAlgo ''', ''RegularWidth'',' ...
            num2str(fltr.opts.RegularWidth) ', ''RegularWhitening'',' ...
            num2str(fltr.opts.RegularWhitening) ');'];
        ind = ind + 1;
        code{ind} = '% constructing the particle filter'; ind = ind + 1;
        code{ind} = 'theFltr = PF_Regular(theSys, initDistr, opts);'; ind = ind + 1;
    case 'PF_Aux'
        code{ind} = '% constructing the options'; ind = ind + 1;
        code{ind} = ['opts = setPFOptions(''NumPart'', ' num2str(fltr.opts.NumPart) ');'];
        ind = ind + 1;
        code{ind} = '% constructing the particle filter'; ind = ind + 1;
        code{ind} = 'theFltr = PF_Aux(theSys, initDistr, opts);'; ind = ind + 1;
end;

code{ind} = ' '; ind = ind + 1;
code{ind} = '% Here is an example of a simulation.'; ind = ind + 1;
code{ind} = '% Assuming that the real system from which data is collected is given as:'; ind = ind + 1;
code{ind} = 'realSys = theSys;'; ind = ind + 1;
code{ind} = '% We can reset the initial condition'; ind = ind + 1; 
code{ind} = 'realSys = set(realSys, rand(dimX, 1));'; ind = ind + 1;
code{ind} = '% Now we simulate the signal and observation trajectories.'; ind = ind + 1;
code{ind} = 'Nsim = 20;'; ind = ind + 1;
code{ind} = 'X = zeros(dimX, Nsim); Y = zeros(dimY, Nsim); Xhat = X; '; ind = ind + 1;
code{ind} = 'for i = 2:Nsim'; ind = ind + 1;
code{ind} = '  realSys = update(realSys);'; ind = ind + 1;
code{ind} = '  [X(:, i), Y(:, i)] = get(realSys);'; ind = ind + 1;
code{ind} = 'end;'; ind = ind + 1;
code{ind} = ' '; ind = ind + 1;
code{ind} = '% Now we simulate the filtering.'; ind = ind + 1;
code{ind} = 'for i=2:Nsim'; ind = ind + 1;
code{ind} = '  theFltr = update(theFltr, Y(:, i));'; ind = ind + 1;
code{ind} = '  Xhat(:, i) = get(theFltr);'; ind = ind + 1;
code{ind} = 'end;'; ind = ind + 1;
code{ind} = ' '; ind = ind + 1;
code{ind} = '% Displaying results, e.g., plotting'; ind = ind + 1;
code{ind} = 'for i = 1:dimX'; ind = ind + 1;
code{ind} = '  subplot(dimX, 1, i); plot(X(i,:)); hold on; plot(Xhat(i,:), ''r-.'');'; ind = ind + 1;
code{ind} = 'end;'; ind = ind + 1;



function fcn = getFcn(typeHandle, strHandle)
% utility function
str = get(strHandle, 'String'); 
if isempty(str) fcn = []; return;
else
    hd = get(typeHandle, 'SelectedObject');
    switch get(hd, 'String')
        case 'script'
            fcn.str = ['@' strtok(str, '.')];
        case 'anonymous'
            fcn.str = str;
    end;
    try
        eval(['fcn.val = ' fcn.str ';']);
    catch 
        fcn = []; 
        rethrow(lasterror); 
    end;
end;



function res = getSelected(h)
% utility function
val = get(h, 'Value'); strs = get(h, 'String');
if iscell(strs) res = strs{val};
else res = strs(val);
end;

function n = getInt(h)
% utility function
str = get(h, 'String'); val = str2double(str);
if isnan(val) n = nan; 
else
    n = round(val); % keep it simple
    if n <= 0 n = nan; end;
end;

function val = getDouble(h)
% utility function
str = get(h, 'String'); 
val = str2double(str);

function val = getDoubleFrac(h)
% utility function
str = get(h, 'String'); 
val = str2double(str);
if val < 0 || val > 1
    val = nan;
end;

function N = getNumPart(h)
N = getInt(h);
if isnan(N)
    errordlg('wrong number of particles');
    N = nan;
    return;
end;


function opts = getResampOpts(handles)
% utility function
ResampAlgo = getSelected(handles.resampTag);
switch ResampAlgo
    case 'none'
        opts.ResampAlgo = 'none';
    case 'simple'
        opts.ResampAlgo = 'fcn_ResampSimp';
        opts.ResampPeriod = getInt(handles.ResampPeriod);
        if isnan(opts.ResampPeriod)
            errordlg('wrong resampling period');
            opts = [];
            return;
        end;
    case 'residual'
        opts.ResampAlgo = 'fcn_ResampResid';
        opts.ResampPeriod = getInt(handles.ResampPeriod);
        if isnan(opts.ResampPeriod)
            errordlg('wrong resampling period');
            opts = [];
            return;
        end;
    case 'branch-kill'
        opts.ResampAlgo = 'fcn_ResampBran';
        opts.ResampPeriod = getInt(handles.ResampPeriod);
        if isnan(opts.ResampPeriod)
            errordlg('wrong resampling period');
            opts = [];
            return;
        end;
        opts.BranchThresh = getDoubleFrac(handles.BranchThresh);
        if isnan(opts.BranchThresh)
            errordlg('wrong branch-kill threshold');
            opts = [];
            return;
        end;
    case 'systematic'
        opts.ResampAlgo = 'fcn_ResampSys';
        opts.ResampPeriod = getInt(handles.ResampPeriod);
        if isnan(opts.ResampPeriod)
            errordlg('wrong resampling period');
            opts = [];
            return;
        end;
end;

function NumPart_Callback(hObject, eventdata, handles)
% hObject    handle to NumPart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumPart as text
%        str2double(get(hObject,'String')) returns contents of NumPart as a double
N = getNumPart(handles.NumPart);
if isnan(N) return; end;
set(handles.widthTag, 'String', num2str(fcn_opt_GKer_width(handles.sysinfo.dimX, N)));

% --- Executes during object creation, after setting all properties.
function NumPart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumPart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


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



function ResampPeriod_Callback(hObject, eventdata, handles)
% hObject    handle to ResampPeriod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ResampPeriod as text
%        str2double(get(hObject,'String')) returns contents of ResampPeriod as a double


% --- Executes during object creation, after setting all properties.
function ResampPeriod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ResampPeriod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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



function BranchThresh_Callback(hObject, eventdata, handles)
% hObject    handle to BranchThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BranchThresh as text
%        str2double(get(hObject,'String')) returns contents of BranchThresh as a double


% --- Executes during object creation, after setting all properties.
function BranchThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BranchThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function widthTag_Callback(hObject, eventdata, handles)
% hObject    handle to widthTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of widthTag as text
%        str2double(get(hObject,'String')) returns contents of widthTag as a double


% --- Executes during object creation, after setting all properties.
function widthTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to widthTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

global DIMX_GLOBAL;

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
N = 100; % the filled-in value for the number of particles. Code below does not work.
%N = getNumPart(findobj(get(hObject, 'Parent'), 'Tag', 'NumPart'));
%if isnan(N) return; end;
set(hObject, 'String', num2str(fcn_opt_GKer_width(DIMX_GLOBAL, N)));


% --- Executes on selection change in filterTypeTag.
function filterTypeTag_Callback(hObject, eventdata, handles)
% hObject    handle to filterTypeTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns filterTypeTag contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filterTypeTag

val = get(hObject, 'Value'); strs = get(hObject, 'String');

switch strs{val}
    case 'PF -- Simple'
        set(handles.paramTag, 'Visible', 'on');
        set(handles.dfJacTag, 'Visible', 'off');
        set(handles.dhJacTag, 'Visible', 'off');
        set(handles.regTag, 'Visible', 'off');
        set(handles.NPanelTag, 'Visible', 'on');
    case 'PF -- EKF proposal'
        set(handles.paramTag, 'Visible', 'on');
        set(handles.regTag, 'Visible', 'off');
        set(handles.dfJacTag, 'Visible', 'off');
        set(handles.dhJacTag, 'Visible', 'on');
        set(handles.NPanelTag, 'Visible', 'on');
    case 'PF -- Regularized'
        set(handles.paramTag, 'Visible', 'on');
        set(handles.dfJacTag, 'Visible', 'off');
        set(handles.dhJacTag, 'Visible', 'off');
        set(handles.regTag, 'Visible', 'on');
        set(handles.NPanelTag, 'Visible', 'on');
    case 'PF -- Auxiliary Variable'
        set(handles.paramTag, 'Visible', 'off');
        set(handles.dfJacTag, 'Visible', 'off');
        set(handles.dhJacTag, 'Visible', 'off');
        set(handles.regTag, 'Visible', 'off');
        set(handles.NPanelTag, 'Visible', 'on');
    case 'EKF'
        set(handles.paramTag, 'Visible', 'off');
        set(handles.dfJacTag, 'Visible', 'on');
        set(handles.dhJacTag, 'Visible', 'on');
        set(handles.regTag, 'Visible', 'off');
        set(handles.NPanelTag, 'Visible', 'off');
end;
        
        


% --- Executes on selection change in resampTag.
function resampTag_Callback(hObject, eventdata, handles)
% hObject    handle to resampTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns resampTag contents as cell array
%        contents{get(hObject,'Value')} returns selected item from resampTag

val = get(hObject, 'Value'); strs = get(hObject, 'String');
switch strs{val}
    case 'residual'
        set(handles.BranchKillText, 'Enable', 'off');
        set(handles.BranchThresh, 'Enable', 'off');
        set(handles.periodText, 'Enable', 'on');
        set(handles.ResampPeriod', 'Enable', 'on');
    case 'simple'
        set(handles.BranchKillText, 'Enable', 'off');
        set(handles.BranchThresh, 'Enable', 'off');
        set(handles.periodText, 'Enable', 'on');
        set(handles.ResampPeriod', 'Enable', 'on');
    case 'branch-kill'
        set(handles.BranchKillText, 'Enable', 'on');
        set(handles.BranchThresh, 'Enable', 'on');
        set(handles.periodText, 'Enable', 'on');
        set(handles.ResampPeriod', 'Enable', 'on');
    case 'systematic'
        set(handles.BranchKillText, 'Enable', 'off');
        set(handles.BranchThresh, 'Enable', 'off');
        set(handles.periodText, 'Enable', 'on');
        set(handles.ResampPeriod', 'Enable', 'on');
    case 'none'
        set(handles.BranchKillText, 'Enable', 'off');
        set(handles.BranchThresh, 'Enable', 'off');
        set(handles.periodText, 'Enable', 'off');
        set(handles.ResampPeriod', 'Enable', 'off');
end;


% --- Executes on selection change in initDistrTag.
function initDistrTag_Callback(hObject, eventdata, handles)
% hObject    handle to initDistrTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns initDistrTag contents as cell array
%        contents{get(hObject,'Value')} returns selected item from initDistrTag


% --- Executes during object creation, after setting all properties.
function initDistrTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initDistrTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function initMeanTag_Callback(hObject, eventdata, handles)
% hObject    handle to initMeanTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initMeanTag as text
%        str2double(get(hObject,'String')) returns contents of initMeanTag as a double


% --- Executes during object creation, after setting all properties.
function initMeanTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initMeanTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function initCovTag_Callback(hObject, eventdata, handles)
% hObject    handle to initCovTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initCovTag as text
%        str2double(get(hObject,'String')) returns contents of initCovTag as a double


% --- Executes during object creation, after setting all properties.
function initCovTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initCovTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bin_dir = which('pfwiz');
web(['file:///' bin_dir(1:end-7) 'doc/pfwiz/node3.html']);


