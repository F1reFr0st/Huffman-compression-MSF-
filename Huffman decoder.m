clear 
close all
clc

file_extension = '.bmp'; % enter file extension of analyzed images
folder_path = "d:\experimental data\test_folder\output\";  % maybe use relative path? say ".\output\"

% Find and show number of .bin files in the folder
image_files = dir(strcat(folder_path, '*.bin'));
nfiles = length(image_files);
disp([int2str(nfiles), ' .bin files in folder']);

load(strcat(folder_path, 'dictionary.mat')); % Load table with codes
width = dictionary{256,2}(end); % Get width of image from table
height = dictionary{256,2}(end-1); % Get height of image from table
decompress_dictionary(:,1) = dictionary(:,1); % Copy table 
decompress_dictionary(:,2) = dictionary(:,2);

m = Input_step_size(); % Enter step between analyzed files (1 by default)
disp(['Analyzing ', num2str(ceil(nfiles/m)), ' files', newline])

activity_map = zeros(height, width); 
difference = zeros(height, width);
for i = 1:m:nfiles-m % Calculate activity map with m step
    % In this loop Modified Structure Function algorithm is realised 
    first_flat_decomressed_image = Decompress_image(i, folder_path, decompress_dictionary); % Decompress first image with Huffman function
    second_flat_decomressed_image = Decompress_image(i+1, folder_path, decompress_dictionary); % Decompress second image with Huffman function
    for j = 1:length(first_flat_decomressed_image)
        difference(j) = abs(first_flat_decomressed_image(j) - second_flat_decomressed_image(j));
        activity_map(j) = activity_map(j) + (difference(j)/(nfiles-1));
    end
    disp([int2str(i), ' - ', int2str(i+1), ' file done']);
end

activity_map = uint8(reshape(activity_map, [height, width]));
imshow(activity_map);
colormap('turbo');    
caxis('auto');
colorbar;




function flat_image = Decompress_image(i, folder_path, d)
    bin_name = strcat(int2str(i), '_compressed_image.bin');
    bin_path = strcat(folder_path, bin_name);

    fileID = fopen(bin_path);  
    decompressed_code = fread(fileID);
    fclose(fileID);

    code_length = decompressed_code(end);
    decompressed_code = decompressed_code(1:end-1);
    decompressed_code = int2bit(decompressed_code, 8);
    decompressed_code = decompressed_code(1:end-code_length);        
    flat_image = huffmandeco(decompressed_code,d);
end

function step = Input_step_size()
    prompt = {'Enter step between images:'};
    dlgtitle = 'Image step';
    dims = [1 40];
    definput = {'1'}; 
    answer = inputdlg(prompt, dlgtitle, dims, definput);
    step = str2double(answer{1});
end
