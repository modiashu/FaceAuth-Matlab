% function[result]= FaceAuth_main(probe_img , claimed_id)
load faceauth_db
% diary on
% for i=9:11  %for replacing C gamma values uncommented.
%     disp(':::Claimed ID::: ')
%     disp(i)
%     for j=8:10
%         disp('Probe Image ID::')
%         disp(j)
%         for k=1:3
%             disp('image no.')
%             disp(k)
%             probe_img=faceauth_db(j).img{k};
i =input('Enter your probe image ID: ');
j =input('Enter the probe image number: ');
claimed_id = input('Enter your ID: ');
% claimed_id = 7;
probe_img=faceauth_db(i).img{j};
eigen_faces_new_offline;
eigenfaces_test_new(probe_img);
%%
C_val = 965;
gamma_val = 1.4363;
%%

% test_face = 2;
% claimed_id = i;
threshold = 0.25;
%%
W_train = evalin('base','W_train');
[X_train, Y_train] = Create_TrSet_philips(W_train, inf);

model = svmlearn(X_train, Y_train, ['-v 0 -t 2 -g ' num2str(gamma_val) ' -c ' num2str(C_val)]);
%%
W_test = evalin('base','W_test');
W_probe = W_test;%(:,test_face);
W_probe_norm = svdatanorm(W_probe,'rbf');
num_train_egs = evalin('base','num_train_egs');
if length(claimed_id) ~= 1
    W_samples = W_train;
else
    W_samples = W_train(:,(claimed_id - 1)*num_train_egs + 1: claimed_id*num_train_egs);
end
W_samples_norm = svdatanorm(W_samples,'rbf');

if (SVM_FaceAuth_philips(W_probe_norm, W_samples_norm, threshold, claimed_id, model)) == 1
% if (SVM_FaceAuth_philips(W_probe_norm, W_samples_norm, claimed_id, model)) == 1
    result=1;
    disp('Authenticated');
else
    result=0;
    disp('Impostor!');
end
%     end
%     end
% end
% dairy off