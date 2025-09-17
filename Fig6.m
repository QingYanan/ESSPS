%% Representational Similarity Analysis 
% refer https://github.com/cocoanlab
%% Basic setup
clear all;
basedir = 'D:\RSA';
datdir = fullfile(basedir, 'data', 'contrast_images','sub*');
roi_masks = filenames(fullfile(basedir, 'masks', '*mask.nii'), 'char');

conditions = {'fw','mw','sw','fd','md', 'sd', 'fc', 'mc', 'sc','fr', 'mr', 'sr'};

line_disp = repmat('=', 1, 50); 
addpath(fullfile(basedir, 'external'));

%% Reading data for ROI masks
roi.fw = fmri_data(filenames(fullfile(datdir, 'fw_*.nii')), roi_masks);
roi.mw = fmri_data(filenames(fullfile(datdir, 'mw_*.nii')), roi_masks);
roi.sw = fmri_data(filenames(fullfile(datdir, 'sw_*.nii')), roi_masks);
roi.fd = fmri_data(filenames(fullfile(datdir, 'fd_*.nii')), roi_masks);
roi.md = fmri_data(filenames(fullfile(datdir, 'md_*.nii')), roi_masks);
roi.sd = fmri_data(filenames(fullfile(datdir, 'sd_*.nii')), roi_masks);
roi.fc = fmri_data(filenames(fullfile(datdir, 'fc_*.nii')), roi_masks);
roi.mc = fmri_data(filenames(fullfile(datdir, 'mc_*.nii')), roi_masks);
roi.sc = fmri_data(filenames(fullfile(datdir, 'sc_*.nii')), roi_masks);
roi.fr = fmri_data(filenames(fullfile(datdir, 'fr_*.nii')), roi_masks);
roi.mr = fmri_data(filenames(fullfile(datdir, 'mr_*.nii')), roi_masks);
roi.sr = fmri_data(filenames(fullfile(datdir, 'sr_*.nii')), roi_masks);

n_subj = size(roi.fw.dat,2);
    
roi.rdms = zeros(12,12);
for cond_i = 1:numel(conditions)
    for cond_j = 1:numel(conditions)
        if cond_i ~= cond_j
            for subj_i = 1:n_subj

                eval(['roi.rdms(cond_i,cond_j,subj_i) = 1-corr(roi.' ...
                    conditions{cond_i} '.dat(:,subj_i), roi.' ...
                    conditions{cond_j} '.dat(:,subj_i));']);

                roi.rdms(cond_j,cond_i,subj_i) = roi.rdms(cond_i,cond_j,subj_i); % to make RDMs symmetric

            end
        end
    end
end

%% Visualize mean RDMs
figure;
set(gcf, 'position', [1         740        1487         215], 'color', 'w')
disp('Representational Dissimilarity Matrices')
imagesc(mean(roi.rdms,3)); 
colorbar;
title('Whole-brain mask ');
set(gca, 'XTick', 1:numel(conditions), 'XTickLabel', conditions, 'XTickLabelRotation', 90);
set(gca, 'YTick', 1:numel(conditions), 'YTickLabel', conditions);


