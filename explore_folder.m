function [] = explore_folder(local_mirror,folder_url)
   
    % Read the folder contents (with a try catch in case connection gets
    % unsteady)
    attempt = 1;
    while 2>1 % Try forever, break inside the loop
        try
            folder_contents = webread(folder_url);
            break; % If successful, exit the loop
        catch
            attempt = attempt+1;
            disp(['The connection was not successful. Attempt ',attempt])
        end
    end
    
    % Parse the HTML content to extract folder and file names
    folderPattern = '<a href="([^"]+/)">'; % Pattern to match folder links
    filePattern = '<a href="([^"/]+)">';     % Pattern to match file links

    % Find nested folders and files
    folderMatches = regexp(folder_contents, folderPattern, 'tokens');
    fileMatches = regexp(folder_contents, filePattern, 'tokens');

    % Create a cell array to store the folder and file names
    folders = {};
    files = {};

    % Populate the cell arrays
    for i = 1:length(folderMatches)
        folders{i} = folderMatches{i}{1};
    end
    for i = 1:length(fileMatches)
        files{i} = fileMatches{i}{1};
    end

    % Remove folders and files that we know are not part of the main website
    folders(1) = []; % The first folder corresponds to parent directory
    files(1:3) = []; % The first three "files" are in reality links for sorting the contents in the website
    files(end) = []; % The last "file" is in reality a mailto link

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Create mirrored local folder
    mkdir(local_mirror);

    % Save files in a mirrored local folder (with a try catch in case connection gets unsteady)
    for i = 1:length(files)
        attempt = 1;
        while 2>1 % Try forever, break inside the loop
            try
                websave([local_mirror,files{i}],[folder_url,files{i}])
                disp(['Downloaded: ',folder_url,files{i}]);
                break; % If successful, exit the loop
            catch
                attempt = attempt+1;
                disp(['The connection was not successful. Attempt ',attempt])
            end
        end
    end

    % Explore the next folder recursively (if there are any nested folders)
    if length(folders)>0
        for i = 1:length(folders)
            explore_folder([local_mirror,folders{i}],[folder_url,folders{i}])
        end
    end
end