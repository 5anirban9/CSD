function varargout = DeleteSubject(varargin)
% DELETESUBJECT MATLAB code for DeleteSubject.fig
%      DELETESUBJECT, by itself, creates a new DELETESUBJECT or raises the existing
%      singleton*.
%
%      H = DELETESUBJECT returns the handle to a new DELETESUBJECT or the handle to
%      the existing singleton*.
%
%      DELETESUBJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DELETESUBJECT.M with the given input arguments.
%
%      DELETESUBJECT('Property','Value',...) creates a new DELETESUBJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DeleteSubject_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DeleteSubject_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DeleteSubject

% Last Modified by GUIDE v2.5 16-Jan-2016 16:52:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DeleteSubject_OpeningFcn, ...
                   'gui_OutputFcn',  @DeleteSubject_OutputFcn, ...
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


% --- Executes just before DeleteSubject is made visible.
function DeleteSubject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DeleteSubject (see VARARGIN)

% Choose default command line output for DeleteSubject
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DeleteSubject wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DeleteSubject_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function subIDs_Callback(hObject, eventdata, handles)
% hObject    handle to subIDs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subIDs as text
%        str2double(get(hObject,'String')) returns contents of subIDs as a double


% --- Executes during object creation, after setting all properties.
function subIDs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subIDs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in deleteBt.
function deleteBt_Callback(hObject, eventdata, handles)
% hObject    handle to deleteBt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
subIDs=get(handles.subIDs,'String');
subIDs
conn=database('myDB','','');
% sqlquery = ['delete * from Subject where ID =' '' subIDs ''];
sqlquery = ['delete * from Subject where ID in (' '' subIDs  ')' ''];
curs = exec(conn,sqlquery);
msgbox('Data Suceessfully deleted!');
commit(conn);
close(curs);
close(conn);
% 'where ID = ' '' SubID ''
