function varargout = addSubject(varargin)
% ADDSUBJECT MATLAB code for addSubject.fig
%      ADDSUBJECT, by itself, creates a new ADDSUBJECT or raises the existing
%      singleton*.
%
%      H = ADDSUBJECT returns the handle to a new ADDSUBJECT or the handle to
%      the existing singleton*.
%
%      ADDSUBJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADDSUBJECT.M with the given input arguments.
%
%      ADDSUBJECT('Property','Value',...) creates a new ADDSUBJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before addSubject_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to addSubject_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help addSubject

% Last Modified by GUIDE v2.5 16-Jan-2016 14:56:51

% Begin initialization code - DO NOT EDIT
global firstName lastNamea age hand handedness sex;
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @addSubject_OpeningFcn, ...
                   'gui_OutputFcn',  @addSubject_OutputFcn, ...
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


% --- Executes just before addSubject is made visible.
function addSubject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to addSubject (see VARARGIN)

% Choose default command line output for addSubject
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes addSubject wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = addSubject_OutputFcn(hObject, eventdata, handles) 
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
global firstName
firstName=get(hObject,'String');

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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global age
age=get(hObject,'String');

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
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
% display(get(hobject.edit1,'string'));
global ID firstName lastName age hand sex;
display({firstName, lastName, age,hand,sex});

% Add Data to Database
conn=database('myDB','','')
fquery = 'select last(ID) from Subject';
curs = exec(conn,fquery);
curs = fetch(curs);
curs.Data
prevID=cell2mat(curs.Data);
if(isnan(prevID)==1)
    ID=1;
else
    ID=prevID+1;
end
tablename = 'Subject';
colnames = {'ID', 'firstName', 'lastName', 'age','handedness','sex'};

firstName=get(handles.edit1,'String');
lastName=get(handles.edit5,'String');
age=get(handles.edit2,'String');
handednessList=get(handles.popupmenu1,'String');sexList=get(handles.sex,'String');
valHandednessList={get(handles.popupmenu1,'value')};valsexList={get(handles.sex,'value')};hand=handednessList{cell2mat(valHandednessList)};sex=sexList{cell2mat(valsexList)};

data={ID firstName, lastName, str2num(age),hand,sex};
data_table=cell2table(data,'VariableNames',colnames);
% load('SubjectInfo.mat');
% if(size(SubjectInfo,1)==1 && SubjectInfo{1,1}==-1)
%     SubjectInfo=data;
% else
%     SubjectInfo=[SubjectInfo;data];
% end
% Subject=cell2table(SubjectInfo,'VariableNames',colnames);
% save('SubjectInfo.mat','SubjectInfo');

fastinsert(conn,tablename,colnames,data_table)
%%%%%EXP Param%%%%%%%%%%%
% tablename = 'setExpPara';
% colnames = {'ID','nofTrials', 'initDelay', 'iti_Min', 'iti_Max', 'trialLength', 'cueAppear', 'nofClasses', 'sampRate'};
% data={ID,40, 30, 2, 3, 8, 3, 2, 512};
% data_table=cell2table(data,'VariableNames',colnames);
% fastinsert(conn,tablename,colnames,data_table);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
commit(conn)
sqlquery = ['select last(ID) from Subject'];
curs = exec(conn,sqlquery);
curs = fetch(curs);
curs.Data
yourID=cell2mat(curs.Data);
msgbox(['Your User ID is :' num2str(yourID)]);
close(curs)
close(conn)

% uisave({'firstName', 'lastName', 'age','hand','sex'},'var.mat');
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global lastName
lastName=get(hObject,'String');


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


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hand handedness
handedness=get(hObject,'String');
index_selected = get(hObject,'Value');
hand = handedness{index_selected};
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sex
sex=get(hObject,'String');
index_selected = get(hObject,'Value');
sex = sex{index_selected};
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function add_Subject_menu_Callback(hObject, eventdata, handles)
% hObject    handle to add_Subject_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Subject_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Subject_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Add_Subject_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Subject_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in sex.
function sex_Callback(hObject, eventdata, handles)
% hObject    handle to sex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sex contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sex


% --- Executes during object creation, after setting all properties.
function sex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
