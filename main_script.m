%% Main script for ESSPS-monitoring
% Refer https://doi.org/10.1038/s41596-019-0289-5
% The codes for developing ESSPS-decision, ESSPS-chasing and ESSPS-outcome
% anticiaption are the same as this code
%% Step 1: Model building 
basedir = 'D:\MVPA';
gray_matter_mask = 'D:\MVPA\gray_matter_mask.nii';

fw_imgs = filenames(fullfile(basedir, 'data', 'derivatives', 'con_beta', 'sub*', 'fw_*.nii'));
sw_imgs = filenames(fullfile(basedir, 'data', 'derivatives', 'con_beta', 'sub*', 'sw_*.nii'));
data = fmri_data([fw_imgs; sw_imgs], gray_matter_mask);

mask = 'D:\MVPA\gray_matter_mask.nii'; %you can change an another mask
data = apply_mask(data, mask);
data.Y = [ones(numel(fw_imgs),1); -ones(numel(sw_imgs),1)]; 

% Training
[~, stats] = predict(data1, 'algorithm_name', 'cv_svm', 'nfolds', 1, 'error_type', 'mcr');
 
% Training SVM with leave-one-subject-out cross-validation
n_folds = [repmat(1:39, 1,1) repmat(1:39, 1,1)];
n_folds = n_folds(:); 
[~, stats_loso] = predict(data, 'algorithm_name', 'cv_svm', 'nfolds', n_folds, 'error_type', 'mcr');

% ROC plot
ROC_loso = roc_plot(stats_loso.dist_from_hyperplane_xval, data.Y == 1, 'threshold', 0);

% Bootstrap tests
[~, stats_boot] = predict(data, 'algorithm_name', 'cv_svm', 'nfolds', 1, 'error_type', 'mcr', 'bootweights', 'bootsamples', 10000);
data_threshold = threshold(stats_boot.weight_obj, .05, 'fdr'); 

orthviews(data_threshold);
mkdir(basedir, 'results')
data_threshold.fullpath = fullfile(basedir, 'results', 'svm_bootstrap_results_fdr05.nii'); 
write(data_threshold, 'thresh');



%% Step 2: Test validation
fsw = which('fsw_svm_bts.nii');
cont_imgs{1} = filenames(fullfile(basedir, 'data', 'derivatives','validation','sub*', 'fw*.nii'), 'char');
cont_imgs{2} = filenames(fullfile(basedir, 'data', 'derivatives', 'validation','sub*', 'sw*.nii'), 'char');
data_test = fmri_data(cont_imgs, gray_matter_mask);
pexp_fsw = apply_mask(data_test, fsw, 'pattern_expression', 'ignore_missing');
pexp_fsw = reshape(pexp_fsw, 34, 2);
roc_fsw_validation = roc_plot([pexp_fsw(:,1);pexp_fsw(:,2)], [true(34,1);false(34,1)], 'twochoice');


%% Step 3: Test generalizability
% The codes for testing generalizability on other datasets are the same as
% this code
fsw = which('fsw_svm_bts.nii');
cont_imgs{1} = filenames(fullfile(basedir, 'data', 'derivatives','subjective_fear','sub*', 'high_*.nii'), 'char');
cont_imgs{2} = filenames(fullfile(basedir, 'data', 'derivatives', 'subjective_fear','sub*', 'low_*.nii'), 'char');
data_test = fmri_data(cont_imgs, gray_matter_mask);
pexp_fsw = apply_mask(data_test, fsw, 'pattern_expression', 'ignore_missing');
pexp_fsw = reshape(pexp_fsw, 65, 2);
roc_fsw_generalization = roc_plot([pexp_fsw(:,1);pexp_fsw(:,2)], [true(65,1);false(65,1)], 'twochoice');
