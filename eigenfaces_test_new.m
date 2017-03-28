function eigenfaces_test_new(probe_img)
%% Initialization
% Get the structure of image data
% load('F:\FaceAuth\Modified Matlab\Matlab\tr_set1_split');
% db_test = data_ts; % database
load faceauth_db
% probe_img=faceauth_db(1).img{4};

Eig_faces = evalin('base','Eig_faces');
Psi_train = evalin('base','Psi_train');
% temp = db_test(1).img{1};
% num_rows = size(temp,1);
% num_cols = size(temp,2);
% num_sets = size(db_test,2);
% num_test_egs = size(db_test(1).img,2);
% num_test_images = num_sets*num_test_egs;
%%
% Now, find out Gamma, i.e. vector representations of all images.
% Gamma_test = find_gamma(probe_img);
%%
% Find Phi - modified representation of test images
% for i = 1:num_test_images
%     Phi_test(:,i) = Gamma_test(:,i) - Psi_train;
% end
probe_img=imresize(probe_img,[115 115]);
% probe_img = double(reshape(probe_img',13225,1));
probe_img =(reshape(probe_img',13225,1));
probe_img=double(probe_img)/255;
Phi_test= probe_img - Psi_train;
%% Find out weights for all eigenfaces
% Each column contains weight for corresponding image
W_test = Eig_faces'*Phi_test;
assignin('base','W_test',W_test);
% Now, find distances from original weights
% First, city-block distances
% for i=1:num_test_images
%     for j = 1:num_train_images
%         cb_dist(i,j) = sum(abs(W_test(:,i) - W_train(:,j)));
%     end
% end
% [sorted_dist, ind_cb] = sort(cb_dist,2,'ascend');
% cb_dists = ceil(ind_cb(:,1)/num_train_egs);
% disp('City block');
% % Euclidean distance
% for i=1:num_test_images
%     for j = 1:num_train_images
%         eucl_dist(i,j) = sqrt(sum((W_test(:,i) - W_train(:,j)).^2));
%     end
% end
% [sorted_dist, ind_eucl] = sort(eucl_dist,2,'ascend');
% eucl_dists = ceil(ind_eucl(:,1)/num_train_egs);
% disp('Euclidean');
% % Mahalanobis distance
% for i=1:num_test_images
%     y = W_test(:,i);
%     for j = 1:num_train_images
%         x = W_train(:,j);        
%         maha_dist(i,j) = sqrt((x-y)'*inv(cov([x',y']))*(x-y));
%     end
% end
% [sorted_dist, ind_maha] = sort(maha_dist,2,'ascend');
% maha_dists = ceil(ind_maha(:,1)/num_train_egs);
% disp('Mahalanobis');