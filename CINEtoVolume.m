function varargout = CINEtoVolume(varargin)
% CINETOVOLUME MATLAB code for CINEtoVolume.fig
%      CINETOVOLUME, by itself, creates a new CINETOVOLUME or raises the existing
%      singleton*.
%
%      H = CINETOVOLUME returns the handle to a new CINETOVOLUME or the handle to
%      the existing singleton*.
%
%      CINETOVOLUME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CINETOVOLUME.M with the given input arguments.
%
%      CINETOVOLUME('Property','Value',...) creates a new CINETOVOLUME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CINEtoVolume_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CINEtoVolume_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CINEtoVolume

% Last Modified by GUIDE v2.5 13-Jun-2020 13:18:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CINEtoVolume_OpeningFcn, ...
                   'gui_OutputFcn',  @CINEtoVolume_OutputFcn, ...
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


% --- Executes just before CINEtoVolume is made visible.
function CINEtoVolume_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.systolebutton,'UserData',0);
set(handles.diastolebutton,'UserData',0);
set(handles.pushbutton1,'UserData',0);
% varargin   command line arguments to CINEtoVolume (see VARARGIN)
% Choose default command line output for CINEtoVolume
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CINEtoVolume wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CINEtoVolume_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
%allows user to select multiple dicoms from a folder of their choice

if isfield(handles,'path') == 1
    filterpath = append(handles.path,'*.dcm')
    [name,pathname]=uigetfile(filterpath,'Select a dicom...','MultiSelect','on');
else
    [name,pathname]=uigetfile('*.dcm','Select a dicom...','MultiSelect','on');
end

%returns if user presses cancel
if isequal(name, 0); return; end 

%turns into a cell
if ischar(name); name = {name}; end

    handles.path = pathname
    %Load all images into a cell array and store it in the handles structure
    handles.names = fullfile(pathname, name);
    
%     set(handles.axes2,'Units','pixels');
   
    
    %Reads all dicoms in the cell and stores it in another handle
    handles.dcmdata = cellfun(@dicomread,handles.names,'UniformOutput',0);
    
    %displays dicoms on axes, again assigned to another handle
    handles.dcm=imshow(handles.dcmdata{1},'DisplayRange',[])
    seriesnumber = get(hObject, 'UserData') + 1;
    set(hObject, 'UserData', seriesnumber)
    set(handles.text6,'String',num2str(seriesnumber));
    %saves guidata
    guidata(hObject, handles);
    set(handles.diastolebutton, 'BackgroundColor',[.941 .941 .941]);
    set(handles.systolebutton, 'BackgroundColor',[.941 .941 .941]);
    set(handles.slider1, 'Value', 1, 'Min', 1, 'Max', numel(handles.names), 'SliderStep', [1,1]./(numel(handles.names)-1));
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


  % --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = hObject.Value; %sets value of slider bar to val
val = round(val); % rounds value of val to nearest whole number
set(hObject,'Value',val); % sets value of slider to rounded whole number value
index= get(hObject, 'Value'); % creates index based on slider bar value
set(handles.dcm, 'CData', handles.dcmdata{index}); % sets image from the array to match value of slider bar
set(handles.text4,'String',num2str(index));
handles.index = index;
guidata(hObject,handles);


% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on button press in systolebutton.
function systolebutton_Callback(hObject, ~, handles)
% hObject    handle to systolebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cs = get(hObject, 'UserData') + 1; %adds 1 to the user data each time the systole button is pressed
x = get(handles.slider1,'Value'); %assigns value of slider to x to be used as an index
info = dicominfo(handles.names{x}); %assigns dicom metadata of current image to structure "info"
if isfield(handles, 'suid') == 0  %if statement checks if generate UID button has been pressed
    disp('Click the Generate Systole UID Button then try again.') % if it hasn't, this message is displayed in command window
else
info.SeriesInstanceUID = handles.suid; % if the button has been pressed, the generated UID is assigned to the field in the info structure
info.ImageOrientationPatient = [1 0 0 0 1 0]';
originalspace = handles.base - info.ImagePositionPatient(3);
info.ImagePositionPatient(3) = handles.base + originalspace;
end
strs2 = get(handles.PatientNumber,'String'); % assigns value from patient number text box to strs2 as a string
if isempty(strs2); % if statement checks for a value in strs2
    disp('Enter a patient number and try again.') % if no value is found, this message is displayed in the command window
    cs = 0; %resets count to 0 so numbers in file names are not messed up by incorrect button pushes
else
    strs2 = strs2; % if there is a value, then strs2 remains the same
end
strs1 = 'p'; % assigns strings to variables to be used in nameing the new dicom file
strs2; 
strs3 = 'systole';
strs4 = num2str(cs);
strs5 = '.dcm';
strs6 = '-(';
strs7 = num2str(handles.index);
strs8 = ')';
strs = append(strs1,strs2,strs3,strs4,strs6,strs7,strs8,strs5); % puts strings together for new dicom file name and stores it as strs
if isfield(handles, 'systolefolder') == 0
    disp('Select a folder for systole output and try again')
    cs = 0;
else
    filename = fullfile(handles.systolefolder,strs);
    dicomwrite(handles.dcmdata{x},filename,info); % Writes a new dicom file with the current image, the name in strs, and the metadata in info
    disp('Image was successfully written to systole stack')
end
set(hObject, 'UserData', cs) % Sets user data to value of cs to keep track of the number of times the button is pushed
set(handles.systolebutton, 'BackgroundColor','r');




% --- Executes on button press in diastolebutton. This works the same as
% the systole button
function diastolebutton_Callback(hObject, eventdata, handles)
% hObject    handle to diastolebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cd = get(hObject, 'UserData') + 1;
x = get(handles.slider1,'Value');
info = dicominfo(handles.names{x});
if isfield(handles, 'duid') == 0
    disp('Click the Generate Diastole UID button and try again.')
else   
info.SeriesInstanceUID = handles.duid;
info.ImageOrientationPatient = [1 0 0 0 1 0]';
originalspace = handles.base - info.ImagePositionPatient(3);
info.ImagePositionPatient(3) = handles.base + originalspace;
end
strd2 = get(handles.PatientNumber,'String');
if isempty(strd2)
    disp('Enter a patient number and try again.')
    cd = 0;
else
    strd2 = strd2;
end
strd1 = 'p';
strd2; 
strd3 = 'diastole';
strd4 = num2str(cd);
strd5 = '.dcm';
strd6 = '-(';
strd7 = num2str(handles.index);
strd8 = ')';
strd = append(strd1,strd2,strd3,strd4,strd6,strd7,strd8,strd5);
if isfield(handles, 'diastolefolder') == 0
    disp('Select a folder for diastole output and try again')
    cd = 0;
else
filename = fullfile(handles.diastolefolder,strd);
dicomwrite(handles.dcmdata{x},filename,info);
disp('Image was successfully written to diastole stack')
end
set(hObject, 'UserData', cd)
set(handles.diastolebutton, 'BackgroundColor','r');




% --- Executes on button press in newpatient. 
function newpatient_Callback(hObject, ~, handles)
% hObject    handle to newpatient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.suid = dicomuid %generates a new dicom UID and displays it in the command window, saving it to the suid field
handles.duid = dicomuid
guidata(hObject,handles); %saves new UID to be used in other UI controls
set(handles.systolebutton,'UserData',0); % Sets userdata of the systole button to 0, so that the numbering scheme will stay the same when the user starts a new stack
set(handles.diastolebutton,'UserData',0);
set(handles.pushbutton1,'UserData',0);
set(handles.PatientNumber, 'String','');
set(handles.outputfolders,'BackgroundColor','g');
set(handles.BaseSet,'BackgroundColor','g');

% --- Executes on button press in DiastoleUID. This button works the same
% as the newpatient button 

% function DiastoleUID_Callback(hObject, eventdata, handles)
% % hObject    handle to DiastoleUID (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% handles.duid = dicomuid
% guidata(hObject,handles);
% set(handles.diastolebutton,'UserData',0);
% set(handles.pushbutton1,'UserData',0);



function PatientNumber_Callback(hObject, eventdata, handles)
% hObject    handle to PatientNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PatientNumber as text
%        str2double(get(hObject,'String')) returns contents of PatientNumber as a double


% --- Executes during object creation, after setting all properties.
function PatientNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PatientNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes on button press in outputfolders.
function outputfolders_Callback(hObject, eventdata, handles)
% hObject    handle to outputfolders (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.systolefolder = uigetdir('','Select systole output folder');
handles.diastolefolder = uigetdir('', 'Select diastole output folder');
set(handles.outputfolders,'BackgroundColor','r');
guidata(hObject,handles);


% --- Executes on button press in diafolder.
% function diafolder_Callback(hObject, eventdata, handles)
% % hObject    handle to diafolder (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% handles.diastolefolder = uigetdir();
% guidata(hObject,handles);


% --- Executes on button press in BaseSet.
function BaseSet_Callback(hObject, eventdata, handles)
% hObject    handle to BaseSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x = get(handles.slider1,'Value');
info = dicominfo(handles.names{x});
handles.base = info.ImagePositionPatient(3);
set(handles.BaseSet,'BackgroundColor','r');
guidata(hObject,handles);
