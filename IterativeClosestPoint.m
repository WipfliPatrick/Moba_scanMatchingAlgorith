%**************************************************************************
%* Moba - Mobile Localization                                             *
%**************************************************************************

%read data
X=readtable('ScanFilesNew\Scan000000.dat');           %Fancy GUI needed ^^
P=readtable('ScanFilesNew\Scan000001.dat');


%translation vector
T=[1;1];
%rotation matrix
R=zeros(2);

%minimize sum of the quadrats of the distance of the point pairs
X=table2array(X);
P=table2array(P);
matrix_height=X(90);                                %Wofür diese Variabeln?
matrix_width=max([X(1),X(180)]);

%Creats image of the data-cloud
[image]=paint_image(X);
%[image2]=paint_image(P);
%converts polar data-cloud to a kartesic one as a matrix
[X_k]=transvert_array(X);
[P_k]=transvert_array(P);
%calculates the optimal rotationmatrix and translationvector of the two
%data-clouds
[R, T] = optimal_R_and_T(X_k, P_k);

%paint the data-cloud on a kartesic map
function [image]=paint_image(X)
size=max(X);
image=zeros(size*2);
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
end

%transverts polar to kartesic koordinates and creates a new matrix
function [kart_matrix] = transvert_array(X)
size=max(X);
count=0;
kart_matrix=zeros(181,2);
for i=1:181
    alpha=i-1;
    d=X(i);
    if(d==0)
        %if there is no distance measured there is no measured point
        %so no point painting
        continue;
    end
    %transformation polar to kartesic
    x_from_zero=cosd(alpha)*d;
    y_from_zero=sind(alpha)*d;
    %zero is in the middle of the image. so need to calculate the offset
    if(alpha>90)
        x_wOffset=round(x_from_zero+size);
    else
        x_wOffset=round(size-x_from_zero);
    end
    y_wOffset=round(size-y_from_zero);
    %fills kartesic matrix
    kart_matrix(i,1)=x_wOffset;
    kart_matrix(i,2)=y_wOffset;
    count=count+1;
end
end

%mean value of the datafiles
function [R, T] = optimal_R_and_T(X_k, P_k)
mue_x=sum(X_k)/length(X_k);
mue_p=sum(P_k)/length(P_k);
W=zeros(2);
for j=1:181
    W=W+(X_k(j)-mue_x)*transpose(P_k(j)-mue_p);
end
%Singular value decomposition of matrix W
[U,E,V] = svd(W);
%Optimal rotationsmatrix R
R = U * transpose(V);
%Optimaler Translationsvektor T
T = transpose(mue_x) - R * transpose(mue_p);
%Get filename of next datafile
end

%Creates the filename of the next upcoming datafile
function [filename_new] = get_next_filename(count_index)
   
   %incrementing index of the next datafile
   i = count_index;
   %String splits
   a = 'ScanFilesNew\Scan';
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
