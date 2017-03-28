function eigen_faces_new
%% Initialization
% Get the structure of image data
load('G:\FaceAuth\Modified Matlab\Matlab\faceauth_db');
db_train = faceauth_db; % Enter database struct

temp = db_train(1).img{1};
num_rows = size(temp,1);
num_cols = size(temp,2);
num_people = size(db_train,2);
num_train_egs = size(db_train(1).img,2);
num_train_images = num_people*num_train_egs;
%%
% Now, find out Gamma, i.e. vector representations of all images.

Gamma_train = find_gamma(db_train);
%%
% Find psi - mean image
Psi_train = mean(Gamma_train')';
%%
% Find Phi - modified representation of training images
for i = 1:num_train_images
    Phi(:,i) = Gamma_train(:,i) - Psi_train;
end
%%
% Create a matrix from all modified vector images
A = Phi;
%% Find covariance matrix
C = A'*A;
[eig_mat, eig_vals] = eig(C);

%%
% Sort eigen vals to get order
eig_vals_vect = diag(eig_vals);
[sorted_eig_vals, eig_indices] = sort(eig_vals_vect,'descend');

sorted_eig_mat = zeros(num_train_images);
for i=1:num_train_images
    sorted_eig_mat(:,i) = eig_mat(:,eig_indices(i));
end
%% Find out Eigen faces
Eig_faces = (A*sorted_eig_mat);
size_Eig_faces=size(Eig_faces);
% eig_faces_sorted=zeros(size_Eig_faces(1,1),size_Eig_faces(1,2)-12);
% eig_faces_sorted=zeros(size_Eig_faces(1,1),size_Eig_faces(1,2)-2);
% commented for special pupose
% eig_faces_sorted(:,2:(size_Eig_faces(1,2)-2))=Eig_faces(:,4:(size_Eig_faces(1,2)));
% eig_faces_sorted(:,1)=Eig_faces(:,1);


%% Find out weights for all eigenfaces
% Each column contains weight for corresponding image
W_train = Eig_faces'*Phi;
% Weights db created, training ends
assignin('base','W_train',W_train);
assignin('base','num_train_egs',num_train_egs);
assignin('base','num_people',num_people);
assignin('base','Psi_train',Psi_train);
assignin('base','Eig_faces',Eig_faces);
% 
% subplot(3,3,1); (imshow(mat2gray(reshape(Eig_faces(:,1),115,115)'))) 
% title('Eigenface 1')
% subplot(3,3,2); (imshow(mat2gray(reshape(Eig_faces(:,2),115,115)')))
% title('Eigenface 2')
% subplot(3,3,3); (imshow(mat2gray(reshape(Eig_faces(:,3),115,115)')))
% title('Eigenface 3')
% subplot(3,3,4); (imshow(mat2gray(reshape(Eig_faces(:,31),115,115)')))
% title('Eigenface 31')
% subplot(3,3,5); (imshow(mat2gray(reshape(Eig_faces(:,32),115,115)')))
% title('Eigenface 32')
% subplot(3,3,6); (imshow(mat2gray(reshape(Eig_faces(:,33),115,115)')))
% title('Eigenface 33')
% subplot(3,3,7); (imshow(mat2gray(reshape(Eig_faces(:,107),115,115)')))
% title('Eigenface 107')
% subplot(3,3,8); (imshow(mat2gray(reshape(Eig_faces(:,108),115,115)')))
% title('Eigenface 108')
% subplot(3,3,9); (imshow(mat2gray(reshape(Eig_faces(:,109),115,115)')))
% title('Eigenface 109')
% assignin('base','Eig_faces',eig_faces_sorted);
% assignin('base','num_train_images',num_train_images);