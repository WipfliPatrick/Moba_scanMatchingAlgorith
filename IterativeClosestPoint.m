%**************************************************************************
%* Moba - Mobile Localization                                             *
%**************************************************************************

%read data
X=readtable('ScanFilesNew\Scan000000.dat');             %Fancy GUI needed ^^
P=readtable('ScanFilesNew\Scan000001.dat');


%translation vector
%T
T=[1;1];
%rotation matrix
R = zeros(2)

%minimize summ of the quadrats of the distance of the point pairs
X=table2array(X);
P=table2array(P);
size=max(X);
matrix_height=X(90);
matrix_width=max([X(1),X(180)]);
image=zeros(size*2);

%paint it
count=0;
for i=1:181
    alpha=i-1;
    d=X(i);
    if(d==0)
        %if there is no distance measured there is no measured point
        %so no point painting
        continue;
    end
    x_from_zero=cosd(alpha)*d;
    y_from_zero=sind(alpha)*d;
    %zero is in the middle of the image. so need to calculate the offset
    if(alpha>90)
        x_wOffset=round(x_from_zero+size);
    else
        x_wOffset=round(size-x_from_zero);
    end
     y_wOffset=round(size-y_from_zero);
    image(x_wOffset,y_wOffset)=255;
    count=count+1;
end
imshow(image)

%mean value of the datafiles
mue_x=sum(X)/length(X);
mue_p=sum(P)/length(P);
W=0;
for j=1:181
    W=W+(X(j)-mue_x)*transpose(P(j)-mue_p);         %No Matrix yet
end
% 
% for elm=X_transp
%    print(elm) 
% end

%Singular value decomposition of matrix W
[U,E,V] = svd(W)

%Optimal rotationsmatrix R
R = U * transpose(V)

%Get filename of next datafile
function [filename_new] = get_next_filename(count_index)
   
   %incrementing index of the next datafile
   i = count_index;
   %String splits
   a = 'ScanFilesNew\Scan0';
   b = '0';
   c = num2str(i);
   d = '.dat';

   %adding zeros depending on the index-length
     if (i>9999)
        b = '0';
     elseif (i>999)
        b = '00';
     elseif (i>99)
        b = '000';
     elseif (i>9)
        b = '0000';
     else
        b = '00000';
     end
    %Unite editted string splits
    filename_new = [a,b,c,d]  
end

