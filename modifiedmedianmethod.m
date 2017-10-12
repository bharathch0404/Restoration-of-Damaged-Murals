clc;clear;
A= imread('dataset4.tif'); %read the image
noofcracks = zeros(5,1); %no of cracks after each iterations
original = A; %copy of the original image
for u=1:2 %no of iterations increase for more iterations
HSV=rgb2hsv(A); %convert the RGB image to Hue Satuation and Value Image
H=HSV(:,:,1); %get the Hue value
H = H * 360; %convert the Hue value to degrees
S=HSV(:,:,2); %get the Satuation value
YIQ=rgb2ntsc(A); %convert the RGB image to NTSC format
Y=YIQ(:,:,1); %get the illuminance value of the image
SE = strel('square',3); %structuring element we are using
TH = imtophat(Y,SE); %inbuilt top hat function
F=im2bw(TH,0.13); %convert the image to binary image
[r c d]=size(F); %get the number of rows and columns of the image
crack=0; %cracked image
brush=0; %no of brush strokes 
for i=1:r
    for j=1:c
        if(H(i,j)>0 && H(i,j)<60 && S(i,j)>0.4 && S(i,j)<=0.7 && F(i,j)==1)
           crack(i,j)=1; %if the above conditions are met, it is a crack
           noofcracks(u,1)=noofcracks(u,1)+1; % no of cracks in this iteration
        elseif(H(i,j)>0 && H(i,j)<360 && S(i,j) >0 && S(i,j)<=0.3 && F(i,j)==1)
           crack(i,j)=0; %if the above conditions are met it is a brush stroke
        elseif(F(i,j)==1)
           crack(i,j)=1; %it is unidenified but for simplicity we are considering it as an crack
           noofcracks(u,1)=noofcracks(u,1)+1; % no of cracks in this iteration
        end
    end
end
for i=2:r - 1
    for j=2:c - 1
        redmea=0; %matrix for red values
        greenmea=0; %matrix for green values
        blurmea=0; %matrix for blue values
        count=1; %no of items in the matrices
        if(crack(i,j)==1) %if it is a crack
            for k = i-1 : i+1 
             for l = j-1 : j+1 %take a 3x3 neighboorhood
                 if(crack(k,l)==1)
                    
                 else
                        redmea(count)=A(k,l,1); %get the red value
                        greenmea(count)=A(k,l,2); %get the green value
                        bluemea(count)=A(k,l,3); %get the blue value
                        count= count+1; %increase the number of items 
                 end
                 rm=sort(redmea); %sort the red array
                 gm=sort(greenmea); %sort the green array
                 bm=sort(bluemea); %sort the blue array
             end
            end
            if(count>1)
               A(i,j,1)=rm(int8(count/2)); %find the median red value
                A(i,j,2)=gm(int8(count/2)); %find the median green value
                A(i,j,3)=bm(int8(count/2)); %find the median blue value
            end
        end
    end
end
end
display(noofcracks);
imshow(crack);
