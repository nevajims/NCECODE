% find the point of max diff
% find the averad
% go back untill th
[time_data, extension_data,load_data, end_index_] =  read_csv_('test3',1) ;

do_first_plot = 1 ;
do_2nd_plot   = 1 ;
do_3rd_plot   = 1 ;

load whole_test_values whole_test_values
time_ = whole_test_values.results_matrix(:,1);
test_time = time_data(end_index_);

raw_load_test   = load_data(1:end_index_);
raw_load_time   = time_data(1:end_index_);


norm_diff = diff(whole_test_values.marker_strain)/max(diff(whole_test_values.marker_strain));

[max_val , max_ind]  =   max(norm_diff)                                        ;
search_region        =   norm_diff(max_ind-10 : max_ind)                       ;
pass_ind             =   find(search_region > 0.1)                             ;  
local_ind            =   min(pass_ind)                                         ;
end_index            =   local_ind-11+max_ind                                  ;
start_time           =   time_(end_index) - test_time                          ;
[~ , start_index]    =   min (abs(time_-start_time))                           ;

raw_strain_test = whole_test_values.marker_strain (start_index:end_index) ;
raw_strain_time = time_                           (start_index:end_index)-time_(start_index);

if do_first_plot == 1
figure(1)
plot(whole_test_values.marker_strain,'.')
hold on
plot(norm_diff,'g+')
plot(end_index,whole_test_values.marker_strain(end_index),'r+','markersize',30)
plot(start_index,whole_test_values.marker_strain(start_index),'r+','markersize',30)
title(['end time = ' , num2str(time_(end_index))])
xlabel('frame number')
ylabel('strain (%)')
end %if do_first_plot ==1

int_strain_test = interp1(raw_strain_time,raw_strain_test,raw_load_time);

if do_2nd_plot == 1
figure(3)
subplot(2,1,1)
plot(raw_strain_time,raw_strain_test,'r.')
xlabel('time(s)')
ylabel('strain(%)')
hold on    
subplot(2,1,2)
plot(raw_load_time,raw_load_test,'g.')
xlabel('time(s)')
ylabel('load(N)')
end %if do_2nd_plot == 1

if do_3rd_plot == 1
figure(4)
plot(raw_load_test,int_strain_test,'r.')
hold on
xlabel('Load(N)')
ylabel('Strain(%)')
xlim([0 200])

%fit_start  = floor(length(raw_load_time)/2) 
%fit_end    = length(raw_load_time) 

%p_fit =  polyfit(raw_load_test(fit_start:fit_end),int_strain_test(fit_start:fit_end),1)

%strain_fit = polyval(p_fit,raw_load_test(fit_start:fit_end));
%subplot(2,1,2)
%plot(raw_load_test(fit_start:fit_end),strain_fit,'+', 'markersize',20)
end %if do_3rd_plot == 1

% now get the extension time to interpolate for the new load values

% look at the 10 frames before 
% look for any value over 0.1 and tak the lowest index value passing this threshold
