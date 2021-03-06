%% Installing CAT
%
%% Downloading
%
% Download the latest version of CAT from the SPL website:
% http://www.ipe.ethz.ch/laboratories/spl/cat
%
%
%% Installing
%
% Extract the zip file somewhere, copy the whole folder to somewhere where
% you keep Matlab files, or in the Matlab toolbox folder
%
% Once this is done, either add the folder to your Matlab path by:
%
% # Adding the folder to the path:
% 	>> addpath(folder)
% # Optionally, save the path for future Matlab sessions by running:
%   >> savepath
%
% Alternatively, you can execute this file (Install.m) within Matlab with
% the CAT Toolbox folder as your working directory

% Copyright 2015-2016 David Ochsenbein
% Copyright 2012-2014 David Ochsenbein, Martin Iggland
% 
% This file is part of CAT.
% 
% CAT is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation version 3 of the License.
% 
% CAT is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.



% Check that we are in the right directory
if exist('@CAT','dir')
    % The folder to add to the path is the current working directory
    addpath(pwd);
    
    % Ask the user if she wants to save the path permanently
    button = questdlg('Do you want to permanently add the CAT Toolbox to your Matlab path?','Save path?','Yes','No','Yes');
    
    if strcmp(button,'Yes')
        save = savepath;
        if save == 0
            helpdlg('The CAT Toolbox was permanently added to your Matlab path')
        else
            errordlg('The path changes could not be saved. You will need to add the CAT Toolbox to the path again next time you start Matlab','Error saving path');
        end % if
    end
    
else
    errordlg('This script needs to be executed with the CAT Toolbox folder as your working directory','Wrong directory');
end