function varargout = EditSubject(varargin)
% EDITSUBJECT MATLAB code for EditSubject.fig
%      EDITSUBJECT, by itself, creates a new EDITSUBJECT or raises the existing
%      singleton*.
%
%      H = EDITSUBJECT returns the handle to a new EDITSUBJECT or the handle to
%      the existing singleton*.
%
%      EDITSUBJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDITSUBJECT.M with the given input arguments.
%
%      EDITSUBJECT('Property','Value',...) creates a new EDITSUBJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EditSubject_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EditSubject_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EditSubject

% Last Modified by GUIDE v2.5 16-Jan-2016 13:54:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EditSubject_OpeningFcn, ...
                   'gui_OutputFcn',  @EditSubject_OutputFcn, ...
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


% --- Executes just before EditSubject is made visible.
function EditSubject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EditSubject (see VARARGIN)

% Choose default command line output for EditSubject
set(handles.Name,'Visible','off');
set(handles.Age,'Visible','off');
set(handles.Handedness,'Visible','off');
set(handles.Sex,'Visible','off');
set(handles.editFname,'Visible','off');
set(handles.editLname,'Visible','off');
set(handles.editAge,'Visible','off');
set(handles.editPopHand,'Visible','off');
set(handles.editPopSex,'Visible','off');
set(handles.updateBt,'Visible','off');
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EditSubject wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EditSubject_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in updateBt.
function updateBt_Callback(hObject, eventdata, handles)
% hObject    handle to updateBt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SubID
conn=database('myDB','','');
 tablename='Subject';colnames = {'ID', 'firstName', 'lastName', 'age','handedness','sex'};whereclause=['where ID = ' '' SubID ''];
firstName=get(handles.editFname,'String');lastName=get(handles.editLname,'String');age=get(handles.editAge,'String');handednessList=get(handles.editPopHand,'String');sexList=get(handles.editPopSex,'String');
    valHandednessList={get(handles.editPopHand,'value')};valsexList={get(handles.editPopSex,'value')};hand=handednessList{cell2mat(valHandednessList)};sex=sexList{cell2mat(valsexList)};
    data={str2num(SubID) firstName, lastName, str2num(age),hand,sex};
    
    update(conn,tablename,colnames,data,whereclause);
    msgbox('Subject Info successfully updated!');
    commit(conn);close(conn);


function editFname_Callback(hObject, eventdata, handles)
% hObject    handle to editFname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFname as text
%        str2double(get(hObject,'String')) returns contents of editFname as a double


% --- Executes during object creation, after setting all properties.
function editFname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editLname_Callback(hObject, eventdata, handles)
% hObject    handle to editLname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editLname as text
%        str2double(get(hObject,'String')) returns contents of editLname as a double


% --- Executes during object creation, after setting all properties.
function editLname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAge_Callback(hObject, eventdata, handles)
% hObject    handle to editAge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAge as text
%        str2double(get(hObject,'String')) returns contents of editAge as a double


% --- Executes during object creation, after setting all properties.
function editAge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in editPopHand.
function editPopHand_Callback(hObject, eventdata, handles)
% hObject    handle to editPopHand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns editPopHand contents as cell array
%        contents{get(hObject,'Value')} returns selected item from editPopHand


% --- Executes during object creation, after setting all properties.
function editPopHand_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPopHand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in editPopSex.
function editPopSex_Callback(hObject, eventdata, handles)
% hObject    handle to editPopSex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns editPopSex contents as cell array
%        contents{get(hObject,'Value')} returns selected item from editPopSex


% --- Executes during object creation, after setting all properties.
function editPopSex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPopSex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function subID_Callback(hObject, eventdata, handles)
% hObject    handle to subID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subID as text
%        str2double(get(hObject,'String')) returns contents of subID as a double


% --- Executes during object creation, after setting all properties.
function subID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in editBt.
function editBt_Callback(hObject, eventdata, handles)
% hObject    handle to editBt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SubID
SubID=get(handles.subID,'String');
if(length(SubID)~=0)
    conn=database('myDB','','');
    tablename='Subject';colnames = {'ID', 'firstName', 'lastName', 'age','handedness','sex'};whereclause=['where ID = ' '' SubID ''];
    fquery = ['select * from Subject where ID = ' '' SubID ''];
    curs = exec(conn,fquery);
    curs = fetch(curs);
    subInfo=curs.Data;
    
    set(handles.Name,'Visible','on');
    set(handles.Age,'Visible','on');
    set(handles.Handedness,'Visible','on');
    set(handles.Sex,'Visible','on');
    set(handles.updateBt,'Visible','on');
    
    set(handles.editFname,'Visible','on','String',subInfo{1,2});
    set(handles.editLname,'Visible','on','String',subInfo{1,3});
    set(handles.editAge,'Visible','on','String',num2str(subInfo{1,4}));
    if(strcmp(subInfo{1,5},'Left Handed')==1)
        val=1;
    else
        val=2;
    end
    set(handles.editPopHand,'Visible','on','value',val);
    if(strcmp(subInfo{1,6},'Male')==1)
        val=1;
    else
        val=2;
    end
    set(handles.editPopSex,'Visible','on','value',val);
    commit(conn)
    close(curs)
    close(conn)
    
end
    
