function varargout = FeedBack(varargin)
% FEEDBACK MATLAB code for FeedBack.fig
%      FEEDBACK, by itself, creates a new FEEDBACK or raises the existing
%      singleton*.
%
%      H = FEEDBACK returns the handle to a new FEEDBACK or the handle to
%      the existing singleton*.
%
%      FEEDBACK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FEEDBACK.M with the given input arguments.
%
%      FEEDBACK('Property','Value',...) creates a new FEEDBACK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FeedBack_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FeedBack_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FeedBack

% Last Modified by GUIDE v2.5 29-Apr-2016 03:37:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FeedBack_OpeningFcn, ...
                   'gui_OutputFcn',  @FeedBack_OutputFcn, ...
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


% --- Executes just before FeedBack is made visible.
function FeedBack_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FeedBack (see VARARGIN)

% Choose default command line output for FeedBack
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FeedBack wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FeedBack_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Planning.
function Planning_Callback(hObject, eventdata, handles)
% hObject    handle to Planning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Planning



function subName_Callback(hObject, eventdata, handles)
% hObject    handle to subName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subName as text
%        str2double(get(hObject,'String')) returns contents of subName as a double


% --- Executes during object creation, after setting all properties.
function subName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subName (see GCBO)
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SubjectName=get(handles.subName,'String');
Planning=get(handles.Planning,'Value');
Propreoception=get(handles.Proprioception,'Value');
RunMenu=get(handles.popupmenu1,'String');
RunVal=get(handles.popupmenu1,'Value');
Run=str2num(RunMenu{RunVal});


addpath(genpath('functions'));addpath(genpath('C:\Program Files\gtec\'));
src_path='C:\Users\Administrator\Desktop\GUI_MaltabFinal3\DataBase_UU_March2016\';
nofTrials=40;initDelay=30;iti_Min=2;iti_Max=3;trialLength=8;cueAppear=3;nofClasses=2;sampRate=512;
[trig_signal,label_signal,trialStartIndexes, trialEndIndexes,classLabels]=genTrig_n_Label_mod(nofTrials,initDelay,iti_Min,iti_Max,sampRate,trialLength,cueAppear,nofClasses);
trig_signal=trig_signal'; %Triggers Series
label_signal=label_signal';  %Label Series
tmStamps=[0:1/sampRate:length(trig_signal)/sampRate-1/sampRate]'; % Time line

simTime=round(max(tmStamps));

load([src_path 'TrainingAnalysisReport' num2str(Planning) '0' SubjectName '.mat']);
hardwareConn=Propreoception;
load('movingFeed.mat');




sim('FeedBackParadigmPlanProp_discrete_Online','StopTime',num2str(simTime),'SrcWorkspace','current');
%     load('singleTrialFeat.mat');
   
      load('featClassStoreOnline.mat');
      load('ContClassifierOutput');

%     
      load('FeedBackData.mat');  
      eval(['FeedBackData' num2str(Planning) num2str(Propreoception) '_' SubjectName  num2str(Run) '=FeedBackData;']);

      save([src_path 'FeedBackDataBase' num2str(Planning) num2str(Propreoception) '_' SubjectName num2str(Run) '.mat'],'tmStamps','nofTrials','sampRate','trialLength','cueAppear', 'trig_signal','label_signal','trialStartIndexes', 'trialEndIndexes','classLabels',['FeedBackData' num2str(Planning) num2str(Propreoception) '_' SubjectName num2str(Run)],'featClassStoreOnline','ContClassifierOutput');

msgbox('FeedBack Completed!');


% --- Executes on button press in Propreoception.
function Proprioception_Callback(hObject, eventdata, handles)
% hObject    handle to Propreoception (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Propreoception
