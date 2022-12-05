%Código funcionando com TODAS as etapas certinho.
%Agora só falta aplicar a mesma coisa pra SDCT


close all
clear all
x = double(imread('boat.tiff')); %reading image of 512x512 pixels
figure, imshow(x/255); %displaying image (Figura 1)

y = x; %storing image in another variable

%Creating Watermark

a = zeros(512,512); %the size of the matriz depends on the size of the image that im reading
a(100:250,100:350) = 1;

figure, imshow(a); %displaying watermark (Figura 2)

save m.dat a -ascii %saving matriz in a file

%Perform WaterMarking

%RGB content of the image
x1 = x(:,:,1);
%x2 = x(:,:,2);
%x3 = x(:,:,3);

%Fazer a dct em cada bloco e dps substituir

%Perform dct on each RGB component and storing in a different variable
dx1 = dct2(x1); dx11 = dx1 ;
%dx2 = dct2(x2); dx22 = dx2 ;
%dx3 = dct2(x3); dx33 = dx3 ;

%----------------------------------------------- COLOCAR MARCA D'ÁGUA

load m.dat %binary mark for watermarking. Loading the matriz from the file that I created
g = 100; %coeeficient of watermark's strength (Cox call it alpha parameter)
%As the size of g gets bigger, the watermarking gets stronger, but if this value is too big, the image will be deteriorated

[rm, cm] = size(m); %rows and columns of the matriz 300x500

dx1(1:rm,1:cm) = dx1(1:rm,1:cm) + g*m; %adding the watermark to the image by adding the coefficient g to the image
%dx2(1:rm,1:cm) = dx2(1:rm,1:cm) + g*m;
%dx3(1:rm,1:cm) = dx3(1:rm,1:cm) + g*m;
figure, imshow(dx1); %displaying each component of the image after watermarking (Figura 3)
%figure, imshow(dx2); %(Figura 4)
%figure, imshow(dx3); %(Figura 5)

%------------------------------------------------ INVERSA

%Perform idct on each RGB component and storing in a different variable

%Também fazer a inversa bloco à bloco

y1 = idct2(dx1);
%y2 = idct2(dx2);
%y3 = idct2(dx3);
y(:,:,1) = y1;
%y(:,:,2) = y2;
%y(:,:,3) = y3;

figure, imshow(y1); %Inverse in each component (Figura 6)
%figure, imshow(y2); % (Figura 7)
%figure, imshow(y3); % (Figura 8)


figure, imshow(y/255); %displaying the watermarked image (Figura 9)

figure; imshow(abs(y-x)*100); %comparing the original image with the watermarked image( Figura 10)


z = y; %storing the watermarked image in another variable
[r, c, s] = size(z); %rows, columns and channels of the watermarked image

%De-watermarking
% Clean image (known mask)

y = z;
%Perform dct on each RGB component and storing in a different variable
dy1 = dct2(y(:,:,1));
%dy2 = dct2(y(:,:,2));
%dy3 = dct2(y(:,:,3));
%Subtracting the watermark from the RGB channels
dy1(1:rm,1:cm) = dy1(1:rm,1:cm) - g*m;
%dy2(1:rm,1:cm) = dy2(1:rm,1:cm) - g*m;
%dy3(1:rm,1:cm) = dy3(1:rm,1:cm) - g*m;
%Perform idct on each RGB component to get the original image
y11 = idct2(dy1);
%y22 = idct2(dy2);
%y33 = idct2(dy3);

%combining the RGB channels to get the original image (yy)
yy(:,:,1) = y11;
%yy(:,:,2) = y22;
%yy(:,:,3) = y33;
%displaying the original image
figure, imshow(yy/255);
%comparison showing all black image for no difference b/w yy and x
figure, imshow(abs(yy-x)*10000);
%figure, imshowpair(y1,x,"diff")

%Analysing differences
Z = imabsdiff(y1,x);

%figure, imshowpair(y1,x,"diff")

%figure, imshowpair(y1, imread("boat2.tiff"),"diff");






