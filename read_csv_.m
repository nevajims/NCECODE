
function [time_data, extension_data,load_data, end_index] =  read_csv_(file_name_no_ext,do_plot); 


%file_name_no_ext = 'test3'                                        ; %      

fid              = fopen    ([ file_name_no_ext , '.csv' ])        ; %
data_            = csvread ([ file_name_no_ext,  '.csv' ],3,0)     ; %

No_cols          = size(data_,2)                                   ; %    
format_          = repmat('%35s ',1,No_cols)                       ; %
all_headers_     = textscan(fid, format_ , 2 , 'Delimiter' , ',')  ; %
xlabel_ = [all_headers_{1}{1},all_headers_{1}{2}];
ylabel_ = [all_headers_{3}{1},all_headers_{3}{2}];

time_data = data_(:,1);
extension_data = data_(:,2);
load_data = data_(:,3);


% Find the max in the load and then find the 
[max_val,max_index] = max(load_data) ;
less_HL = find(load_data < max_val*0.99);
after_max = find(less_HL > max_index);
end_index = less_HL(min(after_max));

if do_plot == 1
figure(2)
plot(time_data , load_data,'x')  
xlabel(xlabel_)
ylabel(ylabel_)
hold on
plot(time_data(end_index) , load_data(end_index),'r+','markersize',20)  
time_from_max = (time_data(end_index) - time_data(max_index));   
title(['Time at end = ',num2str(time_data(end_index)),'s, (time from max = ',num2str(time_from_max),' s).'])
end %if do_plot == 1


end  % function




