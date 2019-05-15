%read data
X=readtable('ScanFilesNew\Scan000000.dat');
P=readtable('ScanFilesNew\Scan000001.dat');


%translation vector
%T
T=[1;1];
%rotation matrix
%R

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

mue_x=sum(X)/size(X);
mue_p=sum(P)/size(P);
W=0;
for j=1:181
    W=W+(X(j)-mue_x)*(P(j)-mue_p);
end
% 
% for elm=X_transp
%    print(elm) 
% end