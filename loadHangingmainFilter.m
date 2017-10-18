function [ matrix, filename_set ] = loadHangingmainFilter

filename_set = {'kernel_uppershadow.csv',
                'kernel_realbody.csv',
                'kernel_lowershadow.csv',
                'kernel_close_price.csv'}';

n_filename = length(filename_set);
matrix = cell(1,n_filename);
for i = 1 : n_filename
filename = filename_set{i};
delimiter = ',';
formatSpec = '%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fclose(fileID);
matrix{i} = [dataArray{1:5}];
filename_set{i} = strrep(filename_set{i},'.csv','');
filename_set{i} = strrep(filename_set{i},'kernel_','');
filename_set{i} = strrep(filename_set{i},'_',' ');
end
end