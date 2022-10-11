clear 
close all
clc

file_extension = '.bmp'; % Enter file extension of analyzed images
input_folder_path = "D:\Experimental data\test_folder\input\"; 
output_folder_path = "D:\Experimental data\test_folder\output\";
% Find and show number of images in the folder
image_files = dir(strcat(input_folder_path, '*', file_extension));
nfiles = length(image_files); % number of images in the folder
disp([int2str(nfiles), ' images found', newline]);

for file_n=1:nfiles % Calculate image with average values
    img_name = image_files(file_n).name;
    img_path = strcat(input_folder_path, img_name);
    img = imread(img_path);
    if file_n == 1
        average_img = img;
    else
        average_img = average_img/2 + img/2;
    end
end

[height, width] = size(average_img);
[frequency, symbols] = imhist(average_img);
total_frequency = sum(frequency);
probability = frequency ./ total_frequency ; % Calculate values probability in image

dictionary = huffmandict(symbols,probability); % Create dictionary with codes

total_original_image_size = 0;
total_compressed_file_size = 0;
for file_n=1:nfiles % Compress every image in folder
    img_name = image_files(file_n).name;
    img_path = strcat(input_folder_path, img_name);
    img = imread(img_path);
    flat_image=(img(:)); % Read image and make 1D array

    code_table = huffmanenco(flat_image,dictionary); % Encode image

    bit_code = Exact_8bit_length(code_table); % Convert bin array to string and make it multiple of 8
    dec_code = Bin_to_dec(bit_code); % Convert string of bin values to dec values
    code_length_difference = length(bit_code) - length(code_table); % Calculate number of added 0 values
    dec_code(end+1) = code_length_difference; % Add number of added 0 values as last string element  

    bin_name = strcat(int2str(file_n), '_compressed_image.bin');
    bin_path = strcat(output_folder_path, bin_name);
    fileID = fopen(bin_path,'w'); % Save bin file
    fwrite(fileID, dec_code);
    fclose(fileID);

    original_image_size = dir(img_path).bytes/1000; % Get size of original image
    compressed_file_size = dir(bin_path).bytes/1000; % Get size of compressed file
    total_original_image_size = total_original_image_size + original_image_size; % Sum size of original image
    total_compressed_file_size = total_compressed_file_size + compressed_file_size; % Sum size of compressed file
    disp(img_name);
    disp(['Original image size: ', int2str(original_image_size), ' Kb'])
    disp(['Compressed image size: ',int2str(compressed_file_size), ' Kb'])
    disp(['Image size reduced to: ', int2str(compressed_file_size/original_image_size*100),'% ', newline])
end

dictionary{256,2}(end+1) = height; % Add height value to dictionary
dictionary{256,2}(end+1) = width; % Add width value to dictionary
dictionary_path = strcat(output_folder_path, 'dictionary.mat');
save(dictionary_path,'dictionary');
dictionary_size = dir(dictionary_path).bytes/1000;
total_compressed_file_size_all = total_compressed_file_size + dictionary_size; 

disp('All images compressed'); % Display total size of original images and compressed files
disp(['Total size of original images: ', int2str(total_original_image_size), ' Kb']);
disp(['Total size of compressed files: ', int2str(total_compressed_file_size_all), ' Kb']);
disp(['Total image size reduced to: ', int2str(total_compressed_file_size_all/total_original_image_size*100),'% '])




function code = Exact_8bit_length(code_table)
    code = sprintf('%d', code_table');
    while mod(length(code), 8) ~= 0
        code = append(code, '0');
    end
end

function code = Bin_to_dec(bit_code)
    code_length = ceil(length(bit_code)/8);
    code = zeros(code_length, 1);
    counter = 1;
    for i=1:8:length(bit_code)
        code(counter) = bin2dec(bit_code(i:i+7));
        counter = counter + 1;
    end
end
