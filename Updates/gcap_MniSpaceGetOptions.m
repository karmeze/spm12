function [thr, showLabel] = gcap_MniSpaceGetOptions
%----------------------------------------------------------------------------------
% FORMAT [thr, showLabel] = gcap_MniSpaceGetOptions
%----------------------------------------------------------------------------------
%   22.10.01    Sergey Pakhomov
%   22.10.01    last modified
%----------------------------------------------------------------------------------
thr = 0;
showLabel = ones(1,5);

optionFileName = 'gcap_MniSpaceOption.txt';
newLineChar = sprintf('\n');
commaChar = sprintf(',');
fid = fopen(optionFileName, 'rt');
if fid == -1
    errordlg('Can not open gcap_MniSpaceOption.txt file','Error');
    return;
end
data = fscanf(fid,'%c',inf);
fclose(fid);

indLines = find(data == newLineChar);
nLine = size(indLines, 2);
for iLine = 1:nLine-1
    lineData = data(indLines(iLine)+1 : indLines(iLine+1)-1);
    if ~(lineData(1:2) == '//')
        indComma = find(lineData == commaChar);
        nComma = size(indComma, 2);
        if ~(nComma == 1)
            errordlg('Invalid option file structure','Error');
            return;
        end
        option = lineData(1:indComma(1)-1);
        value = str2num(lineData(indComma(1)+1:size(lineData,2)));
        switch option
        case 'Threshold'
            thr = value;
        case 'Show level 1 labels'
            showLabel(1) = value;
        case 'Show level 2 labels'
            showLabel(2) = value;
        case 'Show level 3 labels'
            showLabel(3) = value;
        case 'Show level 4 labels'
            showLabel(4) = value;
        case 'Show level 5 labels'
            showLabel(5) = value;
        otherwise
            errordlg('Invalid option file structure','Error');
            return;
        end
    end
end
