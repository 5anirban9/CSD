function varargout = Main(varargin)
% MAIN MATLAB code for Main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Main

% Last Modified by GUIDE v2.5 29-Apr-2016 03:50:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_OutputFcn, ...
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


% --- Executes just before Main is made visible.
function Main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Main (see VARARGIN)

% Choose default command line output for Main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Subject_Callback(hObject, eventdata, handles)
% hObject    handle to Subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Add_Subject_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalin('base', 'addSubject');


% --------------------------------------------------------------------
function strat_Exp_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to strat_Exp_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function startExp_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to startExp_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function stratParam_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to stratParam_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
openfig('startParam.fig','reuse');


% --------------------------------------------------------------------
function viewSubjectMenu_Callback(hObject, eventdata, handles)
% hObject    handle to viewSubjectMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Data;
conn=database('myDB','','')
fquery = 'select * from Subject';
curs = exec(conn,fquery);
curs = fetch(curs);
curs.Data
d=curs.Data;
 cnames = {'ID','First Name','Last Name','Age','Handedness','Sex'};
% f = figure('Name','List of Subjects');
% t = uitable(f,'Data',d,'ColumnName',cnames,'Position',[10 200 900 200]);


f = figure('Position', [100 100 752 250],'Name','List of Subjects');
t = uitable('Parent', f, 'Position', [25 50 700 200], 'Data', d,'ColumnName',cnames);
close(curs)
close(conn)
% openfig('viewSubjectMenu.fig','reuse');


% --------------------------------------------------------------------
function viewPara_Callback(hObject, eventdata, handles)
% hObject    handle to viewPara (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Data;
conn=database('myDB','','')
fquery = 'select * from setExpPara';
curs = exec(conn,fquery);
curs = fetch(curs);
curs.Data
d=curs.Data;
cnames = {'ID','nofTrials', 'initDelay', 'iti_Min', 'iti_Max', 'trialLength', 'cueAppear', 'nofClasses', 'sampRate'};
f = figure('Name','Subject Info');
t = uitable(f,'Data',d,'ColumnName',cnames,'Position',[10 200 900 200]);
close(curs)
close(conn)


% --------------------------------------------------------------------
function startTrainingMenu_Callback(hObject, eventdata, handles)
% hObject    handle to startTrainingMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% openfig('startTraining.fig','reuse');
evalin('base','startTraining');

% --------------------------------------------------------------------
function analyseDataMenu_Callback(hObject, eventdata, handles)
% hObject    handle to analyseDataMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% openfig('dataAnalysis.fig','reuse');


% --------------------------------------------------------------------
function analyseTrainingDataMenu_Callback(hObject, eventdata, handles)
% hObject    handle to analyseTrainingDataMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
openfig('analyseTrainingDdata.fig','reuse');


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function startEvalMenu_Callback(hObject, eventdata, handles)
% hObject    handle to startEvalMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
openfig('startEvaluation.fig','reuse');


% --------------------------------------------------------------------
function EditSubject_Callback(hObject, eventdata, handles)
% hObject    handle to EditSubject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalin('base', 'EditSubject');
% openfig('EditSubject.fig','reuse');



% --------------------------------------------------------------------
function DeleteSubject_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteSubject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalin('base', 'DeleteSubject');


% --------------------------------------------------------------------
function Training_Callback(hObject, eventdata, handles)
% hObject    handle to Training (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalin('base', 'Training');


% --------------------------------------------------------------------
function Analysis_Callback(hObject, eventdata, handles)
% hObject    handle to Analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalin('base', 'Analysis');

% --------------------------------------------------------------------
function FeedBack_Callback(hObject, eventdata, handles)
% hObject    handle to FeedBack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalin('base', 'FeedBack');
