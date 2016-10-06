% need to make it so that it can chage angle 90 degrees
% load in both orientations and then depending on the vlaue of a toggle
% switch either display one or the other
%
% have a button which sets the value for the orientation
%
% reading in the 


function extension_1(movie_filename)

movie_data             =   get_movie_data(movie_filename) ;
movie_data

length(movie_data{1})
size(movie_data{1})

threshold_val          =   0.6                            ;
frame_to_view          =   1                              ;
min_detection_size     =   500                            ;
max_circ_tol           =   20                             ;
show_detected_objects  =   0                              ;

x_ord_choices          =   {'time (s)'};
y_ord_choices          =   {'strain(%)','marker sizes(pix)','marker circularities(%)','marker positions (pix)','marker distance (pix)'};
x_ord_choice           =   1;
y_ord_choice           =   1;

orientation_choice     =   1;   %      1 = standard orientation ,  2 = rotated orientation     

handles.fig_handle = figure('units','normalized','outerposition',[0 0 0.8 0.8],'UserData',struct('movie_data', movie_data ,'frame_to_view',frame_to_view,'threshold_val',0.6 , 'min_detection_size' , min_detection_size,...
'show_detected_objects',show_detected_objects,'detected_object_properties',NaN,'pixels_per_mm',NaN,'Calibration_type',1,'whole_test_values',NaN,'max_circ_tol',max_circ_tol,'test_format',1,'CH_speed_mm_min',NaN,... 
'x_ord_choices',{x_ord_choices} ,'y_ord_choices' ,{y_ord_choices},'x_ord_choice',x_ord_choice,'y_ord_choice',y_ord_choice,'orientation_choice',orientation_choice));  

handles.slider_handle_1   = uicontrol('Style','slider','Min',0,'Max',1,'Value',threshold_val,'units','normalized','Position' ,  [0.02 0.85 0.1 0.03],  'Callback' , @slider_func_1)  ; 
set(handles.slider_handle_1,'BusyAction','cancel')
handles.slider_handle_1_txt = uicontrol('Style','text','units','normalized','FontSize',12,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.02,0.88,0.1,0.03],'String',['Threshold = ',num2str(threshold_val)]);

disp('HERE1')

handles.slider_handle_2   = uicontrol('Style','slider','Min',1,'Max',length(movie_data{orientation_choice}),'Value',frame_to_view,'units','normalized','Position' ,  [0.02 0.79 0.1 0.03],  'Callback' , @slider_func_2)  ; 
set(handles.slider_handle_2,'BusyAction','cancel')
handles.slider_handle_2_txt = uicontrol('Style','text','units','normalized','FontSize',12,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.02,0.82,0.1,0.03],'String',['Frame = ',num2str(frame_to_view)]);

disp('HERE2')

handles.slider_handle_3   = uicontrol('Style','slider','Min',1,'Max',2000,'Value',min_detection_size ,'units','normalized','Position' ,  [0.47 0.87 0.1 0.03],  'Callback' , @slider_func_3)  ; 
handles.slider_handle_3_txt = uicontrol('Style','text','units','normalized','FontSize',12,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.46,0.9,0.12,0.03],'String',['Min Det. size = ',num2str(min_detection_size),' pixels']);

disp('HERE3')

handles.slider_handle_4   = uicontrol('Style','slider','Min',1,'Max',50,'Value',max_circ_tol ,'units','normalized','Position' ,  [0.47 0.77 0.1 0.03],  'Callback' , @slider_func_4)  ; 
handles.slider_handle_4_txt = uicontrol('Style','text','units','normalized','FontSize',12,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.46,0.8,0.12,0.03],'String',['Max circ. tol = ',num2str(max_circ_tol),'%.']);

disp('HERE4')

handles.combo_box_2 = uicontrol('Style', 'popup','FontSize',10,'String', {'Two Markers','Three Markers'},'units','normalized', 'Position', [0.02,0.71,0.1,0.05],'Callback' , @select_test_format); % select the x odinate
handles.combo_box_2_txt = uicontrol('Style','text','units','normalized','FontSize',12,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.01 0.76 0.12 0.03],'String','Test format');

handles.but_func_3 =  uicontrol('Style', 'pushbutton', 'String', 'Set Crosshead Speed','units','normalized', 'Position', [0.02,0.68,0.1,0.035 ] ,'Callback' , @set_crossead_speed); % select point on dispersion curve       
handles.but_func_3_txt  = uicontrol('Style','text','units','normalized','FontSize',10,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.02 0.65 0.13 0.03]  ,'String','Not set', 'visible', 'on');

handles.checkbox_2      =  uicontrol('Style', 'checkbox', 'String', 'Orientation','units','normalized','BackgroundColor',[0.8,0.8,0.8], 'Position', [0.02,0.96,0.1,0.035 ],'FontSize',12,'Callback' , @set_orientation); % select point on dispersion curve       
handles.checkbox_2_txt  =  uicontrol('Style','text','units','normalized','FontSize',10,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.02 0.92 0.13 0.03]  ,'String','(Normal)', 'visible', 'on');

%------------------------------------------------------------------
% plot results  button
handles.but_func_4 =  uicontrol('Style', 'togglebutton','units','normalized','String', 'Plot results','BackgroundColor',[0.8,0.8,0.8], 'Position', [0.02,0.25,0.075,0.035], 'visible', 'off' ,'Callback' , @plot_results); % select point on dispersion curve       

% select x ordinate
% time cross / head position (if ch speed set)
handles.combo_box_3 = uicontrol('Style', 'popup','FontSize',10,'String', x_ord_choices ,'units','normalized', 'Position', [0.02,0.17,0.13,0.05],'Callback' , @select_x_ordinate,'visible', 'off','Value',x_ord_choice); % select the x odinate
handles.combo_box_3_txt = uicontrol('Style','text','units','normalized','FontSize',12,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.01 0.22 0.12 0.03],'String','Select X ordinate', 'visible', 'off');

% select y ordinate
% two makers seperately / strain / distance between markers
handles.combo_box_4 = uicontrol('Style', 'popup','FontSize',10,'String', y_ord_choices ,'units','normalized', 'Position', [0.02,0.08,0.13,0.05],'Callback' , @select_y_ordinate,'visible', 'off','Value',y_ord_choice); % select the x odinate
handles.combo_box_4_txt = uicontrol('Style','text','units','normalized','FontSize',12,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.01 0.13 0.12 0.03],'String','Select Y ordinate', 'visible', 'off');
%------------------------------------------------------------------

handles.checkbox_1 =  uicontrol('Style', 'checkbox','String','Show Det Objects','units','normalized'  ,'Position' , [0.47 0.73 0.12 0.03],'FontSize',12, 'BackgroundColor',[0.8,0.8,0.8]  ,'Callback' , @checkbox_func_1) ; % switch on and off the animation of a selected mode
handles.checkbox_1_txt  = uicontrol('Style','text','units','normalized','FontSize',10,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.47 0.69 0.12 0.03]  ,'String',['Num Det Objects = OFF'], 'visible', 'off');
handles.checkbox_1_info = uicontrol('Style','text','units','normalized','FontSize',8,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.47 0.53 0.12 0.15]   ,'String',{'Objec Stats:','None set'}, 'visible', 'off');

handles.combo_box_1 = uicontrol('Style', 'popup','FontSize',10,'String', {'None','Two Points','Two Markers','Direct Input'},'units','normalized', 'Position', [0.02,0.55,0.1,0.05],'Callback' , @select_calibration_type); % select the x odinate
handles.combo_box_1_txt = uicontrol('Style','text','units','normalized','FontSize',12,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.01 0.60 0.12 0.03],'String','Calibration Type');

handles.but_func_1 =  uicontrol('Style', 'pushbutton', 'String', 'Set ','units','normalized', 'Position', [0.02,0.52,0.07,0.035 ] ,'Callback' , @choose_cal_point); % select point on dispersion curve       
handles.but_func_1_txt = uicontrol('Style','text','units','normalized','FontSize',12,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.01 0.48 0.16 0.03],'String','pixels per mm = not set');

handles.but_func_2  =  uicontrol('Style', 'pushbutton','String','Calc test vals','units','normalized'  ,'Position' , [0.02 0.40 0.07 0.035], 'BackgroundColor',[0.8,0.8,0.8]  ,'Callback' , @but_func_2) ; % switch on and off the animation of a selected mode
handles.but_func_2_txt  = uicontrol('Style','text','units','normalized','FontSize',10,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.02 0.31 0.17 0.09]  ,'String',['Not calculated'], 'visible', 'on');

handles.plot_handle = NaN;
handles.plot_legend = NaN;

% --------------------------------------
%  Have a figure with optional plots
% --------------------------------------
%  x - ordinate
%  y - ordinate 
% --------------------------------------
fig_setup(handles,orientation_choice);                           
end %function extension_1( )

%---------------------------------------------------------------------------------------------------------
% need a calculate crosshead position function 
% put in a new 
%---------------------------------------------------------------------------------------------------------

function plot_data_structure = calculate_crosshead_position(plot_data_structure)

% look at the strain and work out when the it becomes non zero
% strain should be calculated during initial steeings

time_ = plot_data_structure.whole_test_values.results_matrix(:,1)  ;

plot_data_structure.whole_test_values.results_matrix(:,1);

start_index = min(find((diff(plot_data_structure.whole_test_values.marker_strain)/mean(diff(plot_data_structure.whole_test_values.marker_strain)))>0.05))     ;
end_index   = max(find((diff(plot_data_structure.whole_test_values.marker_strain)/mean(diff(plot_data_structure.whole_test_values.marker_strain)))>0.05)) +1  ;

% now make the crosshead zeros before and after the   //   start and end

initial_bit                                              =   zeros(start_index-1,1);
moving_bit                                               =   (time_(start_index:end_index) - time_(start_index)) *  plot_data_structure.whole_test_values.CH_speed_mm_min/60;
end_bit                                                  =   ones(length(plot_data_structure.whole_test_values.results_matrix(:,1))-(end_index),1)*moving_bit(length(moving_bit));
plot_data_structure.whole_test_values.crosshead_position =   [initial_bit ; moving_bit ; end_bit];


end %function plot_data_structure = calculate_crosshead_position(plot_data_structure)

function select_x_ordinate (hObject, ~)
new_value =  get(hObject,'Value');  
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');
plot_data_structure.x_ord_choice = new_value;
plot_data_structure = set_ordinates(plot_data_structure);

if(get(plot_data_structure.handles.but_func_4,'Value'))
plot_data_structure = plot_values(plot_data_structure);
end %if(get(plot_data_structure.handles.but_func_4,'Value'))

set(get(hObject,'Parent'),'UserData',plot_data_structure);
end

function select_y_ordinate (hObject, ~)
new_value =  get(hObject,'Value');  
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');
plot_data_structure.y_ord_choice = new_value;
plot_data_structure = set_ordinates(plot_data_structure);
if(get(plot_data_structure.handles.but_func_4,'Value') )
plot_data_structure = plot_values(plot_data_structure);
end %if(get(plot_data_structure.handles.but_func_4,'Value') )
set(get(hObject,'Parent'),'UserData',plot_data_structure);
end

function plot_results (hObject, ~)

plot_data_structure  =  get(get(hObject,'Parent'),'UserData');

if(get(hObject,'Value')); 
    
set(plot_data_structure.handles.axis_3,'Visible','on')

plot_data_structure = set_ordinates(plot_data_structure);
plot_data_structure = plot_values(plot_data_structure);

else
set(plot_data_structure.handles.axis_3,'Visible','off')
plot_data_structure = remove_plot_stuff(plot_data_structure);

end 

%  detemine the choices that have been selected
%  set he limits and then plot the vallues
%  disp([x_ord_txt,',',y_ord_txt]) 

set(get(hObject,'Parent'),'UserData',plot_data_structure);
end %function plot_results (hObject, ~)

function plot_data_structure = remove_plot_stuff(plot_data_structure)

if  ~isnan(plot_data_structure.handles.plot_handle)
delete(plot_data_structure.handles.plot_handle)    
plot_data_structure.handles.plot_handle = NaN;
end    % if  ~isnan(plot_data_structure.handles.plot_handle)

if  ~isnan(plot_data_structure.handles.plot_legend)
delete(plot_data_structure.handles.plot_legend)
plot_data_structure.handles.plot_legend = NaN;
end    % if  ~isnan(plot_data_structure.handles.plot_legend)

end

function plot_data_structure = set_ordinates(plot_data_structure)
axes(plot_data_structure.handles.axis_3)

x_ord_txt =  plot_data_structure.x_ord_choices{plot_data_structure.x_ord_choice} ;
y_ord_txt =  plot_data_structure.y_ord_choices{plot_data_structure.y_ord_choice} ;

xlabel(x_ord_txt)
ylabel(y_ord_txt)
end

function plot_data_structure = plot_values(plot_data_structure)
all_x_options  =   {'time (s)','crosshead position (mm)'} ;
all_y_options  =   {'strain(%)','marker sizes(pix)','marker circularities(%)','marker positions (mm)','marker distance (mm)','marker positions (pix)','marker distance (pix)'} ;
x_ord_txt =  plot_data_structure.x_ord_choices{plot_data_structure.x_ord_choice} ;
y_ord_txt =  plot_data_structure.y_ord_choices{plot_data_structure.y_ord_choice} ;

axes(plot_data_structure.handles.axis_3)
plot_data_structure = remove_plot_stuff(plot_data_structure);

hold on
x_index = strmatch(x_ord_txt,all_x_options,'exact');
y_index = strmatch(y_ord_txt,all_y_options,'exact');

switch(x_index)

    
    case(1)    %'time (s)'
data_x = plot_data_structure.whole_test_values.results_matrix(:,1);
    case(2)    %'crosshead position'
data_x = plot_data_structure.whole_test_values.crosshead_position;

end %switch(x_index)

switch(y_index)
    
    case(1) % 'strain(%)'
data_y = plot_data_structure.whole_test_values.marker_strain;

%(((plot_data_structure.whole_test_values.results_matrix(:,5)-plot_data_structure.whole_test_values.results_matrix(:,2))-...
%(plot_data_structure.whole_test_values.results_matrix(1,5)-plot_data_structure.whole_test_values.results_matrix(1,2)))/...
%(plot_data_structure.whole_test_values.results_matrix(1,5)-plot_data_structure.whole_test_values.results_matrix(1,2)) )  *100;

% diff(data_y)/mean(diff(data_y))

plot_data_structure.handles.plot_handle = plot(data_x,data_y,'.');

xlim([min(data_x) max(data_x)])
ylim([min(data_y) max(data_y)])


    case(2) % 'marker sizes(pix)'
        
for index = 1: plot_data_structure.whole_test_values.correct_number_of_objects
data_xm(:,index) = data_x;   
data_y(:,index)  = plot_data_structure.whole_test_values.results_matrix(:,index*3);

leg_text{index} = ['Marker ',num2str(index)];
end %for index = 1: whole_test_values.correct_number_of_objects

plot_data_structure.handles.plot_handle = plot(data_xm,data_y ,'-+');

xlim([min(data_x) max(data_x)])
ylim([plot_data_structure.min_detection_size max(max(data_y))])

plot_data_structure.handles.plot_legend = legend(leg_text,'location','EastOutside');
        
    case(3) % 'marker circularities(%)'
for index = 1: plot_data_structure.whole_test_values.correct_number_of_objects
data_xm(:,index) = data_x;   
data_y(:,index)  = plot_data_structure.whole_test_values.results_matrix(:,index*3+1);

leg_text{index} = ['Marker ',num2str(index)];
end %for index = 1: whole_test_values.correct_number_of_objects

plot_data_structure.handles.plot_handle = plot(data_xm,data_y ,'-+');
xlim([min(data_x) max(data_x)])
%ylim([min(min(data_y)) max(max(data_y))])
ylim([100-plot_data_structure.max_circ_tol 100+plot_data_structure.max_circ_tol])

    case(4) % 'marker positions (mm)'
for index = 1: plot_data_structure.whole_test_values.correct_number_of_objects
data_xm(:,index) = data_x;   
data_y(:,index)  = plot_data_structure.whole_test_values.results_matrix(:,index*3-1) / plot_data_structure.whole_test_values.pixels_per_mm;
leg_text{index} = ['Marker ',num2str(index)];
end %for index = 1: whole_test_values.correct_number_of_objects

plot_data_structure.handles.plot_handle = plot(data_xm,data_y ,'+');

xlim([min(data_x) max(data_x)])
ylim([min(min(data_y)) max(max(data_y))])

plot_data_structure.handles.plot_legend = legend(leg_text,'location','EastOutside');
       
        
    case(5) % 'marker distance (mm)',
 data_y = (plot_data_structure.whole_test_values.results_matrix(:,5)-plot_data_structure.whole_test_values.results_matrix(:,2))/plot_data_structure.whole_test_values.pixels_per_mm;

plot_data_structure.handles.plot_handle = plot(data_x,data_y,'.');

xlim([min(data_x) max(data_x)])
ylim([min(data_y) max(data_y)])
        
    case(6) % 'marker positions (pix)'
        
for index = 1: plot_data_structure.whole_test_values.correct_number_of_objects
data_xm(:,index) = data_x;   
data_y(:,index)  = plot_data_structure.whole_test_values.results_matrix(:,index*3-1);

leg_text{index} = ['Marker ',num2str(index)];
end %for index = 1: whole_test_values.correct_number_of_objects

plot_data_structure.handles.plot_handle = plot(data_xm,data_y ,'+');
xlim([min(data_x) max(data_x)])
ylim([min(min(data_y)) max(max(data_y))])

plot_data_structure.handles.plot_legend = legend(leg_text,'location','EastOutside');

    case(7) % 'marker distance (pix)'    
data_y = (plot_data_structure.whole_test_values.results_matrix(:,5)-plot_data_structure.whole_test_values.results_matrix(:,2));

plot_data_structure.handles.plot_handle = plot(data_x,data_y,'.');

xlim([min(data_x) max(data_x)])
ylim([min(data_y) max(data_y)])

end % switch

end %function plot_data_structure = plot_values(plot_data_structure);

function plot_data_structure = set_ordinate_choices(plot_data_structure)

x_ord_choices          =   {'time (s)'}  ;
y_ord_choices          =   {'strain(%)','marker sizes(pix)','marker circularities(%)'};

if ~isnan(plot_data_structure.CH_speed_mm_min)
x_ord_choices{length(x_ord_choices)+1} = 'crosshead position (mm)';    
end %if ~isnan(plot_data_structure.CH_speed_mm_min)

if ~isnan(plot_data_structure.pixels_per_mm)
y_ord_choices{length(y_ord_choices)+1} = 'marker positions (mm)';        
y_ord_choices{length(y_ord_choices)+1} = 'marker distance (mm)';        
else
y_ord_choices{length(y_ord_choices)+1} = 'marker positions (pix)';        
y_ord_choices{length(y_ord_choices)+1} = 'marker distance (pix)';        
end %if ~isnan(plot_data_structure.pixels_per_mm)

set(plot_data_structure.handles.combo_box_3,'String',x_ord_choices)
set(plot_data_structure.handles.combo_box_4,'String',y_ord_choices)

plot_data_structure.y_ord_choices = y_ord_choices;
plot_data_structure.x_ord_choices = x_ord_choices;

end %function plot_data_structure = set_ordinate_choices(plot_data_structure)

function select_test_format (hObject, ~)
new_value =  get(hObject,'Value');  % doesnt matter as this is just a toggle switch
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');
plot_data_structure.test_format = new_value;
if new_value ==2
msgbox('The three marker format is not written yet')
end %if new_value ==2
set(get(hObject,'Parent'),'UserData',plot_data_structure);
end %function select_test_format (hObject, ~)

function set_crossead_speed (hObject, ~)
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');

answers = inputdlg('Input the crosshead speed (mm/min)');
if length(answers) == 1
temp_answer = str2num(answers{1});
if length(temp_answer)~=0
if temp_answer > 0
plot_data_structure.CH_speed_mm_min = temp_answer;
end
end
end

if isnan(plot_data_structure.CH_speed_mm_min) 
set (plot_data_structure.handles.but_func_3_txt,'String','Not set')
plot_data_structure = set_ordinate_choices(plot_data_structure);
else
set (plot_data_structure.handles.but_func_3_txt,'String',['CH speed = ',num2str(plot_data_structure.CH_speed_mm_min),' mm/min.'])    
plot_data_structure = set_ordinate_choices(plot_data_structure);
end %if isnan(plot_data_structure.CH_speed_mm_min)

if isstruct(plot_data_structure.whole_test_values)
plot_data_structure.whole_test_values.CH_speed_mm_min = plot_data_structure.CH_speed_mm_min;
if ~isnan(plot_data_structure.whole_test_values.CH_speed_mm_min)
plot_data_structure                         = calculate_crosshead_position(plot_data_structure)  ;
end
end

set(get(hObject,'Parent'),'UserData',plot_data_structure);
end

function slider_func_4 (hObject, ~)

new_value =  get(hObject,'Value');
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');

plot_data_structure.max_circ_tol  = round(new_value);

set(plot_data_structure.handles.slider_handle_4_txt,'String',['Max circ. tol = ',num2str(plot_data_structure.max_circ_tol),'%.'])

plot_data_structure = reset_test_vals(plot_data_structure);

plot_data_structure =  display_binary_image(plot_data_structure);


set(get(hObject,'Parent'),'UserData',plot_data_structure);
end % function slider_func_mag (hObject, ~) 

function but_func_2(hObject, ~)
% reset this if threshold or
% dont recalculate values unless there is a change-  check for this
new_value =  get(hObject,'Value');  % doesnt matter as this is just a toggle switch
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');

if ~isstruct(plot_data_structure.whole_test_values)
 
if isstruct(plot_data_structure.detected_object_properties)   
plot_data_structure = calculate_test_values(plot_data_structure);

info_string{1}  =  ['Calculated (',num2str(plot_data_structure.whole_test_values.no_incorrect_frames), ' skipped)' ]   ;
info_string{2}  =  ['Mean size = ',num2str(round(plot_data_structure.whole_test_values.size_mean))   , 'pix, (std = ',num2str(round(plot_data_structure.whole_test_values.size_std*10)/10) ,'%)'   ]         ;
info_string{3}  =  ['Mean circ = ',num2str(round(plot_data_structure.whole_test_values.circ_mean))   , '%, (std = '  ,num2str(round(plot_data_structure.whole_test_values.circ_std*10)/10) ,'%)'   ]         ;

set(plot_data_structure.handles.but_func_2_txt,'String',info_string)

plot_data_structure = set_ordinate_choices(plot_data_structure);
set(plot_data_structure.handles.but_func_4 ,'visible','on')
set(plot_data_structure.handles.combo_box_3,'visible','on')
set(plot_data_structure.handles.combo_box_3_txt,'visible','on')
set(plot_data_structure.handles.combo_box_4,'visible', 'on')
set(plot_data_structure.handles.combo_box_4_txt,'visible','on')
else
    
plot_data_structure = reset_test_vals(plot_data_structure);    

end %if ~isnan(plot_data_structure.detected_object_properties)   
else
msgbox('Values already calculated for these settings')
end %if isnan(plot_data_structure.whole_test_values)

set(get(hObject,'Parent'),'UserData',plot_data_structure);
end 

function plot_data_structure = calculate_test_values(plot_data_structure)   

frame_rate                     =   plot_data_structure.movie_data{plot_data_structure.orientation_choice}.FrameRate                                      ;
correct_number_of_objects      =   length(plot_data_structure.detected_object_properties.Detected_Object_List)   ;
number_of_frames               =   length(plot_data_structure.movie_data{plot_data_structure.orientation_choice})                                        ;   
CH_speed_mm_min                =   plot_data_structure.CH_speed_mm_min;
threshold_val                  =   plot_data_structure.threshold_val                                             ;
min_detection_size             =   plot_data_structure.min_detection_size                                        ;
max_circ_tol                   =   plot_data_structure.max_circ_tol                                              ;
pixels_per_mm                  =   plot_data_structure.pixels_per_mm                                             ;
no_incorrect_frames            = 0                                                                               ;

waitbar_h = waitbar (0,'0%')                                                                                     ;

results_column_headers ={'time','Position(pixels)','Circlarity','Area'}                                          ;
results_matrix = NaN(number_of_frames,correct_number_of_objects*3+1)                                             ;
% Create  an empty matrix of NaN's to be populated

for index = 1:number_of_frames
% for each frame -  first find out if it has the correct under of objects       ;
% pause (0.01)                                                                  ;
results_matrix(index,1) = (1/frame_rate) * (index-1)                            ;
detected_object_properties_temp = find_detected_objects (plot_data_structure.movie_data{plot_data_structure.orientation_choice},index,threshold_val,min_detection_size,max_circ_tol);

if length(detected_object_properties_temp.Detected_Object_List) == correct_number_of_objects
    
for index_2 = 1:correct_number_of_objects
results_matrix(index , 2 + (index_2-1)*3) = detected_object_properties_temp.all_connected_object_properties(detected_object_properties_temp.Detected_Object_List(index_2)).Centroid(1)      ;
results_matrix(index , 3 + (index_2-1)*3) = detected_object_properties_temp.all_connected_object_properties(detected_object_properties_temp.Detected_Object_List(index_2)).Area             ;
bb_temp = detected_object_properties_temp.all_connected_object_properties(detected_object_properties_temp.Detected_Object_List(index_2)).BoundingBox                                        ;
results_matrix(index , 4 + (index_2-1)*3) = (bb_temp(3)/bb_temp(4)) *100                                                                                                                    ;
end %for index_2 = 1:correct_number_of_objects
else
no_incorrect_frames = no_incorrect_frames + 1 ;
end %if length(detected_object_properties_temp.Detected_Object_List) == correct_number_of_objects
% now make sure there are the correct number of detected objects  - if not  dont produce results
waitbar(index/number_of_frames , waitbar_h , [num2str(round(1000*index/number_of_frames)/10 ), '%'])

end %for index = 1:number_of_frames
close(waitbar_h )

reducesd_results_matrix = results_matrix(find( ~isnan(results_matrix(:,2))) ,:);
all_mean_values  =  mean(reducesd_results_matrix);
all_std_values   =  100 * std(reducesd_results_matrix)./mean(reducesd_results_matrix);
all_size_means   =  ones(correct_number_of_objects,1);
all_circ_means   =  ones(correct_number_of_objects,1);
all_size_stds   =  ones(correct_number_of_objects,1);
all_circ_stds   =  ones(correct_number_of_objects,1);

for index = 1:correct_number_of_objects
all_size_means(index) =  all_mean_values(3 +(index-1)*3);      
all_circ_means(index) =  all_mean_values(4 +(index-1)*3);  
all_size_stds(index)  =  all_std_values (3 +(index-1)*3);      
all_circ_stds(index)  =  all_std_values (4 +(index-1)*3);  

end    

whole_test_values.size_mean                 = mean(all_size_means)       ;
whole_test_values.circ_mean                 = mean(all_circ_means)       ;
whole_test_values.size_std                  = mean(all_size_stds)       ;
whole_test_values.circ_std                  = mean(all_circ_stds)       ;
whole_test_values.frame_rate                = frame_rate                 ;     
whole_test_values.correct_number_of_objects = correct_number_of_objects  ;
whole_test_values.number_of_frames          = number_of_frames           ; 
whole_test_values.threshold_val             = threshold_val              ;
whole_test_values.min_detection_size        = min_detection_size         ;
whole_test_values.max_circ_tol              = max_circ_tol               ;
whole_test_values.pixels_per_mm             = pixels_per_mm              ;
whole_test_values.no_incorrect_frames       = no_incorrect_frames        ; 
whole_test_values.results_matrix            = results_matrix             ;
whole_test_values.CH_speed_mm_min           = CH_speed_mm_min;

whole_test_values.marker_strain             =(((whole_test_values.results_matrix(:,5)-whole_test_values.results_matrix(:,2))-...
(whole_test_values.results_matrix(1,5)-whole_test_values.results_matrix(1,2)))/...
(whole_test_values.results_matrix(1,5)-whole_test_values.results_matrix(1,2)) )  *100;
plot_data_structure.whole_test_values       = whole_test_values          ;

if ~isnan(plot_data_structure.whole_test_values.CH_speed_mm_min)
plot_data_structure                         = calculate_crosshead_position(plot_data_structure)  ;
end

% Detect objects needs to be on
% Correct number of objects based on the 'current' frame-  first get this
% get the frame rate
% for each frame save the raw properties 
% and the 'extra properties'
% from this create a matrix of properties for each object  (if wrong nuber
% then the values will be NAN in all cols for this frame)
% if not correct then miss out for now (can make it more compliacted later)
% go through every frame and calculate the following for each:

% stucture of the raw data for each frame

% Have a status bar based on the for - loop
%
% Whole_test_values
%
% once the properties are calculated-  update the status and give options
% for x and y ordinate along with 

end %function plot_data_structure = calculate_test_values(plot_data_structure)

function plot_data_structure = reset_test_vals(plot_data_structure)
plot_data_structure.whole_test_values    =    NaN            ;
set(plot_data_structure.handles.but_func_2_txt,'String','Not calculated');
set(plot_data_structure.handles.but_func_4,'visible', 'off');
set(plot_data_structure.handles.combo_box_3,'visible', 'off');
set(plot_data_structure.handles.combo_box_3_txt,'visible', 'off');
set(plot_data_structure.handles.combo_box_4,'visible', 'off');
set(plot_data_structure.handles.combo_box_4_txt,'visible', 'off');
set(plot_data_structure.handles.axis_3,'Visible','off');
plot_data_structure = remove_plot_stuff(plot_data_structure);
set(plot_data_structure.handles.but_func_4,'Value',0)

end

function choose_cal_point(hObject, ~)
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');

plot_data_structure  =  set_calbration(plot_data_structure);

if isnan(plot_data_structure.pixels_per_mm) 
set (plot_data_structure.handles.but_func_1_txt,'String','pixels per mm = not set')
else
set (plot_data_structure.handles.but_func_1_txt,'String',['pixels per mm = ',num2str(plot_data_structure.pixels_per_mm)] )    
end %if isnan(plot_data_structure.pixels_per_mm)

plot_data_structure =  display_binary_image(plot_data_structure);

set(get(hObject,'Parent'),'UserData',plot_data_structure);

end %function choose_cal_point(hObject, ~)

function plot_data_structure  =  set_calbration(plot_data_structure)

switch (plot_data_structure.Calibration_type)
case(1)    
plot_data_structure.pixels_per_mm = NaN;

case(2) % two points from the grascale image
   
axes(plot_data_structure.handles.axis_1)
hold on

selected_pts = ginput(2);

x_L = get(plot_data_structure.handles.axis_1,'Xlim');
y_L = get(plot_data_structure.handles.axis_1,'Ylim');

if sum(selected_pts(:,1)>x_L(1))==2 && sum(selected_pts(:,2)>y_L(1))==2 && sum(selected_pts(:,1)< x_L(2))==2 && sum(selected_pts(:,2) < y_L(2))==2  
    
plot ( selected_pts(:,1), selected_pts(:,2) ,'r+','markersize',25)
num_of_pixels = abs(selected_pts(1,1) - selected_pts(2,1));

answers = inputdlg(['Input the distance between points in mm,  (', num2str(num_of_pixels),'pixels) ']);
if length( answers) == 1
temp_answer = str2num(answers{1});
disp(num2str(temp_answer))
if length(temp_answer)~=0
if temp_answer > 0
plot_data_structure.pixels_per_mm = num_of_pixels/temp_answer;
else
plot_data_structure.pixels_per_mm = NaN;        
end
else
plot_data_structure.pixels_per_mm = NaN;    
end
else
plot_data_structure.pixels_per_mm = NaN;        
end

hold off
imshow(plot_data_structure.movie_data{plot_data_structure.orientation_choice}(plot_data_structure.frame_to_view).gray)
else    
plot_data_structure.pixels_per_mm = NaN;            
end
case(3) % two objects from the binary image at currect values
% first detect objects if not already set
if  get(plot_data_structure.handles.checkbox_1,'value')
% make sure there are more than two objects
if length(plot_data_structure.detected_object_properties.Detected_Object_List) ==2
temp_cenroids = {plot_data_structure.detected_object_properties.all_connected_object_properties.Centroid};

%temp_cenroids{plot_data_structure.detected_object_properties.Detected_Object_List(1)}(1) 
num_of_pixels = abs(temp_cenroids{plot_data_structure.detected_object_properties.Detected_Object_List(1)}(1)-temp_cenroids{plot_data_structure.detected_object_properties.Detected_Object_List(2)}(1));    

answers = inputdlg(['Input the distance between markers in mm,  (', num2str(num_of_pixels),'pixels) ']);
if length( answers) == 1
temp_answer = str2num(answers{1});

if length(temp_answer)~=0
if temp_answer > 0
plot_data_structure.pixels_per_mm = num_of_pixels/temp_answer;
else
plot_data_structure.pixels_per_mm = NaN;        
end
else
plot_data_structure.pixels_per_mm = NaN;    
end
else
plot_data_structure.pixels_per_mm = NaN;        
end
else    
msgbox('Should be two detected objects')    
end

else
h = msgbox('Turn object detection on before setting calibration');
pause(2)
close(h)
plot_data_structure.pixels_per_mm = NaN;            
end    

case(4)
answers = inputdlg('Input the number of pixels per mm');
if length( answers) == 1
temp_answer = str2num(answers{1});

if length(temp_answer)~=0
if temp_answer > 0
plot_data_structure.pixels_per_mm = temp_answer;
else
plot_data_structure.pixels_per_mm = NaN;        
end
else
plot_data_structure.pixels_per_mm = NaN;    
end
else
plot_data_structure.pixels_per_mm = NaN;        
end
end %switch (plot_data_structure.Calibration_type)


if isstruct(plot_data_structure.whole_test_values)
plot_data_structure.whole_test_values.pixels_per_mm = plot_data_structure.pixels_per_mm;
end
plot_data_structure = set_ordinate_choices(plot_data_structure);

if(get(plot_data_structure.handles.but_func_4   ,'Value')); 
plot_data_structure = set_ordinates(plot_data_structure);
plot_data_structure = plot_values(plot_data_structure);
end

end

function select_calibration_type (hObject, ~)
new_value =  get(hObject,'Value');
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');
%disp(num2str(new_value))
plot_data_structure.Calibration_type = new_value;

if plot_data_structure.Calibration_type ==1
set (plot_data_structure.handles.but_func_1_txt,'String','pixels per mm = not set')
plot_data_structure.pixels_per_mm = NaN;
plot_data_structure = set_ordinate_choices(plot_data_structure);
end%if plot_data_structure.Calibration_type ==1

set(get(hObject,'Parent'),'UserData',plot_data_structure);
end %function select_calibration_type

function checkbox_func_1(hObject, ~)
drawnow; pause(0.05);
new_value =  get(hObject,'Value');
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');

plot_data_structure.show_detected_objects  = new_value;
plot_data_structure.detected_object_properties = NaN;

plot_data_structure =  display_binary_image(plot_data_structure);
plot_data_structure = reset_test_vals(plot_data_structure);

set(get(hObject,'Parent'),'UserData',plot_data_structure);
end %function checkbox_func_1(hObject, ~)

function slider_func_1 (hObject, ~)
drawnow; pause(0.05);
new_value =  get(hObject,'Value');
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');
plot_data_structure.threshold_val  = new_value                         ;
set(plot_data_structure.handles.slider_handle_1_txt,'String',['Threshold = ',num2str(round(plot_data_structure.threshold_val*100)/100) ] )
plot_data_structure = reset_test_vals(plot_data_structure);

plot_data_structure =  display_binary_image(plot_data_structure);

set(get(hObject,'Parent'),'UserData',plot_data_structure);
end % function slider_func_mag (hObject, ~) 

function slider_func_2 (hObject, ~)
drawnow; pause(0.05);

new_value =  get(hObject,'Value');
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');
plot_data_structure.frame_to_view  = round(new_value)                      ;
set(plot_data_structure.handles.slider_handle_2_txt,'String',['Frame = ',num2str(plot_data_structure.frame_to_view) ] )


plot_data_structure =  display_binary_image(plot_data_structure);
drawnow; pause(0.05);
axes(plot_data_structure.handles.axis_1)
cla(plot_data_structure.handles.axis_1)
imshow(plot_data_structure.movie_data{plot_data_structure.orientation_choice}(plot_data_structure.frame_to_view).gray)

set(get(hObject,'Parent'),'UserData',plot_data_structure);
end % function slider_func_mag (hObject, ~) 

function slider_func_3 (hObject, ~)
drawnow; pause(0.05);
new_value =  get(hObject,'Value');
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');
plot_data_structure.min_detection_size  = round(new_value);

plot_data_structure = reset_test_vals(plot_data_structure);

set(plot_data_structure.handles.slider_handle_3_txt,'String',['Min Det. size = ',num2str(plot_data_structure.min_detection_size),' pixels'])
plot_data_structure =  display_binary_image(plot_data_structure);

set(get(hObject,'Parent'),'UserData',plot_data_structure);
end % function slider_func_mag (hObject, ~) 

function detected_object_properties = find_detected_objects (movie_data,frame_to_view,threshold_val,min_detection_size,max_circ_tol)

BW1 = im2bw(movie_data(frame_to_view).gray,threshold_val);

all_connected_objects  = bwconncomp(BW1);
Detected_object_Count = 0;
Detected_Object_List  = zeros(length(all_connected_objects.PixelIdxList)) ;
all_connected_object_properties = regionprops(all_connected_objects, 'basic');

%all_connected_object_properties

for index = 1:length(all_connected_objects.PixelIdxList)
    
temp_bb = all_connected_object_properties(index).BoundingBox;    

if length(all_connected_objects.PixelIdxList{index}) >= min_detection_size...    
&&  abs(temp_bb(3)/temp_bb(4)-1) < (max_circ_tol/100);

Detected_object_Count = Detected_object_Count + 1;
Detected_Object_List(Detected_object_Count) = index;
end %if length(all_connected_objects.PixelIdxList{index}) >= min_detection_size

end %for index = 1:length(all_connected_objects.PixelIdxList)

Detected_Object_List = Detected_Object_List(find(Detected_Object_List~=0));


detected_object_properties.Detected_Object_List = Detected_Object_List;
detected_object_properties.all_connected_objects = all_connected_objects;
detected_object_properties.all_connected_object_properties = all_connected_object_properties;

detected_object_properties = detected_object_properties;

end %function      plot_data_structure = find_detected_objects (plot_data_structure)

function plot_data_structure =  display_binary_image(plot_data_structure)

BW1 = im2bw(plot_data_structure.movie_data{plot_data_structure.orientation_choice}(plot_data_structure.frame_to_view).gray,plot_data_structure.threshold_val);

axes(plot_data_structure.handles.axis_2)

imshow(BW1)
hold on
if plot_data_structure.show_detected_objects
%plot_data_structure = find_detected_objects (plot_data_structure); 
plot_data_structure.detected_object_properties = find_detected_objects (plot_data_structure.movie_data,plot_data_structure.frame_to_view,plot_data_structure.threshold_val,plot_data_structure.min_detection_size,plot_data_structure.max_circ_tol);
set(plot_data_structure.handles.checkbox_1_txt,'visible', 'on')


if length(plot_data_structure.detected_object_properties.Detected_Object_List)~=0

checkbox_1_info_txt{1}  =   'Objec Stats(Pos/AR/Area)  : ';

for index = 1:length(plot_data_structure.detected_object_properties.Detected_Object_List)
% create the cell array of object properties ( area / aspect ratio / position )
    
Centroid_temp = plot_data_structure.detected_object_properties.all_connected_object_properties(plot_data_structure.detected_object_properties.Detected_Object_List(index)).Centroid;
BB_temp     =  plot_data_structure.detected_object_properties.all_connected_object_properties(plot_data_structure.detected_object_properties.Detected_Object_List(index)).BoundingBox;
Area_temp   =  plot_data_structure.detected_object_properties.all_connected_object_properties(plot_data_structure.detected_object_properties.Detected_Object_List(index)).Area;

if isnan(plot_data_structure.pixels_per_mm)
pos_temp_txt  =   [num2str(round(Centroid_temp(1)*10)/10),'pix'];
else
pos_temp_txt  =   [num2str(round((Centroid_temp(1)/plot_data_structure.pixels_per_mm)*10)/10),'mm'];    
end %if isnan(plot_data_structure.pixels_per_mm)

checkbox_1_info_txt{index+1}  = ['(',num2str(index) ,'):',pos_temp_txt,', ',num2str( round (BB_temp(3)/BB_temp(4) *100) ) , '%, ' ,num2str(Area_temp),' pix.'];    

set(plot_data_structure.handles.checkbox_1_info,'visible' , 'on' )
set(plot_data_structure.handles.checkbox_1_info,'String',checkbox_1_info_txt )

plot(Centroid_temp(1),Centroid_temp(2),'r+', 'MarkerSize', 20);

plot ([BB_temp(1),BB_temp(1),BB_temp(1)+BB_temp(3),BB_temp(1)+BB_temp(3),BB_temp(1)]   ,[BB_temp(2),BB_temp(2)+BB_temp(4),BB_temp(2)+BB_temp(4),BB_temp(2),BB_temp(2)],'r-' ) 

set (plot_data_structure.handles.checkbox_1_txt,'String',['Num Det Objects = ',num2str(length(plot_data_structure.detected_object_properties.Detected_Object_List))])         
end %for index = 1:length(plot_data_structure.detected_object_properties.Detected_Object_List)    

else
set (plot_data_structure.handles.checkbox_1_txt,'String',['Num Det Objects = 0'])             
end %if length(plot_data_structure.detected_object_properties.Detected_Object_List)~=0
else
set(plot_data_structure.handles.checkbox_1_txt,'visible', 'off')        
set(plot_data_structure.handles.checkbox_1_info,'visible' , 'off' )
%set (plot_data_structure.handles.checkbox_1_txt,'String',['Num Det Objects = OFF'])         
end %if plot_data_structure.show_detected_objects

end %function plot_data_structure =  display_binary_image(plot_data_structure)

function  set_orientation(hObject, ~)
drawnow; pause(0.05);
new_value =  get(hObject,'Value');
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');
disp(num2str(new_value))
plot_data_structure.orientation_choice  = new_value + 1;

switch(plot_data_structure.orientation_choice)
    case (1)
set(plot_data_structure.handles.checkbox_2_txt,'String','(Normal)')
    case (2)
set(plot_data_structure.handles.checkbox_2_txt,'String','(Rotated)')
end %switch(plot_data_structure.orientation_choice)

fig_setup(plot_data_structure.handles,plot_data_structure.orientation_choice)

%plot_data_structure =  display_binary_image(plot_data_structure);


set(get(hObject,'Parent'),'UserData',plot_data_structure);

%plot_data_structure = reset_test_vals(plot_data_structure);
%plot_data_structure =  display_binary_image(plot_data_structure);


end % set video orientation 

function fig_setup(handles,orientation_choice)
plot_data_structure                         = get(handles.fig_handle,'UserData')   ;

handles.axis_1                  = subplot(2,2,1)               ;

movie_data = {plot_data_structure.movie_data}

disp('HERE5')

imshow(movie_data{orientation_choice}(plot_data_structure.frame_to_view).gray)

handles.axis_2                  = subplot(2,2,2)               ;
BW1 = im2bw(movie_data{orientation_choice}(plot_data_structure.frame_to_view).gray,plot_data_structure.threshold_val);
imshow(BW1)
disp('HERE6')

handles.axis_3 = subplot(2,2,3:4);
set(handles.axis_3,'Position',[0.33 0.11 0.55 0.4])
set(handles.axis_3,'Visible','off')

set(handles.axis_1,'UserData',1)
set(handles.axis_2,'UserData',2)
set(handles.axis_3,'UserData',3)

disp('HERE7')
plot_data_structure.handles = handles;
disp('HERE8')
%set(slider_handle_2,'Value',plot_data_structure.mult_factor_speed)  
set(handles.fig_handle,'UserData',plot_data_structure)                                                                     ;
disp('HERE9')
end

function movie_data = get_movie_data(movie_filename)
% outputs the grayscale image

video_obj = VideoReader(movie_filename);
N_frames  = video_obj.NumberOfFrames     ;
width_    = video_obj.Width              ; 
height_   = video_obj.Height             ;
%FrameRate = video_obj.FrameRate          
FrameRate = 6.5;


movie_dataN(1:N_frames) = struct('gray',zeros(height_,width_,'uint8'),'colormap',[],'FrameRate',FrameRate);
movie_dataR(1:N_frames) = struct('gray',zeros(width_,height_,'uint8'),'colormap',[],'FrameRate',FrameRate);

for index = 1 : N_frames
movie_dataN(index).gray = rgb2gray(read(video_obj,index));
movie_dataR(index).gray = rot90(rgb2gray(read(video_obj,index)));
end

%size(movie_dataN(1).gray)
%size(movie_dataR(1).gray)
%movie_dataC{1} = {movie_dataN};
%movie_dataC{2} = {movie_dataR};
movie_dataC = {movie_dataN,movie_dataR};
%save movie_dataC movie_dataC
%movie_data = movie_dataN;

movie_data = movie_dataC;
%load movie_data movie_data

save movie_data movie_data

end %function movie_data = get_movie_data(movie_filename);










